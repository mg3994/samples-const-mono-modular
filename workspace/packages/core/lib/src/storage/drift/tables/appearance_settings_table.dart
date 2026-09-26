import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show Color, Locale, ThemeMode;

import '../app_database.dart';

part 'appearance_settings_table.g.dart';

/// Type converter for Flutter [Color] stored as a 32-bit ARGB integer.
class ColorConverter extends TypeConverter<Color, int> {
  /// Creates a [ColorConverter].
  const ColorConverter();

  @override
  Color fromSql(int fromDb) => Color(fromDb);

  @override
  int toSql(Color value) => value.toARGB32();
}

/// Type converter for Flutter [Locale] stored as a language tag string.
class LocaleConverter extends TypeConverter<Locale, String> {
  /// Creates a [LocaleConverter].
  const LocaleConverter();

  @override
  Locale fromSql(String fromDb) {
    final parts = fromDb.replaceAll('-', '_').split('_');
    if (parts.length > 1) {
      return Locale(parts[0], parts[1]);
    }
    return Locale(parts[0]);
  }

  @override
  String toSql(Locale value) {
    final country = value.countryCode;
    if (country != null && country.isNotEmpty) {
      return '${value.languageCode}_$country';
    }
    return value.languageCode;
  }
}

/// Database table representing appearance settings in Drift.
@DataClassName('AppearanceSettingsData')
class AppearanceSettings extends Table {
  /// Primary key identifying the settings profile (defaults to 1).
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// User's theme mode preference: system, light, or dark.
  ///
  /// Uses Drift enum support [textEnum] with default [ThemeMode.system].
  TextColumn get themeMode =>
      textEnum<ThemeMode>().withDefault(Constant(ThemeMode.system.name))();

  /// Selected application locale.
  ///
  /// Defaults to English ('en').
  TextColumn get locale => text()
      .map(const LocaleConverter())
      .withDefault(const Constant('en'))();

  /// Primary seed color used for dynamic Material 3 color scheming.
  ///
  /// Defaults to orange (0xFFFF9800).
  IntColumn get seedColor => integer()
      .map(const ColorConverter())
      .withDefault(const Constant(0xFFFF9800))();

  /// Timestamp when the settings were last updated.
  ///
  /// Defaults to the current date and time.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Data Access Object for querying and modifying [AppearanceSettings].
@DriftAccessor(tables: [AppearanceSettings])
class AppearanceSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AppearanceSettingsDaoMixin {
  /// Creates an [AppearanceSettingsDao].
  AppearanceSettingsDao(super.attachedDatabase);

  /// Watches appearance settings for the given [id] (defaults to 1).
  Stream<AppearanceSettingsData?> watchSettings({int id = 1}) {
    return (select(appearanceSettings)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Fetches appearance settings for the given [id] once.
  Future<AppearanceSettingsData?> getSettings({int id = 1}) {
    return (select(appearanceSettings)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts or updates the appearance settings row.
  Future<void> upsertSettings(AppearanceSettingsCompanion companion) {
    return into(appearanceSettings).insertOnConflictUpdate(companion);
  }

  /// Resets settings for the given [id] back to defaults.
  Future<void> resetSettings({int id = 1}) {
    return into(appearanceSettings).insertOnConflictUpdate(
      AppearanceSettingsCompanion.insert(
        id: Value(id),
      ),
    );
  }
}
