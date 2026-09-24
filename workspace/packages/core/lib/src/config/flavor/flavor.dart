import 'dart:io' show Platform;

import 'flavor_interface.dart';

class Flavor implements FlavorInterface {
  const new _() : _customUrl = null;
  final String? _customUrl;
  static const bool kIsWeb = bool.fromEnvironment('dart.library.js_interop');

  /// Returns the localhost address for the current platform at runtime.
  static String get localhost =>
      (!kIsWeb && Platform.isAndroid) ? '10.0.2.2' : 'localhost';

  // Flavor instances remain `const`
  static const Flavor development = Flavor._();
  static const Flavor staging = Flavor._();
  static const Flavor production = Flavor._();

  @override
  String get baseUrl {
    const envUrl = String.fromEnvironment('SERVER_URL');
    if (envUrl.isNotEmpty) return envUrl;
    if (_customUrl != null) return _customUrl;
    return 'http://$localhost:8080';
  }

  String get name {
    if (identical(this, development)) return 'development';
    if (identical(this, staging)) return 'staging';
    return 'production';
  }
}
