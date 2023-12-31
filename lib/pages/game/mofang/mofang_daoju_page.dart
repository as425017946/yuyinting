import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/playRouletteBean.dart';
import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../widget/OptionGridView.dart';
/// 魔方获得道具
class MoFangDaoJuPage extends StatefulWidget {
  List<Gifts> list;
  int zonge;
  String title;
  MoFangDaoJuPage({super.key, required this.list, required this.zonge, required this.title,});

  @override
  State<MoFangDaoJuPage> createState() => _MoFangDaoJuPageState();
}

class _MoFangDaoJuPageState extends State<MoFangDaoJuPage> {
  Widget DaoJu(BuildContext context, int i){
    return SizedBox(
      height: 180.h,
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
            child: Column(
              children: [
                WidgetUtils.onlyTextCenter(
                    '总价值：${widget.zonge}',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCYellow,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600)),
                WidgetUtils.commonSizedBox(20.h, 0),
                Expanded(child: SingleChildScrollView(
                  child: OptionGridView(
                    itemCount: widget.list.length,
                    rowCount: 3,
                    mainAxisSpacing: 0.h,
                    // 上下间距
                    crossAxisSpacing: 10.h,
                    //左右间距
                    itemBuilder: DaoJu,
                  ),
                ))
              ],
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
