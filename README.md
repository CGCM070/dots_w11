# GlazeWM + Zebar — Documentación completa

Entorno de escritorio con tiling window manager para Windows 11.
Componentes: **GlazeWM** (gestor de ventanas) + **Zebar** (barra de estado).

---

## Estructura de archivos

```
%USERPROFILE%\
└── .glzr\
    ├── glazewm\
    │   ├── config.yaml        ← configuración principal de GlazeWM  [git]
    │   └── README.md          ← este archivo                        [git]
    └── zebar\
        ├── settings.json      ← qué widget carga zebar al arrancar  [git]
        ├── with-glazewm.html  ← widget de la barra (React/JSX)      [git] ← HARDLINK
        └── styles.css         ← estilos de la barra                 [git] ← HARDLINK
```

### Repositorios git

| Ruta | Descripción |
|------|-------------|
| `~/.glzr/glazewm/` | Repo git con `config.yaml` y este README |
| `~/.glzr/zebar/` | Repo git con `settings.json`, `with-glazewm.html` y `styles.css` |

### Hardlinks (importante)

Los archivos de la barra están en **dos ubicaciones que son el mismo archivo físico** gracias a hardlinks de Windows:

```
~/.glzr/zebar/with-glazewm.html  ──┐
                                    ├── mismo inodo en disco
AppData/Roaming/zebar/downloads/   ─┘
  glzr-io.starter@0.0.0/with-glazewm.html

~/.glzr/zebar/styles.css          ──┐
                                    ├── mismo inodo en disco
AppData/Roaming/zebar/downloads/   ─┘
  glzr-io.starter@0.0.0/styles.css
```

**Por qué:** Zebar carga los widgets desde `AppData/Roaming/zebar/downloads/` y no acepta rutas locales en `settings.json`. Los hardlinks permiten editar en `~/.glzr/zebar/` (con git) y que Zebar vea los cambios automáticamente.

**Para editar la barra:** modifica los archivos en `~/.glzr/zebar/` y recarga Zebar.

**Si Zebar actualiza el pack y rompe los hardlinks**, recréalos con PowerShell:

```powershell
$src = "$env:USERPROFILE\.glzr\zebar"
$dst = "$env:APPDATA\zebar\downloads\glzr-io.starter@0.0.0"

Remove-Item "$dst\with-glazewm.html" -ErrorAction SilentlyContinue
Remove-Item "$dst\styles.css" -ErrorAction SilentlyContinue

New-Item -ItemType HardLink -Path "$dst\with-glazewm.html" -Target "$src\with-glazewm.html"
New-Item -ItemType HardLink -Path "$dst\styles.css"        -Target "$src\styles.css"
```

> **Nota:** Los hardlinks no requieren permisos de administrador en Windows 11. Los symlinks sí.

---

## GlazeWM

### Archivo: `config.yaml`

```yaml
general:
  startup_commands: ['shell-exec zebar']   # Lanza Zebar al arrancar
  shutdown_commands: ['shell-exec taskkill /IM zebar.exe /F']
  focus_follows_cursor: true               # Bug con touchpad (#799), funciona con ratón
  hide_method: 'cloak'                     # Oculta ventanas sin cerrarlas

gaps:
  inner_gap: '10px'
  outer_gap:
    top: '38px'      # 28px barra Zebar + 10px de separación extra
    right: '10px'
    bottom: '10px'
    left: '10px'

window_effects:
  focused_window:
    border: { enabled: true, color: '#89b4fa', width: '2px' }
  other_windows:
    border: { enabled: true, color: '#45475a', width: '1px' }

window_behavior:
  initial_state: 'tiling'
  state_defaults:
    floating: { centered: true, shown_on_top: false }
    fullscreen: { maximized: false, shown_on_top: false }

window_rules:
  - commands: ['ignore']       # Zebar no se tileariza
    match:
      - window_process: { equals: 'zebar' }

workspaces:
  - name: '1'  # ... hasta 9
```

### Comandos disponibles en keybindings

| Categoría | Comando |
|-----------|---------|
| **Foco** | `focus --direction left\|right\|up\|down` |
| | `focus --workspace N` |
| | `focus --next-active-workspace` / `--prev-active-workspace` |
| **Mover** | `move --direction left\|right\|up\|down` |
| | `move --workspace N` |
| **Resize** | `resize --width +5%` / `--height -5%` |
| **Ventana** | `close` |
| | `toggle-floating --centered` |
| | `toggle-fullscreen` |
| | `toggle-tiling-direction` |
| | `toggle-minimized` |
| **Shell** | `shell-exec <programa>` |
| **Sistema** | `wm-reload-config` |
| | `wm-exit` |
| | `wm-toggle-pause` |

### Keybindings activos

#### Workspaces
| Binding | Acción |
|---------|--------|
| `Alt+1..9` | Ir al workspace |
| `Alt+Shift+1..9` | Mover ventana al workspace y seguirla |

#### Navegación
| Binding | Acción |
|---------|--------|
| `Alt+H` / `Alt+←` | Foco izquierda |
| `Alt+J` / `Alt+↓` | Foco abajo |
| `Alt+K` / `Alt+↑` | Foco arriba |
| `Alt+L` / `Alt+→` | Foco derecha |
| `Alt+Shift+H/J/K/L` | Mover ventana |
| `Alt+Ctrl+H/J/K/L` | Redimensionar (-5% / +5%) |

#### Estado de ventana
| Binding | Acción |
|---------|--------|
| `Alt+W` | Cerrar ventana |
| `Alt+F` | Fullscreen |
| `Alt+Shift+Space` | Alternar flotante/tiling |
| `Alt+Shift+V` | Cambiar dirección tiling (H/V) |

#### Aplicaciones
| Binding | Acción |
|---------|--------|
| `Alt+Space` | Flow Launcher |
| `Alt+B` | Chrome |
| `Alt+Shift+B` | Chrome incógnito |
| `Alt+Shift+Return` | Windows Terminal |
| `Alt+Shift+F` | Explorador de archivos |
| `Alt+Shift+E` | Outlook |
| `Alt+Shift+T` | Teams |
| `Alt+Shift+C` | Claude Code (PowerShell) |
| `Alt+Shift+O` | Terminal Ubuntu (WSL) |

#### Sistema
| Binding | Acción |
|---------|--------|
| `Alt+Shift+R` | Recargar config (hot reload) |
| `Alt+Shift+X` | Salir de GlazeWM |

---

## Zebar

### Archivo: `settings.json`

```json
{
  "startupConfigs": [
    {
      "pack": "glzr-io.starter",
      "widget": "with-glazewm",
      "preset": "default"
    }
  ]
}
```

Zebar solo acepta `pack/widget/preset` en `settings.json` — no hay soporte para rutas locales directas. De ahí el sistema de hardlinks explicado arriba.

### Archivo: `with-glazewm.html`

Widget React (buildless via Babel CDN). Estructura del layout:

```
.app  (flexbox, space-between)
├── .left
│   └── .workspaces         ← botones de workspace con fondo pill
└── .right                  ← panel derecho con fondo pill
    ├── tiling-direction
    ├── .network
    ├── .cpu
    └── .battery
```

**Providers activos:**

| Provider | Datos |
|----------|-------|
| `glazewm` | workspaces, tiling direction, binding modes |
| `network` | icono wifi/ethernet + SSID |
| `cpu` | porcentaje de uso |
| `battery` | porcentaje + icono de carga |

### Archivo: `styles.css`

**Diseño actual:**
- Barra con `background: transparent` — sin rectángulo de fondo en toda la barra
- `.workspaces` y `.right` tienen cada uno su propio `background` + `border-radius: 6px` (efecto pill)
- Workspace inactivo: `rgba(255 255 255 / 40%)`
- Workspace con ventanas: `rgba(255 255 255 / 70%)`
- Workspace activo (focused): `#f97316` (naranja)
- Layout: `flexbox` con `justify-content: space-between`

**Para cambiar colores**, editar las variables en `:root` y los selectores `.workspace`:

```css
:root {
  --text-size: 12px;
  --icon-size: 12px;
  --text-color-dark: rgba(255 255 255 / 95%);
  --icon-color-dark: rgba(115 130 175 / 95%);
}

.workspace.focused {
  color: #f97316;   /* color del workspace activo */
}
```

### Recargar Zebar

Zebar no tiene hot reload de configuración. Para aplicar cambios:

```powershell
taskkill /IM zebar.exe /F
Start-Process zebar
```

O salir y volver a entrar con GlazeWM (`Alt+Shift+X` y volver a abrir sesión), que lo lanza automáticamente via `startup_commands`.

---

## Workflow de modificaciones

### Modificar GlazeWM

```bash
# 1. Editar
code ~/.glzr/glazewm/config.yaml

# 2. Recargar sin reiniciar
# Alt+Shift+R desde el escritorio

# 3. Commitear
cd ~/.glzr/glazewm
git add config.yaml && git commit -m "..."
```

### Modificar Zebar (barra)

```bash
# 1. Editar (desde .glzr/zebar, NO desde AppData)
code ~/.glzr/zebar/with-glazewm.html
code ~/.glzr/zebar/styles.css

# 2. Recargar Zebar
taskkill /IM zebar.exe /F && zebar

# 3. Commitear
cd ~/.glzr/zebar
git add . && git commit -m "..."
```

> Editar directamente en `AppData/Roaming/zebar/downloads/` también funciona
> (es el mismo archivo por hardlink), pero se pierde la proximidad con git.

---

## Notas conocidas

- `focus_follows_cursor: true` no funciona con touchpad — bug GlazeWM [#799](https://github.com/glzr-io/glazewm/issues/799). Funciona con ratón externo.
- Si se actualiza el pack `glzr-io.starter` desde el marketplace de Zebar, los hardlinks se rompen. Recrearlos con el script de PowerShell de la sección de hardlinks.
- Los hardlinks solo funcionan dentro del mismo volumen/disco. Si mueves el perfil a otro disco, habrá que recrearlos.
