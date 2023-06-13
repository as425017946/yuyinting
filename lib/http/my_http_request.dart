import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import '../utils/loading.dart';
import '../utils/my_toast_utils.dart';
import 'OptionInterceptor.dart';
import 'my_http_config.dart';

class MyHttpRequest {
  static final Dio dio = Dio();

  static Future<Map<String, dynamic>?> _request(
    String url, {
    String? method = 'POST',
    dynamic headers,
    dynamic params,
  }) async {
    try {
      Response<Map<String, dynamic>> response;
      dio.options.connectTimeout = MyHttpConfig.connectTimeOut;
      dio.options.receiveTimeout = MyHttpConfig.receiveTimeout;
      dio.interceptors.add(OptionInterceptor());

      if (method == 'GET') {
        response = await dio.get(url, queryParameters: params);
      } else if (method == 'UPLOAD') {
        ///忽略 https 证书校验
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.badCertificateCallback = (cert, host, port) {
            return true;
          };
        };

        ///通过FormData
        FormData formData = FormData.fromMap(params);

        if (headers != null) {
          ///显示指定Map的限定类型 动态添加headers
          dio.options.headers.addAll(new Map<String, String>.from(headers));
        }

        ///发送post
        response = await dio.post(
          url, data: formData,
          ///这里是发送请求回调函数
          ///[progress] 当前的进度
          ///[total] 总进度
          onSendProgress: (int progress, int total) {
            print("当前进度是 $progress 总进度是 $total");
          },
        );
      } else {
        response = await dio.post(
          url,
          data: params,
        );
      }
      return response.data;
    } on DioError catch (e) {
      print('错误信息返回$e');
      Loading.dismiss();
      switch (e.type) {
        case DioErrorType.connectTimeout:
          MyToastUtils.showToastBottom('网络异常，请检查你的网络！');
          break;
        case DioErrorType.sendTimeout:
          MyToastUtils.showToastBottom('发送请求超时');
          break;
        case DioErrorType.receiveTimeout:
          MyToastUtils.showToastBottom('网络异常，请检查你的网络！');
          break;
        case DioErrorType.response:
          MyToastUtils.showToastBottom('服务器异常！');
          break;
        case DioErrorType.cancel:
          MyToastUtils.showToastBottom('请求取消！');
          break;
        case DioErrorType.other:
          MyToastUtils.showToastBottom('网络异常，请检查你的网络！');
          break;
      }
    }
  }

  //get请求
  static Future<Map<String, dynamic>?> get(
      String url, Map<String, dynamic> headers,
      [Map<String, dynamic>? params]) async {
    return _request(
      url,
      method: 'GET',
      headers: headers,
      params: params,
    );
  }

  //post请求
  static Future<Map<String, dynamic>?> post(String url,
      Map<String, dynamic> headers, dynamic params) async {
    return _request(
      url,
      method: 'POST',
      headers: headers,
      params: params,
    );
  }

  ///dio 实现文件上传
  static Future<Map<String, dynamic>?> fileUpload(
      String url,
      Map<String, dynamic> headers,
      Map<String, dynamic> params) async {
    return _request(
      url,
      method: 'UPLOAD',
      headers: headers,
      params: params,
    );
  }
}
