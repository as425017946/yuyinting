import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../colors/my_colors.dart';
import '../utils/style_utils.dart';
/// 二次确认弹窗
class QueRenPage extends StatefulWidget {
  String title;
  String jine;
  bool isDuiHuan;
  QueRenPage({super.key, required this.title, required this.jine, required this.isDuiHuan});

  @override
  State<QueRenPage> createState() => _QueRenPageState();
}

class _QueRenPageState extends State<QueRenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: double.infinity,
          height: 300.h,
          margin: EdgeInsets.only(left: 50.h, right: 50.h),
          decoration: const BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(
                Radius.circular(10)),
          ),
          child: Column(
            children: [
              const Spacer(),
              RichText(
                text: TextSpan(
                    text: '本次参与将消耗',
                    style: StyleUtils.getCommonTextStyle(
                        color: MyColors.g2, fontSize: 32.sp, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                          text: widget.jine,
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.origin, fontSize: 32.sp, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: widget.title == '赛车商店' && widget.isDuiHuan ? '蘑菇币，请确认' : 'V豆/钻石，请确认',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g2, fontSize: 32.sp, fontWeight: FontWeight.w600)),
                    ]),
              ),
              WidgetUtils.commonSizedBox(20.h, 20.h),
              widget.isDuiHuan == false ? Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: ((){

                    }),
                    child: WidgetUtils.showImages('assets/images/mofang_check_yes.png', 30.h, 30.h),
                  ),
                  WidgetUtils.commonSizedBox(0, 10.h),
                  WidgetUtils.onlyText('今日不在弹出', StyleUtils.getCommonTextStyle(
                      color: MyColors.g2, fontSize: 32.sp, fontWeight: FontWeight.w600)),
                  const Spacer(),
                ],
              ) : const Text(''),
              WidgetUtils.commonSizedBox(40.h, 20.h),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: ((){
                      Navigator.pop(context);
                    }),
                    child: Container(
                      width: 200.h,
                      height: 80.h,
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.d8,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: WidgetUtils.onlyTextCenter('取消', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: 32.sp)),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 20.h),
                  GestureDetector(
                    onTap: ((){
                      ///确认后请求接口
                      Navigator.pop(context);
                      eventBus.fire(QuerenBack(title: widget.title, jine: widget.jine));
                    }),
                    child: Container(
                      width: 200.h,
                      height: 80.h,
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.blue,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: WidgetUtils.onlyTextCenter('确认', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 32.sp)),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              WidgetUtils.commonSizedBox(20.h, 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
