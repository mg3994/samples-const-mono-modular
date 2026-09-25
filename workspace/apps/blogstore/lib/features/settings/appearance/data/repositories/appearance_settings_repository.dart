import 'dart:async';
import 'package:flutter/material.dart';
import 'package:signals_core/signals_core.dart';


class AppearanceSettingsRepositoryImpl(
  Stream<AppearanceSettingsState> cloudStream,
  Stream<AppearanceSettingsState> localStream,
  Stream<bool> isConnectedStream, {
  required AppearanceSettingsState initialSettings,
  required final Future<AppearanceSettingsState> Function() _fetchRemoteSettings,
  required final Future<void> Function(AppearanceSettingsState settings) _updateRemoteSettings,
  required final Future<void> Function(AppearanceSettingsState settings) _updateLocalSettings,
}) implements AppearanceSettingsRepository {

  // Reactive State Signals
  late final Signal<AppearanceSettingsState> _settingsSignal;
  late final Signal<bool> _isConnectedSignal;
  
  // Stream Connectors
  late final Connect<AppearanceSettingsState, AppearanceSettingsState> _connector;
  late final Connect<bool, bool> _connectivityConnector;

  // Status Signals
  final _syncError = signal<String?>(null);
  final _isPendingSync = signal<bool>(false);

  bool _isReconciling = false;

  this {
    _settingsSignal = signal(initialSettings);
    _isConnectedSignal = signal(true);

    _connectivityConnector = connect(_isConnectedSignal)..from(isConnectedStream);

    // Auto-clear sync error on fresh stream emissions
    final autoClearingCloudStream = cloudStream.map((data) {
      _syncError.value = null;
      _reconcileIncomingData(data, source: 'cloud');
      return data;
    });

    final autoClearingLocalStream = localStream.map((data) {
      _syncError.value = null;
      _reconcileIncomingData(data, source: 'local');
      return data;
    });

    _connector = connect(_settingsSignal)
      ..from(autoClearingCloudStream)
      ..from(autoClearingLocalStream);

    // Reconnection Listener
    effect(() {
      final isOnline = _isConnectedSignal.value;
      if (isOnline && _isPendingSync.value) {
        unawaited(_reconcileOnReconnection());
      }
    });
  }

  @override
  ReadonlySignal<AppearanceSettingsState> get computedAppearanceSettings =>
      _settingsSignal;

  @override
  ReadonlySignal<String?> get syncError => _syncError;

  @override
  ReadonlySignal<bool> get isPendingSync => _isPendingSync;

  @override
  void clearError() {
    _syncError.value = null;
  }

  /// Mutate state with auto-stamped DateTime.now()
  @override
  Future<void> updateSettings(AppearanceSettingsState newSettings) async {
    final currentSettings = _settingsSignal.value;

    // Structural Equality Check (Record built-in ==)
    if (currentSettings == newSettings) return;

    // Stamp new state with current timestamp
    final stampedSettings = newSettings.copyWith(updatedAt: DateTime.now());

    // 0ms Optimistic Update
    batch(() {
      _syncError.value = null;
      _settingsSignal.value = stampedSettings;
    });

    await _updateLocalSettings(stampedSettings);

    if (_isConnectedSignal.value) {
      try {
        await _updateRemoteSettings(stampedSettings);
        _isPendingSync.value = false;
      } catch (_) {
        _isPendingSync.value = true;
        _syncError.value = 'Saved locally. Will sync when back online.';
      }
    } else {
      _isPendingSync.value = true;
    }
  }

  void _reconcileIncomingData(AppearanceSettingsState incoming, {required String source}) {
    final current = _settingsSignal.value;

    if (incoming.updatedAt.isAfter(current.updatedAt)) {
      _settingsSignal.value = incoming;
      
      if (source == 'cloud') {
        unawaited(_updateLocalSettings(incoming));
      }
    }
  }

  Future<void> _reconcileOnReconnection() async {
    if (_isReconciling) return;
    _isReconciling = true;

    try {
      final localData = _settingsSignal.value;
      final remoteData = await _fetchRemoteSettings();

      if (remoteData.updatedAt.isAfter(localData.updatedAt)) {
        batch(() {
          _settingsSignal.value = remoteData;
          _isPendingSync.value = false;
          _syncError.value = null;
        });
        await _updateLocalSettings(remoteData);
      } else if (localData.updatedAt.isAfter(remoteData.updatedAt)) {
        await _updateRemoteSettings(localData);
        batch(() {
          _isPendingSync.value = false;
          _syncError.value = null;
        });
      } else {
        _isPendingSync.value = false;
      }
    } catch (_) {
      _syncError.value = 'Reconnection sync failed. Retrying...';
    } finally {
      _isReconciling = false;
    }
  }

  @override
  void dispose() {
    _connector.dispose();
    _connectivityConnector.dispose();
    _settingsSignal.dispose();
    _isConnectedSignal.dispose();
    _syncError.dispose();
    _isPendingSync.dispose();
  }
}