# Workspace: Modular Monorepo

This directory is the heart of the modular architecture. It uses Dart's workspace feature to manage multiple apps and packages.

## Directory Layout
- `apps/`: High-level Flutter applications.
- `packages/`: Reusable logic, UI components, and resources.
- `tools/`: Workspace-specific developer tools.

## Principles
1. **Modularity**: Business logic should reside in `packages/core` or feature-specific packages.
2. **Localization**: All strings should be managed through `packages/l10n`.
3. **App Shells**: Apps in `apps/` should be lightweight shells that orchestrate shared packages.
4. **Architecture (Clean + Iceberg)**: Combine Clean Architecture (strict boundary separation of Data, Domain, Presentation) with the **Iceberg Pattern** (keep a thin, lightweight UI/Presentation layer at the surface, while the vast majority of complex business rules, orchestration, networking, and state caching reside deep and well-encapsulated below the waterline in `packages/core` or the server backend).

## Main App
- **[Blogstore](file:///C:/Users/manis/Desktop/workspace/workspace/apps/blogstore/AGENTS.md)**: The primary application shell.
