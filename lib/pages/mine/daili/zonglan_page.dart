import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 团队总览
class ZonglanPage extends StatefulWidget {
  const ZonglanPage({Key? key}) : super(key: key);

  @override
  State<ZonglanPage> createState() => _ZonglanPageState();
}

class _ZonglanPageState extends State<ZonglanPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 10),
        Row(
          children: [
            const Expanded(child: Text('')),
            WidgetUtils.onlyText('时间：', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
            Container(
              color: MyColors.dailiTime,
              padding: const EdgeInsets.all(2),
              child: WidgetUtils.onlyText('2023-06-12', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
            ),
            WidgetUtils.commonSizedBox(0, 10),
            WidgetUtils.onlyText('至', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
            WidgetUtils.commonSizedBox(0, 10),
            Container(
              color: MyColors.dailiTime,
              padding: const EdgeInsets.all(2),
              child: WidgetUtils.onlyText('2023-06-12', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
            ),
            WidgetUtils.commonSizedBox(0, 10),
            GestureDetector(
              onTap: ((){
                
              }),
              child: WidgetUtils.myContainer(ScreenUtil().setHeight(50), ScreenUtil().setHeight(120), MyColors.homeTopBG, MyColors.homeTopBG, '查询', ScreenUtil().setSp(25), Colors.white),
            ),
            const Expanded(child: Text('')),
          ],
        ),
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(540),
          margin: const EdgeInsets.all(20),
          //边框设置
          decoration: const BoxDecoration(
            //背景
            color: MyColors.dailiBlue,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            children: [
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('推广人数', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                  Expanded(child: WidgetUtils.onlyTextCenter('总充值人数', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('总充值金额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                  Expanded(child: WidgetUtils.onlyTextCenter('总游戏参与额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('总中奖礼物额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                  Expanded(child: WidgetUtils.onlyTextCenter('总直刷礼物额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('运营支出金额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                  Expanded(child: WidgetUtils.onlyTextCenter('历史总分润', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }
}
