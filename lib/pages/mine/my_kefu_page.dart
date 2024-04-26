import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';

import '../../bean/kefuBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../message/chat_page.dart';

/// 客服新页面
class MyKeFuPage extends StatefulWidget {
  String kefuUid;
  String kefuAvatar;
  MyKeFuPage({super.key, required this.kefuUid, required this.kefuAvatar});

  @override
  State<MyKeFuPage> createState() => _MyKeFuPageState();
}

class _MyKeFuPageState extends State<MyKeFuPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        body: Column(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            )),
            Container(
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.white,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (() {
                      MyUtils.goTransparentRFPage(
                          context,
                          ChatPage(
                              nickName: '小柴客服',
                              otherUid: widget.kefuUid,
                              otherImg:  widget.kefuAvatar));
                      Navigator.pop(context);
                    }),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(70),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          '在线客服',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(35)),
                        ),
                      ),
                    ),
                  ),
                  WidgetUtils.myLine(thickness: 1),
                  GestureDetector(
                    onTap: (() {
                      Clipboard.setData(const ClipboardData(
                        text: '1411768710',
                      ));
                      MyToastUtils.showToastBottom('已成功复制到剪切板');
                      Navigator.pop(context);
                    }),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(70),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'QQ客服（点击复制）',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(35)),
                        ),
                      ),
                    ),
                  ),
                  // WidgetUtils.myLine(thickness: 1),
                  // GestureDetector(
                  //   onTap: (() {
                  //     Clipboard.setData(ClipboardData(
                  //       text: sp.getString('my_telegram').toString(),
                  //     ));
                  //     MyToastUtils.showToastBottom('已成功复制到剪切板');
                  //     Navigator.pop(context);
                  //   }),
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: ScreenUtil().setHeight(70),
                  //     color: Colors.white,
                  //     child: Center(
                  //       child: Text(
                  //         'Telegram客服',
                  //         style: StyleUtils.getCommonTextStyle(
                  //           color: Colors.black,
                  //           fontSize: ScreenUtil().setSp(35),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  WidgetUtils.myLine(thickness: 10),
                  GestureDetector(
                    onTap: (() {
                      // selectAssets();
                      Navigator.pop(context);
                    }),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(70),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          '取消',
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(35),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
