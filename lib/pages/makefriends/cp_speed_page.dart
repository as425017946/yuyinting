import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'makefriends_model.dart';

class CPSpeedPage extends StatelessWidget {
  final MakefriendsController c = Get.find();
  CPSpeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 35),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/cp_bj.png"),
          fit: BoxFit.fill,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          _positioned(Rect.fromLTWH(135.w, 364.h - 35, 480.w, 495.h), img: 'cp_gift.png'),
          _positioned(Rect.fromLTWH(155.w, 220.h - 35, 422.w, 73.h), img: 'cp_success.png'),
          _btnMine(),
          Positioned(
            height: 407.h,
            left: 0,
            bottom: 0,
            right: 0,
            child: _bottom(),
          ),
          _nav(),
        ],
      ),
    );
  }

  Widget _nav() {
    return Container(
      height: 60.w,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 44.w, right: 31.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => c.select = 0,
            child: Text(
              'CP速配',
              style: TextStyle(
                color: const Color(0xFFCFD9FF),
                fontSize: 33.sp,
                fontFamily: 'LR',
              ),
            ),
          ),
          SizedBox(width: 44.w),
          Text(
            '告白纸条',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.sp,
              fontFamily: 'LR',
            ),
          ),
          const Spacer(),
          GestureDetector(
            child: Image.asset('assets/images/cp_help.png', width: 30.w, height: 30.w),
          ),
        ],
      ),
    );
  }

  Widget _positioned(Rect rect, {Widget? child, String img = ''}) {
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: child == null
          ? Image.asset("assets/images/$img", fit: BoxFit.contain)
          : FittedBox(
              fit: BoxFit.contain,
              child: child,
            ),
    );
  }

  Widget _btnMine() {
    final radius = Radius.circular(15.w);
    return Positioned(
      right: 0,
      top: 293.h - 35,
      width: 44.w,
      height: 156.w,
      child: GestureDetector(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(top: 11.w, left: 6.w),
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.only(topLeft: radius, bottomLeft: radius),
          ),
          child: Column(
            children: [
              Image.asset('assets/images/cp_heart.png', width: 28.w, height: 24.w),
              SizedBox(height: 7.w),
              Text(
                '我\n的\n纸\n条',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottom() {
    return Column(
      children: [
        _price(),
        SizedBox(height: 43.h),
        _btns(),
        SizedBox(height: 42.h),
        _banner(),
      ],
    );
  }
  Widget _price() {
    return SizedBox(
      width: 224.w,
      height: 50.h,
      child: FittedBox(
        child: Container(
          width: 224,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0x4CE9DEFF),
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: const Text(
            '50金豆/次',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _btns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: _btn('cp_btn_chouqu.png'),
        ),
        SizedBox(width: 37.w),
        GestureDetector(
          child: _btn('cp_btn_fangru.png'),
        ),
      ],
    );
  }
  Widget _btn(String img) {
    return Image.asset('assets/images/$img', width: 280.w, height: 82.h, fit: BoxFit.contain,);
  }

  Widget _banner() {
    final list = List.generate(100, (_) => 'K***梦  抽到了  纸条男友  A***明 ');
    return SizedBox(
      width: double.infinity,
      height: 138.h,
      child: _Banner(list: list),
    );
  }
}

// ignore: must_be_immutable
class _Banner extends StatelessWidget {
  final List<String> list;
  _Banner({required this.list});
  int _current = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _barrage(100),
        const Spacer(),
        _barrage(250),
      ],
    );
  }

  Widget _barrage(double start) {
    return _Barrage(start, () {
      if (_current >= list.length) {
        _current = 0;
      }
      final item = _BarrageType(_current, list[_current]);
      _current++;
      return item;
    });
  }
}
class _BarrageType { 
  final int index;
  final String text;
  const _BarrageType(this.index, this.text);
}
class _Barrage extends StatelessWidget {
  final double start;
  final _BarrageType Function() next;
  _Barrage(this.start, this.next);
  final distance = 0.0.obs;
  final type = (const _BarrageType(-1, '')).obs;
  @override
  Widget build(BuildContext context) {
   return SizedBox(
    // width: double.infinity,
    height: 49.h,
    child: _item(next()),
   );
  }

  // Widget _animate() {
  //   // return LayoutBuilder(builder: (context, type) {

  //   // });
  // }

  Widget _item(_BarrageType type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      height: 49.h,
      decoration: BoxDecoration(
        color: const Color(0x4CE9DEFF),
        borderRadius: BorderRadius.circular(24.5.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/cp_heart.png', width: 38.h, height: 33.h),
              SizedBox(width: 7.h),
              Text(
                type.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.h,
                ),
              ),
        ],
      ),
    );
  }
}