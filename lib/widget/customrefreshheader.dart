import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


class CustomRefreshHeader extends ClassicalHeader {

  // /// Key
  // final Key key;

  /// 方位
  final AlignmentGeometry alignment;

  /// 提示刷新文字
  final String refreshText;

  /// 准备刷新文字
  final String refreshReadyText;

  /// 正在刷新文字
  final String refreshingText;

  /// 刷新完成文字
  final String refreshedText;

  /// 刷新失败文字
  final String refreshFailedText;

  /// 没有更多文字
  final String noMoreText;

  /// 显示额外信息(默认为时间)
  final bool showInfo;

  /// 更多信息
  final String infoText;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color textColor;

  /// 更多信息文字颜色
  final Color infoColor;

  CustomRefreshHeader({
    extent = 60.0,
    triggerDistance = 70.0,
    float = false,
    completeDuration = const Duration(seconds: 1),
    enableInfiniteRefresh = false,
    enableHapticFeedback = true,
    // required this.key,
    required this.alignment,
    this.refreshText = "下拉刷新",
    this.refreshReadyText = "释放刷新",
    this.refreshingText = "刷新中...",
    this.refreshedText = "刷新完成",
    this.refreshFailedText = "刷新失败",
    this.noMoreText = "没有更多",
    this.showInfo = true,
    this.infoText = "更新时间 %T",
    this.bgColor = Colors.transparent,
    this.textColor = Colors.grey,
    this.infoColor = Colors.grey,
  }) : super(
    extent: extent,
    triggerDistance: triggerDistance,
    float: float,
    completeDuration: float
        ? completeDuration == null
        ? const Duration(
      milliseconds: 400,
    )
        : completeDuration +
        const Duration(
          milliseconds: 400,
        )
        : completeDuration,
    enableInfiniteRefresh: enableInfiniteRefresh,
    enableHapticFeedback: enableHapticFeedback,
  );
}