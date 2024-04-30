import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        onWebViewCreated: (controller) async {
          controller.loadHtmlString(
'''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>航邦支付</title>
<script src="https://cdn.bootcdn.net/ajax/libs/qs/6.11.0/qs.min.js"></script>
</head>
<body>
正在拉起支付宝
</body>
<script>
   window.location.href = "alipays://platformapi/startapp?appId=20000067&url=https://openauth.alipay.com/oauth2/publicAppAuthorize.htm?app_id=2021003183662465&scope=auth_base&redirect_uri=https://mamipay.com/api-order-callback/callback/cashier_ali_oauth_callback?domain=https://mamipay.com&pay=UYeFyDYfpKjalldu22nGWrTzwwdAU+69gk5oIkqeq7kwsBfFhSz9yD8muReegk/Vl7qe+aiDXJbkY57Lj9JI2U20QytBlIXVNfjQsPgYaSJbFDmaIHfY6Kjf0+3u8uqDbwMrk6rZY2nzFMOrGlq3nmlS4kXrh+ntR6ktVfZWJrsvv+fnyuPRImyMBtnInqx2wzSg4/eTLZ4PpSuUD2UqHjYvg3Txdeloq9GgCqCE6No=";
</script>
</html>
'''
          );
        },
      ),
    );
  }
}
