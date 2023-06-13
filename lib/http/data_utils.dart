import '../utils/log_util.dart';
import 'my_http_config.dart';
import 'my_http_request.dart';

class DataUtils{
  // ///更新app
  // static Future<CheckoutBean> checkVersion(Map<String,dynamic> params) async {
  //   // print("检查更新：${params}");
  //   Map<String, dynamic>? respons = await MyHttpRequest.get(MyHttpConfig.checkVersion,
  //       {}, params);
  //   print("检查更新：${respons}");
  //   return CheckoutBean.fromJson(respons!);
  // }
  //
  // /// 登录接口
  // static Future<LoginBean> login(Map<String,dynamic> params) async {
  //   print("登录：传参${params}");
  //   Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.login, {}, params);
  //   print("登录：${respons}");
  //   return LoginBean.fromJson(respons!);
  // }
}