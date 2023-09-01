import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

/// 退出房间
class RoomBackPage extends StatefulWidget {
  const RoomBackPage({super.key});

  @override
  State<RoomBackPage> createState() => _RoomBackPageState();
}

class _RoomBackPageState extends State<RoomBackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: (() {
          Navigator.pop(context);
        }),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 240.h,
              color: Colors.transparent,
            ),
            Expanded(
                child: Container(
                  height: double.infinity,
                  color: Colors.black54,
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(35, 0),
                      Row(
                        children: [
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              eventBus.fire(SubmitButtonBack(title: '退出房间'));
                              Navigator.pop(context);
                            }),
                            child: Column(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/room_exit.png',
                                    ScreenUtil().setHeight(60),
                                    ScreenUtil().setHeight(60)),
                                WidgetUtils.onlyTextCenter(
                                    '退出房间',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(24))),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 50),
                          GestureDetector(
                            onTap: (() {
                              eventBus.fire(SubmitButtonBack(title: '收起房间'));
                              Navigator.pop(context);
                            }),
                            child: Column(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/room_shouqi.png',
                                    ScreenUtil().setHeight(60),
                                    ScreenUtil().setHeight(60)),
                                WidgetUtils.onlyTextCenter(
                                    '收起房间',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(24))),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 40),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(40, 0),
                      Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: (() {
                                  Navigator.pop(context);
                                }),
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: WidgetUtils.CircleImageNet(
                                      200.h,
                                      200.h,
                                      20,
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                                ),
                              ),
                              WidgetUtils.commonSizedBox(20.h, 0),
                              GestureDetector(
                                onTap: (() {
                                  Navigator.pop(context);
                                }),
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: WidgetUtils.CircleImageNet(
                                      200.h,
                                      200.h,
                                      20,
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                                ),
                              ),
                              WidgetUtils.commonSizedBox(20.h, 0),
                              GestureDetector(
                                onTap: (() {
                                  Navigator.pop(context);
                                }),
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: WidgetUtils.CircleImageNet(
                                      200.h,
                                      200.h,
                                      20,
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                                ),
                              ),
                              WidgetUtils.commonSizedBox(20.h, 0),
                              GestureDetector(
                                onTap: (() {
                                  Navigator.pop(context);
                                }),
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: WidgetUtils.CircleImageNet(
                                      200.h,
                                      200.h,
                                      20,
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                                ),
                              ),
                              WidgetUtils.commonSizedBox(20.h, 0),
                              GestureDetector(
                                onTap: (() {
                                  Navigator.pop(context);
                                }),
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: WidgetUtils.CircleImageNet(
                                      200.h,
                                      200.h,
                                      20,
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                                ),
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
