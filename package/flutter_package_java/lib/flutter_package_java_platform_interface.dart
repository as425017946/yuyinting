import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_package_java_method_channel.dart';

abstract class FlutterPackageJavaPlatform extends PlatformInterface {
  /// Constructs a FlutterPackageJavaPlatform.
  FlutterPackageJavaPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPackageJavaPlatform _instance = MethodChannelFlutterPackageJava();

  /// The default instance of [FlutterPackageJavaPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPackageJava].
  static FlutterPackageJavaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPackageJavaPlatform] when
  /// they register themselves.
  static set instance(FlutterPackageJavaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> start() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<String?> stop() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
