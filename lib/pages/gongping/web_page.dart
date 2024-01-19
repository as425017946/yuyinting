import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yuyinting/utils/widget_utils.dart';
///跳转h5页面
class WebPage extends StatefulWidget {
  String url;
  WebPage({super.key, required this.url});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('', true, context, false, 99);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: WebView(
        initialUrl: widget.url, // 替换成你要加载的 H5 页面链接
      ),
    );
  }
}
