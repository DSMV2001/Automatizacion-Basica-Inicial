# Política de incorporación de repositorios externos — presupuesto USD 0

**No clonar ni instalar 100 herramientas.** Cada candidato se evaluará según licencia efectiva, propietario, mantenimiento, dependencias, permisos solicitados, capacidad local y exposición de datos.

| Rol | Candidato | Estado para el MVP | Condición |
|---|---|---|---|
| Programación de tareas | Python + FastAPI existente | Ya incorporado | Pruebas y modo simulación |
| Código/CI | GitHub Actions | Ya incorporado | Solo código público y datos sintéticos |
| Escáner de secretos | gitleaks/gitleaks | Siguiente incorporación | Versión verificada, escaneo repo público |
| Escaneo de dependencias | google/osv-scanner | Siguiente incorporación | Revisión de política de updates |
| Escaneo de contenedores | aquasecurity/trivy | Siguiente incorporación | Límites y políticas de caché |
| Motor visual opcional | n8n-io/n8n / activepieces/activepieces | Estudio P2 | Licencia del proyecto, recursos Docker, necesidad real |
| MySQL para agentes | googleapis/mcp-toolbox | P2 | BD sintética, TLS, SELECT y herramientas permitidas |
| GitHub para agentes | github/github-mcp-server | P2 | PAT o autorización oficial con mínimo permiso |
| Navegación | microsoft/playwright | P2 | Sitios autorizados; API oficial cuando exista |
| Multiagente | langchain-ai/langgraph | P3 | Justificar contra scripts simples |
| API multi-proveedor | BerriAI/litellm | Bloqueado | Acceso API autorizado sin costos adicionales |
| Observabilidad IA | langfuse/langfuse | P3 | Datos sintéticos, recursos suficientes |
| Power Automate cloud | Microsoft conectores estándar | Según licencia | No usar HTTP/MySQL premium ni gateway sin derecho |

## Verificación de cada incorporación

- [ ] Repositorio oficial y versión sin archivar.
- [ ] Licencia revisada para el uso previsto, incluidos SaaS/Redistribución.
- [ ] Dependencias y hashes verificados, sin scripts post-install inesperados.
- [ ] Contenedor sin root, filesystem read-only cuando sea posible, sin montajes del disco completo.
- [ ] Docker Compose sin puertos públicos ni volumen permanente con secretos.
- [ ] Secrets en almacenamiento local no versionado y permisos mínimos.
- [ ] Prueba con datos sintéticos, salida reproducible y plan de reversión.
- [ ] Aprobación humana antes de instalar o conectar cuentas.
