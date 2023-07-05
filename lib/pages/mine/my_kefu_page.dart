import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 客服新页面
class MyKeFuPage extends StatefulWidget {
  const MyKeFuPage({super.key});

  @override
  State<MyKeFuPage> createState() => _MyKeFuPageState();
}

class _MyKeFuPageState extends State<MyKeFuPage> {
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
                    onTap: (() {}),
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
                    onTap: (() {}),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(70),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'qq客服',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(35)),
                        ),
                      ),
                    ),
                  ),
                  WidgetUtils.myLine(thickness: 1),
                  GestureDetector(
                    onTap: (() {}),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(70),
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'Telegram客服',
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(35),
                          ),
                        ),
                      ),
                    ),
                  ),
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
