# Neovim / LazyVim Configuration

## Overview

Neovim configuration using **LazyVim** distribution with Java development support (JUnit 5 tests via jdtls).

## Directory Structure

```
~/.config/nvim/
├── lua/
│   ├── config/
│   │   ├── lazy.lua          # LazyVim plugin manager setup
│   │   ├── keymaps.lua       # Custom keymaps
│   │   ├── options.lua       # Neovim options
│   │   └── autocmds.lua      # Autocommands
│   └── plugins/
│       ├── lsp-complete.lua  # LSP + Mason config (HTML, CSS, JSON, etc.)
│       ├── neo-tree-java.lua # Neo-tree Java integration
│       ├── dap-persist.lua   # DAP UI persistence + test output keymaps
│       └── ...
├── init.lua                  # Entry point
└── plugin/                   # Plugin configs
```

## LazyVim Extras Enabled

```lua
-- lua/config/lazy.lua
{ import = "lazyvim.plugins.extras.lang.java" },   -- Java LSP (jdtls) + tests
{ import = "lazyvim.plugins.extras.dap.core" },    -- Debugging
```

**Nota**: `nvim-jdtls` se configura automáticamente via LazyVim. No es necesario configuración manual.

## Custom Plugins

| Plugin | File | Purpose |
|--------|------|---------|
| `nvim-jdtls` | (LazyVim) | Java Language Server integration |
| `mason.nvim` | `lsp-complete.lua` | Package manager for LSPs, formatters, linters |
| `nvim-dap-ui` | `dap-persist.lua` | DAP UI persistence — keeps test output open |

## Mason Packages Installed

- `jdtls` - Java Language Server
- `java-debug-adapter` - Java debugger
- `java-test` - Java test runner
- `html-lsp`, `css-lsp`, `json-lsp` - Web language servers
- `prettier`, `eslint_d`, `stylelint` - Formatters/Linters
- `google-java-format` - Java formatter

## Keybindings (Java Tests)

Los keymaps de tests están configurados automáticamente por LazyVim via `lang.java`:

| Shortcut | Action | Source |
|----------|--------|--------|
| `<leader>tt` | Run all tests in class | LazyVim |
| `<leader>tr` | Run nearest test (under cursor) | LazyVim |
| `<leader>tT` | Pick test to run | LazyVim |
| `<leader>to` | Toggle test output (REPL + console) | `dap-persist.lua` |
| `<leader>tc` | Close test output | `dap-persist.lua` |

## Debug Keybindings

| Shortcut | Action | Source |
|----------|--------|--------|
| `<leader>du` | Toggle DAP UI (all panels) | `dap-persist.lua` |
| `<leader>dU` | Close DAP UI | `dap-persist.lua` |
| `<leader>dPt` | Debug nearest test | LazyVim |
| `<leader>dPc` | Debug class | LazyVim |

## DAP UI Behavior

- **Al ejecutar tests**: Solo se abre el panel inferior (REPL + console) automáticamente
- **La salida NO se cierra automáticamente** — se queda abierta para inspección
- **Para cerrar**: Usar `<leader>tc` (close) o `<leader>to` (toggle)
- **Para debugging completo**: Usar `<leader>du` para mostrar todos los paneles (scopes, breakpoints, stacks, watches)

### Layout del panel inferior (test output)

| Panel | Tamaño | Contenido |
|-------|--------|-----------|
| REPL (izquierda) | 15% | Resultados de tests (pass/fail) |
| Console (derecha) | 85% | Salida de `System.out.println`, stack traces |

Esto se logra sobreescribiendo los listeners `event_terminated` y `event_exited` de LazyVim y personalizando los layouts en `dap-persist.lua`.

## Features

- **Java LSP**: jdtls con soporte para Maven/Gradle (configurado por LazyVim)
- **JUnit Tests**: Ejecución directa via jdtls (no neotest)
- **Test Output Persistence**: La salida de tests se mantiene visible tras ejecución
- **Debug**: nvim-dap para debugging de Java con UI completa
- **Formateo**: google-java-format

## Notes

- Java LSP (jdtls) requiere Java 17+ instalado en el sistema
- Los tests usan la integración nativa de jdtls (no neotest - tenía bugs con Neovim 0.11)
- nvim-jdtls se configura automáticamente via LazyVim, no manualmente
- La salida de `System.out.println` aparece en el panel "console" de DAP UI
- Los resultados de tests (pass/fail) aparecen en el panel "repl" de DAP UI

---

**Last Updated**: Mar 4, 2026
**Maintained by**: CGCM070
