import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../main.dart';
import '../../utils/my_toast_utils.dart';

/// 我的页面 使用的实名制页面
class MineSMZPage extends StatefulWidget {
  const MineSMZPage({super.key});

  @override
  State<MineSMZPage> createState() => _MineSMZPageState();
}

class _MineSMZPageState extends State<MineSMZPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          height: (340 * 1.1).w,
          width: (460 * 1.3).w,
          decoration: const BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            children: [
              WidgetUtils.commonSizedBox((30 * 1.3).w, 0),
              WidgetUtils.onlyTextCenter(
                  '温馨提示',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.black87,
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w600)),
              Padding(
                padding: EdgeInsets.all((25 * 1.3).w),
                child: Text(
                  '为了保证您的资金安全，需要认证您的实名信息，点击同意开始实名认证',
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: StyleUtils.getCommonTextStyle(
                      color: MyColors.g9,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
              WidgetUtils.commonSizedBox((40 * 1.0).w, 0),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: (60 * 1.3).w,
                      width: (160 * 1.3).w,
                      decoration: BoxDecoration(
                        //背景
                        color: Colors.white,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                            BorderRadius.all(Radius.circular((30 * 1.3).w)),
                        border: Border.all(width: 1, color: MyColors.g9),
                      ),
                      child: WidgetUtils.onlyTextCenter(
                          '取消',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black87, fontSize: 32.sp)),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, (40 * 1.3).w),
                  GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                      if (sp.getString('shimingzhi').toString() == '2' ||
                          sp.getString('shimingzhi').toString() == '3') {
                        Navigator.pushNamed(context, 'ShimingzhiPage');
                      } else if (sp.getString('shimingzhi').toString() == '1') {
                        MyToastUtils.showToastBottom('已认证');
                      } else if (sp.getString('shimingzhi').toString() == '0') {
                        MyToastUtils.showToastBottom('审核中，请耐心等待');
                      }
                    }),
                    child: Container(
                      height: (60 * 1.3).w,
                      width: (160 * 1.3).w,
                      decoration: BoxDecoration(
                        //背景
                        color: Colors.lightBlueAccent,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                            BorderRadius.all(Radius.circular((30 * 1.3).w)),
                      ),
                      child: WidgetUtils.onlyTextCenter(
                          '同意',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white, fontSize: 32.sp)),
                    ),
                  ),
                  const Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
