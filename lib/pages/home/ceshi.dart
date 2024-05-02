
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/my_toast_utils.dart';
import '../../utils/widget_utils.dart';
class CeShi extends StatefulWidget {
  const CeShi({super.key});

  @override
  State<CeShi> createState() => _CeShiState();
}

class _CeShiState extends State<CeShi> {
  TextEditingController controller = TextEditingController();
  var text = '';
  var url = "alipays://platformapi/startapp?appId=20000067&url=";
  var isCode = false;
  
  @override
  Widget build(BuildContext context) {
    var appBar = WidgetUtils.getAppBar('测试', true, context, false, 0) as AppBar;
    return Scaffold(
      appBar: appBar,
      body: _content(),
    );
  }
  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(child: TextField(
                controller: controller,
                onChanged: (value) {
                  var str = value;
                  if (value.startsWith('alipays://')) {
                    final arr = value.split('&url=');
                    setState(() {
                      url = '${arr.first}&url=';
                    });
                    str = arr.last;
                  }
                  setState(() {
                    if (isCode) {
                      text = Uri.encodeComponent(str);
                    } else {
                      text = str;
                    }
                  });
                },
              ),),
              GestureDetector(
                onTap: () {
                  var str = controller.text;
                  if (controller.text.startsWith('alipays://')) {
                    final arr = controller.text.split('&url=');
                    setState(() {
                      url = '${arr.first}&url=';
                    });
                    str = arr.last;
                  }
                  setState(() {
                    isCode = !isCode;
                    if (isCode) {
                      text = Uri.encodeComponent(str);
                    } else {
                      text = str;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(isCode ? 'Encode' : 'Uncode'),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: text));
              MyToastUtils.showToastBottom('成功复制文字');
            },
            child: Text(text),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await launchUrl(Uri.parse(url + text));
          },
          child: const Center(
            child: Text('打开支付宝'),
          ),
        ),
      ],
    );
  }
}
