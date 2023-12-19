import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 送礼物展示的效果页面
class RoomShowLiWuPage extends StatefulWidget {
  // 选择需要赠送的哪个人
  List<bool> listPeople = [];
  String url;
  RoomShowLiWuPage(
      {super.key,
      required this.listPeople,
      required this.url});

  @override
  State<RoomShowLiWuPage> createState() => _RoomShowLiWuPageState();
}

class _RoomShowLiWuPageState extends State<RoomShowLiWuPage>
    with TickerProviderStateMixin {
  //麦位以外人员使用
  late AnimationController _controller10;
  late Animation<double> _animationSize10;
  late Animation<Offset> _animationPosition10;
  late Animation<double> _animationOpacity10;

  //厅主位置使用
  late AnimationController _controller;
  late Animation<double> _animationSize;
  late Animation<Offset> _animationPosition;
  late Animation<double> _animationOpacity;

  //1位置使用
  late AnimationController _controller1;
  late Animation<double> _animationSize1;
  late Animation<Offset> _animationPosition1;
  late Animation<double> _animationOpacity1;

  //2位置使用
  late AnimationController _controller2;
  late Animation<double> _animationSize2;
  late Animation<Offset> _animationPosition2;
  late Animation<double> _animationOpacity2;

  //3位置使用
  late AnimationController _controller3;
  late Animation<double> _animationSize3;
  late Animation<Offset> _animationPosition3;
  late Animation<double> _animationOpacity3;

  //4位置使用
  late AnimationController _controller4;
  late Animation<double> _animationSize4;
  late Animation<Offset> _animationPosition4;
  late Animation<double> _animationOpacity4;

  //5位置使用
  late AnimationController _controller5;
  late Animation<double> _animationSize5;
  late Animation<Offset> _animationPosition5;
  late Animation<double> _animationOpacity5;

  //6位置使用
  late AnimationController _controller6;
  late Animation<double> _animationSize6;
  late Animation<Offset> _animationPosition6;
  late Animation<double> _animationOpacity6;

  //7位置使用
  late AnimationController _controller7;
  late Animation<double> _animationSize7;
  late Animation<Offset> _animationPosition7;
  late Animation<double> _animationOpacity7;

  //8位置使用
  late AnimationController _controller8;
  late Animation<double> _animationSize8;
  late Animation<Offset> _animationPosition8;
  late Animation<double> _animationOpacity8;

  //时长
  int sc = 4;

  // 初始图片大小
  double d1 = 0.6, d2 = 1.0;

  // 由小变大时长，移动时长，消失时长
  double c1 = 0.5, c2 = 0.75, c3 = 1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -460.h),
    );
    final Animatable<double> opacityTween = Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve = _controller.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve = _controller.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve = _controller.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize = sizeTween.animate(sizeCurve);
    _animationPosition = positionTween.animate(positionCurve);
    _animationOpacity = opacityTween.animate(opacityCurve);

    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween1 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween1 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-225.h, -260.h),
    );
    final Animatable<double> opacityTween1 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve1 = _controller1.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve1 = _controller1.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve1 = _controller1.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize1 = sizeTween1.animate(sizeCurve1);
    _animationPosition1 = positionTween1.animate(positionCurve1);
    _animationOpacity1 = opacityTween1.animate(opacityCurve1);

    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween2 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween2 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-75.h, -260.h),
    );
    final Animatable<double> opacityTween2 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve2 = _controller2.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve2 = _controller2.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve2 = _controller2.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize2 = sizeTween2.animate(sizeCurve2);
    _animationPosition2 = positionTween2.animate(positionCurve2);
    _animationOpacity2 = opacityTween2.animate(opacityCurve2);

    _controller3 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween3 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween3 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(75.h, -260.h),
    );
    final Animatable<double> opacityTween3 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve3 = _controller3.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve3 = _controller3.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve3 = _controller3.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize3 = sizeTween3.animate(sizeCurve3);
    _animationPosition3 = positionTween3.animate(positionCurve3);
    _animationOpacity3 = opacityTween3.animate(opacityCurve3);

    _controller4 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween4 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween4 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(225.h, -260.h),
    );
    final Animatable<double> opacityTween4 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve4 = _controller4.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve4 = _controller4.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve4 = _controller4.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize4 = sizeTween4.animate(sizeCurve4);
    _animationPosition4 = positionTween4.animate(positionCurve4);
    _animationOpacity4 = opacityTween4.animate(opacityCurve4);

    _controller5 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween5 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween5 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-225.h, -105.h),
    );
    final Animatable<double> opacityTween5 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve5 = _controller5.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve5 = _controller5.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve5 = _controller5.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize5 = sizeTween5.animate(sizeCurve5);
    _animationPosition5 = positionTween5.animate(positionCurve5);
    _animationOpacity5 = opacityTween5.animate(opacityCurve5);

    _controller6 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween6 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween6 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-75.h, -105.h),
    );
    final Animatable<double> opacityTween6 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve6 = _controller6.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve6 = _controller6.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve6 = _controller6.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize6 = sizeTween6.animate(sizeCurve6);
    _animationPosition6 = positionTween6.animate(positionCurve6);
    _animationOpacity6 = opacityTween6.animate(opacityCurve6);

    _controller7 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween7 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween7 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(75.h, -105.h),
    );
    final Animatable<double> opacityTween7 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve7 = _controller7.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve7 = _controller7.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve7 = _controller7.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize7 = sizeTween7.animate(sizeCurve7);
    _animationPosition7 = positionTween7.animate(positionCurve7);
    _animationOpacity7 = opacityTween7.animate(opacityCurve7);

    _controller8 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween8 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween8 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(225.h, -105.h),
    );
    final Animatable<double> opacityTween8 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve8 = _controller8.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve8 = _controller8.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve8 = _controller8.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize8 = sizeTween8.animate(sizeCurve8);
    _animationPosition8 = positionTween8.animate(positionCurve8);
    _animationOpacity8 = opacityTween8.animate(opacityCurve8);

    _controller10 = AnimationController(
      vsync: this,
      duration: Duration(seconds: sc),
    );
    final Animatable<double> sizeTween10 = Tween<double>(begin: d1, end: d2);
    final Animatable<Offset> positionTween10 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(200.h, -560.h),
    );
    final Animatable<double> opacityTween10 =
        Tween<double>(begin: 1.0, end: 0.0);

    final Animation<double> sizeCurve10 = _controller10.drive(
      CurveTween(curve: Interval(0.0, c1, curve: Curves.easeInOut)),
    );
    final Animation<double> positionCurve10 = _controller10.drive(
      CurveTween(curve: Interval(c1, c2, curve: Curves.easeInOut)),
    );
    final Animation<double> opacityCurve10 = _controller10.drive(
      CurveTween(curve: Interval(c2, c3, curve: Curves.easeInOut)),
    );
    _animationSize10 = sizeTween10.animate(sizeCurve10);
    _animationPosition10 = positionTween10.animate(positionCurve10);
    _animationOpacity10 = opacityTween10.animate(opacityCurve10);

    // svga礼物是空的，播放送的礼物
    if (widget.listPeople[8]) {
      _controller.forward();
    }
    if (widget.listPeople[0]) {
      _controller1.forward();
    }
    if (widget.listPeople[1]) {
      _controller2.forward();
    }
    if (widget.listPeople[2]) {
      _controller3.forward();
    }
    if (widget.listPeople[3]) {
      _controller4.forward();
    }
    if (widget.listPeople[4]) {
      _controller5.forward();
    }
    if (widget.listPeople[5]) {
      _controller6.forward();
    }
    if (widget.listPeople[6]) {
      _controller7.forward();
    }
    if (widget.listPeople[7]) {
      _controller8.forward();
    }
    if (widget.listPeople[9]) {
      _controller10.forward();
    }
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
    _controller8.dispose();
    _controller10.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            widget.listPeople[8]
                ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity.value,
                  child: ScaleTransition(
                    scale: _animationSize,
                    child: Transform.translate(
                      offset: _animationPosition.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[0]
                ? AnimatedBuilder(
              animation: _controller1,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity1.value,
                  child: ScaleTransition(
                    scale: _animationSize1,
                    child: Transform.translate(
                      offset: _animationPosition1.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[1]
                ? AnimatedBuilder(
              animation: _controller2,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity2.value,
                  child: ScaleTransition(
                    scale: _animationSize2,
                    child: Transform.translate(
                      offset: _animationPosition2.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[2]
                ? AnimatedBuilder(
              animation: _controller3,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity3.value,
                  child: ScaleTransition(
                    scale: _animationSize3,
                    child: Transform.translate(
                      offset: _animationPosition3.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[3]
                ? AnimatedBuilder(
              animation: _controller4,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity4.value,
                  child: ScaleTransition(
                    scale: _animationSize4,
                    child: Transform.translate(
                      offset: _animationPosition4.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[4]
                ? AnimatedBuilder(
              animation: _controller5,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity5.value,
                  child: ScaleTransition(
                    scale: _animationSize5,
                    child: Transform.translate(
                      offset: _animationPosition5.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[5]
                ? AnimatedBuilder(
              animation: _controller6,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity6.value,
                  child: ScaleTransition(
                    scale: _animationSize6,
                    child: Transform.translate(
                      offset: _animationPosition6.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[6]
                ? AnimatedBuilder(
              animation: _controller7,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity7.value,
                  child: ScaleTransition(
                    scale: _animationSize7,
                    child: Transform.translate(
                      offset: _animationPosition7.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[7]
                ? AnimatedBuilder(
              animation: _controller8,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity8.value,
                  child: ScaleTransition(
                    scale: _animationSize8,
                    child: Transform.translate(
                      offset: _animationPosition8.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
            widget.listPeople[9]
                ? AnimatedBuilder(
              animation: _controller10,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationOpacity10.value,
                  child: ScaleTransition(
                    scale: _animationSize10,
                    child: Transform.translate(
                      offset: _animationPosition10.value,
                      child: Container(
                        width: 100.h,
                        height: 100.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const Text(''),
          ],
        ),
      ),
    );
  }

}
