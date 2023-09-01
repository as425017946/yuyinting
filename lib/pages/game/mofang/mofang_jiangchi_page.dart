import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';

/// 魔方奖池
class MoFangJiangChiPage extends StatefulWidget {
  const MoFangJiangChiPage({super.key});

  @override
  State<MoFangJiangChiPage> createState() => _MoFangJiangChiPageState();
}

class _MoFangJiangChiPageState extends State<MoFangJiangChiPage> {

  Widget jiangChiWidget(BuildContext context, int i){
    return Container(
      height: 266.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/mofang_jc_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          WidgetUtils.showImagesNet(
              'http://static.runoob.com/images/demo/demo2.jpg', 100.h, 100.h),
          WidgetUtils.commonSizedBox(10.h, 0),
          WidgetUtils.onlyTextCenter(
              '58000豆/钻',
              StyleUtils.getCommonTextStyle(
                  color: MyColors.loginBlue2, fontSize: 18.sp)),
          WidgetUtils.commonSizedBox(5.h, 0),
          WidgetUtils.onlyTextCenter(
              '小西几',
              StyleUtils.getCommonTextStyle(
                  color: MyColors.zpGZYellow, fontSize: 22.sp)),
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
                        '奖池一览',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.loginBlue2, fontSize: 36.sp)),
                    const Spacer(),
                    WidgetUtils.commonSizedBox(0, 40.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(30.h, 0),
                OptionGridView(
                  padding: EdgeInsets.only(left: 20.h, right: 20.h),
                  itemCount: 9,
                  rowCount: 3,
                  mainAxisSpacing: 10.h,
                  // 上下间距
                  crossAxisSpacing: 20.h,
                  //左右间距
                  itemBuilder: jiangChiWidget,
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
