import 'build_mode_interface.dart';
// enums are implicitly constant.
enum BuildMode() implements BuildModeInterface {

  debug,
  profile,
  release;
  // const BuildMode();

  static const BuildMode current =
      bool.fromEnvironment('dart.vm.profile')
          ? BuildMode.profile
          : bool.fromEnvironment('dart.vm.product')
              ? BuildMode.release
              : BuildMode.debug;
}
