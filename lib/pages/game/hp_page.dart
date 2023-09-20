import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HPPage extends StatefulWidget {
  const HPPage({super.key});

  @override
  State<HPPage> createState() => _HPPageState();
}

class _HPPageState extends State<HPPage> {
  List<String> imagesa = [
    "assets/images/car_h_bg_qidian.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg_qidian.jpg",
  ];
  late PageController _controller;
  Timer? _timer;
  int _currentPage = 0;

  //背景图动画
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_controller.hasClients) {
        if (_controller.page!.round() >= imagesa.length - 1) {
          _controller.jumpToPage(0);
        } else {
          _controller.nextPage(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void restartTimer() {
    _timer?.cancel();
    startTimer();
  }

  // 背景使用
  void _onPageChanged() {
    int newIndex = _controller.page!.round() % imagesa.length;
    if (newIndex != _currentPage) {
      setState(() {
        _currentPage = newIndex;
      });
    }
  }

  @override
  void initState() {
    AutoOrientation.landscapeAutoMode();

    ///关闭状态栏，与底部虚拟操作按钮
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []); //隐藏状态栏，底部按钮栏
    // 背景图滚动
    _controller = PageController(
      initialPage: imagesa.length - 1,
    )..addListener(_onPageChanged);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.jumpToPage(0);
    });
    //开启
    // startTimer();
    super.initState();
  }

  @override
  void dispose() {
    /// 如果是全屏就切换竖屏
    AutoOrientation.portraitAutoMode();

    ///显示状态栏，与底部虚拟操作按钮
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child:PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              itemBuilder: (context, index) {
                final imageIndex = index % imagesa.length;
                return Image.asset(
                  imagesa[imageIndex],
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                  gaplessPlayback: true,
                );
              },
            ),
          ),
          GestureDetector(
            onTap: (() {
              startTimer();
            }),
            child: Container(
              height: 240.h,
              width: double.infinity,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
