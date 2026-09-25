part of 'appearance_settings_bloc.dart';

sealed class const AppearanceSettingsEvent();

final class const GetAppearanceSettingsEvent() extends AppearanceSettingsEvent;

final class const SetThemeModeEvent() extends AppearanceSettingsEvent;

final class const SetLocaleEvent() extends AppearanceSettingsEvent;

final class const SetSeedColorEvent() extends AppearanceSettingsEvent;
