# Arquitectura local-first con presupuesto adicional USD 0

Estado: **decisión de diseño, septiembre de 2026**. Este documento contiene únicamente requisitos técnicos no sensibles. No publicar capturas de cuentas, datos personales, nombres de equipos, correos, tokens, credenciales ni datos de clientes en un repositorio público.

## Capacidades disponibles verificadas en el diagnóstico

- Equipo Windows x64 con WSL 2, Docker Desktop, Docker Engine, Compose, Git y Python operativos según las comprobaciones aportadas. La imagen Docker utiliza Python 3.12 independientemente de la versión instalada en Windows.
- MySQL Community Server instalado y activo en Windows; se dispone de MySQL Workbench como interfaz administrativa. El acceso desde contenedores todavía NO está probado; no asumir exposición de MySQL.
- Power Automate Free / capacidades incluidas de Microsoft 365: conectores estándar. No hay derechos confirmados para conectores premium, HTTP premium, conectores personalizados, gateway local ni automatización de escritorio desatendida.
- Disponibilidad de herramientas interactivas de programación con IA bajo los términos y cuotas de suscripción correspondientes. NO asumir que las suscripciones web incluyen API pagada.
- Sin alojamiento Azure habilitado. GitHub contiene el código y puede ejecutar CI en runners estándar; NO es una base de datos ni un alojamiento permanente para API privadas.

## Restricciones obligatorias

1. **Presupuesto incremental: USD 0/mes** en infraestructura y USD 0/mes en API. Las suscripciones personales ya contratadas no forman parte del presupuesto incremental.
2. La API del proyecto debe conservar `ENABLE_LIVE=false` por defecto; únicamente usar `dry_run=true` mientras no exista aprobación expresa y confirmación de la modalidad de acceso a un proveedor.
3. Codex, Claude Code, Gemini CLI y Antigravity se podrán utilizar con autenticación de suscriptor cuando su plan lo permita para **desarrollo interactivo y autorizado**. Nunca utilizar scraping de sesiones web, cookies ni suplantación de un endpoint API para conectar el servicio a flujos desatendidos.
4. Gemini API puede ofrecer un **nivel gratuito separado**, con cuotas específicas y condiciones de tratamiento de datos. Utilizarlo únicamente si el titular decide habilitarlo, conoce sus condiciones y los datos de prueba no son sensibles. Bloquear automáticamente los niveles pagados.
5. El repositorio es público: no subir datos reales, dumps SQL, documentos profesionales, claves, `.env`, registros de modelos ni trazas con contenido de usuario.
6. Los flujos de la cuenta educativa solo se diseñarán para usos expresamente permitidos por su institución; no depender de ese tenant para datos personales o servicios profesionales privados.

## Arquitectura inicial sin pagos

```text
Windows local
 ├─ Power Automate Desktop (manual / attended)
 ├─ MySQL Server en localhost (BD de pruebas y cuenta read-only)
 ├─ Docker Desktop / WSL2
 │   ├─ FastAPI (127.0.0.1:8000; X-Hub-Key solo en desarrollo)
 │   ├─ n8n opcional, local y licenciado según el uso
 │   └─ tareas Python y simulaciones
 └─ IDE / terminal: Codex, Claude Code, Gemini CLI o Antigravity
        ↳ autenticación por suscripción; ejecución interactiva

GitHub público
 └─ GitHub Actions: validación, lint y pruebas del código público;
    sin incluir datos privados ni automatizaciones que requieran acceso al PC.

Power Automate cloud
 └─ Solo conectores estándar permitidos por licencia y política institucional.
    No conectar directamente a MySQL doméstico ni a FastAPI localhost.

Cloud hosting externo
 └─ NO activado hasta disponer de una alternativa gratuita compatible
    o autorización explícita para modificar el presupuesto.
```

Si Windows está apagado, las tareas locales no se ejecutan. GitHub Actions puede programar trabajos públicos y autónomos sin acceder a MySQL local ni a las suscripciones interactivas.

## MySQL: riesgo de mantenimiento pendiente

MySQL Server 8.0.46 es la última versión de la rama 8.0, que llegó a fin de vida en abril de 2026. Planificar una migración a MySQL 8.4 LTS con copia de seguridad, revisión de compatibilidad, prueba de restauración y validación de Workbench antes de almacenar datos reales. No actualizar ni modificar automáticamente la instalación actual.

## Gastos y bloqueos

| Integración | En presupuesto USD 0 | Estado |
|---|---|---|
| API FastAPI local + Docker | Sí, sin cargos adicionales del proveedor; el equipo consume electricidad | Preparada, no desplegada en PC desde GitHub |
| Scripts Python + MySQL local | Sí | Pendiente BD de prueba y usuario de mínimos privilegios |
| Power Automate Desktop attended | Sí dentro del uso permitido | Pendiente primer flujo |
| Power Automate cloud, conectores estándar | Sí dentro de derechos y políticas de la cuenta | Pendiente validación del caso concreto |
| Conectores premium, HTTP cloud o gateway local | No disponible con el plan confirmado | Bloqueado |
| Codex / Claude Code / Gemini CLI / Antigravity | Dentro de cuotas y condiciones de las suscripciones | Probar inicio de sesión y límites individualmente |
| OpenAI/Anthropic API pagada | No incluida en el presupuesto | Bloqueado |
| Gemini API Free Tier | Potencialmente sí | Opt-in explícito, cuota y privacidad por validar |
| Azure compute y bases de datos cloud de pago | No disponible | Bloqueado |
| GitHub Actions estándar en repo público | Gratuito bajo las reglas de GitHub | Solo CI y trabajos sin datos privados |

## Puertas de entrada para descripción de procesos

Antes de implementar automatizaciones reales se recogerán por separado:
- **Disparador:** evento local, frecuencia, email permitido, archivo aprobado, inicio manual.
- **Datos:** ficticios, públicos, internos, confidenciales, personales; origen y destinatarios.
- **Ejecución:** sin IA, IA interactiva bajo suscripción, API Free Tier autorizada o simulación.
- **Salida:** almacenamiento y aprobación humana para acciones externas.
- **Disponibilidad:** tolerancia al equipo apagado y necesidad de acceso remoto.
- **Costo:** USD 0 adicional obligatorio; cualquier cambio requiere nueva aprobación.

## Fuentes oficiales (comprobar cambios posteriores)

- Microsoft: https://learn.microsoft.com/en-us/power-platform/admin/power-automate-licensing/faqs
- Microsoft: https://learn.microsoft.com/en-us/power-platform/admin/power-automate-licensing/types
- OpenAI: https://help.openai.com/en/articles/9039756
- OpenAI Codex: https://help.openai.com/en/articles/11369540
- Anthropic: https://support.claude.com/en/articles/11145838
- Google AI Studio: https://ai.google.dev/gemini-api/docs/billing/
- Google Antigravity: https://antigravity.google/docs/plans
- MySQL EOL: https://dev.mysql.com/doc/relnotes/mysql/8.0/en/
- GitHub Actions: https://docs.github.com/en/billing/concepts/product-billing/github-actions
