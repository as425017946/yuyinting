import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../main.dart';

/// 登录后同意拒绝页面
class AgreeTSPage extends StatefulWidget {
  const AgreeTSPage({super.key});

  @override
  State<AgreeTSPage> createState() => _AgreeTSPageState();
}

class _AgreeTSPageState extends State<AgreeTSPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Container(
            width: 500.h,
            height: 580.h,
            padding: EdgeInsets.only(left: 20.h, right: 20.h),
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(30.h, 0),
                WidgetUtils.onlyTextCenter(
                    '用户协议与隐私保护',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600)),
                WidgetUtils.commonSizedBox(15.h, 0),
                WidgetUtils.onlyText(
                    '感谢你选择小柴派对!我们非常重视你的个人信息和隐私保护:',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: 25.sp)),
                WidgetUtils.commonSizedBox(15.h, 0),
                WidgetUtils.onlyText(
                    '1.我们会收集手机号以保障功能的正常使用。',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: 25.sp)),
                WidgetUtils.commonSizedBox(15.h, 0),
                Text('2.设备信息、GPS、摄像头、麦克风、相册等敏感权限均不会默认开启，只有经过明示授权才会为实现功能或服务时使用。',
                    maxLines: 4,
                    style: StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: 25.sp)),
                WidgetUtils.commonSizedBox(15.h, 0),
                RichText(
                  text: TextSpan(
                      text: '更多内容请你认真阅读并了解',
                      style: StyleUtils.getCommonTextStyle(
                          color: MyColors.g6, fontSize: 25.sp),
                      children: [
                        TextSpan(
                            text: '《用户协议》',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.homeTopBG, fontSize: 25.sp)),
                        TextSpan(
                            text: '和',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.g6, fontSize: 25.sp)),
                        TextSpan(
                            text: '《隐私协议》',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.homeTopBG, fontSize: 25.sp)),
                        TextSpan(
                            text: '，点击同意即表示你已阅读并同意全部条款。',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.g6, fontSize: 25.sp)),
                      ]),
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.pop(context);
                    sp.setString('myAgree', '1');
                  }),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    height: 70.h,
                    alignment: Alignment.center,
                    width: double.infinity,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.homeTopBG,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Text(
                      '同意并继续',
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(15.h, 0),
                GestureDetector(
                  onTap: (() {
                    sp.setString('myAgree', '0');
                    Navigator.pop(context);
                    eventBus.fire(LoginBack(isBack: true));
                  }),
                  child: Text(
                    '不同意并退出',
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: MyColors.g9,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return Future.value(false);
      },
    );
  }
}
