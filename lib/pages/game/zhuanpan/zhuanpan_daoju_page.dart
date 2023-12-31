import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/playRouletteBean.dart';
import '../../../utils/widget_utils.dart';

/// 展示获得的道具
class ZhuanPanDaoJuPage extends StatefulWidget {
  List<Gifts> list;
  int zonge;
  String title;
  ZhuanPanDaoJuPage({super.key, required this.list, required this.zonge, required this.title});

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
                WidgetUtils.showImages(widget.title == '心动转盘' ? 'assets/images/zhuanpan_dj_bg.png' : 'assets/images/zhuanpan_dj_bg2.png', 630.h, 600.h),
                Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (int i = 0; i < widget.list.length; i++)
                          Container(
                            height: 170.h,
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
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      WidgetUtils.showImagesNet(
                                          widget.list[i].img!,
                                          100.h,
                                          100.h),
                                      Positioned(
                                        bottom: 5.h,
                                        right: 5.h,
                                        child: Container(
                                          width: 50.h,
                                          height: 20.h,
                                          decoration: const BoxDecoration(
                                            //设置Container修饰
                                            image: DecorationImage(
                                              //背景图片修饰
                                              image: AssetImage("assets/images/zhuanpan_dj_lw_sl.png"),
                                              fit: BoxFit.fill, //覆盖
                                            ),
                                          ),
                                          child: WidgetUtils.onlyTextCenter(
                                              'x${widget.list[i].count}',
                                              StyleUtils.getCommonTextStyle(
                                                  color: MyColors.roomTCYellow,
                                                  fontSize: 19.sp,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                WidgetUtils.commonSizedBox(2.h, 0),
                                WidgetUtils.onlyTextCenter(
                                    widget.list[i].name!,
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCYellow,
                                        fontSize: 22.sp)),
                                WidgetUtils.commonSizedBox(2.h, 0),
                                WidgetUtils.onlyTextCenter(
                                widget.list[i].price.toString(),
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCYellow,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 170.h,
                    child: Container(
                  child: WidgetUtils.onlyTextCenter(
                      '总价值：${widget.zonge}',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCYellow,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600)),
                )),
                Positioned(
                  bottom: 80.h,
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
