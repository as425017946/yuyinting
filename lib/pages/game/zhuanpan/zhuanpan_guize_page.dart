import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 转盘规则说明
class ZhuanPanGuiZePage extends StatefulWidget {
  int type;

  ZhuanPanGuiZePage({super.key, required this.type});

  @override
  State<ZhuanPanGuiZePage> createState() => _ZhuanPanGuiZePageState();
}

class _ZhuanPanGuiZePageState extends State<ZhuanPanGuiZePage> {
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
              height: 500.h,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Expanded(
              child: Container(
            height: 1000.h,
            padding: EdgeInsets.only(left: 20.h, right: 20.h),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/zhuanpan_jl_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(30.h, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: Container(
                        height: 50.h,
                        width: 50.h,
                        alignment: Alignment.centerLeft,
                        color: Colors.transparent,
                        child: WidgetUtils.showImages(
                            'assets/images/back_white.png', 30.h, 20.h),
                      ),
                    ),
                    const Spacer(),
                    WidgetUtils.showImages(
                        'assets/images/zhuanpan_gz_title.png', 30.h, 130.h),
                    const Spacer(),
                    WidgetUtils.commonSizedBox(0, 20.h),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        WidgetUtils.commonSizedBox(20.h, 0),
                        WidgetUtils.onlyText(
                            '什么是心动/超级转盘',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.zpGZYellow, fontSize: 24.sp)),
                        WidgetUtils.onlyText(
                            '转盘游戏是独立的游戏玩法，仅在转盘页面可参与； 用户通过消耗V豆可打开转盘获得旋转得到的对应礼物奖励。',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white, fontSize: 24.sp)),
                        WidgetUtils.commonSizedBox(20.h, 0),
                        WidgetUtils.onlyText(
                            '心动/超级转盘怎么玩',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.zpGZYellow, fontSize: 24.sp)),
                        WidgetUtils.onlyText(
                            '消耗100V豆开启一次心动转盘， 消耗1000V豆开启一次超级转盘。',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white, fontSize: 24.sp)),
                        // WidgetUtils.onlyText(
                        //     '游戏自动付款顺序为先付V豆，V豆余额不够时付钻石。',
                        //     StyleUtils.getCommonTextStyle(
                        //         color: Colors.white, fontSize: 24.sp)),
                        WidgetUtils.commonSizedBox(20.h, 0),
                        WidgetUtils.onlyText(
                            '什么是欢乐值',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.zpGZYellow, fontSize: 24.sp)),
                        WidgetUtils.onlyText(
                            '欢乐值为超级转盘专属玩法，平台内每个用户每次开启超级转盘均会增加1点欢乐值。',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white, fontSize: 24.sp)),
                        Text(
                          '当欢乐值达到30时将触发“欢乐时刻”，持续5分钟。此时超级转盘中价值最高的4件礼物将提高至6倍爆率。',
                          maxLines: 3,
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.white, fontSize: 24.sp),
                        ),
                        // WidgetUtils.commonSizedBox(20.h, 0),
                        // WidgetUtils.onlyText(
                        //     '转盘开启后获得奖品的概率',
                        //     StyleUtils.getCommonTextStyle(
                        //         color: MyColors.zpGZYellow, fontSize: 24.sp)),
                        // Container(
                        //   height: 500.h,
                        //   decoration: const BoxDecoration(
                        //     image: DecorationImage(
                        //       image: AssetImage('assets/images/zhuanpan_gz_sm1.png'),
                        //       fit: BoxFit.fitWidth,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   height: 500.h,
                        //   decoration: const BoxDecoration(
                        //     image: DecorationImage(
                        //       image: AssetImage('assets/images/zhuanpan_gz_sm2.png'),
                        //       fit: BoxFit.fitWidth,
                        //     ),
                        //   ),
                        // ),
                        WidgetUtils.commonSizedBox(20.h, 0),
                        WidgetUtils.onlyText(
                            '特别声明：',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.zpGZYellow, fontSize: 24.sp)),
                        Text(
                          '该玩法仅供娱乐，参与该玩法所获得的奖励仅限于在平台内消费使用，不可反向兑换成现金或有价商品，不得用于任何形式的盈利活动。\n禁止一切线下交易、币商收购等第三方不正当行为，平台将对上述交易行为进行严厉打击，玩家需自行承担任何与第三方交易行为的不利后果。',
                          maxLines: 10,
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.white, fontSize: 24.sp),
                        ),
                        WidgetUtils.commonSizedBox(20.h, 0),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
