import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        MaterialLocalizations,
        ScaffoldMessenger,
        ScaffoldMessengerState,
        Theme,
        ThemeData;
import 'package:kaisel/kaisel.dart' show KaiselPageScope;
import 'package:l10n/l10n.dart';

import '../../injection/dependency_injection.dart'
    show AppDependencies, AppDependenciesProvider;

///
extension BuildContextLocalizationExtensions on BuildContext {
  /// The application's generated localization strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Material localization strings.
  MaterialLocalizations get m10n => MaterialLocalizations.of(this);

  /// Cupertino localization strings.
  CupertinoLocalizations get c10n => CupertinoLocalizations.of(this);

  /// The current theme for this context.
  ThemeData get theme => Theme.of(this);

  /// The current media query for this context.
  MediaQueryData get mq => MediaQuery.of(this);

  /// The current scaffoldMessenger state for this context.
  ScaffoldMessengerState get sm => ScaffoldMessenger.of(this);

  /// The current page scope for this context.
  KaiselPageScope? get pageScope => KaiselPageScope.maybeOf(this);

  /// The current app dependencies for this context.
  AppDependencies get appDependencies => AppDependenciesProvider.of(this);
}
