import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 转盘规则说明
class ZhuanPanGuiZePage extends StatefulWidget {
  const ZhuanPanGuiZePage({super.key});

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
          WidgetUtils.commonSizedBox(500.h, 0),
          Expanded(
              child: Container(
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
                      child: WidgetUtils.showImages(
                          'assets/images/back_white.png', 30.h, 20.h),
                    ),
                    const Spacer(),
                    WidgetUtils.showImages(
                        'assets/images/zhuanpan_gz_title.png', 30.h, 130.h),
                    const Spacer(),
                    WidgetUtils.commonSizedBox(0, 20.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(20.h, 0),
                WidgetUtils.onlyText(
                    '什么是心动/超级转盘',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.zpGZYellow, fontSize: 24.sp)),
                WidgetUtils.onlyText(
                    '转盘游戏是独立的游戏玩法，仅在转盘页面可参与； 用户通过消耗金豆/钻石可打开转盘获得旋转得到的对应礼物奖励。',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white, fontSize: 24.sp)),
                WidgetUtils.commonSizedBox(20.h, 0),
                WidgetUtils.onlyText(
                    '心动/超级转盘怎么玩',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.zpGZYellow, fontSize: 24.sp)),
                WidgetUtils.onlyText(
                    '消耗100金豆/钻石开启一次心动转盘， 消耗1000金豆/钻石开启一次超级转盘。',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white, fontSize: 24.sp)),
                WidgetUtils.commonSizedBox(20.h, 0),
                WidgetUtils.onlyText(
                    '转盘开启后获奖概率',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.zpGZYellow, fontSize: 24.sp)),
                WidgetUtils.commonSizedBox(20.h, 0),
                Expanded(
                    child: Container(
                  height: 56.h,
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
