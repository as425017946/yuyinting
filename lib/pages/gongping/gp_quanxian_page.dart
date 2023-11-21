import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../utils/style_utils.dart';

/// 请求权限时使用
class GPQuanXianPage extends StatefulWidget {
  const GPQuanXianPage({super.key});

  @override
  State<GPQuanXianPage> createState() => _GPQuanXianPageState();
}

class _GPQuanXianPageState extends State<GPQuanXianPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: SizedBox(
          height: 600.h,
          width: 520.h,
          child: Stack(
            children: [
              WidgetUtils.showImages('assets/images/qx_bg1.png', 600.h, 520.h),
              Column(
                children: [
                  WidgetUtils.commonSizedBox(230.h, 0),
                  WidgetUtils.onlyTextCenter(
                      '温馨提示',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.homeTopBG,
                          fontSize: 42.sp,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 20.h, right: 20.h),
                    child: WidgetUtils.onlyText(
                        '请确保App麦克风、相机、相册、存储权限都已打开，否则将无法正常使用本App！',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.homeTopBG,
                            fontSize: 30.sp)),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                      //打开系统权限设置
                      openAppSettings();
                    }),
                    child: Container(
                      height: 70.h,
                      width: 350.h,
                      margin: EdgeInsets.only(left: 50.h, right: 50.h),
                      //边框设置
                      decoration: BoxDecoration(
                        //背景
                        color: MyColors.peopleBlue2,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(28.h)),
                      ),
                      child: WidgetUtils.onlyTextCenter(
                          '前往设置',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(70.h, 0),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
