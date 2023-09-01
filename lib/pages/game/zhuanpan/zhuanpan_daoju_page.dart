import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../utils/widget_utils.dart';

/// 展示获得的道具
class ZhuanPanDaoJuPage extends StatefulWidget {
  const ZhuanPanDaoJuPage({super.key});

  @override
  State<ZhuanPanDaoJuPage> createState() => _ZhuanPanDaoJuPageState();
}

class _ZhuanPanDaoJuPageState extends State<ZhuanPanDaoJuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(500.h, 0),
          Container(
            height: 630.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 40.h, right: 40.h, ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.showImages(
                    'assets/images/zhuanpan_dj_bg.png', 630.h, 600.h),
                Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (int i = 0; i < 20; i++)
                          Container(
                            height: 160.h,
                            width: 110.h,
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  width: 110.h,
                                  height: 110.h,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/zhuanpan_dj_lw.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      WidgetUtils.commonSizedBox(15.h, 0),
                                      WidgetUtils.showImagesNet(
                                          'http://static.runoob.com/images/demo/demo2.jpg',
                                          60.h,
                                          60.h),
                                      WidgetUtils.commonSizedBox(12.h, 0),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          SizedBox(
                                            width: 40.h,
                                            height: 20.h,
                                            child: WidgetUtils.onlyTextCenter(
                                                '1',
                                                StyleUtils.getCommonTextStyle(
                                                    color: MyColors.roomTCYellow,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w600)),
                                          ),
                                          WidgetUtils.commonSizedBox(0, 2.h),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                WidgetUtils.commonSizedBox(2.h, 0),
                                WidgetUtils.onlyTextCenter(
                                    '礼物名称',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCYellow,
                                        fontSize: 22.sp))
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100.h,
                  child: GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/zhuanpan_dj_btn.png', 90.h, 300.h)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
