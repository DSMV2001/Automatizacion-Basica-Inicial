# AI Automation Hub

MVP de automatización modular: FastAPI, webhook para Power Automate, simulación sin costo por defecto, conexión opcional con un gateway compatible con OpenAI (p. ej., LiteLLM), Docker y pruebas CI.

> **Estado:** prototipo inicial; NO está desplegado ni conectado todavía a Power Automate, MySQL ni a las cuentas de modelos. No pegar secretos ni datos de clientes en el repositorio.

## Comprobaciones para la fase híbrida

Antes de conectar proveedores, SQL o servicios en la nube, consulta la [guía en español de requisitos y diagnóstico](docs/REQUISITOS_Y_DIAGNOSTICO_ES.md). Incluye los paneles oficiales, datos que debes verificar y advertencias sobre secretos. En Windows puedes ejecutar el script **local y de solo lectura**, previa revisión:

```powershell
powershell -NoProfile -File .\scripts\diagnostico_local.ps1
```

Revisa el resultado antes de compartirlo. No se necesitan claves ni suscripciones API pagadas para las pruebas iniciales.

## Inicio local (Windows PowerShell)

```powershell
git clone https://github.com/DSMV2001/Automatizacion-Basica-Inicial.git
cd Automatizacion-Basica-Inicial
Copy-Item .env.example .env
# Edita .env: establece un HUB_API_KEY aleatorio de 32+ caracteres
docker compose up --build -d
curl.exe http://127.0.0.1:8000/health
```

Sin Docker: `python -m venv .venv`; activa el entorno, `pip install -e ".[dev]"`, carga variables de `.env` en tu terminal o con `uvicorn --env-file .env automation_hub.app:app --reload`.

## Primera tarea, sin llamadas a proveedores

```powershell
$headers = @{ "X-Hub-Key" = "TU_CLAVE_DE_.ENV" }
$body = @{ task_type = "summarize"; input = "Texto de prueba sin información confidencial"; dry_run = $true } | ConvertTo-Json
Invoke-RestMethod -Uri http://127.0.0.1:8000/v1/tasks/execute -Method Post -Headers $headers -Body $body -ContentType "application/json"
```

Solo devuelve una estimación aproximada de tokens, no una facturación real. En modo local, el puerto está ligado a 127.0.0.1: NO es accesible directamente desde Power Automate cloud. Antes de integrar Power Automate, desplegar mediante HTTPS y autenticación robusta (preferentemente Azure AD / API Management), o utilizar un relay seguro autorizado. No exponer el puerto del portátil a Internet.

## Activar llamadas reales (solo después de configurar presupuesto y autorización)

Configurar `ENABLE_LIVE=true`, `LLM_BASE_URL` (HTTPS; apunta a un gateway administrado como LiteLLM), `LLM_API_KEY`, `LLM_MODEL` y `HUB_API_KEY` en el entorno. Enviar `dry_run=false`. **AVISO:** habilitar LIVE puede generar cargos de API independientes de suscripciones de ChatGPT/Claude/Gemini. Este MVP limita longitud y salida pero **todavía NO aplica presupuestos monetarios ni registra el uso facturado**; no utilizarlo con datos sensibles o producción.

## Estructura

- `src/automation_hub/`: API, configuración y ejecución opcional mediante gateway.
- `tests/`: autenticación, límites y modo seguro por defecto.
- `.github/workflows/ci.yml`: pruebas automáticas con permisos mínimos.
- `docs/ARCHITECTURE.md`: evolución Power Automate, MySQL, MCP y observabilidad.
- `docs/SECURITY.md`: modelo inicial de amenazas y lista de requisitos.

Ejecutar pruebas: `python -m pytest -q`.

Licencia: aún pendiente de decisión; no asumir autorización para reutilizar código de terceros sin revisar sus licencias.
