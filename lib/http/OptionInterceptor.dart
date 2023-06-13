import 'package:dio/dio.dart';
import '../config/my_config.dart';
import '../main.dart';

//Option拦截器可以用来统一处理Option信息 可以在这里添加
class OptionInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //在请求发起前修改头部
    ///请求的Content-Type，默认值是"application/json; charset=utf-8".
    ///如果你的headers是固定的你可以在BaseOption中设置,如果不固定可以在这里进行根据条件设置
    options.headers["X-Token"] = sp.getString(MyConfig.userToken)??'';

    // if (options.queryParameters["hideLoading"] != true) {
    //   EasyLoading.show();
    // }
// 一定要加上这句话 否则进入不了下一步
    return handler.next(options);
  }
}