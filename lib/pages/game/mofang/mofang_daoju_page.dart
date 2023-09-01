import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../widget/OptionGridView.dart';
/// 魔方获得道具
class MoFangDaoJuPage extends StatefulWidget {
  const MoFangDaoJuPage({super.key});

  @override
  State<MoFangDaoJuPage> createState() => _MoFangDaoJuPageState();
}

class _MoFangDaoJuPageState extends State<MoFangDaoJuPage> {
  Widget DaoJu(BuildContext context, int i){
    return SizedBox(
      height: 160.h,
      width: 110.h,
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
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          const Spacer(),
          Container(
            height: 480.h,
            margin: EdgeInsets.only(left: 40.h, right: 40.h),
            padding: EdgeInsets.only(top: 100.h, left: 30.h, right: 30.h , bottom: 40.h),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mofang_dj_lan_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: OptionGridView(
                itemCount: 9,
                rowCount: 3,
                mainAxisSpacing: 0.h,
                // 上下间距
                crossAxisSpacing: 10.h,
                //左右间距
                itemBuilder: DaoJu,
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(20.h, 0),
          GestureDetector(
            onTap: ((){
              Navigator.pop(context);
            }),
            child: WidgetUtils.showImages('assets/images/mofang_dj_lan_colse.png', 70.h, 70.h),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
