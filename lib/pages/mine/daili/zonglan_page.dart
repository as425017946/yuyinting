import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/loading.dart';

import '../../../bean/zonglanBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/date_picker.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 团队总览
class ZonglanPage extends StatefulWidget {
  const ZonglanPage({Key? key}) : super(key: key);

  @override
  State<ZonglanPage> createState() => _ZonglanPageState();
}

class _ZonglanPageState extends State<ZonglanPage> {
  String starTime = '',
      endTime = '',
      tuiguang = '',
      chongzhiPeople = '',
      chongzhiMoney = '',
      gameMoney = '',
      zjMoney = '',
      zsMoney = '',
      yunying = '',
      zongfenrun = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      starTime = now.toString().substring(0, 10);
      endTime = now.toString().substring(0, 10);
      doPostTeamOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 10),
        Row(
          children: [
            const Expanded(child: Text('')),
            WidgetUtils.onlyText(
                '时间：',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
            GestureDetector(
              onTap: (() {
    if(MyUtils.checkClick()) {
      DateTime now = DateTime.now();
      int year = now.year;
      int month = now.month;
      int day = now.day;

      DatePicker.show(
        context,
        startDate: DateTime(1970, 1, 1),
        selectedDate: DateTime(year, month, day),
        endDate: DateTime(2023, 12, 31),
        onSelected: (date) {
          setState(() {
            starTime = date.toString().substring(0, 10);
          });
        },
      );
    }
              }),
              child: Container(
                color: MyColors.dailiTime,
                padding: const EdgeInsets.all(2),
                child: WidgetUtils.onlyText(
                    starTime,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
              ),
            ),
            WidgetUtils.commonSizedBox(0, 10),
            Opacity(
                opacity: 1,
                child: WidgetUtils.onlyText(
                    '至',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(28)))),
            WidgetUtils.commonSizedBox(0, 10),
            GestureDetector(
              onTap: (() {
                DateTime now = DateTime.now();
                int year = now.year;
                int month = now.month;
                int day = now.day;

                DatePicker.show(
                  context,
                  startDate: DateTime(1970, 1, 1),
                  selectedDate: DateTime(year, month, day),
                  endDate: DateTime(2023, 12, 31),
                  onSelected: (date) {
                    setState(() {
                      endTime = date.toString().substring(0, 10);
                    });
                  },
                );
              }),
              child: Container(
                color: MyColors.dailiTime,
                padding: const EdgeInsets.all(2),
                child: WidgetUtils.onlyText(
                    endTime,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
              ),
            ),
            WidgetUtils.commonSizedBox(0, 10),
            GestureDetector(
              onTap: (() {
                doPostTeamOverview();
              }),
              child: WidgetUtils.myContainer(
                  ScreenUtil().setHeight(50),
                  ScreenUtil().setHeight(120),
                  MyColors.homeTopBG,
                  MyColors.homeTopBG,
                  '查询',
                  ScreenUtil().setSp(25),
                  Colors.white),
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
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '推广人数',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '充值人数',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          tuiguang,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          chongzhiPeople,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '充值金额',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '游戏参与额',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          chongzhiMoney,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          gameMoney,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '中奖礼物额',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '直刷礼物额',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          zjMoney,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          zsMoney,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '运营支出金额',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '总V币/钻石分润',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          yunying,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          zongfenrun,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 团队总览
  Future<void> doPostTeamOverview() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'start_date': starTime,
      'end_date': endTime,
    };
    try {
      zonglanBean bean = await DataUtils.postTeamOverview(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            tuiguang = bean.data!.promotionNum.toString();
            chongzhiPeople = bean.data!.rechargeNum.toString();
            chongzhiMoney = bean.data!.rechargeAmount.toString();
            gameMoney = bean.data!.game!;
            zjMoney = bean.data!.win!;
            zsMoney = bean.data!.direct!;
            yunying = bean.data!.operate!;
            zongfenrun = '${bean.data!.rebateGb!}/${bean.data!.rebateD!}';
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
