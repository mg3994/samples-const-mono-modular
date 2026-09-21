# Blogstore Main Flutter App

This is the **primary** Flutter frontend for the Blogstore project, located within the modular monorepo.

## Architecture Guidelines (Clean + Iceberg)
- **Thin UI (Iceberg Pattern)**: The app layer acts as the visible tip of the iceberg—providing a lightweight, responsive UI that orchestrates deep services from `packages/core`.
- **Presentation Layer (Clean Architecture)**: Focuses exclusively on the presentation layer, delegating complex orchestration, caching, and data rules to the shared modular components.

## Project Role
- **Main Frontend**: This app replaces the legacy reference app in `blogstore/blogstore_flutter`.
- **Modular Integration**: Uses packages from `workspace/packages/` (e.g., `core`, `l10n`).
- **Serverpod Connection**: Connects to the `blogstore_server` backend via the `blogstore_client`.

## Quick Links
- [Blogstore Docs Directory](file:///C:/Users/manis/Desktop/workspace/workspace/apps/blogstore/docs/)
- [Testing & Driver Guide](file:///C:/Users/manis/Desktop/workspace/workspace/apps/blogstore/docs/testing.md)
- [Frontend Architecture Skill](file:///C:/Users/manis/Desktop/workspace/.agents/skills/flutter-apply-architecture-best-practices/SKILL.md)

## Responsibilities
- Implement production-ready UI/UX.
- Integrate workspace packages.
- Orchestrate client-side business logic.

## Relevant Skills
- [serverpod-flutter-frontend](file:///C:/Users/manis/Desktop/workspace/.agents/skills/serverpod-flutter-frontend/SKILL.md)
- [flutter-add-widget-test](file:///C:/Users/manis/Desktop/workspace/.agents/skills/flutter-add-widget-test/SKILL.md)
- [flutter-add-integration-test](file:///C:/Users/manis/Desktop/workspace/.agents/skills/flutter-add-integration-test/SKILL.md)
