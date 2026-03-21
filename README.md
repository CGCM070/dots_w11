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

```cmd
git clone git@github.com:CGCM070/dots_w11.git %USERPROFILE%\dots_w11
```

### Paso 2: Crear directorios destino (si no existen)

```cmd
mkdir %USERPROFILE%\.glzr\glazewm 2>nul
mkdir %USERPROFILE%\.glzr\zebar 2>nul
mkdir %USERPROFILE%\bin 2>nul
mkdir %APPDATA%\FlowLauncher\Settings 2>nul
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

:: bin - script
mklink %USERPROFILE%\bin\dev-session.cmd %DOTS%\bin\dev-session.cmd
```

### Paso 5: Verificar

```cmd
dir %USERPROFILE%\.glzr\glazewm\config.yaml
dir %USERPROFILE%\.glzr\zebar\
dir %LOCALAPPDATA%\nvim
dir %APPDATA%\FlowLauncher\Settings\Settings.json
dir %APPDATA%\FlowLauncher\Settings\Plugins
dir %USERPROFILE%\bin\dev-session.cmd
```

Cada archivo/carpeta debe mostrar `<SYMLINK>` o `<SYMLINKD>` en la salida.

### Paso 6: Recargar aplicaciones

- **GlazeWM**: Pulsar `Alt+Shift+R` para recargar la config
- **Flow Launcher**: Cerrar y reabrir (o `taskkill /IM Flow.Launcher.exe /F` y volver a lanzar)
- **Neovim**: Abrir normalmente, lazy.nvim instalará los plugins automáticamente en el primer arranque

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

### Notas para el agente

- **Usar `mklink` de cmd**, no `New-Item -ItemType SymbolicLink` de PowerShell (falla sin admin aunque el modo desarrollador esté activo).
- **No modificar archivos en los destinos directamente** — siempre editar dentro del repo (`~/dots_w11/`) y los symlinks propagarán los cambios.
- Si GlazeWM no detecta cambios tras crear el symlink, recargar con `Alt+Shift+R`.
- Neovim instalará plugins automáticamente al abrir por primera vez (lazy.nvim).
- El script `dev-session.cmd` abre nvim y Claude Code (con `--chrome`) en ventanas tileadas side-by-side.
- Flow Launcher debe reiniciarse tras aplicar los symlinks para que tome la nueva configuración.
- Para ejecutar `mklink` desde bash (Git Bash), usar: `cmd //c mklink "destino" "origen"`.
