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
