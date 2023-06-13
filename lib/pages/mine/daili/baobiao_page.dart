import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 团队报表
class BaobiaoPage extends StatefulWidget {
  const BaobiaoPage({Key? key}) : super(key: key);

  @override
  State<BaobiaoPage> createState() => _BaobiaoPageState();
}

class _BaobiaoPageState extends State<BaobiaoPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 10),
        Row(
          children: [
            const Expanded(child: Text('')),
            Column(
              children: [
                Row(
                  children: [
                    WidgetUtils.onlyText('账号：', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
                    Container(
                      color: MyColors.dailiTime,
                      height: ScreenUtil().setHeight(40),
                      width: ScreenUtil().setHeight(300),
                      padding: const EdgeInsets.all(2),
                      child: WidgetUtils.commonTextField(controller, '输入ID或用户名'),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(20, 10),
                Row(
                  children: [
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
                  ],
                )
              ],
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
        WidgetUtils.commonSizedBox(40, 10),
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(240),
          padding: const EdgeInsets.all(20),
          color: MyColors.dailiBaobiao,
          child: Column(
            children: [
              Row(
                children: [
                  WidgetUtils.onlyText('用户名:', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
                  const Expanded(child: Text('')),
                  WidgetUtils.onlyText('分润:', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  WidgetUtils.onlyText('游戏参与额：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
                  const Expanded(child: Text('')),
                  WidgetUtils.onlyText('中奖礼物额：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  WidgetUtils.onlyText('直刷礼物额：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
                  const Expanded(child: Text('')),
                  WidgetUtils.onlyText('运营支出金:', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }
}
