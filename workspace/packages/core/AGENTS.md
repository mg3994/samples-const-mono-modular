# Core Package Agent Guide

Common logic, networking, storage, and utilities shared across the workspace.

## Architecture Guidelines (Clean + Iceberg)
- **Deep Logic (Iceberg Pattern)**: As the base of the architectural iceberg, this package encapsulates the core business logic, domain models, data repositories, and networking rules deep below the user-interface surface.
- **Layered Boundaries (Clean Architecture)**: Maintain clear data, domain, and contract boundaries to remain decoupled from any single UI framework or app shell state.

## Project Role
- **Shared Utilities**: Provides central configurations, network handlers, storage helpers, and custom error types.
- **Dependency**: Imported by the main application shell and other feature packages.

## Quick Links
- [Core Package Docs Directory](file:///C:/Users/manis/Desktop/workspace/workspace/packages/core/docs/)
- [Core Package Docs README](file:///C:/Users/manis/Desktop/workspace/workspace/packages/core/docs/README.md)

## Relevant Skills
- [flutter-apply-architecture-best-practices](file:///C:/Users/manis/Desktop/workspace/.agents/skills/flutter-apply-architecture-best-practices/SKILL.md)
- [synchronized-lock](file:///C:/Users/manis/Desktop/workspace/.agents/skills/synchronized-lock/SKILL.md)
- [flutter-implement-json-serialization](file:///C:/Users/manis/Desktop/workspace/.agents/skills/flutter-implement-json-serialization/SKILL.md)
