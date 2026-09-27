# Security notes

**MVP limitations:** This project is an initial local development scaffold, NOT hardened production infrastructure. X-Hub-Key is a bootstrap local-only secret, not OAuth/SSO. Do not expose the container's HTTP endpoint directly to the Internet. The health endpoint is public. Live LLM mode can incur API costs. No monetary budget enforcement or comprehensive audit logging exists yet.

1. Generate a unique HUB_API_KEY of at least 32 random characters; store in a private local .env file. Never commit .env, model keys or customer data.
2. Use dry_run by default; explicitly enable live requests only after identifying the paid API account and budget.
3. When enabling live mode, use an authorized HTTPS gateway; no plaintext HTTP or redirect following.
4. Treat model responses as untrusted, and never execute their contents automatically.
5. Avoid personal and confidential information until a data protection assessment defines allowed providers, residency, retention and DPA controls.
6. For Power Automate cloud, deploy behind HTTPS and preferably Entra ID/API Management; enforce signed/scoped requests, audit logs, rate limits, quotas and rotation.
7. For MySQL, create separate test credentials and a read-only account; never expose the database to the public Internet.
8. Before production, run dependency, container and secret scans and pin GitHub Actions to reviewed commits.
