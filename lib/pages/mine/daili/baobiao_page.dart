import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../../bean/baobiaoBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/date_picker.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
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
  String starTime = '', endTime = '', keyword = '';

  Widget _itemBB(BuildContext context, int i) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(240),
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.all(20.h),
      color: MyColors.dailiBaobiao,
      child: Column(
        children: [
          Row(
            children: [
              WidgetUtils.onlyText(
                  '用户名:',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(
                  list[i].nickname!,
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g2,
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.w600)),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText(
                  'V币/钻石分润:',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(
                  '${list[i].rebateGb}/${list[i].rebateD}',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g2,
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.w600)),
            ],
          ),
          WidgetUtils.commonSizedBox(20, 10),
          Row(
            children: [
              WidgetUtils.onlyText(
                  '游戏参与额：',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(
                  list[i].game!,
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g2,
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.w600)),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText(
                  '中奖礼物额：',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(
                  list[i].win!,
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g2,
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.w600)),
            ],
          ),
          WidgetUtils.commonSizedBox(20, 10),
          Row(
            children: [
              WidgetUtils.onlyText(
                  '直刷礼物额：',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(
                  list[i].direct!,
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g2,
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.w600)),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText(
                  '运营支出金:',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(
                  list[i].operate!,
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g2,
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  var listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      starTime = now.toString().substring(0, 10);
      endTime = now.toString().substring(0, 10);
      doPostTeamReport();
    });
    listen = eventBus.on<InfoBack>().listen((event) {
      setState(() {
        keyword = event.info;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

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
                    WidgetUtils.onlyText(
                        '账号：',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g6,
                            fontSize: ScreenUtil().setSp(28))),
                    Container(
                      color: MyColors.dailiTime,
                      height: ScreenUtil().setHeight(40),
                      width: ScreenUtil().setHeight(300),
                      padding: const EdgeInsets.all(2),
                      child:
                          WidgetUtils.commonTextField(controller, '输入ID或用户名'),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(20, 10),
                Row(
                  children: [
                    WidgetUtils.onlyText(
                        '时间：',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g6,
                            fontSize: ScreenUtil().setSp(28))),
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
                        child: WidgetUtils.onlyText(
                            starTime,
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g6,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                    ),
                    Opacity(
                        opacity: 1, child: WidgetUtils.commonSizedBox(0, 10)),
                    Opacity(
                        opacity: 1,
                        child: WidgetUtils.onlyText(
                            '至',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g6,
                                fontSize: ScreenUtil().setSp(28)))),
                    Opacity(
                        opacity: 1, child: WidgetUtils.commonSizedBox(0, 10)),
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
                        child: WidgetUtils.onlyText(
                            endTime,
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g6,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                    ),
                  ],
                )
              ],
            ),
            WidgetUtils.commonSizedBox(0, 10),
            GestureDetector(
              onTap: (() {
                MyUtils.hideKeyboard(context);
                doPostTeamReport();
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
        WidgetUtils.commonSizedBox(40, 10),
        Expanded(
          child: list.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  itemBuilder: _itemBB,
                  itemCount: list.length,
                )
              : Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      WidgetUtils.showImages(
                          'assets/images/no_have.png', 100, 100),
                      WidgetUtils.commonSizedBox(10, 0),
                      WidgetUtils.onlyTextCenter(
                          '暂无搜索信息',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(26))),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  List<Data> list = [];

  /// 团队报表
  Future<void> doPostTeamReport() async {
    LogE('用户token ${sp.getString('user_token')}');
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'start_date': starTime,
      'end_date': endTime,
      'keyword': keyword,
    };
    try {
      baobiaoBean bean = await DataUtils.postTeamReport(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list = bean.data!;
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
