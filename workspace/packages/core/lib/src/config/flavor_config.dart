import 'build_mode/build_mode_interface.dart';
import 'flavor/flavor_interface.dart';
import 'build_mode/build_mode.dart' show BuildMode;
import 'flavor/flavor.dart' show Flavor;

final class FlavorConfig<
  F extends FlavorInterface,
  B extends BuildModeInterface
> {
  const FlavorConfig({required this.flavor, required this.buildMode});

  final F flavor;
  final B buildMode;

  String get baseUrl => flavor.baseUrl;
}

typedef AppFlavorConfig = FlavorConfig<Flavor, BuildMode>;

const String appFlavor = String.fromEnvironment(
  'FLUTTER_APP_FLAVOR',
  defaultValue: 'production',
);

const Flavor currentFlavor = appFlavor == 'dev' || appFlavor == 'development'
    ? Flavor.development
    : appFlavor == 'stg' || appFlavor == 'staging'
        ? Flavor.staging
        : Flavor.production;
/// Flavor Build Config
const AppFlavorConfig currentFBConfig = FlavorConfig(
  flavor: currentFlavor,
  buildMode: BuildMode.current,
);
