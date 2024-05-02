import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CeShi extends StatefulWidget {
  const CeShi({super.key});

  @override
  State<CeShi> createState() => _CeShiState();
}

class _CeShiState extends State<CeShi> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tiaozhuan();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Example'),
      ),
      body: Text(''),
    );
  }
  Future<void>  tiaozhuan() async{
    await launch('https://github.com/a5528ee3-55d1-49af-a23b-5d0f650f63dd');
  }
}
