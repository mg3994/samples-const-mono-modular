import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app/bootstrap.dart';
import 'app/error/bootstrap_error.dart';
import 'injection/dependency_injection.dart' show AppDependencies;

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();

  final errors = BootstrapErrorReporter();

  FlutterError.onError = (details) {
    errors.report(details.exception, details.stack ?? StackTrace.current);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    errors.report(error, stackTrace);
    return true;
  };

  /// Default instance of [AppDependencies].
  const defaultDependencies = AppDependencies();

  runZonedGuarded(
    () => runApp(
      BootStrap(
        binding: binding,
        errors: errors,
        appDependencies: defaultDependencies,
      ),
    ),
    errors.report,
  );
}
