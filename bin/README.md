# bin

Scripts y accesos rápidos que terminan en `~/.local/bin` cuando se instala este repo.

## Scripts propios

- `rofi-whitelist`: abre un launcher de rofi usando `.config/rofi/whitelist.tsv`.
- `screen-manager.sh`: muestra un menu de pantallas y aplica layouts con `hyprctl`.
- `sunshine-tablet-desktop.sh`: prepara un monitor headless para Sunshine y deja un workspace dedicado en la tablet.
- `toggle-kb.sh`: notifica el layout activo del teclado en Hyprland.
- `warm-light.sh`: activa o desactiva luz calida con `gammastep`.
- `workspace-monitor-layout.sh`: alterna un layout headless basico para Sunshine.
- `yazi-cd.sh`: abre yazi y deja la terminal en el directorio final al salir.

## Symlinks

- `pgcli`: cliente interactivo para PostgreSQL.
- `vd`: alias corto de VisiData para explorar datos tabulares en terminal.
- `vd2to3.vdx`: helper de VisiData para convertir plugins/scripts antiguos.
- `visidata`: visor y manipulador de datos tabulares en terminal.

## Nota

Antes de borrar o renombrar scripts, revisar `.config/hypr/hyprland.conf` para no romper shortcuts.

Para el flujo de Sunshine con tablet, ver `docs/runbooks/sunshine-tablet-desktop.md`.
