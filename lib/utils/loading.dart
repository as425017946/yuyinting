import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../config/my_config.dart';

class Loading {
  Loading() {
    EasyLoading.instance
      /// 加载时间
      ..displayDuration = const Duration(milliseconds: 2000)
      /// 加载类型
      ..indicatorType = EasyLoadingIndicatorType.ring
      /// 加载样式
      ..loadingStyle = EasyLoadingStyle.custom
      /// 指示器的大小, 默认40.0.
      ..indicatorSize = 35.0
      ..lineWidth = 2
      /// loading的圆角大小, 默认5.0.
      ..radius = 10.0
      /// 进度条指示器的颜色, 仅对[EasyLoadingStyle.custom]有效.
      ..progressColor = Colors.white
      /// loading的背景色, 仅对[EasyLoadingStyle.custom]有效.
      ..backgroundColor = Colors.black.withOpacity(0.7)
      /// 指示器的颜色, 仅对[EasyLoadingStyle.custom]有效.
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.6)
      /// 当loading展示的时候，是否允许用户操作.
      ..userInteractions = false
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.custom;
  }

  static void show([String? text]) {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.backgroundColor = Colors.transparent;
    EasyLoading.instance.indicatorColor = Colors.transparent;
    EasyLoading.instance.textColor = Colors.transparent;
    EasyLoading.instance.maskColor = Colors.transparent;
    EasyLoading.instance.boxShadow = <BoxShadow>[];
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.pumpingHeart;
    EasyLoading.show(status: text ?? MyConfig.successTitle);
  }

  static void show2([String? text]) {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.backgroundColor =  Colors.black.withOpacity(0.7);
    EasyLoading.instance.indicatorColor = Colors.white;
    EasyLoading.instance.textColor = Colors.white;
    EasyLoading.instance.maskColor = Colors.black.withOpacity(0.6);
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.pumpingHeart;
    EasyLoading.show(status: text ?? MyConfig.successTitle);
  }

  static void toast(String text) {
    EasyLoading.showToast(text);
  }

  static void dismiss() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }

  static bool get isShow => EasyLoading.isShow;
}
