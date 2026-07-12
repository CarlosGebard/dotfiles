# Runbook: escritorio de tablet con Sunshine

## Proposito

Usar `sunshine-tablet-desktop.sh` para exponer un workspace dedicado de Hyprland en un monitor headless para un cliente Sunshine en tablet, dejando el escritorio normal en el monitor fisico.

## Activar

```bash
sunshine-tablet-desktop.sh on
```

Por defecto crea o activa:

- monitor fisico: monitor enfocado actual, modo `preferred`, escala `auto`, workspace `1`
- monitor de tablet: `HEADLESS-2`, `1920x1080@60`, workspaces `3` y `4`
- pantalla de laptop: no se desactiva salvo que se use `SUNSHINE_DISABLE_LAPTOP=1`

Sunshine debe estar configurado para capturar la pantalla `HEADLESS-2`.

## Desactivar

```bash
sunshine-tablet-desktop.sh off
```

Esto mueve el workspace de tablet de vuelta al monitor fisico y desactiva el monitor headless.

## Revisar estado

```bash
sunshine-tablet-desktop.sh status
```

## Overrides comunes

```bash
SUNSHINE_CLIENT_WIDTH=2560 SUNSHINE_CLIENT_HEIGHT=1600 sunshine-tablet-desktop.sh on
SUNSHINE_TABLET_WORKSPACES="3 4 5" SUNSHINE_TABLET_WORKSPACE=3 sunshine-tablet-desktop.sh on
SUNSHINE_PHYSICAL_OUTPUT=DP-2 sunshine-tablet-desktop.sh on
SUNSHINE_DISABLE_LAPTOP=0 sunshine-tablet-desktop.sh on
```

## Recuperacion

Si el monitor de tablet queda activo pero no sirve, ejecutar:

```bash
sunshine-tablet-desktop.sh off
```

Si la pantalla queda negra, abrir una TTY con `Ctrl+Alt+F3`, iniciar sesion y ejecutar:

```bash
HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /tmp/hypr | head -n 1) ~/.local/bin/sunshine-tablet-desktop.sh off
```

Si eso no alcanza, reactivar la pantalla de laptop:

```bash
HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /tmp/hypr | head -n 1) hyprctl keyword monitor eDP-1,preferred,0x0,auto
```

Si cambiaron los nombres de monitores, inspeccionar las salidas de Hyprland:

```bash
hyprctl monitors all
```
