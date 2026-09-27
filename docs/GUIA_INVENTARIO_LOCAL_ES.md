# Cómo revisar el portátil sin entregar control ni secretos

Este proceso se realiza **en tu propia computadora** y requiere que elijas explícitamente qué información revisar. No habilita acceso remoto ni envía archivos a ChatGPT o a GitHub. El repositorio es público: **no publiques informes sin revisar**.

## Paso 0: revisar el código

Abre los archivos de `scripts/` antes de ejecutarlos. Usa una consola PowerShell **sin privilegios de administrador** en la carpeta del repositorio. No necesitas desactivar Malwarebytes.

## Paso 1: inventario técnico

```powershell
powershell -NoProfile -File .\scripts\inventory_system.ps1
```

Devuelve solo versión y modelo general de Windows, CPU, memoria, GPU, capacidad y espacio libre por letra de unidad, versiones de una lista limitada de aplicaciones útiles y estado de servicios MySQL. No revisa seriales, claves, usuarios ni datos de archivos. Los nombres de programas instalados podrían considerarse privados: revisa el resumen antes de compartirlo.

## Paso 2: catálogo estadístico de carpetas AUTORIZADAS

Empieza con una carpeta pequeña donde **no haya documentos confidenciales**, por ejemplo una carpeta de pruebas que tú hayas creado:

```powershell
powershell -NoProfile -File .\scripts\inventory_metadata.ps1 -Roots @("$HOME\Documents\PruebasAI")
```

Posteriormente agrega una carpeta específica del SSD o de la unidad USB, después de confirmar que estás autorizado a procesarla:

```powershell
powershell -NoProfile -File .\scripts\inventory_metadata.ps1 -Roots @("$HOME\Documents\PruebasAI", "E:\CarpetaAutorizada") -MaxFilesPerRoot 20000 -MaxMinutesPerRoot 5
```

Cambia `E:\CarpetaAutorizada` por la ubicación real. **Nunca** apuntes de entrada a `C:\`, `C:\Windows`, a toda una unidad USB de terceros ni a carpetas corporativas. No se siguen enlaces simbólicos/junctions. Solo se generan estadísticas agregadas de cantidad y tamaño por categoría; no se exportan rutas ni nombres.

Para guardar un resultado privado fuera de Git:

```powershell
powershell -NoProfile -File .\scripts\inventory_metadata.ps1 -Roots @("$HOME\Documents\PruebasAI") -OutputPath "$HOME\Desktop\resumen_local.json"
```

El archivo de salida **no puede existir previamente**; así se evita sobrescribirlo por accidente. No se accede al contenido de los archivos.

## Paso 3: nube

- Google Drive: conectar una integración autorizada y seleccionar una carpeta, o elegir una carpeta local efectivamente sincronizada.
- OneDrive: trabajar con carpetas seleccionadas que ya estén disponibles en Windows, o un conector habilitado posteriormente.
- Los ficheros de nube exclusivamente en línea NO se deben descargar en masa para inventariarlos.
- El índice de chat, la biblioteca y los archivos adjuntos se revisan por separado.

## Paso 4: prueba funcional

Tras revisar los resúmenes, elegir **una sola** carpeta con documentos públicos o ficticios y un proceso de automatización reversible. Los permisos para tareas profesionales o sobre datos personales requieren nueva aprobación específica.

## Qué enviarnos

1. Salida depurada de `inventory_system.ps1` (opcionalmente una captura del estado de Malwarebytes sin códigos de licencia).
2. Resumen JSON de `inventory_metadata.ps1` de una carpeta de pruebas.
3. Descripción general de las ubicaciones que *tú* autorizas: documentos locales, carpeta del SSD, unidad USB, Google Drive personal u OneDrive personal. No compartir rutas privadas completas ni nombres de clientes.

**Limitación:** los scripts se prueban en el CI contra archivos sintéticos/públicos. La ejecución Windows debe probarse localmente antes de recorrer colecciones grandes.
