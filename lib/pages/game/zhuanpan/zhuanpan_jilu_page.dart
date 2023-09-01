import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../colors/my_colors.dart';

/// 转盘记录
class ZhuanPanJiLuPage extends StatefulWidget {
  const ZhuanPanJiLuPage({super.key});

  @override
  State<ZhuanPanJiLuPage> createState() => _ZhuanPanJiLuPageState();
}

class _ZhuanPanJiLuPageState extends State<ZhuanPanJiLuPage> {
  Widget Jilu(BuildContext context, int i) {
    return Column(
      children: [
        SizedBox(
          height: 100.h,
          child: Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20.h),
              WidgetUtils.showImagesNet(
                  'http://static.runoob.com/images/demo/demo2.jpg', 60.h, 60.h),
              WidgetUtils.commonSizedBox(0, 10.h),
              Expanded(
                  child: Column(
                children: [
                  const Spacer(),
                  WidgetUtils.onlyText(
                      '道具名称',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white, fontSize: 28.sp)),
                  WidgetUtils.commonSizedBox(5.h, 0),
                  WidgetUtils.onlyText(
                      '2023年8月30日11:52:20',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.zpJLYellow, fontSize: 24.sp)),
                  const Spacer(),
                ],
              )),
              WidgetUtils.onlyText(
                  'x1',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomTCYellow, fontSize: 48.sp)),
              WidgetUtils.commonSizedBox(0, 20.h),
            ],
          ),
        ),
        Container(
          height: 3.h,
          margin: EdgeInsets.only(left: 20.h, right: 20.h),
          color: MyColors.zpJLHX,
        ),
      ],
    );
  }

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
                image: AssetImage('assets/images/zhuanpan_jl_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(50.h, 0),
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
                    WidgetUtils.showImages(
                        'assets/images/zhuanpan_jl_title.png', 30.h, 230.h),
                    const Spacer(),
                    WidgetUtils.commonSizedBox(0, 40.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(20.h, 0),
                Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                  itemBuilder: Jilu,
                  itemCount: 15,
                )),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
