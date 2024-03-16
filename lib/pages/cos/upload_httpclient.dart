import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:yuyinting/utils/log_util.dart';

import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';

typedef ProgressCallback = void Function(int count, int total);

class UploadHttpClient {
  /// 上传文件
  /// @param filePath 文件路径
  /// @param progressCallback 进度回调
  ///  image图片 audio音频 video视频
  static Future<void> upload(String filePath, String type, String title,ProgressCallback progressCallback) async {
    // 获取直传签名等信息
    String ext = path.extension(filePath).substring(1);
    Map<String, dynamic> directTransferData;
    try {
      directTransferData = await _getStsDirectSign(ext,type);
    } catch (err) {
      print(err);
      throw Exception("getStsDirectSign fail");
    }
    Loading.show('上传中...');
    String cosHost = directTransferData['cosHost'];
    String cosKey = directTransferData['cosKey'];
    String authorization = directTransferData['authorization'];
    String securityToken = directTransferData['sessionToken'];
    String url = 'https://$cosHost/$cosKey';
    File file = File(filePath);
    int fileSize = await file.length();
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/octet-stream');
    request.headers.set('Content-Length', fileSize.toString());
    request.headers.set('Authorization', authorization);
    request.headers.set('x-cos-security-token', securityToken);
    request.headers.set('Host', cosHost);
    request.contentLength = fileSize;
    Stream<List<int>> stream = file.openRead();
    int bytesSent = 0;
    stream.listen(
          (List<int> chunk) {
        bytesSent += chunk.length;
        double progress = bytesSent / fileSize;
        print('Progress: ${progress.toStringAsFixed(2)}');
        progressCallback(bytesSent, fileSize);
        request.add(chunk);
      },
      onDone: () async {
        HttpClientResponse response = await request.close();
        LogE('上传状态 ${response.statusCode}');
        if (response.statusCode == 200) {
          Loading.dismiss();
          eventBus.fire(TencentBack(filePath: cosKey, title: title));
          print('上传成功');
        } else {
          Loading.dismiss();
          throw Exception("上传失败 $response");
        }
      },
      onError: (error) {
        Loading.dismiss();
        print('Error: $error');
        throw Exception("上传失败 ${error.toString()}");
      },
      cancelOnError: true,
    );
  }

  /// 获取直传的url和签名等
  /// @param ext 文件后缀 直传后端会根据后缀生成cos key
  /// @return 直传url和签名等
  static Future<Map<String, dynamic>> _getStsDirectSign(String ext,String type) async {
    HttpClient httpClient = HttpClient();
    //直传签名业务服务端url（正式环境 请替换成正式的直传签名业务url）
    //直传签名业务服务端代码示例可以参考：https://github.com/tencentyun/cos-demo/blob/main/server/direct-sign/nodejs/app.js
    //10.91.22.16为直传签名业务服务器的地址 例如上述node服务，总之就是访问到直传签名业务服务器的url
    HttpClientRequest request = await httpClient
        .getUrl(Uri.parse("${MyHttpConfig.baseURL}/upload/uploadCos?type=$type&ext=$ext"));
    // 添加 header 头信息
    request.headers.add("Content-Type", "application/json"); // 例如，设置 Content-Type 为 application/json
    request.headers.add("Authorization", sp.getString('user_token') ?? ''); // 例如，设置 Authorization 头
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(responseBody);
      print(json);
      // LogE('上传地址== ${json['data']['cosKey']}');
      // LogE('上传地址request_id== ${json['data']['request_id']}');
      // LogE('上传地址cosHost== ${json['data']['cosHost']}');
      // LogE('上传地址cosKey== ${json['data']['cosKey']}');
      httpClient.close();
      if (json['code'] == 200) {
        return json['data'];
      } else {
        throw Exception(
            'getStsDirectSign error code: ${json['code']}, error message: ${json['message']}');
      }
    } else {
      httpClient.close();
      throw Exception(
          'getStsDirectSign HTTP error code: ${response.statusCode}');
    }
  }
}