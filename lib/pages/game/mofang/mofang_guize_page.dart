import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              height: 380.h,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
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
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 54.h,
                            width: 156.h,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/mofang_gz_btn1.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: WidgetUtils.onlyTextCenter(
                                '玩法介绍：',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.mfZGBlue, fontSize: 24.sp)),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.h, right: 20.h, top: 20.h),
                        child: RichText(
                          text: TextSpan(
                              text: '1.使用',
                              style: StyleUtils.getCommonTextStyle(
                                  color: Colors.white, fontSize: 24.sp),
                              children: [
                                TextSpan(
                                    text: '20V豆/钻石',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: MyColors.mfZGBlue,
                                        fontSize: 24.sp)),
                                TextSpan(
                                    text: '可进行1次水星魔方，使用',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.white, fontSize: 24.sp)),
                                TextSpan(
                                    text: '500V豆/钻石',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: MyColors.mfZGBlue,
                                        fontSize: 24.sp)),
                                TextSpan(
                                    text:
                                        '可进行1次金星魔方，百分百获得礼物，奖励将放入背包中，可以随时赠送。钻石游戏赢得的礼物将自动兑换为钻石返还到您的钱包内。',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.white, fontSize: 24.sp)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.h, right: 20.h),
                        child: WidgetUtils.onlyText(
                            '游戏自动付款顺序为先付V豆，V豆余额不够时付钻石；',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white, fontSize: 24.sp)),
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
                                image: AssetImage(
                                    'assets/images/mofang_gz_btn1.png'),
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
                      // Container(
                      //   height: 54.h,
                      //   width: 400.h,
                      //   decoration: const BoxDecoration(
                      //     image: DecorationImage(
                      //       image:
                      //           AssetImage('assets/images/mofang_gz_btn2.png'),
                      //       fit: BoxFit.fill,
                      //     ),
                      //   ),
                      //   child: WidgetUtils.onlyTextCenter(
                      //       '蓝色魔方（20V豆、钻石/次）奖励概率：',
                      //       StyleUtils.getCommonTextStyle(
                      //           color: Colors.white, fontSize: 24.sp)),
                      // ),
                      Container(
                        height: 580.h,
                        margin: EdgeInsets.only(left: 20.h, right: 20.h),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/mofang_jc_bg1.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 54.h,
                      //   width: 400.h,
                      //   decoration: const BoxDecoration(
                      //     image: DecorationImage(
                      //       image:
                      //           AssetImage('assets/images/mofang_gz_btn2.png'),
                      //       fit: BoxFit.fill,
                      //     ),
                      //   ),
                      //   child: WidgetUtils.onlyTextCenter(
                      //       '金色魔方（500V豆、钻石/次）奖励概率：',
                      //       StyleUtils.getCommonTextStyle(
                      //           color: Colors.white, fontSize: 24.sp)),
                      // ),
                      Container(
                        height: 600.h,
                        margin: EdgeInsets.only(left: 20.h, right: 20.h),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage('assets/images/mofang_jc_bg2.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.h, right: 20.h),
                        child: WidgetUtils.onlyText(
                            '郑重声明：',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.zpGZYellow, fontSize: 24.sp)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.h, right: 20.h),
                        child: Text(
                          '1. 星球魔方是提升用户房间语聊互动体验的功能，仅供娱乐交流使用。用户获得的奖励不得反向兑换成现金或有价值商品；'
                          '\n2.平台禁止将通过星球魔方获得的奖励进行线上/线下交易，平台严厉打击以营利为目的的礼物交易行为，通过非正当渠道获取礼物的用户需自行承担不利后果；'
                          '\n3.任何影响活动公平性的用户及利用平台进行违法违规活动的用户，官方有权取消其参与本活动的资格，并回收违规账号非法获得的奖励。情节严重者，平台有权追究相关法律责任；'
                          '\n4.消费中请注意保管好账号、密码、短信验证码等登录操作凭证，谨防上当受骗。',
                          maxLines: 10,
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.white, fontSize: 24.sp),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(20.h, 0),
                    ],
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
