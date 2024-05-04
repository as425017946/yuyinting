import 'dart:math';

import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
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
            onTap: () => c.action(() {
              Get.dialog(_DialogHelp());
            }),
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
          onTap: () => c.action(() {
            Get.dialog(_DialogReceive());
          }),
          child: _btn('cp_btn_chouqu.png'),
        ),
        SizedBox(width: 37.w),
        GestureDetector(
          onTap: () => c.action(() {
            Get.dialog(_DialogSend());
          }),
          child: _btn('cp_btn_fangru.png'),
        ),
      ],
    );
  }
  Widget _btn(String img) {
    return Image.asset('assets/images/$img', width: 280.w, height: 82.h, fit: BoxFit.contain,);
  }

  Widget _banner() {
    return SizedBox(
      width: double.infinity,
      height: 138.h,
      child: _Banner(),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Barrage(),
        const Spacer(),
        _Barrage(),
      ],
    );
  }
}

// ignore: must_be_immutable
class _Barrage extends StatelessWidget {
  final _isFirst = true.obs;
  final _items = [
    _BarrageType.empty().obs,
    _BarrageType.empty().obs,
    _BarrageType.empty().obs,
    _BarrageType.empty().obs,
  ];
  double _total = 0;
  double _width = 0;
  void _callBack(double total, double width) {
    _total = total;
    _width = width;
  }
  void _run(int index, int itemIndex, int time) async {
    final item = _items[itemIndex];
    int t = 7000 + Random().nextInt(3000);
    item(_BarrageType(index, t));
    await Future.delayed(const Duration(milliseconds: 500));
    final interval = t.toDouble() * (_width + 20.h) / (_width + _total);
    await Future.delayed(Duration(milliseconds: interval.toInt() + 1000 + Random().nextInt(500)));
    _run((index + 1), (itemIndex  + 1)%_items.length, time);
  }
  final _all = '清风晨曦诗意独步琴瑟浮生梦幻繁星烟雨飘渺落花流水蝴蝶倾城晨曦彼岸柔情倚楼漫步清风听风茉莉蓝天蒙蒙如梦忆梦西游无悔醉舞青春';
  String _getName() {
    if (Random().nextInt(3) == 1) {
      return '萌***';
    }
    final start = Random().nextInt(_all.length);
    final name = _all.substring(start, start + 1);
    return '$name***';
  }
  String _text() {
    final String sex;
    if (Random().nextInt(3) == 1) {
      sex = '男';
    } else {
      sex = '女';
    }
    return '${_getName()}  抽到了  纸条$sex友  ${_getName()}';
  }
  
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (_isFirst.value) {
          _isFirst.value = false;
          _run(0, 0, 0);
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 49.h,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: _items
              .map((element) => Obx(() => _item(element.value, _callBack)))
              .toList(),
        ),
      ),
    );
  }
  Widget _item(_BarrageType type, void Function(double, double) callBack) {
    return _BarrageItem(
      aniKey: type.index,
      text: _text(),
      time: type.time,
      callBack: callBack,
    );
  }
}
class _BarrageType {
  final int index;
  final int time;
  _BarrageType(this.index, this.time);
  factory _BarrageType.empty() {
    return _BarrageType(-1, 0);
  }
}

class _BarrageItem extends StatelessWidget {
  // final double start;
  final int aniKey;
  final String text;
  final int time;
  final void Function(double, double) callBack;
  const _BarrageItem({required this.aniKey, required this.text, required this.time, required this.callBack});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, type) {
      final width = 0.0.obs;
      return AfterLayout(
        callback: (RenderAfterLayout ral) {
          width.value = ral.size.width;
          if (aniKey >= 0) {
            callBack(context.width, ral.size.width);
          }
        },
        child: _switcher(context.width, width),
      );
    });
  }
  Widget _switcher(double total, Rx<double> width) {
    final key = Key(aniKey.toString());
    return Obx(() {
      var tween = Tween<Offset>(begin: Offset.zero, end: Offset(-(total/width.value + 1), 0));
      return Transform.translate(
        offset: Offset(total, 0),
        child: AnimatedSwitcher(
        duration: Duration(milliseconds: time),
        transitionBuilder: (child, animation) {
          if (child.key != key || aniKey < 0) {
            return const SizedBox();
          }
          return SlideTransition(
            position: tween.animate(animation),
            child: child,
          );
        },
        child: _item(key),
      ),
      );
    });
  }

  Widget _item(Key key) {
    return Container(
      key: key,
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
            text,
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

class _DialogReceive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 620.w,
        height: 620.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cp_choudao.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class _DialogSend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 620.w,
        height: 652.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cp_fangru.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class _DialogHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 620.w,
        height: 760.w,
        padding: EdgeInsets.only(left: 33.w, right: 33.w, top: 33.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30.w)),
        ),
        child: Column(
          children: [
            _nav(),
            SizedBox(height: 20.w),
            Text(
              _text,
              style: TextStyle(
                fontSize: 17.sp,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nav() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '说明',
            style: TextStyle(
              fontSize: 33.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: Image.asset('assets/images/cp_close.png', width: 27.w, height: 27.w),
        ),
      ],
    );
  }

  final _text = '''
一、游戏简介
你准备好探索未知的交友世界了吗？欢迎来到纸条交友游戏，一个充满神秘与期待的社交平台。在这里，你将有机会抽取来自不同用户的神秘小纸条，同时也有机会让你的小纸条落入他人的手中。但请记住，这是一个充满未知的游戏，你无法预知会抽到谁的小纸条，也无法知道你的小纸条会被谁所发现。
二、真诚交友，认真对待
我们鼓励每一位玩家以真诚的态度参与游戏。当你准备放入小纸条时，请务必认真填写内容，让接收者能够通过你的文字更深入地了解你。乱填或虚假的信息不仅会被视为无效，也是对他人时间的不尊重。
三、真实交友，费用机制
为了确保交友信息的真实性和质量，我们设置了费用机制。当你每天抽放纸条的次数超过3次后，需要支付一定的费用。这样做的目的是为了提高参与门槛，筛选出真正有诚意和需求的用户。
四、信息甄别，保护自我
虽然我们希望每一位玩家都能以真诚的态度参与游戏，但我们也必须提醒你，我们无法保证所有纸条内容的真实性。在与其他玩家交流时，请务必保持警惕，仔细甄别信息。切勿轻易进行转账或其他涉及金钱的交易，以防被骗。
五、祝福与期待
最后，我们衷心祝愿你能在这个纸条交友游戏中收获一段美好的姻缘或深厚的友谊。但请记住，交友需要时间和耐心，不要急于求成。慢慢来，享受这个过程，也许你会发现更多的惊喜和可能。
''';
}
