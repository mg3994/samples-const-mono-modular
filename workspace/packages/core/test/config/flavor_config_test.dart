import 'package:core/core.dart';
import 'package:core/src/config/build_mode/build_mode.dart';
import 'package:core/src/config/flavor/flavor.dart';
import 'package:test/test.dart';

void main() {
  group('Flavor Configurations Tests', () {
    test('Flavor development maps correct name and fallback baseUrl', () {
      final flavor = Flavor.development;
      expect(flavor.name, 'development');
      expect(flavor.baseUrl, isNotEmpty);
      expect(flavor.baseUrl, contains('dev'));
    });

    test('Flavor staging maps correct name and fallback baseUrl', () {
      final flavor = Flavor.staging;
      expect(flavor.name, 'staging');
      expect(flavor.baseUrl, isNotEmpty);
      expect(flavor.baseUrl, contains('stg'));
    });

    test('Flavor production maps correct name and fallback baseUrl', () {
      final flavor = Flavor.production;
      expect(flavor.name, 'production');
      expect(flavor.baseUrl, isNotEmpty);
      expect(flavor.baseUrl, contains('prod'));
    });
  });

  group('BuildMode Tests', () {
    test('BuildMode enum options exist', () {
      expect(BuildMode.values, contains(BuildMode.debug));
      expect(BuildMode.values, contains(BuildMode.profile));
      expect(BuildMode.values, contains(BuildMode.release));
    });

    test('BuildMode current resolves cleanly', () {
      final currentMode = BuildMode.current;
      expect(currentMode, isNotNull);
    });
  });

  group('AppFlavorConfig Integration Tests', () {
    test('currentFBConfig initializes with valid baseline attributes', () {
      expect(currentFBConfig, isNotNull);
      expect(currentFBConfig.baseUrl, isNotEmpty);
    });

    test('AppFlavorConfig custom mapping returns accurate baseUrl', () {
      const config = AppFlavorConfig(
        flavor: Flavor.development,
        buildMode: BuildMode.debug,
      );
      expect(config.baseUrl, Flavor.development.baseUrl);
    });
  });
}
