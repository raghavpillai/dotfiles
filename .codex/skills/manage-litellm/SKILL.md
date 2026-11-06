---
name: manage-litellm
description: Manage litellm.zlt.dev users, persistent admin access, provider credentials, model routing, and inference tests. Use for the Zealot LiteLLM gateway; inference.zlt.dev is a separate service.
---

# Manage LiteLLM

## API routing

The OpenAI-compatible client base URL is **`https://litellm.zlt.dev/api/v1`**.
Send chat requests to `https://litellm.zlt.dev/api/v1/chat/completions`.
For management endpoints, use `https://litellm.zlt.dev/api` plus the endpoint,
for example `/user/info` or `/model/info`.

Caddy strips `/api` before forwarding to LiteLLM. Routes without that prefix,
including `https://litellm.zlt.dev/v1/chat/completions`, go through Google SSO
and can return HTTP 302 instead of JSON. Keep the SSO protection on dashboard
routes; use the existing API route for programmatic access. API calls still
require a LiteLLM bearer key. On the host, direct requests use
`http://127.0.0.1:4000/v1/chat/completions`.

## Host and persistence

Last verified on 2026-11-05; inspect current configuration before changing it.

- Host: `ubuntu@10.30.1.76`; SSH identity: `~/.ssh/ghes-key.pem`.
- Compose: `/opt/litellm/compose.yml`; Caddy: `/etc/caddy/Caddyfile`.
- Services: `litellm`, `sso-bridge`, `oauth2-proxy`, and `db`.
- SSO bridge source: `/opt/litellm/sso-bridge.py`.
- PostgreSQL named volume: `litellm_pgdata`; backup timer: `litellm-backup.timer`.

Inspect first and make changes within the user's requested scope. Prefer
LiteLLM management APIs for database-backed users, credentials, and models.
Back up configuration before editing it, validate Compose before recreating a
service, and recreate only the service that needs the change. Preserve the
database volume. Read credentials in process from the authorized environment;
never print them or put secret values in command arguments or documentation.

## Persistent admin access

The SSO bridge's `ADMIN_EMAILS` setting is authoritative for `proxy_admin`.
At sign-in, it promotes listed emails and demotes unlisted proxy admins to
`internal_user`. Changing only the database role will not preserve admin access.

To grant an admin, preserve existing entries while adding the normalized email
to `sso-bridge.environment.ADMIN_EMAILS` in Compose, then recreate only
`sso-bridge`. Update the existing user's role through `/user/update` to
`proxy_admin`. Verify the saved allowlist, running container environment, and
the role returned by `/user/info`. Preserve existing keys and budgets.

## Abliteration provider routing

The deployed LiteLLM v1.106.0 had no native Abliteration adapter. Its saved
`OPENAI_LIKE` provider produced an unmapped-provider error. Check the deployed
version before assuming native provider support from newer documentation.

The verified database configuration uses:

```yaml
credential_name: Abliteration AI
credential_info:
  custom_llm_provider: OpenAI
# Preserve the existing credential's api_key and api_base values.

model_name: abliteration/abliterated-model-large-v2
litellm_params:
  model: openai/abliterated-model-large-v2
  custom_llm_provider: openai
  api_base: https://api.abliteration.ai/v1
  litellm_credential_name: Abliteration AI
```

The public model alias and upstream model are different. Preserve that mapping.
Credential GET responses mask API keys; do not write those masked values back.
Patch only the needed metadata and retain the existing secret.

Provider references: [API](https://docs.abliteration.ai/api/introduction),
[models](https://docs.abliteration.ai/models), and
[LiteLLM OpenAI-compatible routing](https://docs.litellm.ai/docs/providers/openai_compatible).

## Verification

When inference testing is requested, send a small real completion through the
HTTPS `/api/v1/chat/completions` route using the saved public model alias.
Check HTTP 200, nonempty assistant content, and token usage. A connection check
or successful localhost request alone does not verify the external API route.

For the dashboard's `/health/test_connection`, pass the saved
`litellm_params.model` (the upstream model), provider, credential name, and
`model_info.id`. Supplying only the public alias can send that alias upstream
and produce a misleading model-not-found error.

Report the tested endpoint, model, result, and whether the change is persisted.
Keep generated tokens and credentials out of the output.
