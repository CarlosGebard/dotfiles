# Changelog

## 2026-03-21

- Corregido el modulo `cpu` en `config` para usar `{usage}%` en lugar de `{}%`.
- Motivo: Waybar estaba mostrando un valor incorrecto para el uso total de CPU en la barra.
- Actualizado el boton de Bluetooth para abrir `bluetuith` en `alacritty`.
- Actualizado el modulo de audio para abrir `wiremix` al hacer click.
- Reemplazado `custom/bluetooth` por el modulo nativo `bluetooth` de Waybar para mostrar estado y dispositivos conectados.
- Eliminado el indicador `bluetooth` de Waybar para dejar el control de Bluetooth en el `tray` mediante `blueman-applet`.
- Añadido `blueman-applet` al autostart de Hyprland para que el control de Bluetooth aparezca en el `tray` al iniciar sesión.
- Eliminado todo lo relacionado con `pasystray` porque no se integra correctamente con el `tray` de Waybar en este entorno.
- Mejorado el modulo `pulseaudio` para mostrar mejor el estado del audio y mantener `wiremix` como panel principal al hacer click.
- Ajustado el modulo `pulseaudio` para mostrar el nombre del dispositivo cuando la salida es Bluetooth y mantener compacto el resto de casos.
- Simplificado el modulo `pulseaudio` para mostrar solo el porcentaje de volumen en la barra.
- Restaurado el icono en el modulo `pulseaudio`, dejando el formato simple `icono + porcentaje`.
