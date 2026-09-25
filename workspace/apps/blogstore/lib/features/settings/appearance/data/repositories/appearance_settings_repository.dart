import 'dart:async';

import 'package:signals_core/signals_core.dart';

import '../../domain/repositories/appearance_settings_repository.dart';

class AppearanceSettingsRepositoryImpl(
  Stream<AppearanceSettings> cloudStream,
  Stream<AppearanceSettings> localStream, {
  required AppearanceSettings initialSettings,
  required final Future<void> Function(AppearanceSettings settings)
  _updateRemoteSettings,
  required final Future<void> Function(AppearanceSettings settings)
  _updateLocalSettings,
}) implements AppearanceSettingsRepository {
  late final Signal<AppearanceSettings> _settingsSignal;
  late final Connect<AppearanceSettings, AppearanceSettings> _connector;
  final _syncError = signal<String?>(null);

  this {
    _settingsSignal = signal(initialSettings);

    // 1. STREAM INTERCEPTION: Clear sync error automatically whenever
    // fresh data arrives from either stream (Cloud or Local DB)
    final autoClearingCloudStream = cloudStream.map((data) {
      _syncError.value = null;
      return data;
    });

    final autoClearingLocalStream = localStream.map((data) {
      _syncError.value = null;
      return data;
    });

    // Pipe the auto-clearing streams into the signal
    _connector = connect(_settingsSignal)
      ..from(autoClearingCloudStream)
      ..from(autoClearingLocalStream);
  }

  @override
  ReadonlySignal<AppearanceSettings> get computedAppearanceSettings =>
      _settingsSignal;

  @override
  ReadonlySignal<String?> get syncError => _syncError;

  @override
  void clearError() {
    _syncError.value = null;
  }

  @override
  Future<void> updateSettings(AppearanceSettings newSettings) async {
    final previousSettings = _settingsSignal.value;

    // 2. EQUALITY GUARD: Prevent redundant sync operations if state hasn't changed
    if (previousSettings == newSettings) return;

    // 3. OPTIMISTIC UPDATE: Clear previous errors & apply local change atomically
    batch(() {
      _syncError.value = null;
      _settingsSignal.value = newSettings;
    });

    try {
      await Future.wait([
        _updateLocalSettings(newSettings),
        _updateRemoteSettings(newSettings),
      ]);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // 4. ROLLBACK: Revert state and set error message on failure
      batch(() {
        _settingsSignal.value = previousSettings;
        _syncError.value = 'Failed to sync theme changes. Reverted back.';
      });
    }
  }

  @override
  void dispose() {
    _connector.dispose();
    _settingsSignal.dispose();
    _syncError.dispose();
  }
}
