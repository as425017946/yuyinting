import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../http/my_http_config.dart';
import '../main.dart';
import '../utils/log_util.dart';

enum OnlineConfigType { online, test, zhaozeng, pengfei }
const onlineType = OnlineConfigType.online;

class OnlineConfig {
  /// Ping
  static Map<String, dynamic> pingParams = <String, dynamic>{
    // 'type': 'test',
    'type': onlineType == OnlineConfigType.online ? 'go' : 'test',
  };
  static void updateIp(String ip) {
    sp.setString('isDian', ip);
    MyHttpConfig.baseURL = getBaseURL();
    MyHttpConfig.filelog = getFilelog();
    LogE('Ping 设置: $ip');
  }

  /// Api
  static String getBaseURL() {
    switch (onlineType) {
      case OnlineConfigType.pengfei:
        //鹏飞测试环境
        return "http://192.168.0.51/api";
      case OnlineConfigType.zhaozeng:
        //赵增测试环境
        return "http://192.168.0.53/api";
      case OnlineConfigType.test:
        //测试环境
        return "http://18.162.113.63:8080/api";
        // 修改后的测试环境
        // return "http://${sp.getString('isDian').toString()}:8081/api";
      case OnlineConfigType.online:
        //正式环境
        return "http://43.143.252.226:8080/api";

      // 正式环境
      // return "http://www.aa986.com:8080/api";
    }
  }

  static String getFilelog() {
    switch (onlineType) {
      case OnlineConfigType.online:
        //上传用户声网日志正式
        return "http://119.45.100.48:8080/api/upload/filelog";
      default:
        //上传用户声网日志测试
        return "http://18.162.113.63:8080/api/upload/filelog";
    }
  }

  /// 环信
  static EMOptions getEMOptions() {
    switch (onlineType) {
      case OnlineConfigType.online:
      // 本地环境
        return EMOptions(
            appKey: "1129240201157233#xc",
            autoLogin: false,
            debugModel: true,
            requireAck: true, //已读回执
            isAutoDownloadThumbnail: true);
      case OnlineConfigType.zhaozeng:
      // 本地环境
        return EMOptions(
            appKey: "1199230605161000#demo",
            autoLogin: false,
            debugModel: true,
            requireAck: true, //已读回执
            isAutoDownloadThumbnail: true);
      default:
        // 测试环境
        return EMOptions(
            appKey: "1129240201157233#demo",
            autoLogin: false,
            debugModel: true,
            requireAck: true, //已读回执
            isAutoDownloadThumbnail: true);
    }
  }
}
