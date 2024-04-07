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
    const space = Expanded(child: Text(''));
    final item = ((String title, String content) {
      return Row(children: [
        WidgetUtils.onlyText(
          title,
          StyleUtils.getCommonTextStyle(
            color: MyColors.g3,
            fontSize: ScreenUtil().setSp(25),
          ),
        ),
        WidgetUtils.onlyText(
          content,
          StyleUtils.getCommonTextStyle(
              color: MyColors.g2,
              fontSize: ScreenUtil().setSp(25),
              fontWeight: FontWeight.w600),
        ),
      ]);
    });
    return Container(
      width: double.infinity,
      height: 184.w,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      margin: EdgeInsets.symmetric(vertical: 20.w),
      color: MyColors.dailiBaobiao,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              item('用户名: ', list[i].nickname!),
              space,
              item('金币: ', '${list[i].rebateGb}'),
            ],
          ),
          SizedBox(height: 20.w),
          Row(
            children: [
              item('礼物打赏额: ', list[i].direct!),
              space,
              item('运营支出金: ', list[i].operate!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _top() {
    final TextStyle style = StyleUtils.getCommonTextStyle(
      color: MyColors.g6,
      fontSize: 28.sp,
    );
    return Container(
      height: 184.w,
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
                    WidgetUtils.onlyText('账号：', style),
                    Container(
                      color: MyColors.dailiTime,
                      height: 42.w,
                      width: 349.w,
                      padding: const EdgeInsets.all(2),
                      child: WidgetUtils.commonTextField(controller, '输入ID或用户名'),
                    ),
                  ],
                ),
                SizedBox(height: 30.w),
                Row(
                  children: [
                    WidgetUtils.onlyText('时间：', style),
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
              MyUtils.hideKeyboard(context);
              doPostTeamReport();
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
        _top(),
        Expanded(
          child: list.isNotEmpty
              ? ListView.builder(
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
