# Guía de recopilación de requisitos — AI Automation Hub

**Contexto confirmado (2026-09-27):** suscripciones a herramientas de IA, sin acceso API verificado; licencia de Power Automate desconocida; MySQL instalado en el PC; objetivo de ejecución híbrida (PC y nube). El proyecto se mantiene en **simulación local** y no solicita pagos ni claves todavía.

## Regla de seguridad
**No pegar, adjuntar ni subir** claves API, contraseñas, tokens, cadenas de conexión, identificadores privados de proyectos, correos personales, IP públicas, datos de clientes ni capturas con métodos de pago. Si compartes pantallas o resultados de consola, difumina nombres de usuario, hosts públicos, rutas personales y cualquier dato que identifique a terceros. Los valores secretos se configurarán más adelante como variables de entorno locales o administradores de secretos.

## Prioridad 1 — Comprobaciones locales

### A. Windows, WSL y Docker
1. Abre Docker Desktop y comprueba que indique que el motor está funcionando. En **Settings > General**, revisa el motor WSL 2; en **Settings > Resources > WSL Integration**, comprueba tu distribución si utilizas una.
2. En PowerShell ejecuta **solo comandos de lectura** (puedes utilizar `scripts/diagnostics.ps1`):
   ```powershell
   Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber
   wsl --version
   wsl --list --verbose
   docker version
   docker compose version
   git --version
   python --version
   ```
3. Comparte: versión de Windows, versión de WSL, estado de Docker (funciona/no funciona), versiones de Docker, Compose, Git y Python. Si aparece algún error, comparte su texto depurado.
4. No envíes un `docker info` completo ni variables de entorno: pueden revelar detalles de infraestructura.
Documentación: https://docs.docker.com/desktop/features/wsl/

### B. MySQL y MySQL Workbench
1. Abre **MySQL Workbench**, abre tu conexión **local** y accede a **Server > Server Status**. Confirma que el servidor esté activo, su versión y su estado de SSL/TLS. Si la conexión no abre, indica el error **sin nombres de usuario ni hosts privados**.
2. En el editor SQL, ejecuta únicamente:
   ```sql
   SELECT VERSION() AS mysql_version, @@port AS mysql_port, @@version_comment AS edition;
   SHOW VARIABLES LIKE 'require_secure_transport';
   ```
3. Comparte las versiones, el puerto (puede ser 3306 u otro), si MySQL Server funciona como servicio de Windows o contenedor Docker, y si existe **una base de datos vacía de pruebas**. No hacen falta contraseñas, volcados ni nombres de bases de producción.
4. Para la fase posterior necesitaremos autorizar un usuario de prueba con permisos SELECT únicamente. No lo crees ni nos envíes sus credenciales todavía.
Documentación: https://dev.mysql.com/doc/workbench/en/wb-mysql-connections-navigator-management-server-status.html

## Prioridad 2 — Licencias, API y consumo

### C. Microsoft Power Automate
1. Abre https://make.powerautomate.com e inicia sesión con tu cuenta habitual.
2. En el icono **Settings** (engranaje), selecciona **View my licenses**. También puedes consultar la tarjeta **Subscriptions** desde la configuración de tu cuenta.
3. Comprueba si aparece **Power Automate Premium**, licencia incluida con Microsoft 365, prueba temporal u otra. Comprueba si tienes acceso a un entorno y si puedes crear flujos en la nube.
4. Comparte solamente la denominación visible de la licencia, si es cuenta personal o profesional/educativa y si los conectores **HTTP** y **custom connectors** aparecen disponibles. Difumina direcciones de correo, información de tenant y nombres de la organización.
Documentación: https://learn.microsoft.com/en-us/power-platform/admin/power-automate-licensing/types

### D. OpenAI — ChatGPT y API son diferentes
1. Para la suscripción web: ChatGPT > **Settings > Billing**; anota tu tipo de plan (sin capturas de pago).
2. Para la API: abre https://platform.openai.com/usage y, si tu cuenta de API tiene permisos, comprueba si hay una organización/proyecto API con panel de consumo. En la configuración de facturación de la plataforma, comprueba solo si aparece habilitada (sí/no). **No crees claves nuevas ni agregues tarjetas para esta comprobación.**
3. Comparte: tipo de plan web; ¿tienes una cuenta API activa? (sí/no/no sé); ¿hay uso API registrado? (sí/no/no sé). No envíes importes detallados si no deseas compartirlos.
Documentación: https://help.openai.com/en/articles/9039756

### E. Gemini — aplicación, AI Studio y API
1. En tu cuenta de Gemini comprueba el tipo de suscripción de la aplicación.
2. Entra en https://aistudio.google.com/ y abre **Projects / API keys**, **Billing** y **Dashboard > Usage** si tienes acceso.
3. Comparte solo si tienes un proyecto de Gemini API, si aparece **Free tier**, **Prepay** o **Postpay**, y si existe uso disponible. No copies claves ni IDs completos.
4. Tener la aplicación de Gemini no confirma que dispongas de créditos API.
Documentación: https://ai.google.dev/gemini-api/docs/billing/

### F. Claude — aplicación y Claude Console
1. En https://claude.ai revisa el tipo de plan contratado desde configuración/facturación.
2. Entra en https://console.anthropic.com/ y comprueba si tienes acceso a **Billing**, **Usage** o **Cost**. No es necesario activar pagos.
3. Comparte el plan de la aplicación y si existe una cuenta de API habilitada. La suscripción de Claude no incluye por sí misma consumo de API.
Documentación: https://support.anthropic.com/en/articles/9876003-i-subscribe-to-a-paid-claude-ai-plan-why-do-i-have-to-pay-separately-for-api-usage-on-console

## Prioridad 3 — Nube, presupuesto y casos de uso

### G. Alojamiento híbrido
1. Comprueba en https://portal.azure.com > **Subscriptions** si tienes alguna suscripción de Azure (solo sí/no; no compartas el ID). Si existe, comprueba si tienes permisos para crear recursos y el acceso a **Cost Management > Budgets**.
2. Indica si también tienes cuentas en Google Cloud u otro VPS; ninguna es obligatoria en esta fase.
3. Define tu presupuesto máximo **mensual** para la nube y para **API de IA por separado**. Es válido fijar USD 0 para empezar. No crearemos recursos de pago sin una decisión posterior.
4. Si usaremos información confidencial, indica las regiones o restricciones jurídicas que debamos tener en cuenta sin enviar documentos de clientes.
Documentación: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management

### H. Primer flujo a automatizar
Describe un caso de uso sin datos reales:
- Evento de inicio: manual / horario / correo / webhook / archivo nuevo.
- Entrada: categoría de documento o dato (ficticio para pruebas).
- Acción deseada: consulta SQL / generar resumen / clasificar / crear borrador / notificar.
- Resultado: dónde almacenar el resultado y quién puede verlo.
- Frecuencia aproximada y si una persona debe aprobar acciones externas.
- Clasificación de la información: pública / interna / confidencial / datos personales.

## GitHub (ya conectado; no tienes que mandar claves)
Repositorio: https://github.com/DSMV2001/Automatizacion-Basica-Inicial
Revisar pruebas: https://github.com/DSMV2001/Automatizacion-Basica-Inicial/actions
Una vez que se autorice el despliegue, las claves para CI se almacenarán en **Settings > Secrets and variables > Actions**, nunca en commits. No agregues secretos todavía.
Documentación: https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets

## Formato para compartir el diagnóstico
```text
WINDOWS: edición / versión / build
WSL: versión / distribución WSL2 (si aplica)
DOCKER: Desktop, Engine y Compose / funciona SÍ-NO
PYTHON y GIT: versiones
MYSQL: Workbench / Server versión / puerto / Windows o Docker / conexión OK-NO
POWER AUTOMATE: nombre visible de licencia / ¿HTTP premium? / ¿custom connectors?
CHATGPT: plan web / API activa SÍ-NO-DESCONOZCO
GEMINI: plan web / API activa / nivel Free-Prepay-Postpay-Desconozco
CLAUDE: plan web / Console API activa SÍ-NO-DESCONOZCO
AZURE u otra nube: cuenta SÍ-NO / permisos de crear recursos SÍ-NO-DESCONOZCO
PRESUPUESTO MENSUAL: nube USD ___ / APIs USD ___
PRIMER FLUJO: evento / datos ficticios de entrada / salida / frecuencia / aprobación
```

**Importante:** el PC no queda accesible desde Power Automate cloud porque Docker publique el puerto en localhost. Nunca abriremos puertos del router ni publicaremos MySQL directamente; la futura conectividad será por HTTPS autenticado, gateway o canal de salida seguro, dependiendo de licencia y nube.
