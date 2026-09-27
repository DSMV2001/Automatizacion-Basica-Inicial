# Catálogo genérico de procesos candidatos (sin datos personales)

**Propósito:** plantillas reutilizables para seleccionar automatizaciones antes de acceder a información real. Documento apto para repositorio público. No confirma que exista ningún archivo ni servicio personal. Prioridad orientativa: **P1** piloto sin costo, **P2** después de validación; **P3** exige evaluación de privacidad/permisos.

| ID | Proceso | Disparador | Entrada habitual | Resultado | Fase |
|---|---|---|---|---|---|
| J01 | Seguimiento de vacantes públicas | Diario/manual | Enlaces oficiales y consultas | Tabla de oportunidades vigentes | P1 |
| J02 | Detección de vacantes repetidas | Nueva oferta | URL/código de puesto | Registro sin duplicados | P1 |
| J03 | Seguimiento de postulaciones | Solicitud enviada | Datos proporcionados voluntariamente | Recordatorios y estados | P1 |
| J04 | Preparación de variantes ATS | Inicio de solicitud | CV aprobado y descripción de puesto | Borrador de CV/carta | P2 |
| J05 | Investigación salarial y migratoria | Vacante elegida | País, ocupación, fecha | Ficha con fuentes | P2 |
| E01 | Planeación de estudio e idiomas | Semanal | Materias y horas libres | Plan y ejercicios | P1 |
| E02 | Becas y programas internacionales | Semanal | Fuentes públicas | Calendario de plazos | P2 |
| E03 | Materiales docentes y casos sintéticos | Nueva clase | Objetivos y documentos autorizados | Esquema, ejemplos ficticios | P2 |
| L01 | Seguimiento de normativa pública | Semanal | Registros oficiales | Resumen con fuentes y fecha | P2 |
| L02 | Matriz de tratamientos y riesgos | Alta/cambio de proceso | Plantilla y datos ficticios | Inventario y alertas | P2 |
| L03 | Control de versiones documentales | Archivo aprobado | Documentos no confidenciales | Registro de cambios | P1 |
| L04 | Borradores y reportes profesionales | Tarea autorizada | Plantillas ficticias o anonimizadas | Documento para revisión humana | P3 |
| S01 | Diario de actividad deportiva | Tras entrenar | Exportación local voluntaria GPX/CSV | Resumen y tendencias | P2 |
| S02 | Rutas deportivas | Ruta aprobada | GPX/waypoints de origen verificable | Archivo GPX revisado | P2 |
| S03 | Comparador de dispositivos | Nueva oferta | Especificaciones y precios públicos | Matriz de alternativas | P1 |
| T01 | Itinerarios y alertas de viaje | Fecha/ubicación | Fuentes públicas | Calendario y checklist | P2 |
| A01 | Clasificación del correo | Diario/solicitud | Mensajes autorizados | Etiquetas y borradores | P2 |
| A02 | Calendario, reuniones y seguimiento | Nuevo evento | Calendario autorizado | Resumen y recordatorio | P1 |
| D01 | Inventario de discos y nubes | Ejecución manual | Carpetas elegidas | Estadísticas agregadas | P1 |
| D02 | Copias de seguridad verificadas | Manual/horario | Carpetas autorizadas | Registro y validación sin borrar fuentes | P2 |
| F01 | Consolidación financiera | Mensual | Exportaciones voluntarias | Presupuesto y conciliación | P3 |
| C01 | Calidad del repositorio | Commit/PR | Código público propio | Pruebas, lint y alertas | P1 |
| C02 | Benchmark de modelos y prompts | Cambio planificado | Datos sintéticos y modelos autorizados | Costos y calidad medidos | P2 |
| C03 | Reutilización de fragmentos de código | Nueva tarea | Scripts propios | Plantillas revisadas | P1 |

## Reglas transversales

- La **ubicación real** de cualquier fuente se considera desconocida hasta realizar inventario autorizado.
- En el repositorio público solo se guardarán código, plantillas ficticias, documentación genérica y resultados sintéticos.
- Datos personales, actividad física, finanzas, documentos profesionales privados y correos reales permanecen en almacenamiento local o repositorio privado explícitamente autorizado.
- Los agentes producen borradores y solicitudes de cambio: envíos, pagos, borrados, operaciones sobre datos reales y publicaciones exigen autorización humana.
- Presupuesto incremental USD 0: sin APIs de pago, Azure ni conectores premium.
- Una suscripción interactiva de IA no autoriza integrarla como API desatendida.
- Para tareas jurídicas, migratorias y normativas comprobar fechas y fuentes oficiales, sin generar decisiones automáticas.

## Plantilla de descripción (duplicar por proceso)

```yaml
process_id: "J01"
name: "..."
owner: "..."
frequency: "manual"
trigger: "..."
input_sources:
  - kind: "public-url | local-folder | selected-cloud-folder | local-database"
    location_verified: false
data_classification: "public | internal | confidential | personal"
steps_manual: []
outputs: []
storage_destination: "..."
human_approval: true
needs_ai: false
ai_channel: "none | interactive-subscription | authorized-free-api"
execution: "local | github-actions-public | standard-cloud-connector"
failure_recovery: "..."
retention_days: null
budget_incremental_usd: 0
success_measure: "..."
```
