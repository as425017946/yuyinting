import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';

/// 转盘的奖池
class ZhuanPanJiangChi2Page extends StatefulWidget {
  const ZhuanPanJiangChi2Page({super.key});

  @override
  State<ZhuanPanJiangChi2Page> createState() => _ZhuanPanJiangChi2PageState();
}

class _ZhuanPanJiangChi2PageState extends State<ZhuanPanJiangChi2Page> {
  Widget jiangChiWidget(BuildContext context, int i) {
    return Container(
      height: 227.h,
      width: 161.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/zhuanpan_jc_btn_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          WidgetUtils.showImagesNet(
              'http://static.runoob.com/images/demo/demo2.jpg', 120.h, 120.h),
          WidgetUtils.commonSizedBox(10.h, 0),
          Row(
            children: [
              const Spacer(),
              WidgetUtils.showImages('assets/images/zhuanpan_jc_ys2.png', 20.h, 20.h),
              WidgetUtils.commonSizedBox(0, 5.h),
              WidgetUtils.onlyText('x12', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 18.sp)),
              const Spacer(),
            ],
          ),
          WidgetUtils.commonSizedBox(10.h, 0),
          GestureDetector(
            onTap: ((){

            }),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.showImages('assets/images/zhuanpan_jc_btn.png', 42.h, 133.h),
                WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: MyColors.zpWZ1, fontSize: 20.sp, fontWeight: FontWeight.w600))
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(child: GestureDetector(
            onTap: ((){
              Navigator.pop(context);
            }),
            child: Container(
              height: 450.h,
              width: double.infinity,
              color: Colors.transparent,
            ),
          )),
          Container(
            height: 820.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/zhuanpan_jc_bg2.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetUtils.commonSizedBox(130.h, 0),
                //头部信息
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 30.h),
                    Stack(
                      children: [
                        Opacity(
                          opacity: 0.47,
                          child: Container(
                            width: 120.h,
                            height: 45.h,
                            decoration: BoxDecoration(
                              color: MyColors.zpBG,
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        Container(
                          width: 120.h,
                          height: 45.h,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20.h),
                              WidgetUtils.showImages('assets/images/zhuanpan_jc_ys2.png', 32.h, 32.h),
                              WidgetUtils.commonSizedBox(0, 10.h),
                              WidgetUtils.onlyText('1', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 24.sp)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    WidgetUtils.onlyText('帮助', StyleUtils.getCommonTextStyle(color: MyColors.zpGZYellow, fontSize: 24.sp)),
                    WidgetUtils.commonSizedBox(0, 30.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(20.h, 0),
                //标题
                WidgetUtils.showImages('assets/images/zhuanpan_jc_title3.png', 32.h, 320.h),
                WidgetUtils.commonSizedBox(50.h, 0),
                Expanded(
                    child: OptionGridView(
                      padding: EdgeInsets.only(left: 50.h, right: 50.h),
                      itemCount: 6,
                      rowCount: 3,
                      mainAxisSpacing: 20.h,
                      // 上下间距
                      crossAxisSpacing: 20.h,
                      //左右间距
                      itemBuilder: jiangChiWidget,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
