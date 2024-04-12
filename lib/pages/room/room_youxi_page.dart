import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_utils.dart';
import '../game/car_page.dart';
import '../game/mofang_page.dart';
import '../game/zhuanpan_page.dart';

/// 房间游戏使用
class RoomYouXiPage extends StatefulWidget {
  String roomID;

  RoomYouXiPage({super.key, required this.roomID});

  @override
  State<RoomYouXiPage> createState() => _RoomYouXiPageState();
}

class _RoomYouXiPageState extends State<RoomYouXiPage> {
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
              color: Colors.transparent,
            ),
          )),
          Container(
            width: double.infinity,
            height: 300.h,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc3.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20.h, 0),
                WidgetUtils.onlyTextCenter(
                    '游戏娱乐',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600)),
                WidgetUtils.commonSizedBox(50.h, 0),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          // 赛车
                          Navigator.pop(context);
                          MyUtils.goTransparentPage(context, const Carpage());
                        }
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/room_yx_1.png', 120.h, 120.h),
                    ),
                    WidgetUtils.commonSizedBox(0, 40.h),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          // 转盘
                          Navigator.pop(context);
                          MyUtils.goTransparentPage(
                              context,
                              ZhuanPanPage(
                                roomId: widget.roomID,
                              ));
                        }
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/room_yx_2.png', 120.h, 120.h),
                    ),
                    WidgetUtils.commonSizedBox(0, 40.h),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          // 魔方
                          Navigator.pop(context);
                          MyUtils.goTransparentPage(
                              context,
                              MoFangPage(
                                roomID: widget.roomID,
                              ));
                        }
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/room_yx_3.png', 120.h, 120.h),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
