# Optimization Notes

This revision turns the skill from a permissive demo generator into a production-oriented 1Panel App Store builder/reviewer.

## Fixed

- Corrected executable permissions for shell/Python tooling.
- Removed the false rule that every version directory must ship a `data/` runtime directory.
- Removed automatic `latest/` / `stable/` generation; concrete pinned versions are the default.
- Prevented a concrete upstream image tag from being silently replaced by a newer registry tag.
- Added multi-service Compose protection so DB/Redis/worker/init dependencies are not silently dropped.
- Preserved mapping-form Compose `environment` values and normalized long-form ports.
- Removed invented `/app/data`, PUID, PGID and UMASK defaults.
- Replaced the hardcoded 8080 rejection; 80/443 remain common host-port conflicts, while 8080 is validated normally.
- Added checks for undefined `PANEL_APP_PORT_*` variables and other unresolved Compose variables.
- Added floating-image checks for concrete version directories.
- Added browser-visible WebSocket hostname warnings.
- Added draft validation mode for missing release assets such as `logo.png`.
- Corrected metadata language coverage and accepts both `zh-hant` and legacy/case-variant `zh-Hant`.

## Improved

- Compose parsing now uses Python + PyYAML instead of depending on `yq`.
- A Compose file is structurally inspected once during generation, reducing startup overhead and inconsistent parsing.
- Added explicit dependency strategy guidance for reusing 1Panel-managed DB/Redis and for exceptions such as pgvector.
- Added init/migrate/permission/idempotency guidance, including Frappe-family multi-process apps.
- Added safer fixed-version, architecture and cross-version-update controls.
- Expanded regression tests for versioning, ports, multi-service lossiness, env mappings, floating tags and metadata consistency.

## Validation

Run:

```bash
bash ./tests/run_all.sh
```

The packaged revision is expected to pass all included static/unit tests before delivery.
