import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
/// 我的推广
class TuiguangPage extends StatefulWidget {
  const TuiguangPage({Key? key}) : super(key: key);

  @override
  State<TuiguangPage> createState() => _TuiguangPageState();
}

class _TuiguangPageState extends State<TuiguangPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 10),
        Row(
          children: [
            const Expanded(child: Text('')),
            WidgetUtils.onlyText('2023-06-12', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(33))),
            WidgetUtils.commonSizedBox(0, 10),
            WidgetUtils.onlyText('至', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(33))),
            WidgetUtils.commonSizedBox(0, 10),
            WidgetUtils.onlyText('2023-06-12', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(33))),
            const Expanded(child: Text('')),
          ],
        ),
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(485),
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
                  Expanded(child: WidgetUtils.onlyTextCenter('推广总人数', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                  Expanded(child: WidgetUtils.onlyTextCenter('本周有效用户', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
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
                  Expanded(child: WidgetUtils.onlyTextCenter('本周团队游戏参与额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                  Expanded(child: WidgetUtils.onlyTextCenter('本周团队中奖礼物额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
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
                  Expanded(child: WidgetUtils.onlyTextCenter('本周直刷礼物额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                  Expanded(child: WidgetUtils.onlyTextCenter('本周实际分润', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                  Expanded(child: WidgetUtils.onlyTextCenter('100', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold))),
                ],
              ),
              WidgetUtils.commonSizedBox(30, 10),
              WidgetUtils.onlyTextCenter('分润比例：直刷股份XX%  游戏股份XX%', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(21)))
            ],
          ),
        ),

        ///历史总分润
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                height: ScreenUtil().setHeight(173),
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: MyColors.dailiPink,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter('历史总分润', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28))),
                    WidgetUtils.commonSizedBox(15, 10),
                    WidgetUtils.onlyTextCenter('100.00', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(33), fontWeight: FontWeight.bold)),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(0, 40),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                height: ScreenUtil().setHeight(173),
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: MyColors.dailiPurple,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter('可领取分润', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28))),
                    WidgetUtils.commonSizedBox(15, 10),
                    WidgetUtils.onlyTextCenter('100.00', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(33), fontWeight: FontWeight.bold)),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            )
          ],
        ),
        WidgetUtils.commonSizedBox(50, 20),
        /// 立即推广按钮
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: ((){
                    Navigator.pushNamed(context, 'ShareTuiguangPage');
                  }),
                  child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '立即推广', ScreenUtil().setSp(33), Colors.white) ,
                ),
              ),
              WidgetUtils.commonSizedBox(0, 20),
              Expanded(
                child: GestureDetector(
                  onTap: ((){

                  }),
                  child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '领取分润', ScreenUtil().setSp(33), Colors.white) ,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
