import 'package:dart_ping/dart_ping.dart';

import '../main.dart';
import 'event_utils.dart';
import 'log_util.dart';

class MyPing {
  static checkIp(ips, void Function(String) callBack) {
    int? time;
    for (var ip in ips) {
      final ping = Ping(ip, count: 3);
      ping.stream.listen(
        (event) {
          if (event.summary != null) {
            final s = event.summary!.time!.inMilliseconds;
            // ignore: unnecessary_brace_in_string_interps
            LogE("Ping：${ip} ${s}ms");
            if (time == null || time! > s) {
              time = s;
              callBack(ip);
              // ignore: unnecessary_brace_in_string_interps
              LogE("设置IP: ${ip}");
            }
          }
          LogE('Running command: $event');
        },
      );
    }
  }
}
