# dots_w11

> **AGENTES IA — LEER ANTES DE EDITAR CUALQUIER ARCHIVO**
> Los archivos de este repositorio son la fuente de verdad, pero sus rutas de sistema (p.ej. `~\.glzr\glazewm\config.yaml`) son **symlinks creados con `mklink` de cmd** que apuntan aquí. Editar el destino del symlink edita este repo. Si encuentras un archivo fuera de `dots_w11/` que coincide con alguna entrada del [mapa de symlinks](#mapa-de-symlinks-referencia-rápida), **edita directamente el archivo dentro de `dots_w11/`**, no el destino enlazado. Nunca asumir que son copias independientes.

Dotfiles para Windows 11. Contiene configuraciones de GlazeWM, Zebar, Neovim, Flow Launcher, Windows Terminal, PowerShell 7 y scripts utilitarios.

> **NOTA sobre Claude Code**: `claude/` es una **copia de respaldo, NO un symlink**. Los archivos vivos
> (`~\.claude\settings.json`, `~\.claude\settings.local.json` y `~\.claude\statusline.sh`) son libres e independientes en cada máquina:
> Claude Code los reescribe solo cada vez que apruebas un permiso con "no preguntes más". **No los enlaces.**
> Para actualizar el respaldo, copia de `~\.claude\` a `claude\` a mano. Si el respaldo y el archivo vivo
> divergen, gana el archivo vivo.

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
├── windows-terminal/       # Windows Terminal
│   └── settings.json
├── powershell/             # PowerShell 7 profile + clipboard monitor
│   └── Microsoft.PowerShell_profile.ps1
├── claude/                 # Claude Code CLI (respaldo, NO symlink)
│   ├── settings.json
│   └── settings.local.json
├── bin/                    # Scripts utilitarios
│   ├── dev-session.cmd
│   └── link-wt.cmd
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
- [PowerShell 7](https://github.com/PowerShell/PowerShell) (`winget install Microsoft.PowerShell`) — ver [sección PowerShell 7](#powershell-7) para detalles
- [Flow Launcher](https://www.flowlauncher.com/)
- [Google Chrome](https://www.google.com/chrome/)

### Paso 1: Clonar el repositorio

```cmd
git clone git@github.com:CGCM070/dots_w11.git %USERPROFILE%\dots_w11
```

### Paso 2: Crear directorios destino (si no existen)

```cmd
mkdir %USERPROFILE%\.glzr\glazewm 2>nul
mkdir %USERPROFILE%\.glzr\zebar 2>nul
mkdir %USERPROFILE%\bin 2>nul
mkdir %APPDATA%\FlowLauncher\Settings 2>nul
mkdir %USERPROFILE%\Documents\PowerShell 2>nul
```

> **NOTA**: No crear el directorio `%LOCALAPPDATA%\nvim` porque se linkeará como carpeta completa.

### Paso 3: Eliminar configs existentes (si las hay)

> **IMPORTANTE**: El agente debe preguntar al usuario antes de eliminar configuraciones existentes.

```cmd
del %USERPROFILE%\.glzr\glazewm\config.yaml 2>nul
del %USERPROFILE%\.glzr\zebar\settings.json 2>nul
del %USERPROFILE%\.glzr\zebar\styles.css 2>nul
del %USERPROFILE%\.glzr\zebar\with-glazewm.html 2>nul
rmdir /s /q %LOCALAPPDATA%\nvim 2>nul
del %APPDATA%\FlowLauncher\Settings\Settings.json 2>nul
rmdir /s /q %APPDATA%\FlowLauncher\Settings\Plugins 2>nul
del %USERPROFILE%\bin\dev-session.cmd 2>nul
del %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 2>nul
:: Windows Terminal: cerrar WT antes de eliminar
del "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" 2>nul
```

### Paso 4: Crear symlinks

> **NOTA**: Requiere tener habilitado el modo desarrollador en Windows 11 (Settings > System > For developers > Developer Mode ON). Con el modo desarrollador activo se pueden crear symlinks sin privilegios de administrador usando `mklink`.

```cmd
set DOTS=%USERPROFILE%\dots_w11

:: GlazeWM - config
mklink %USERPROFILE%\.glzr\glazewm\config.yaml %DOTS%\glazewm\config.yaml

:: Zebar - archivos individuales
mklink %USERPROFILE%\.glzr\zebar\settings.json %DOTS%\zebar\settings.json
mklink %USERPROFILE%\.glzr\zebar\styles.css %DOTS%\zebar\styles.css
mklink %USERPROFILE%\.glzr\zebar\with-glazewm.html %DOTS%\zebar\with-glazewm.html

:: Neovim - carpeta completa
mklink /D %LOCALAPPDATA%\nvim %DOTS%\nvim

:: Flow Launcher - settings principal
mklink %APPDATA%\FlowLauncher\Settings\Settings.json %DOTS%\flow-launcher\Settings.json

:: Flow Launcher - carpeta de plugins settings
mklink /D %APPDATA%\FlowLauncher\Settings\Plugins %DOTS%\flow-launcher\Plugins

:: bin - scripts
mklink %USERPROFILE%\bin\dev-session.cmd %DOTS%\bin\dev-session.cmd

:: PowerShell 7 - perfil
mklink %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 %DOTS%\powershell\Microsoft.PowerShell_profile.ps1

:: Windows Terminal - IMPORTANTE: cerrar WT antes de ejecutar este mklink
mklink "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "%DOTS%\windows-terminal\settings.json"
:: Alternativamente ejecutar: bin\link-wt.cmd (recuerda cerrar WT primero)
```

### Paso 5: Verificar

```cmd
dir %USERPROFILE%\.glzr\glazewm\config.yaml
dir %USERPROFILE%\.glzr\zebar\
dir %LOCALAPPDATA%\nvim
dir %APPDATA%\FlowLauncher\Settings\Settings.json
dir %APPDATA%\FlowLauncher\Settings\Plugins
dir %USERPROFILE%\bin\dev-session.cmd
dir %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
dir "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
```

Cada archivo/carpeta debe mostrar `<SYMLINK>` o `<SYMLINKD>` en la salida.

### Paso 6: Recargar aplicaciones

- **GlazeWM**: Pulsar `Alt+Shift+R` para recargar la config
- **Flow Launcher**: Cerrar y reabrir (o `taskkill /IM Flow.Launcher.exe /F` y volver a lanzar)
- **Neovim**: Abrir normalmente, lazy.nvim instalará los plugins automáticamente en el primer arranque

### PowerShell 7

PowerShell 7 (`pwsh`) es el shell por defecto en Windows Terminal. Su perfil se ubica en una ruta distinta a Windows PowerShell 5:

| Versión | Ruta del perfil |
|---|---|
| PowerShell 5 (`powershell.exe`) | `~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` |
| **PowerShell 7** (`pwsh.exe`) | `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |

Este repo gestiona el perfil de **PowerShell 7**. El symlink apunta desde la ruta del sistema al archivo en `dots_w11/powershell/`.

#### Instalación

```cmd
winget install Microsoft.PowerShell
```

Tras instalar, PowerShell 7 aparece automáticamente como perfil en Windows Terminal. Para configurarlo como perfil por defecto, se establece `defaultProfile` en `windows-terminal/settings.json` con el GUID de PowerShellCore (`{574e775e-4f2a-5b96-ac1e-a2962a402336}`), lo cual ya está hecho en este repo.

#### Qué configura el perfil

**PSReadLine** (módulo incluido en PS7, no requiere instalación):
- Predicciones desde historial con vista de lista (`PredictionSource History`, `PredictionViewStyle ListView`)
- Flechas arriba/abajo filtran historial por lo ya escrito (`HistorySearchBackward`/`HistorySearchForward`)
- Tab despliega menú de opciones (`MenuComplete`)
- Colores de sintaxis personalizados: comandos (amarillo), parámetros (gris), strings (verde), errores (rojo), comentarios (verde oscuro), keywords (cyan)

**Clipboard Monitor** (notificación al copiar):
- Muestra un toast oscuro semi-transparente ("Copiado ✓") en la esquina inferior derecha durante 1.5 segundos cada vez que el clipboard cambia
- Usa la Win32 API `AddClipboardFormatListener` (event-driven, 0% CPU en reposo)
- Corre en un runspace de fondo con thread STA (necesario para WinForms)
- **Detecta cambios de clipboard a nivel de sistema** (no solo dentro de la terminal)
- Dependencias: `System.Windows.Forms` y `System.Drawing` — ambas incluidas en el .NET Desktop Runtime que viene con PS7 en Windows, **no requiere instalar nada extra**
- Para desactivar: eliminar el bloque entre `# Clipboard Monitor` y `# Fin Clipboard Monitor` en el perfil

#### Notas técnicas

- PS7 usa .NET 8+ internamente. La compilación C# en el perfil requiere resolver assemblies de forma dinámica (las DLLs están fraccionadas en .NET Core vs .NET Framework). El perfil lo maneja automáticamente buscando en el directorio de instalación de `pwsh`.
- Si el clipboard monitor falla por cualquier razón, se captura silenciosamente (`try/catch`) y no afecta al funcionamiento normal de la terminal.
- El monitor se inicia con `BeginInvoke()` (asíncrono) — no añade delay perceptible al arranque de la terminal.

### Claude Code

`claude/` guarda un **respaldo** de la configuración del CLI. No aparece en el mapa de symlinks y
**no debe enlazarse**: Claude Code reescribe estos archivos por su cuenta cada vez que apruebas un
permiso con "no preguntes más", así que un symlink metería ruido constante en el repo.

- **`settings.json`** — configuración personal y permisos base. `language` (español), `effortLevel`,
  `statusLine` (apunta a `statusline.sh`), `voice` (hold-to-talk), tema y notificaciones. En `permissions`: `allow` para lectura, git, búsqueda y los MCP en uso; `ask` para
  `rm -rf`; y `deny` sobre `.env` y sobre los propios archivos de permisos, para que ningún agente
  pueda auto-concederse accesos.
- **`settings.local.json`** — permisos de la máquina, sin secretos.
- **`statusline.sh`** — la barra de estado, con un color por dato. Lo ejecuta Git Bash.

  | Dato | Color |
  |---|---|
  | Carpeta del proyecto | Azul |
  | Rama de git (`no git` fuera de un repo) | Verde |
  | Modelo | Amarillo |
  | Contexto usado | Verde hasta el 59 %, amarillo del 60 al 84 %, rojo desde el 85 % |

  Los umbrales y los colores (códigos ANSI) están en las primeras líneas del script. Recibe por la
  entrada estándar el JSON que le pasa Claude Code y lo lee con `grep`, sin depender de `jq`.

Los permisos específicos de un proyecto **no van aquí**: viven en el `.claude/` de cada repo.

El respaldo **no es una copia literal** del archivo vivo. Antes de copiarlo aquí se quitan:

- el bloque `autoMode`, que describe el entorno de trabajo de la máquina (organización, repositorios y
  servicios internos) y hay que escribirlo de nuevo en cada equipo;
- los permisos que llevan direcciones IP de una red interna.

Para restaurar en una máquina nueva: copiar los tres archivos a `~\.claude\` y revisar las rutas
absolutas de las reglas `deny`, que llevan el nombre de usuario dentro.

### Mapa de symlinks (referencia rápida)

| Origen (repo)                  | Destino (sistema)                                | Tipo     | Comando        |
|-------------------------------|--------------------------------------------------|----------|----------------|
| `glazewm/config.yaml`        | `~\.glzr\glazewm\config.yaml`                   | Archivo  | `mklink`       |
| `zebar/settings.json`        | `~\.glzr\zebar\settings.json`                   | Archivo  | `mklink`       |
| `zebar/styles.css`           | `~\.glzr\zebar\styles.css`                      | Archivo  | `mklink`       |
| `zebar/with-glazewm.html`    | `~\.glzr\zebar\with-glazewm.html`               | Archivo  | `mklink`       |
| `nvim/`                      | `%LOCALAPPDATA%\nvim`                            | Carpeta  | `mklink /D`    |
| `flow-launcher/Settings.json`| `%APPDATA%\FlowLauncher\Settings\Settings.json`  | Archivo  | `mklink`       |
| `flow-launcher/Plugins/`     | `%APPDATA%\FlowLauncher\Settings\Plugins\`       | Carpeta  | `mklink /D`    |
| `bin/dev-session.cmd`        | `~\bin\dev-session.cmd`                          | Archivo  | `mklink`       |
| `powershell/Microsoft.PowerShell_profile.ps1` | `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` | Archivo | `mklink` |
| `windows-terminal/settings.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` | Archivo | `mklink` (cerrar WT antes) |

### Notas para el agente

- **Leer este README antes de editar cualquier archivo de configuración** — los archivos del sistema son symlinks, la fuente real está en este repo.
- **Usar `mklink` de cmd**, no `New-Item -ItemType SymbolicLink` de PowerShell (falla sin admin aunque el modo desarrollador esté activo).
- **No modificar archivos en los destinos directamente** — siempre editar dentro del repo (`~/dots_w11/`) y los symlinks propagarán los cambios.
- Los symlinks se crearon con **cmd** (`mklink`), no con PowerShell ni con Git Bash directamente. Para crearlos desde bash usar: `cmd //c mklink "destino" "origen"`.
- Si GlazeWM no detecta cambios tras crear el symlink, recargar con `Alt+Shift+R`.
- Neovim instalará plugins automáticamente al abrir por primera vez (lazy.nvim).
- El script `dev-session.cmd` abre nvim y Claude Code (con `--chrome`) en ventanas tileadas side-by-side usando PowerShell 7 (`pwsh`).
- El script `bin/link-wt.cmd` crea el symlink de Windows Terminal — ejecutar con WT cerrado.
- Flow Launcher debe reiniciarse tras aplicar los symlinks para que tome la nueva configuración.
- Para ejecutar `mklink` desde bash (Git Bash), usar: `cmd //c mklink "destino" "origen"`.
- **Windows Terminal** recrea `settings.json` automáticamente si se elimina mientras está abierto. Siempre cerrar WT antes de crear su symlink.
