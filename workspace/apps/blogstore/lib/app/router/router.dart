import 'package:bloc_signals_flutter/bloc_signals_flutter.dart'
    show BlocSignalBuilder;
import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart'
    show
        KaiselConfig,
        KaiselConfigCodec,
        KaiselModalRoute,
        KaiselRoute,
        KaiselShellConfig;
import 'package:l10n/l10n.dart' show AppLocalizations;

import '../../features/settings/appearance/presentation/bloc/appearance_settings_bloc.dart'
    show AppearanceSettingsBloc;
import '../app.dart' show BuildContextLocalizationExtensions;
part 'routes.dart';
part 'app_stack_codec.dart';

/// Application router managing navigation for the Blogstore app.
final class const AppRouter({
  /// Optional application settings BLoC used for route configurations.
  final AppearanceSettingsBloc? appearanceSettingsBloc,
}) {
  /// Builds the top-level application widget with navigation.
  Widget buildApp(BuildContext context) {
    // buider is required unless i have used `context.value`
    return BlocSignalBuilder<AppearanceSettingsBloc, AppearanceSettingsState>(
      bloc: appearanceSettingsBloc,
      builder: (context, state) {
        // do your all repo case stffs here
        return MaterialApp.router(
          routerConfig: routerConfig,
          onGenerateTitle: (context) => context.l10n.appName,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates, // avoid using this as it is not yet fixed for gen-l10nfor intl utils so prefer old approch

          debugShowCheckedModeBanner:
              switch (context.appDependencies.flavorConfig.buildMode) {
                .debug => true,
                .profile => true,
                .release => false,
              },
          themeMode: state.themeMode,
          locale: state.locale,
          theme: AppTheme.light(seed: state.seedColor),
          darkTheme: AppTheme.dark(seed: state.seedColor),
        );
      },
    );
  }
}
