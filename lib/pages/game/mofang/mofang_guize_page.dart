import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 魔方规则说明
class MoFangGuiZePage extends StatefulWidget {
  const MoFangGuiZePage({super.key});

  @override
  State<MoFangGuiZePage> createState() => _MoFangGuiZePageState();
}

class _MoFangGuiZePageState extends State<MoFangGuiZePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(380.h, 0),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/room_tc1.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetUtils.commonSizedBox(20.h, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetUtils.commonSizedBox(0, 20.h),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/back_white.png', 30.h, 20.h),
                    ),
                    const Spacer(),
                    WidgetUtils.onlyTextCenter(
                        '规则说明',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.loginBlue2, fontSize: 36.sp)),
                    const Spacer(),
                    WidgetUtils.commonSizedBox(0, 40.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(30.h, 0),
                Row(
                  children: [
                    Container(
                      height: 54.h,
                      width: 156.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/mofang_gz_btn1.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: WidgetUtils.onlyTextCenter(
                          '玩法说明：',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.mfZGBlue, fontSize: 24.sp)),
                    ),
                    const Spacer(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.h, right: 20.h, top: 20.h),
                  child: RichText(
                    text: TextSpan(
                        text: '1.使用',
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.white, fontSize: 24.sp),
                        children: [
                          TextSpan(
                              text: '60金豆/钻石',
                              style: StyleUtils.getCommonTextStyle(
                                  color: MyColors.mfZGBlue, fontSize: 24.sp)),
                          TextSpan(
                              text: '可进行1次超级魔方，百分百获得礼物。奖励将放入背包中，可以随时赠送;',
                              style: StyleUtils.getCommonTextStyle(
                                  color: Colors.white, fontSize: 24.sp)),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.h, right: 20.h),
                  child: WidgetUtils.onlyText(
                      '2.开启超级魔方后，收起活动主界面仍会自动进行;',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white, fontSize: 24.sp)),
                ),
                WidgetUtils.commonSizedBox(20.h, 0),
                Row(
                  children: [
                    Container(
                      height: 54.h,
                      width: 156.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/mofang_gz_btn1.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: WidgetUtils.onlyTextCenter(
                          '概率说明：',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.mfZGBlue, fontSize: 24.sp)),
                    ),
                    const Spacer(),
                  ],
                ),
                WidgetUtils.commonSizedBox(30.h, 0),
                Container(
                  height: 54.h,
                  width: 400.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/mofang_gz_btn2.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: WidgetUtils.onlyTextCenter(
                      '蓝色魔方（50金豆、钻石/次）奖励概率：',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white, fontSize: 24.sp)),
                ),
                Expanded(
                    child: Container(
                      height: 56.h,
                      margin: EdgeInsets.only(left: 20.h, right: 20.h),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/zhuanpan_gz_sm1.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
