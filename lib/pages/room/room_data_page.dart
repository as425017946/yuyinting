import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bean/roomDataBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/date_picker.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 房间数据
class RoomDataPage extends StatefulWidget {
  String roomID;

  RoomDataPage({super.key, required this.roomID});

  @override
  State<RoomDataPage> createState() => _RoomDataPageState();
}

class _RoomDataPageState extends State<RoomDataPage> {
  String starTime = '',
      endTime = '',
      spending = '',
      joinNum = '',
      consumeNum = '',
      remainRate = '',
      consumeRate = '',
      firstNum = '',
      consumeFirst = '',
      consumeFirstRat = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      starTime = now.toString().substring(0, 10);
      endTime = now.toString().substring(0, 10);
      doPostRoomData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                if (MyUtils.checkClick()) {
                  Navigator.pop(context);
                }
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(700),
            width: double.infinity,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(15, 0),
                WidgetUtils.onlyTextCenter(
                    '房间数据',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(32))),
                WidgetUtils.commonSizedBox(20, 0),
                /// 时间筛选
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.2,
                      child: Container(
                        height: 80.h,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      height: 80.h,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Row(
                        children: [
                          const Spacer(),
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
                            child: WidgetUtils.onlyText(
                                starTime,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.mfZGBlue,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                          WidgetUtils.commonSizedBox(0, 10.w),
                          Transform.translate(
                              offset: Offset(0, 5.w),
                              child: WidgetUtils.onlyText(
                                  '﹀',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.mfZGBlue,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600))),
                          WidgetUtils.commonSizedBox(0, 10.w),
                          WidgetUtils.onlyText(
                              '至',
                              StyleUtils.getCommonTextStyle(
                                color: MyColors.g9,
                                fontSize: 22.sp,
                              )),
                          WidgetUtils.commonSizedBox(0, 10.w),
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
                            child: WidgetUtils.onlyText(
                                endTime,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.mfZGBlue,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                          WidgetUtils.commonSizedBox(0, 10.w),
                          Transform.translate(
                              offset: Offset(0, 5.w),
                              child: WidgetUtils.onlyText(
                                  '﹀',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.mfZGBlue,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600))),
                          WidgetUtils.commonSizedBox(0, 50.w),
                          GestureDetector(
                            onTap: ((){
                              if(MyUtils.checkClick()){
                                doPostRoomData();
                              }
                            }),
                            child: WidgetUtils.onlyText('点击搜索', StyleUtils.getCommonTextStyle(
                                color: MyColors.mfZGBlue,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(30, 0),
                /// 数据展示
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter('房间流水', StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                          WidgetUtils.commonSizedBox(10.w, 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(spending, StyleUtils.getCommonTextStyle(
                                  color: MyColors.dailiTime,
                                  fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0, 5.w),
                              WidgetUtils.onlyTextCenter('豆', StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(22))),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter('进房人数', StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                          WidgetUtils.commonSizedBox(10.w, 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(joinNum, StyleUtils.getCommonTextStyle(
                                  color: MyColors.dailiTime,
                                  fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0, 5.w),
                              WidgetUtils.onlyTextCenter('人', StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(22))),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(20, 0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter('付费总人数', StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                          WidgetUtils.commonSizedBox(10.w, 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(consumeNum, StyleUtils.getCommonTextStyle(
                                  color: MyColors.dailiTime,
                                  fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0, 5.w),
                              WidgetUtils.onlyTextCenter('人', StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(22))),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter('房间留存率(观看5分钟)', StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                          WidgetUtils.commonSizedBox(10.w, 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(remainRate, StyleUtils.getCommonTextStyle(
                                  color: MyColors.dailiTime,
                                  fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0, 5.w),
                              WidgetUtils.onlyTextCenter('%', StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(22))),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(20, 0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter('房间消费率', StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                          WidgetUtils.commonSizedBox(10.w, 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(consumeRate, StyleUtils.getCommonTextStyle(
                                  color: MyColors.dailiTime,
                                  fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0, 5.w),
                              WidgetUtils.onlyTextCenter('%', StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(22))),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter('首次进房新人数', StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                          WidgetUtils.commonSizedBox(10.w, 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(firstNum, StyleUtils.getCommonTextStyle(
                                  color: MyColors.dailiTime,
                                  fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0, 5.w),
                              WidgetUtils.onlyTextCenter('人', StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(22))),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(20, 0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter('消费新人数', StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                          WidgetUtils.commonSizedBox(10.w, 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(consumeFirst, StyleUtils.getCommonTextStyle(
                                  color: MyColors.dailiTime,
                                  fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0, 5.w),
                              WidgetUtils.onlyTextCenter('人', StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(22))),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter('新人消费率', StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                          WidgetUtils.commonSizedBox(10.w, 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(consumeFirstRat, StyleUtils.getCommonTextStyle(
                                  color: MyColors.dailiTime,
                                  fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0, 5.w),
                              WidgetUtils.onlyTextCenter('%', StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(22))),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 团队总览
  Future<void> doPostRoomData() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'start_time': starTime,
      'end_time': endTime,
      'room_id': widget.roomID
    };
    try {
      roomDataBean bean = await DataUtils.postRoomData(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            spending = bean.data!.spending!;
            joinNum = bean.data!.joinNum.toString();
            consumeNum = bean.data!.consumeNum.toString();
            remainRate = bean.data!.remainRate!;
            consumeRate = bean.data!.consumeRate!;
            firstNum = bean.data!.joinFirstNum.toString();
            consumeFirst = bean.data!.consumeFirstNum.toString();
            consumeFirstRat = bean.data!.consumeFirstRate!;
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
