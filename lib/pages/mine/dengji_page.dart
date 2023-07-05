import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/widget_utils.dart';

/// 测试等级 描边使用
class DengjiPage extends StatefulWidget {
  const DengjiPage({super.key});

  @override
  State<DengjiPage> createState() => _DengjiPageState();
}

class _DengjiPageState extends State<DengjiPage> {
  var appBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('测试描边字体', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(35, 0),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              WidgetUtils.showImagesFill('assets/images/dj_1.webp', ScreenUtil().setHeight(34), ScreenUtil().setHeight(34)),
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '50',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'ARIAL',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = MyColors.djOneM),
                  ),
                  Text(
                    '50',
                    style: TextStyle(
                        color: MyColors.djOne,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'ARIAL'),
                  ),
                ],
              )
            ],
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              WidgetUtils.showImagesFill('assets/images/dj_2.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '100',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Impact',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = MyColors.djOneM),
                  ),
                  Text(
                    '100',
                    style: TextStyle(
                        color: MyColors.djOne,
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Impact'),
                  ),
                ],
              )
            ],
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              WidgetUtils.showImagesFill('assets/images/dj_3.webp', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '100',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Impact',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = MyColors.djOneM),
                  ),
                  Text(
                    '100',
                    style: TextStyle(
                        color: MyColors.djOne,
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Impact'),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
