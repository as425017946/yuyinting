import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../utils/line_painter.dart';
import '../../../utils/widget_utils.dart';
/// 关于
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('关于', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(20, 10),
            Row(
              children: [
                const Expanded(child: Text('')),
                WidgetUtils.showImagesFill( 'assets/images/people_bg.jpg', ScreenUtil().setHeight(150), ScreenUtil().setHeight(150), ),
                const Expanded(child: Text('')),
              ],
            ),
          WidgetUtils.commonSizedBox(10, 10),
          Row(
            children: [
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('版本 1.0.0', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
              const Expanded(child: Text('')),
            ],
          ),
          WidgetUtils.commonSizedBox(50, 10),
          Container(
            height: ScreenUtil().setHeight(80),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: Row(
              children: [
                WidgetUtils.onlyText('版本检查', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
                const Expanded(child: Text('')),
                Column(
                  children: [
                    WidgetUtils.commonSizedBox(24, 10),
                    CustomPaint(
                      painter: LinePainter(colors: Colors.red),
                    )
                  ],
                ),
                WidgetUtils.commonSizedBox(10, 10),
                WidgetUtils.onlyText('1.0.0', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 12)),
                WidgetUtils.commonSizedBox(10, 10),
                Image(
                  image: const AssetImage('assets/images/mine_more.png'),
                  width: ScreenUtil().setHeight(10),
                  height: ScreenUtil().setHeight(17),
                ),
              ],
            ),
          ),
          WidgetUtils.myLine(),
          Container(
            height: ScreenUtil().setHeight(80),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: Row(
              children: [
                WidgetUtils.onlyText('官方公众号', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('123456', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 12)),
                WidgetUtils.commonSizedBox(10, 10),
                WidgetUtils.showImages(
                    'assets/images/mine_fuzhi.png',
                    ScreenUtil().setHeight(15),
                    ScreenUtil().setHeight(15)),
              ],
            ),
          ),
          WidgetUtils.myLine(),
          Container(
            height: ScreenUtil().setHeight(80),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: Row(
              children: [
                WidgetUtils.onlyText('版权所属', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('某某公司', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 12)),
              ],
            ),
          ),
          WidgetUtils.myLine(),
          const Expanded(child: Text('')),
          Row(
            children: [
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('《用户协议》', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.onlyText('《隐私协议》', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
              const Expanded(child: Text('')),
            ],
          ),
          WidgetUtils.commonSizedBox(20, 10),
        ],
      ),
    );
  }
}
