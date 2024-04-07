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
import 'tuiguang_page.dart';

/// 团队总览
class ZonglanPage extends StatefulWidget {
  const ZonglanPage({Key? key}) : super(key: key);

  @override
  State<ZonglanPage> createState() => _ZonglanPageState();
}

class _ZonglanPageState extends State<ZonglanPage> with YQYLItem {
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

  Widget _top() {
    final TextStyle style = StyleUtils.getCommonTextStyle(
      color: MyColors.g6,
      fontSize: 28.sp,
    );
    return Container(
      height: 124.w,
      padding: EdgeInsets.symmetric(horizontal: 74.w),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    WidgetUtils.onlyText('时间：', style),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          DateTime now = DateTime.now();
                          int year = now.year;
                          int month = now.month;
                          int day = now.day;

                          DatePicker.show(
                            context,
                            startDate: DateTime(1970, 1, 1),
                            selectedDate: DateTime(year, month, day),
                            endDate: DateTime(2024, 12, 31),
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
                        child: WidgetUtils.onlyText(starTime, style),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9.w),
                      child: WidgetUtils.onlyText('至', style),
                    ),
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
                          endDate: DateTime(2024, 12, 31),
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
                        child: WidgetUtils.onlyText(endTime, style),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: (() {
              doPostTeamOverview();
            }),
            child: WidgetUtils.myContainer(
              49.w,
              139.w,
              MyColors.homeTopBG,
              MyColors.homeTopBG,
              '查询',
              25.sp,
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _top(),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 31.w),
          decoration: BoxDecoration(
            color: MyColors.dailiBlue,
            borderRadius: BorderRadius.all(Radius.circular(21.w)),
          ),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 328.0 / 122,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 35.w),
            children: [
              gridItem('推广人数', tuiguang),
              gridItem('充值人数', chongzhiPeople),
              gridItem('充值金额', chongzhiMoney),
              gridItem('礼物打赏额', zsMoney),
              gridItem('运营支出金额', yunying),
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
