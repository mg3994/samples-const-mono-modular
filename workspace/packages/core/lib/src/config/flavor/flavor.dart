import 'flavor_interface.dart';

class  Flavor implements FlavorInterface {
  static const Flavor development = Flavor._(
    baseUrl: String.fromEnvironment(
      'SERVER_URL',
      defaultValue: 'http://localhost:8080',
    ),
  );

  static const Flavor staging = Flavor._(
    baseUrl: String.fromEnvironment(
      'SERVER_URL',
      defaultValue: 'http://localhost:8080',
    ),
  );

  static const Flavor production = Flavor._(
    baseUrl: String.fromEnvironment(
      'SERVER_URL',
      defaultValue: 'http://localhost:8080',
    ),
  );

  const Flavor._({required this.baseUrl});

  @override
  final String baseUrl;

  String get name {
    if (identical(this, development)) return 'development';
    if (identical(this, staging)) return 'staging';
    return 'production';
  }
}
