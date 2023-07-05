import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
///游戏页面
class YouxiPage extends StatefulWidget {
  const YouxiPage({Key? key}) : super(key: key);

  @override
  State<YouxiPage> createState() => _YouxiPageState();
}

class _YouxiPageState extends State<YouxiPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20),
                  WidgetUtils.onlyText('热门游戏', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.bold))
                ],
              ),
              WidgetUtils.commonSizedBox(20, 0),
              Container(
                height: ScreenUtil().setHeight(300),
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: WidgetUtils.CircleImageNet(300, double.infinity, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
              ),
              WidgetUtils.commonSizedBox(10, 0),
              Container(
                height: ScreenUtil().setHeight(80),
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('幸运大转盘', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(29),fontWeight: FontWeight.bold)),
                          WidgetUtils.onlyText('流光溢彩，霓虹再现', StyleUtils.getCommonTextStyle(color: MyColors.g6,fontSize: ScreenUtil().setSp(26),fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    WidgetUtils.showImages('assets/images/quliaojie.png', 25, 65),
                  ],
                ),
              ),
              WidgetUtils.myLine(color: MyColors.f6,thickness: 10),
              WidgetUtils.commonSizedBox(20, 0),
              Container(
                height: ScreenUtil().setHeight(300),
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: WidgetUtils.CircleImageNet(300, double.infinity, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
              ),
              WidgetUtils.commonSizedBox(10, 0),
              Container(
                height: ScreenUtil().setHeight(80),
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('幸运大转盘', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(29),fontWeight: FontWeight.bold)),
                          WidgetUtils.onlyText('流光溢彩，霓虹再现', StyleUtils.getCommonTextStyle(color: MyColors.g6,fontSize: ScreenUtil().setSp(26),fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    WidgetUtils.showImages('assets/images/quliaojie.png', 25, 65),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
