import 'package:signals_core/signals_core.dart';

abstract interface class const AppearanceSettingsRepository() {
  ReadonlySignal<AppearanceSettings> get computedAppearanceSettings;
  ReadonlySignal<String?> get syncError;
  void clearError();
  Future<void> updateSettings(AppearanceSettings newSettings);
  void dispose();
}
