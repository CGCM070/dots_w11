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
