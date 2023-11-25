import 'package:flutter/material.dart';
/// 横幅动画使用
class SlideAnimationController {
  late AnimationController controller;
  late Animation<Offset> animation;

  SlideAnimationController({
    required TickerProvider vsync,
    Duration duration = const Duration(seconds: 15),
  }) {
    controller = AnimationController(
      duration: duration,
      vsync: vsync,
    );

    controller.addListener(() {
      if (controller.isCompleted) {
        // 在动画完成时执行操作，例如关闭页面
        // Navigator.pop(context);
      }
    });

    animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: const Offset(3, 0), end: Offset.zero), weight: 10),
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: Offset.zero), weight: 80),
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(-3, 0)), weight: 10),
    ]).animate(controller);
  }

  void playAnimation() {
    controller.forward();
  }

  void dispose() {
    controller.dispose();
  }
}