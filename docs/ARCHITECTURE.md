# Architecture roadmap

## MVP (this commit)
- FastAPI REST endpoint; static secret in X-Hub-Key; simulation-first.
- Optional HTTPS OpenAI-compatible gateway (LiteLLM can be deployed separately).
- Request-size and approximate token caps; no automatic retries; no data persistence.
- Docker runs without root and only binds the host loopback interface.
- CI executes unit tests and static lint checks.

## Phase 2 — only after reviewing credentials, licenses, and data classes
- Power Automate: HTTPS reverse proxy or API Management + Entra ID OAuth, flow-scoped identities, durable audit IDs.
- MySQL: service account with SELECT only, TLS, parameterized queries, separate local testing database.
- MCP toolbox: isolated service, explicitly allowlisted SQL tools, strict network policy and authorization.
- Provider routing: deploy and secure LiteLLM; restrict model IDs and providers; enable budget enforcement.
- Telemetry: Langfuse with redaction; measure actual gateway usage and costs per job.

## Phase 3
- Human approval for sending messages, creating PRs, spending money and database mutations.
- Per-workflow quotas, idempotency keys, event queues, failure handling, SSO and key rotation.
- Adopt an explicit dependency update and security review process.

Note: MySQL Workbench is a desktop client, not the remote API; integrate with MySQL server through approved drivers/MCP instead.
