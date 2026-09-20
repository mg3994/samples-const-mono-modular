# BlocSignal Core API Architectural Reference

Comprehensive architectural guidelines and API patterns for the `bloc_signals` state management core framework.

## The Diagnostic Triad
Every `BlocSignalBase` subclass manages state propagation through three separated streams:
1. **State Mutation (`emit`)**: Drives user interface renderings and computed values directly.
2. **Operational Errors (`emitError`)**: Forwards unexpected exceptional behavior to global or local observers for lifecycle handling without modifying the application's underlying business parameters.
3. **Operational Milestones (`emitTelemetry`)**: Tracks asynchronous analytic markers or cached transitions natively without causing rendering updates or pipeline stalls.

## Event Transformers & Scheduling
When managing sophisticated concurrent events via `on<EventType>()`, specify performance execution constraints using pure streamless wrappers:
- `sequential()`: Handles events step-by-step in accurate FIFO sequencing.
- `droppable()`: Completely discards any newly added event if an existing handler is currently awaiting completion futures.
- `restartable()`: Instantly replaces any executing active handler with the latest event argument state cleanly.

## Key Rules
- Always use inline `late final` field parameters backed by `computed()` for tracking computed dependencies:
  ```dart
  late final isLoaded = computed(() => stateValue.items.isNotEmpty);
  ```
- Invoke `createEffect()` for assigning long-running context reactions owned entirely by the state container, guaranteeing zero memory leak trails upon closing the framework instance.
