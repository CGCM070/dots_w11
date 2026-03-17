# GlazeWM v3 — Config Reference

Config: `%USERPROFILE%\.glzr\glazewm\config.yaml`

## Estructura del config.yaml

```yaml
general:
  startup_commands: ['shell-exec zebar']   # Lanza Zebar al arrancar
  shutdown_commands: ['shell-exec taskkill /IM zebar.exe /F']
  focus_follows_cursor: true
  hide_method: 'cloak'                     # Oculta ventanas sin cerrarlas

gaps:
  inner_gap: '10px'
  outer_gap:
    top: '40px'    # Espacio para la barra Zebar
    right: '10px'
    bottom: '10px'
    left: '10px'

window_effects:
  focused_window:
    border: { enabled: true, color: '#hex', width: '2px' }
    hide_title_bar: { enabled: false }
    transparency: { enabled: false, opacity: '95%' }
  other_windows:
    border: { enabled: true, color: '#hex', width: '1px' }

window_behavior:
  initial_state: 'tiling'                  # tiling | floating | fullscreen
  state_defaults:
    floating: { centered: true, shown_on_top: false }

workspaces:
  - name: '1'                              # Solo nombre, sin más config necesaria

window_rules:
  - commands: ['ignore']                   # No tilear esta ventana
    match:
      - window_process: { equals: 'zebar' }
      - window_title: { regex: 'patrón' }
      - window_class: { not_regex: 'clase' }

keybindings:
  - commands: ['comando']                  # SIEMPRE plural, lista con comillas simples
    bindings: ['alt+key', 'alt+otro']      # Múltiples bindings opcionales
```

## Comandos disponibles

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
| | `wm-enable-binding-mode --name <nombre>` |

## Binding modes (modo resize, etc.)

```yaml
binding_modes:
  - name: 'resize'
    keybindings:
      - commands: ['resize --width -2%']
        bindings: ['h']
      - commands: ['wm-disable-binding-mode --name resize']
        bindings: ['escape']

# Activar desde keybindings global:
  - commands: ['wm-enable-binding-mode --name resize']
    bindings: ['alt+r']
```

## Teclas modificadoras válidas

`alt` `shift` `ctrl` `lwin` `rwin`

## Recarga en caliente

`Alt+Shift+R` — no hace falta reiniciar GlazeWM para aplicar cambios.

---

## Keybindings activos

### Workspaces
| Binding | Acción |
|---------|--------|
| `Alt+1..9` | Ir al workspace |
| `Alt+Shift+1..9` | Mover ventana al workspace |

### Navegación
| Binding | Acción |
|---------|--------|
| `Alt+H` / `Alt+←` | Foco izquierda |
| `Alt+J` / `Alt+↓` | Foco abajo |
| `Alt+K` / `Alt+↑` | Foco arriba |
| `Alt+L` / `Alt+→` | Foco derecha |
| `Alt+Shift+H/J/K/L` | Mover ventana |
| `Alt+Ctrl+H/J/K/L` | Redimensionar |

### Estado de ventana
| Binding | Acción |
|---------|--------|
| `Alt+W` | Cerrar ventana |
| `Alt+F` | Fullscreen |
| `Alt+Shift+Space` | Alternar flotante/tiling |
| `Alt+Shift+F` | Explorador de archivos |
| `Alt+Shift+V` | Cambiar dirección tiling |

### Aplicaciones
| Binding | Acción |
|---------|--------|
| `Alt+Space` | Flow Launcher |
| `Alt+B` | Chrome |
| `Alt+Shift+B` | Chrome incógnito |
| `Alt+Shift+Return` | Windows Terminal |
| `Alt+Shift+E` | Outlook |
| `Alt+Shift+T` | Teams |
| `Alt+Shift+C` | Claude Code (PowerShell) |
| `Alt+Shift+O` | Terminal Ubuntu (WSL) |

### Sistema GlazeWM
| Binding | Acción |
|---------|--------|
| `Alt+Shift+R` | Recargar config |
| `Alt+Shift+X` | Salir de GlazeWM |

### Pendiente (requiere ejecutar bind.txt + reiniciar sesión)
| Binding | Acción |
|---------|--------|
| `Win+Alt+C` | Claude Code (PowerShell) — alternativa |
| `Win+Alt+O` | Terminal Ubuntu — alternativa |

> `focus_follows_cursor: true` está activado pero no funciona con touchpad (bug GlazeWM #799).
