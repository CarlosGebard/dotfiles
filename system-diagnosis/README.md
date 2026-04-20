# Diagnostico del sistema

Este directorio contiene un diagnostico puntual del host y una guia corta de como se obtuvo.

## Archivos

- `diagnosis.md`: estado actual del sistema, hallazgos, riesgos y recomendaciones.
- `package-audit.md`: auditoria de paquetes, candidatos a limpieza y metodo de gestion.

## Metodo

El diagnostico se construyo con evidencia local tomada el `2026-03-18` desde la sesion actual usando utilidades del sistema como `uname`, `lscpu`, `uptime`, `top`, `vmstat`, `free`, `df`, `du`, `pacman`, `journalctl` y lectura de configuraciones en `/etc`.

## Alcance y limites

- La sesion actual no expone la tabla completa de procesos del host. Por eso el apartado de procesos muestra metricas globales de CPU y memoria, pero no un ranking confiable de procesos del sistema completo.
- Algunos comandos relacionados con `systemd` y el estado de arranque pueden verse afectados por el entorno de ejecucion. Cuando eso ocurra, el diagnostico lo marca explicitamente.
- Las recomendaciones de mantenimiento y seguridad se apoyan en documentacion oficial actual de Arch Linux y systemd, enlazada dentro de `diagnosis.md`.

## Uso

Lee `diagnosis.md` primero para el estado general del host. Luego usa `package-audit.md` para decidir que paquetes mantener, reclasificar o eliminar.
