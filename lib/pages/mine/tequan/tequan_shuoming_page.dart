import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

/// 特权说明
class TeQuanShuoMingPage extends StatefulWidget {
  String title;

  TeQuanShuoMingPage({super.key, required this.title});

  @override
  State<TeQuanShuoMingPage> createState() => _TeQuanShuoMingPageState();
}

class _TeQuanShuoMingPageState extends State<TeQuanShuoMingPage> {
  String info = '', info2 = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.title.contains('时间')) {
      info = '·剩余时间以30天为周期，从获得登记次日起算30天，周期内贵族等级出现变化则剩余时间自动充值30天;';
    } else {
      info = '·1金豆=1贵族值，贵族值在30天内累计;';
      info2 = '·赠送经典、礼盒和贵族均可以获得贵族值;';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Container(
              height: 300.h,
              width: 482.w,
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.newGZ2,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(15.h)),
                border: Border.all(width: 1, color: MyColors.newGZ3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetUtils.commonSizedBox(20.h, 0),
                  WidgetUtils.onlyTextCenter(
                      widget.title,
                      StyleUtils.getCommonTextStyle(
                        color: MyColors.mineYellow,
                        fontSize: 32.sp,
                      )),
                  WidgetUtils.commonSizedBox(30.h, 0),
                  Text(
                    info,
                    maxLines: 10,
                    style: TextStyle(
                        color: MyColors.mineOrange,
                        fontSize: 22.sp,
                        height: 1.5),
                  ),
                  WidgetUtils.commonSizedBox(20.h, 0),
                  !widget.title.contains('时间')
                      ? Text(
                          info2,
                          maxLines: 10,
                          style: TextStyle(
                              color: MyColors.mineOrange,
                              fontSize: 22.sp,
                              height: 1.5),
                        )
                      : const Text(''),
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(40.h, 0),
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child:
                WidgetUtils.showImages('assets/images/tequan_colse.png', 50.h, 50.h),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
