import 'package:logger/logger.dart';

const String _tag = "打印输出";

var _logger = Logger(
  printer: PrettyPrinter(
      methodCount: 0,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

LogV(String msg) {
  _logger.v("$_tag :: $msg");
}

LogD(String msg) {
  _logger.d("$_tag :: $msg");
}

LogI(String msg) {
  _logger.i("$_tag :: $msg");
}

LogW(String msg) {
  _logger.w("$_tag :: $msg");
}

LogE(String msg) {
  _logger.e("$_tag :: $msg");
}

LogWTF(String msg) {
  _logger.wtf("$_tag :: $msg");
}
