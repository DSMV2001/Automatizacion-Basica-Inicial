# Descubrimiento de fuentes y permisos mínimos

**Regla:** inventariar metadatos antes de abrir el contenido de archivos. No usar este repositorio público como destino de resultados locales, rutas privadas o registros sin depurar.

| Origen | Comprobación inicial | Método propuesto | Lo que no se hará |
|---|---|---|---|
| Documentos de Windows | Carpeta seleccionada manualmente | Script de metadatos por extensión | Lectura masiva de contenido, indexación secreta |
| SSD/USB extraíble | Confirmación de letra y carpetas permitidas | Enumeración solo lectura con límites | Formatear, mover o borrar |
| Google Drive personal | Usuario conecta y selecciona carpetas | Conector autorizado o carpeta sincronizada acotada | Suponer acceso por tener la aplicación |
| OneDrive personal | Elegir carpetas concretas | Sincronización local permitida o conector disponible | Forzar descarga de todo el almacenamiento |
| ChatGPT Library | Archivos aportados y carpetas compartidas | Revisión de material seleccionado | Publicar expedientes privados |
| Gmail/Calendar | Cuentas conectadas y autorizaciones existentes | Consultas focalizadas/lectura controlada | Buzón o agenda completos sin alcance definido |
| GitHub | Repositorios que el usuario puede autorizar | API oficial y PRs de revisión | Ejecutar código de terceros automáticamente |
| MySQL local | Servidor de pruebas y usuario SELECT | Driver local, consultas parametrizadas | Acceso de red público, root para automatizaciones |
| SQL Server / Access | Comprobar motores reales y archivo de ejemplo | ODBC/pyodbc o exportación aprobada | Asumir que SSMS es el motor SQL |

## Privacidad y riesgos

1. Datos confidenciales de trabajo: inventario privado y permisos del titular, nunca procesar sin base legal/contractual.
2. Información financiera y de salud: habilitación específica por flujo, minimización, destino local y revisión previa del contenido enviado a la IA.
3. El script `scripts/inventory_metadata.ps1` **NO accede al contenido**; solo agrupa por extensión, tamaño total y cantidad dentro de carpetas autorizadas.
4. Nunca guardar los resultados en el repositorio público; revisar el JSON agregado antes de adjuntarlo a un chat.
5. Directorios de Google Drive en modo streaming y ficheros OneDrive "solo en línea" pueden no estar físicamente en el dispositivo: consultar su índice mediante un conector cuando esté disponible; no descargar automáticamente.
6. Malwarebytes/Defender reducen exposición a amenazas conocidas; no demuestran que dependencias, contenedores, scripts o código de terceros sean seguros.
7. Antes de acceder a bibliotecas personales desde una interfaz gráfica, trabajar en una sesión iniciada por el usuario y con permisos concedidos a archivos/carpetas concretos; no pedir control irrestricto ni contraseñas.
