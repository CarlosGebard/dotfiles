# Diagnostico del sistema

Fecha del levantamiento: `2026-03-18`

## Resumen ejecutivo

- Sistema base: `Arch Linux` rolling.
- CPU: `Intel Core i7-8665U`, `4` nucleos / `8` hilos.
- Memoria: `15 GiB` RAM, con `7.1 GiB` disponibles en la verificacion posterior a la limpieza.
- Swap: `4.0 GiB` total, `3.9 GiB` en uso en la verificacion posterior a la limpieza.
- Disco raiz/home: `464 GiB`, `150 GiB` usados, `291 GiB` libres (`35%` de uso) tras la limpieza aplicada.
- Paquetes: `1316` instalados en total, `181` explicitos nativos, `29` externos/AUR, `0` huerfanos.
- Hallazgo prioritario: el kernel en ejecucion es `6.18.9-arch1-2`, pero el paquete instalado ya es `6.19.8.arch1-1`; hay reinicio pendiente tras la actualizacion de hoy.
- Hallazgo prioritario: hay reinicio pendiente para cargar tanto el kernel nuevo como `intel-ucode`, ya instalado en esta sesion.
- Hallazgo prioritario: la cache de `pacman` bajo de `20 GiB` a `15 GiB` tras `paccache -rk3`; los journals siguen en `2.2 GiB`.
- Hallazgo prioritario: la primera ronda segura de limpieza de paquetes ya se aplico y dejo el sistema con `0` huérfanos.

## 1. Procesos, CPU y memoria

### Observabilidad real disponible

La sesion actual no expone la tabla completa de procesos del host. Los comandos `ps` y `top` solo mostraron el arbol del shell de esta sesion, por lo que no es posible identificar con rigor "los procesos que mas consumen CPU" del sistema completo desde este entorno.

### CPU

- `uptime`: `load average 3.23 2.49 2.30`
- Para un equipo de `8` hilos logicos, la carga observada es moderada; no indica saturacion sostenida por si sola.
- Muestra de `top`: `53.3% idle`, `20.7% user`, `17.8% system`, `5.9% iowait`
- Muestras de `vmstat`:
  - idle entre `66%` y `81%`
  - iowait entre `7%` y `10%`

### Lectura operativa

- No hay evidencia de CPU saturada de forma sostenida.
- Si hay senales de espera de I/O y uso intenso de swap, lo que suele degradar respuesta interactiva aunque el CPU no este al `100%`.

### Memoria

- RAM total: `15 GiB`
- RAM usada: `7.0 GiB`
- RAM libre: `3.7 GiB`
- Memoria disponible: `7.1 GiB`
- Buffers/cache: `6.2 GiB`
- Swap: `3.9 GiB` usados de `4.0 GiB`

### Lectura operativa

- La RAM no esta agotada.
- El hecho de tener la swap practicamente llena indica presion historica de memoria o procesos que fueron desplazados y aun no regresan a RAM.
- Si percibes lentitud, el primer sospechoso no es el CPU sino la combinacion de swap alta + caches pesados + posibles accesos a disco.

## 2. Espacio en disco

### Estado general

- Particion principal: `/dev/nvme0n1p3`
- Uso: `150 GiB` de `464 GiB`
- Libre: `291 GiB`

No hay urgencia de capacidad total del disco, pero si hay varios focos claros de limpieza de alto retorno.

### Directorios mas grandes en `/home/carlos`

- `Documents`: `34 GiB`
- `.cache`: `22 GiB`
- `Videos`: `20 GiB`
- `.local`: `15 GiB`
- `Music`: `7.1 GiB`
- `.config`: `5.6 GiB`
- `Downloads`: `4.3 GiB`
- `.mail`: `3.5 GiB`
- `.npm`: `3.2 GiB`
- `.stack`: `2.8 GiB`

### Focos concretos de limpieza

#### `~/.cache` (`3.2 GiB` tras limpieza)

- `~/.cache/net.imput.helium`: `1.7 GiB`
- `~/.cache/huggingface`: `594 MiB`

#### `~/.local/share` (`11 GiB` aprox. tras limpieza puntual)

- `~/.local/share/PrismLauncher`: `5.9 GiB`
- `~/.local/share/Trash`: `4 KiB`
- `~/.local/share/pnpm`: `36 MiB`
- `~/.local/share/umu`: `776 MiB`
- `~/.local/share/nvim`: `706 MiB`

#### Otros focos

- `/var/cache/pacman/pkg`: `15 GiB`
- `journalctl --disk-usage`: `2.2 GiB`
- `~/Videos/Serial Experiments Lain 1998 1080p BluRay FLAC 2.0 x264-Chotab`: `20 GiB`
- `~/Documents/01-Proyects`: `20 GiB`
- `~/Documents/02-Resources`: `12 GiB`

### Lectura operativa

La optimizacion de espacio no pasa por tocar el sistema base, sino por:

1. limpiar caches reproducibles,
2. vaciar papelera,
3. depurar caches de compilacion/paquetes,
4. revisar datos pesados de usuario (`Videos`, `Documents`, `PrismLauncher`).

## 3. Paquetes y mantenimiento

### Inventario

- Total instalados: `1316`
- Nativos: `1287`
- Explícitos: `181`
- Externos/AUR: `29`
- Huerfanos: `0`
- Flatpak apps detectadas: `1` app, con runtimes asociados de alrededor de `1.6 GiB`

### Huerfanos detectados

La primera ronda segura de remocion ya fue ejecutada con `pacman -Rns $(pacman -Qdtq)` cuando aun habia `13` huérfanos. La transaccion retiro `29` paquetes en total, incluyendo los `-debug` y dependencias de testing ya no requeridas. Al cierre de esta auditoria no quedan huérfanos.

### Estado de actualizacion

- `pacman.log` muestra actividad de actualizacion hoy `2026-03-18 22:09 -0300`.
- `archlinux-keyring` instalado: `20260301-1`
- `linux` instalado: `6.19.8.arch1-1`
- `linux-lts` instalado: `6.18.18-1`
- `linux-firmware` instalado: `20260309-1`
- `intel-ucode` instalado: `20260227-1`

### Hallazgo critico de mantenimiento

El kernel en ejecucion segun `uname -a` sigue siendo `6.18.9-arch1-2`, pero ya tienes instalados kernels mas nuevos y ademas `intel-ucode` quedo instalado y sus `initramfs` fueron regenerados hoy. Eso implica que aun no estas corriendo ni el kernel ni el microcodigo ya desplegados en disco. El reinicio es la medida inmediata mas importante de esta auditoria.

### Configuracion de `pacman`

`/etc/pacman.conf` tiene:

- `CheckSpace`
- `ParallelDownloads = 5`
- `SigLevel = Required DatabaseOptional`

Eso es una base correcta para seguridad y mantenimiento.

### Archivos `.pacnew`

Se detectaron:

- `/etc/sudoers.pacnew`
- `/etc/bluetooth/main.conf.pacnew`
- `/etc/makepkg.conf.d/fortran.conf.pacnew`
- `/etc/locale.gen.pacnew`
- `/etc/pacman.d/mirrorlist.pacnew`
- `/etc/pacman.conf.pacnew`

Estos archivos requieren revision. Tener `.pacnew` acumulados no rompe el sistema hoy, pero si deja configuraciones importantes sin converger tras actualizaciones.

## 4. Seguridad

### Hallazgos observados

- `openssh` esta instalado.
- `ufw` esta instalado.
- `intel-ucode` ya esta instalado, pero todavia no cargado hasta reiniciar.
- No se detectaron sockets escuchando en la sesion actual, pero este dato no es concluyente por las limitaciones del entorno.
- No pude confirmar de forma fiable el estado real de `ufw`, `sshd` ni de otros servicios de `systemd` desde esta sesion.

### SSH

En `sshd_config` se observan los valores por defecto comentados:

- `PermitRootLogin prohibit-password` comentado
- `PasswordAuthentication yes` comentado
- `PubkeyAuthentication yes` comentado
- `KbdInteractiveAuthentication yes` comentado en el archivo principal
- `KbdInteractiveAuthentication no` en `/etc/ssh/sshd_config.d/99-archlinux.conf`

Lectura operativa:

- No hay evidencia aqui de una politica endurecida de SSH.
- Si `sshd` esta habilitado en el host real, conviene definir explicitamente autenticacion por clave, deshabilitar password auth y revisar `PermitRootLogin`.

### Microcodigo

`lscpu` informo `Vulnerability Old microcode: Vulnerable` en la captura inicial y el equipo usa CPU Intel. Ya se instalo `intel-ucode`; falta reiniciar y volver a verificar el estado efectivo.

### Endurecimiento adicional

No se confirmo `AppArmor`, `fwupd` ni estado de Secure Boot en esta sesion. Son candidatos razonables para una segunda fase de hardening, no para una conclusion falsa con los datos actuales.

## 5. Recomendaciones priorizadas

### Inmediatas

1. Reiniciar el sistema para cargar el kernel nuevo y `intel-ucode`.
2. Revisar y fusionar los `.pacnew` criticos, empezando por `sudoers`, `pacman.conf` y `mirrorlist`.
3. Evaluar si quieres reducir aun mas la cache de `pacman` o mantener 3 versiones como ahora.

### Esta semana

1. Ejecutar la segunda ronda de auditoria de paquetes en `package-audit.md`, ya por grupos funcionales.
2. Corregir razones de instalacion en paquetes que quieras conservar como explicitos.
3. Confirmar si `sshd` realmente se usa; si si, endurecer su configuracion.
4. Verificar si `ufw` esta activo y con politica por defecto restrictiva.
5. Revisar `Documents/01-Proyects`, `Documents/02-Resources` y `Videos` para mover o archivar contenido grande.

### Opcionales de hardening

1. Evaluar `fwupd` para firmware desde LVFS.
2. Evaluar `AppArmor` si quieres MAC ligero y utilitario.
3. Evaluar Secure Boot con `sbctl` si el flujo de arranque y el hardware lo permiten.

## 6. Pasos concretos sugeridos

Ya se ejecutaron tres cambios durante la remediacion inicial: instalacion de `intel-ucode`, limpieza conservadora de caches de usuario y recorte de cache de `pacman` con `paccache -rk3`. Estos son los siguientes pasos recomendados:

```bash
# 1. Aplicar el kernel actualizado
sudo reboot

# 2. Revisar archivos .pacnew
sudo DIFFPROG='nvim -d' pacdiff

# 3. Limpiar cache de pacman conservando versiones recientes
sudo paccache -rk3
sudo paccache -ruk0

# 4. Reducir journals archivados
sudo journalctl --vacuum-size=500M

# 5. Verificar si quedan nuevos huerfanos
pacman -Qdt

# 6. Verificar si SSH expone el host y endurecerlo si corresponde
sudo ss -tulpn
sudoedit /etc/ssh/sshd_config
```

Nota: la primera ronda segura de `pacman -Rns $(pacman -Qdtq)` ya fue aplicada en esta sesion. Si vuelven a aparecer huérfanos, conviene revisarlos antes de una nueva remocion.

## 7. Recomendaciones de politica operativa

- Mantener el flujo de actualizacion completo con `pacman -Syu`, evitando actualizaciones parciales.
- Establecer una rutina mensual de limpieza de cache y revision de `.pacnew`.
- Mantener una politica de cache de `pacman` consistente, idealmente con `paccache`.
- Revisar despues de cada actualizacion importante si hace falta reinicio del kernel o de servicios.
- Si expones servicios de red, documentar puertos esperados y aplicar firewall por defecto restrictivo.

## 8. Fuentes y mejores practicas consultadas

- ArchWiki, System maintenance: https://wiki.archlinux.org/title/System_maintenance
- ArchWiki, Microcode: https://wiki.archlinux.org/title/Microcode
- Arch package `fwupd`: https://archlinux.org/packages/extra/x86_64/fwupd/
- ArchWiki, OpenSSH: https://wiki.archlinux.org/title/OpenSSH
- ArchWiki, UFW: https://wiki.archlinux.org/title/Uncomplicated_Firewall
- ArchWiki / pacman-key sobre firma de paquetes y actualizacion regular: https://wiki.archlinux.org/title/Pacman-key
- systemd `journalctl` manual (`--vacuum-size`, `--vacuum-time`): https://www.freedesktop.org/software/systemd/man/254/journalctl.html
- Manual de AppArmor en Arch: https://man.archlinux.org/man/aa-notify.8

## 9. Limitaciones del diagnostico

- No fue posible obtener una lista confiable de procesos del host completo desde esta sesion.
- El estado efectivo de `systemd`, servicios y arranque EFI/Secure Boot debe validarse directamente en una sesion no aislada.
- No se ejecutaron acciones destructivas ni de limpieza automatica en esta tarea; el objetivo aqui fue diagnosticar y dejar una guia operativa segura.
