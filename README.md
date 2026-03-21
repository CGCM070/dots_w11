# dots_w11

Dotfiles para Windows 11. Contiene configuraciones de GlazeWM, Zebar, Neovim, Flow Launcher y scripts utilitarios.

## Estructura

```
dots_w11/
├── glazewm/                # GlazeWM tiling window manager
│   ├── config.yaml
│   └── README.md
├── zebar/                  # Zebar status bar
│   ├── settings.json
│   ├── styles.css
│   └── with-glazewm.html
├── nvim/                   # Neovim (LazyVim)
│   ├── init.lua
│   ├── lua/
│   └── plugin/
├── flow-launcher/          # Flow Launcher (app launcher)
│   ├── Settings.json
│   └── Plugins/
│       └── */Settings.json
├── bin/                    # Scripts utilitarios
│   └── dev-session.cmd
├── .gitignore
└── README.md
```

## Setup automático (guía para agentes IA)

Este README está diseñado para que un agente de IA (Claude Code, Copilot, etc.) pueda configurar todo el entorno automáticamente en una máquina Windows 11 limpia.

### Prerrequisitos

El agente debe verificar que estén instalados antes de proceder:

- [Git](https://git-scm.com/)
- [GlazeWM](https://github.com/glzr-io/glazewm) (tiling window manager)
- [Zebar](https://github.com/glzr-io/zebar) (status bar para GlazeWM)
- [Neovim](https://neovim.io/) (>= 0.9)
- [Windows Terminal](https://aka.ms/terminal)
- [Flow Launcher](https://www.flowlauncher.com/)
- [Google Chrome](https://www.google.com/chrome/)

### Paso 1: Clonar el repositorio

```powershell
git clone git@github.com:CGCM070/dots_w11.git "$env:USERPROFILE\dots_w11"
```

### Paso 2: Crear directorios destino (si no existen)

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.glzr\glazewm"
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.glzr\zebar"
New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\nvim"
New-Item -ItemType Directory -Force -Path "$env:APPDATA\FlowLauncher\Settings\Plugins"
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\bin"
```

### Paso 3: Eliminar configs existentes (si las hay)

> **IMPORTANTE**: El agente debe preguntar al usuario antes de eliminar configuraciones existentes.

```powershell
# Solo si el usuario confirma
Remove-Item -Recurse -Force "$env:USERPROFILE\.glzr\glazewm\config.yaml" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:USERPROFILE\.glzr\zebar\*" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:APPDATA\FlowLauncher\Settings\Settings.json" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:APPDATA\FlowLauncher\Settings\Plugins" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:USERPROFILE\bin\dev-session.cmd" -ErrorAction SilentlyContinue
```

### Paso 4: Crear symlinks

> **NOTA**: Requiere PowerShell como Administrador, o tener habilitado el modo desarrollador en Windows 11 (Settings > System > For developers > Developer Mode ON).

```powershell
$dots = "$env:USERPROFILE\dots_w11"

# GlazeWM - symlink del archivo config
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.glzr\glazewm\config.yaml" -Target "$dots\glazewm\config.yaml"

# Zebar - symlink de cada archivo
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.glzr\zebar\settings.json" -Target "$dots\zebar\settings.json"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.glzr\zebar\styles.css" -Target "$dots\zebar\styles.css"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.glzr\zebar\with-glazewm.html" -Target "$dots\zebar\with-glazewm.html"

# Neovim - symlink de toda la carpeta
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim" -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$dots\nvim"

# Flow Launcher - symlink del settings principal
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\FlowLauncher\Settings\Settings.json" -Target "$dots\flow-launcher\Settings.json"

# Flow Launcher - symlink de la carpeta de plugins settings
Remove-Item -Recurse -Force "$env:APPDATA\FlowLauncher\Settings\Plugins" -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\FlowLauncher\Settings\Plugins" -Target "$dots\flow-launcher\Plugins"

# bin - symlink del script
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\bin\dev-session.cmd" -Target "$dots\bin\dev-session.cmd"
```

### Paso 5: Verificar

```powershell
# Verificar que los symlinks apuntan correctamente
$symlinks = @(
    "$env:USERPROFILE\.glzr\glazewm\config.yaml",
    "$env:USERPROFILE\.glzr\zebar\settings.json",
    "$env:LOCALAPPDATA\nvim",
    "$env:APPDATA\FlowLauncher\Settings\Settings.json",
    "$env:APPDATA\FlowLauncher\Settings\Plugins",
    "$env:USERPROFILE\bin\dev-session.cmd"
)
foreach ($link in $symlinks) {
    Get-Item $link | Select-Object FullName, Target
}
```

### Paso 6: Recargar aplicaciones

```powershell
# Recargar GlazeWM (o usar Alt+Shift+R si ya está corriendo)
# Reiniciar Flow Launcher
Stop-Process -Name "Flow.Launcher" -ErrorAction SilentlyContinue
Start-Process "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe"
# Neovim instalará plugins automáticamente al abrir (lazy.nvim)
```

### Mapa de symlinks (referencia rápida)

| Origen (repo)                  | Destino (sistema)                                | Tipo    |
|-------------------------------|--------------------------------------------------|---------|
| `glazewm/config.yaml`        | `~\.glzr\glazewm\config.yaml`                   | Archivo |
| `zebar/settings.json`        | `~\.glzr\zebar\settings.json`                   | Archivo |
| `zebar/styles.css`           | `~\.glzr\zebar\styles.css`                      | Archivo |
| `zebar/with-glazewm.html`    | `~\.glzr\zebar\with-glazewm.html`               | Archivo |
| `nvim/`                      | `%LOCALAPPDATA%\nvim`                            | Carpeta |
| `flow-launcher/Settings.json`| `%APPDATA%\FlowLauncher\Settings\Settings.json`  | Archivo |
| `flow-launcher/Plugins/`     | `%APPDATA%\FlowLauncher\Settings\Plugins\`       | Carpeta |
| `bin/dev-session.cmd`        | `~\bin\dev-session.cmd`                          | Archivo |

### Notas para el agente

- **No modificar archivos en los destinos directamente** — siempre editar dentro del repo y los symlinks propagarán los cambios.
- Si GlazeWM no detecta cambios tras crear el symlink, recargar con `Alt+Shift+R`.
- Neovim instalará plugins automáticamente al abrir por primera vez (lazy.nvim).
- El script `dev-session.cmd` abre nvim y Claude Code (con --chrome) en ventanas tileadas side-by-side.
- Flow Launcher debe reiniciarse tras aplicar los symlinks para que tome la nueva configuración.
