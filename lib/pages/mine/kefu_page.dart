import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 客服中心
class KefuPage extends StatefulWidget {
  const KefuPage({Key? key}) : super(key: key);

  @override
  State<KefuPage> createState() => _KefuPageState();
}

class _KefuPageState extends State<KefuPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('客服中心', true, context, false, 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(100, 0),
          GestureDetector(
            onTap: ((){

            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              margin: const EdgeInsets.only(left: 45, right: 45),
              alignment: Alignment.center,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(44.0)),
                //设置四周边框
                border: Border.all(width: 1, color: MyColors.homeTopBG),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetUtils.showImages('assets/images/mine_kefu1.png', ScreenUtil().setHeight(61), ScreenUtil().setHeight(59)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.onlyText('在线客服', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(38), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(30, 0),
          GestureDetector(
            onTap: ((){

            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              margin: const EdgeInsets.only(left: 45, right: 45),
              alignment: Alignment.center,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(44.0)),
                //设置四周边框
                border: Border.all(width: 1, color: MyColors.homeTopBG),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetUtils.showImages('assets/images/mine_kefu2.png', ScreenUtil().setHeight(54), ScreenUtil().setHeight(46)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.onlyText('QQ客服', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(38), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(30, 0),
          GestureDetector(
            onTap: ((){

            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              margin: const EdgeInsets.only(left: 45, right: 45),
              alignment: Alignment.center,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(44.0)),
                //设置四周边框
                border: Border.all(width: 1, color: MyColors.homeTopBG),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetUtils.showImages('assets/images/mine_kefu3.png', ScreenUtil().setHeight(60), ScreenUtil().setHeight(60)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.onlyText('Telegram客服', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(38), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
