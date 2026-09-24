import 'package:core/core.dart' show AppFlavorConfig, currentFBConfig;
import 'package:flutter/material.dart';

import '../app/bootstrap.dart'
    show
        AppearanceSettingsBloc,
        CrashReporter,
        DefaultAppearanceSettingsBloc,
        DefaultCrashReporter,
        DefaultFirebaseInitializer,
        DefaultNotificationGateway,
        FirebaseInitializer,
        NotificationGateway;

/// Container holding pluggable external dependencies for bootstrap.
final class const AppDependencies({
  final AppFlavorConfig flavorConfig = currentFBConfig,

  /// Firebase initialization service.
  final FirebaseInitializer firebaseInitializer =
      const DefaultFirebaseInitializer(),

  /// Crashlytics / error reporting service.
  final CrashReporter crashReporter = const DefaultCrashReporter(),

  /// Notification gateway service.
  final NotificationGateway notificationGateway =
      const DefaultNotificationGateway(),

  /// Runtime database instance (Optional in const constructor)
  // final AppDatabase? db,
  // final FirebaseAuth? auth,
  // final FirebaseAnalytics? analytics,

  
});

class const AppDependenciesProvider({
  super.key,
  required final AppDependencies appDependencies,
  required super.child,
}) extends InheritedWidget {
  static AppDependencies of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<AppDependenciesProvider>();
    assert(result != null, 'No DependenciesProvider found in context');
    return result!.appDependencies;
  }

  @override
  bool updateShouldNotify(AppDependenciesProvider oldWidget) =>
      appDependencies != oldWidget.appDependencies;
}
