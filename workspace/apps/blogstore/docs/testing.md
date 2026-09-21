# Flutter Testing & Driver Guide

Information on how to test and drive the Blogstore Flutter app in the modular workspace.

## Automated Testing with Flutter Driver
If the user asks to test the app:
1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD.
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect.
3. Use `flutter_driver` (`dart` MCP) to navigate.

## Driver Configuration
- Located in `workspace/apps/blogstore/lib/driver.dart`.
- Text entry emulation is OFF by default to keep the app usable by hand.
- To enable driver typing: set `enableTextEntryEmulation: true` in `lib/driver.dart` and `hot_restart`.

## Manual Verification
- Use `tail_flutter_logs` to monitor the app's output.
- Use `hot_restart` via MCP after significant UI or logic changes.
