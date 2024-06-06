import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

import 'my_toast_utils.dart';

class PayTool {
  static Future<void> launch(String payType, String? url) async {
    if (url == null || url.isEmpty) {
      MyToastUtils.showToastBottom('支付链接错误!');
      return;
    }
    var payUrl = url;
    switch (payType) {
      case 'wx':
        if (payUrl.startsWith('weixin://')) break;
        final String t = payUrl.split('/').last;
        const String path = '/pages/appPay/appPay';
        final query = base64Decode('dXVpZD0wZjQyNjJkODdiMzA0ZmRlOTk3ZDU2ZGY3YjY2OGJjMiZwcmljZT0xMCZwYXlFbnRyYW5jZT0yJnRrPTcyZWE2ZjcwMmNiMTRhNTZhMTg5MjQzMjBmYTBiOWFmJmFwcFNlY3JldD02YmVjODc0MmRhMjJhMzdkZGVhMTY0YTIzZGRhODhmNyZtZXJjaGFudE5hbWU9JUU1JUIwJThGJUU2JTlGJUI0JUU3JUJEJTkxJUU3JUJCJTlDJUU1JUJBJTk3');
        final String headImgUrl = Uri.encodeComponent('http://wx.qlogo.cn/mmhead/Q3auHgzwzM4Bx0qREf887k4FibZ7DDskUpNMrXT9y5rztm0A3ykEQfA/132');
        final String nickname = Uri.encodeComponent('航邦数字经营');
        payUrl = 'weixin://dl/business/?t=$t&path=$path&user_name=gh_8282e30f802d&query=$query&head_img_url=$headImgUrl&nickname=$nickname';
        break;
      default:
    }
    final uri = Uri.parse(payUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      MyToastUtils.showToastBottom('无法跳转支付!');
    }
  }
}