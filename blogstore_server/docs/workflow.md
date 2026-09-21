# Serverpod Workflow

This document describes the workflow for working with the Serverpod backend.

## Server Management
- The user starts the server and Flutter app with `serverpod start`.
- NEVER start the server yourself. If it's not running, ask the user to start it.
- Use the MCP server for most tasks instead of the CLI.

## MCP Tools Checklist
Use the `serverpod` MCP server to:
- `create_migration` and `apply_migrations`: Update database after changing data models.
- `create_repair_migration`: Fix out-of-sync database.
- `tail_server_logs`: Read server logs.
- `tail_flutter_logs`: Read Flutter app logs.
- `hot_reload` / `hot_restart`: Reload or restart the server and Flutter app. ALWAYS `hot_restart` after Flutter changes that need more than hot reload.
- `spawn_flutter_app`: Start companion Flutter apps.
- `get_flutter_app_dtd`: Get the Dart Tooling Daemon for testing.

## Model Changes
- Define models in `.spy.yaml` files.
- NEVER edit generated code in `lib/src/generated/` or the `blogstore_client` package.
- Migrations in `migrations/` can be edited by hand ONLY for data transformations.

## Testing
- Tests run against an embedded PostgreSQL managed by Serverpod.
- No Docker is needed for tests (`config/test.yaml` handles this).
- Run `dart test` in the server package.

## Post-Change Checklist
1. `dart analyze` (CLI)
2. `dart format` (CLI)
3. `create_migration` and `apply_migrations` (MCP - if models changed)
4. `hot_restart` (MCP)
5. Run tests: `dart test`
6. Check logs: `tail_server_logs` and `tail_flutter_logs`
