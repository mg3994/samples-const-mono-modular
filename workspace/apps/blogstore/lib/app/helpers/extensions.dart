import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show MaterialLocalizations, Theme, ThemeData;
import 'package:l10n/l10n.dart';

import '../../injection/dependency_injection.dart' show AppDependencies, AppDependenciesProvider;

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

  AppDependencies get appDependencies => AppDependenciesProvider.of(this);
}
