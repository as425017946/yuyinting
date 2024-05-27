import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_package_java_platform_interface.dart';

/// An implementation of [FlutterPackageJavaPlatform] that uses method channels.
class MethodChannelFlutterPackageJava extends FlutterPackageJavaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_package_java');

  @override
  Future<String?> start() async {
    final result = await methodChannel.invokeMethod<String>('Background_Service_Start');
    return result;
  }

  @override
  Future<String?> stop() async {
    final result = await methodChannel.invokeMethod<String>('Background_Service_Stop');
    return result;
  }
}
