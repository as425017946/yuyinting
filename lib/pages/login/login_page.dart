import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yuyinting/pages/navigator/tabnavigator.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
///登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if(MyUtils.compare('登录', event.title) == 0){
        //跳转并关闭当前页面
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Tab_Navigator()),
          // ignore: unnecessary_null_comparison
              (route) => route == null,
        );

      }
    });
  }

  /// 获取文档目录文件
  Future<String> _getLocalDocumentFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// 获取临时目录文件
  Future<File> _getLocalTemporaryFile() async {
    final dir = await getTemporaryDirectory();
    return File('${dir.path}/str.txt');
  }

  /// 获取应用程序目录文件
  Future<File> _getLocalSupportFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/str.txt');
  }

  @override
  Widget build(BuildContext context) {
    //设置字体大小根据系统的“字体大小”辅助选项来进行缩放,默认为false : 字体随着系统的“字体大小”辅助选项来进行缩放
    ScreenUtil.init(context,designSize: const Size(750,1334));
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Center(
            child: WidgetUtils.commonSubmitButton('登录'),
          ),
          WidgetUtils.showImages('assets/images/a1.gif', 50, 50),
          WidgetUtils.showImages('assets/images/a2.gif', 50, 50),

        ],
      ),
    );
  }
}
