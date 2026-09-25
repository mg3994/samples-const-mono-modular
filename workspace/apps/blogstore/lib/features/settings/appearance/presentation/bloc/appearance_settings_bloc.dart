import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart' show Color, Locale, ThemeMode;

part 'appearance_settings_event.dart';
part 'appearance_settings_state.dart';

class AppearanceSettingsBloc()
    extends BlocSignal<AppearanceSettingsEvent, AppearanceSettingsState> {
  this : super(initialState: (

    themeMode: ,
    locale: ,
    seedColor: ,
  ),equals:(previous, current) => previous.themeMode == current.themeMode && previous.locale == current.locale && previous.seedColor == current.seedColor,);

}


