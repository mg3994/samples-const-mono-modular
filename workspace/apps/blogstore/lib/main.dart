import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app/bootstrap.dart';
import 'app/error/bootstrap_error.dart';


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

  runZonedGuarded(
    () => runApp(BootStrap(binding: binding, errors: errors)),
    errors.report,
  );
}
