# Blogstore Modular Monorepo

This project is a modular monorepo leveraging Dart's workspace feature. It centralizes shared logic and multiple app shells.

## Monorepo Structure

### Core Backend & Client
- **[Server Backend](file:///C:/Users/manis/Desktop/workspace/blogstore_server/AGENTS.md)**: Serverpod server.
- **[Client Library](file:///C:/Users/manis/Desktop/workspace/blogstore_client/AGENTS.md)**: Generated bridge.

### Workspace (Main Development Area)
The `workspace/` directory contains the modular components of the project.
- **Apps**:
    - **[Blogstore App](file:///C:/Users/manis/Desktop/workspace/workspace/apps/blogstore/AGENTS.md)**: The **PRIMARY** Flutter frontend.
- **Packages**:
    - **[Core Package](file:///C:/Users/manis/Desktop/workspace/workspace/packages/core/AGENTS.md)**: Shared utilities.
    - **[Localization](file:///C:/Users/manis/Desktop/workspace/workspace/packages/l10n/AGENTS.md)**: I18n resources.

### Legacy Reference
- **[Legacy Flutter App](file:///C:/Users/manis/Desktop/workspace/blogstore/blogstore_flutter/AGENTS.md)**: Reference only, pending deletion.

## Workflow & Guidelines
- **[Serverpod Workflow](file:///C:/Users/manis/Desktop/workspace/blogstore_server/docs/workflow.md)**: Database, migrations, and MCP tools.
- **[Testing & Driver](file:///C:/Users/manis/Desktop/workspace/workspace/apps/blogstore/docs/testing.md)**: UI testing guide.

## Checklist
1. Focus development on `workspace/apps/` and `workspace/packages/`.
2. Ensure new logic is modularized in appropriate packages.
3. Follow the [Post-Change Checklist](file:///C:/Users/manis/Desktop/workspace/blogstore_server/docs/workflow.md#post-change-checklist) for backend updates.
