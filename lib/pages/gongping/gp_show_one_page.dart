import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import '../../widget/Marquee.dart';

/// 公屏展示系统推送的信息
class GPShowOnePage extends StatefulWidget {
  const GPShowOnePage({super.key});

  @override
  State<GPShowOnePage> createState() => _GPShowOnePageState();
}

class _GPShowOnePageState extends State<GPShowOnePage> with TickerProviderStateMixin{

  //动画控制器
  late AnimationController controller;
  late Animation<Offset> animation ;
  @override
  void initState() {
    super.initState();
    //duration 动画的时长
    controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    // 监听动画
    controller.addListener(() {
      if(controller.isCompleted){
        Navigator.pop(context);
      }
    });
    animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: const Offset(3,0), end: Offset.zero), weight: 20),
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: Offset.zero), weight: 60),
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(-3,0)), weight: 20),
    ]).animate(controller);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.transparent,
      body: SizedBox(
        height: ScreenUtil().setHeight(340),
        width: double.infinity,
        child: SlideTransition(
          position: animation,
          child: Stack(
            children: [
              const SVGASimpleImage(
                assetsName: 'assets/svga/gp/gp_maliao.svga',
              ),
              GestureDetector(
                onTap: ((){
                  controller.forward();
                }),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(150),
                      left: ScreenUtil().setHeight(150),
                      right: ScreenUtil().setHeight(50)
                  ),
                  child: Marquee(
                    speed: 10,
                    child: Text(
                      '恭喜某某用户单抽喜中价值500元的小柴一个',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(30),
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
