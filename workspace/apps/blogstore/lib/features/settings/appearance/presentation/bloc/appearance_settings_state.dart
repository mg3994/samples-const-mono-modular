part of 'appearance_settings_bloc.dart';

typedef AppearanceSettingsState = ({
  ThemeMode themeMode,
  Locale locale,
  Color seedColor,
  DateTime updatedAt,
});

/// Extension to add copyWith utility to the Record
extension AppearanceSettingsStateX on AppearanceSettingsState {
  AppearanceSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    Color? seedColor,
    DateTime? updatedAt,
  }) {
    return (
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      seedColor: seedColor ?? this.seedColor,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}