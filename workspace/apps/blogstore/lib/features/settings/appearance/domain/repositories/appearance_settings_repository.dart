import 'package:signals_core/signals_core.dart';

abstract interface class const AppearanceSettingsRepository() {
  ReadonlySignal<AppearanceSettingsState> get computedAppearanceSettings;
  ReadonlySignal<String?> get syncError;
  ReadonlySignal<bool> get isPendingSync;

  void clearError();
  Future<void> updateSettings(AppearanceSettingsState newSettings);
  void dispose();
}
