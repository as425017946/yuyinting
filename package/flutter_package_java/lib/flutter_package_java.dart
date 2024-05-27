
import 'flutter_package_java_platform_interface.dart';

class FlutterPackageJava {
  static final bgService = _BackgroundService();

}

class _BackgroundService {
  Future<String?> start() {
    return FlutterPackageJavaPlatform.instance.start();
  }
  Future<String?> stop() async {
    return FlutterPackageJavaPlatform.instance.stop();
  }
}