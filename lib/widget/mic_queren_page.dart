import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../colors/my_colors.dart';
import '../main.dart';
import '../utils/style_utils.dart';
/// 开麦确认
class MicPage extends StatefulWidget {
  const MicPage({super.key});

  @override
  State<MicPage> createState() => _MicPageState();
}

class _MicPageState extends State<MicPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // 默认选中今日不在弹出
  bool  isCheck = true;
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
              WidgetUtils.onlyTextCenter('主播申请打开您的麦克风，是否允许', StyleUtils.getCommonTextStyle(
                  color: MyColors.g2, fontSize: 32.sp, fontWeight: FontWeight.w600)),
              const Spacer(),
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
                      child: WidgetUtils.onlyTextCenter('拒绝', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: 32.sp)),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 20.h),
                  GestureDetector(
                    onTap: ((){
                      if(MyUtils.checkClick()){
                        Navigator.pop(context);
                      }
                    }),
                    child: Container(
                      width: 200.h,
                      height: 80.h,
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.roomMessageYellow2,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: WidgetUtils.onlyTextCenter('开麦', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 32.sp)),
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
