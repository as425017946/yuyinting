import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class CeShi extends StatefulWidget {
  const CeShi({super.key});

  @override
  State<CeShi> createState() => _CeShiState();
}

class _CeShiState extends State<CeShi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Example'),
      ),
      body: WebView(
        initialUrl: 'assets/version.html',  // 指定本地HTML文件的路径
      ),
    );
  }
}
