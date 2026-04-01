# ============================================
# PSReadLine - configuración recomendada
# ============================================

# Predicciones desde historial + lista navegable
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Flechas filtran historial por lo ya escrito
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab despliega menú de opciones
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Colores de sintaxis
Set-PSReadLineOption -Colors @{
    Command   = 'Yellow'
    Parameter = 'DarkGray'
    String    = 'Green'
    Error     = 'Red'
    Comment   = 'DarkGreen'
    Keyword   = 'Cyan'
}

# ============================================
# Clipboard Monitor - Notificación al copiar
# Para eliminar: borra desde aquí hasta "# Fin Clipboard Monitor"
# ============================================
try {
    $Global:_clipMonRunspace = [runspacefactory]::CreateRunspace()
    $Global:_clipMonRunspace.ApartmentState = 'STA'
    $Global:_clipMonRunspace.ThreadOptions = 'ReuseThread'
    $Global:_clipMonRunspace.Open()

    $Global:_clipMonPS = [powershell]::Create()
    $Global:_clipMonPS.Runspace = $Global:_clipMonRunspace
    [void]$Global:_clipMonPS.AddScript({
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing

        $cs = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class ClipboardNotifier : Form
{
    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    static extern bool AddClipboardFormatListener(IntPtr hwnd);

    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    static extern bool RemoveClipboardFormatListener(IntPtr hwnd);

    private const int WM_CLIPBOARDUPDATE = 0x031D;
    private Timer _timer;
    private Form _toast;

    public ClipboardNotifier()
    {
        ShowInTaskbar = false;
        FormBorderStyle = FormBorderStyle.None;
        WindowState = FormWindowState.Minimized;
        Opacity = 0;

        _toast = new Form {
            FormBorderStyle = FormBorderStyle.None,
            ShowInTaskbar = false,
            TopMost = true,
            BackColor = Color.FromArgb(35, 35, 40),
            Size = new Size(160, 34),
            StartPosition = FormStartPosition.Manual,
            Opacity = 0.9
        };

        var lbl = new Label {
            Text = "  Copiado \u2713",
            ForeColor = Color.FromArgb(160, 220, 160),
            Font = new Font("Segoe UI", 9.5f),
            Dock = DockStyle.Fill,
            TextAlign = ContentAlignment.MiddleLeft
        };
        _toast.Controls.Add(lbl);

        var wa = Screen.PrimaryScreen.WorkingArea;
        _toast.Location = new Point(wa.Right - _toast.Width - 16, wa.Bottom - _toast.Height - 16);

        _timer = new Timer { Interval = 1500 };
        _timer.Tick += (s, e) => { _toast.Hide(); _timer.Stop(); };

        AddClipboardFormatListener(Handle);
    }

    protected override void WndProc(ref Message m)
    {
        if (m.Msg == WM_CLIPBOARDUPDATE)
        {
            _timer.Stop();
            _toast.Show();
            _timer.Start();
        }
        base.WndProc(ref m);
    }

    protected override void OnFormClosing(FormClosingEventArgs e)
    {
        RemoveClipboardFormatListener(Handle);
        _timer.Dispose();
        _toast.Dispose();
        base.OnFormClosing(e);
    }
}
'@

        $needed = @(
            'System.Windows.Forms', 'System.Windows.Forms.Primitives'
            'System.Drawing.Primitives', 'System.Drawing.Common'
            'System.ComponentModel.Primitives', 'System.ComponentModel.EventBasedAsync'
            'System.Private.CoreLib', 'System.Runtime', 'System.Runtime.InteropServices'
        )
        $refs = [System.AppDomain]::CurrentDomain.GetAssemblies() |
            Where-Object { $_.Location -and $_.GetName().Name -in $needed } |
            Select-Object -ExpandProperty Location -Unique
        $psDir = [System.IO.Path]::GetDirectoryName(
            [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
        foreach ($n in $needed) {
            $dll = Join-Path $psDir "$n.dll"
            if (($dll -notin $refs) -and (Test-Path $dll)) { $refs += $dll }
        }

        Add-Type -TypeDefinition $cs -ReferencedAssemblies $refs
        [System.Windows.Forms.Application]::Run([ClipboardNotifier]::new())
    })

    [void]$Global:_clipMonPS.BeginInvoke()
} catch {
    # Fallo silencioso - el monitor no es crítico
}
# Fin Clipboard Monitor
