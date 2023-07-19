import 'package:flutter/material.dart';
//飞龙特效
class LongPage extends StatefulWidget {
  const LongPage({Key? key}) : super(key: key);

  @override
  State<LongPage> createState() => _LongPageState();
}

class _LongPageState extends State<LongPage> with SingleTickerProviderStateMixin{
  //帧动画
  late Animation<double> animation;
  late AnimationController controller;
  var index = 0;
  int interval = 100;
  //素材列表
  List<String> images=["assets/images/feilong/0.png","assets/images/feilong/l1.png","assets/images/feilong/l2.png","assets/images/feilong/l3.png","assets/images/feilong/l4.png","assets/images/feilong/l5.png",
    "assets/images/feilong/l6.png","assets/images/feilong/l7.png","assets/images/feilong/l8.png","assets/images/feilong/l9.png","assets/images/feilong/l10.png","assets/images/feilong/l11.png",
        "assets/images/feilong/l12.png","assets/images/feilong/l13.png","assets/images/feilong/l14.png","assets/images/feilong/l15.png","assets/images/feilong/l16.png","assets/images/feilong/l17.png",
        "assets/images/feilong/l18.png","assets/images/feilong/l19.png","assets/images/feilong/l20.png","assets/images/feilong/l21.png","assets/images/feilong/l22.png","assets/images/feilong/l23.png",
    "assets/images/feilong/l24.png","assets/images/feilong/l25.png","assets/images/feilong/l26.png","assets/images/feilong/l27.png","assets/images/feilong/l28.png","assets/images/feilong/l29.png",
    "assets/images/feilong/l30.png","assets/images/feilong/l31.png","assets/images/feilong/l32.png","assets/images/feilong/l33.png","assets/images/feilong/l34.png","assets/images/feilong/l35.png",
    "assets/images/feilong/l36.png","assets/images/feilong/l37.png","assets/images/feilong/l38.png","assets/images/feilong/l39.png","assets/images/feilong/l40.png","assets/images/feilong/l41.png",
    "assets/images/feilong/l42.png","assets/images/feilong/l43.png","assets/images/feilong/l44.png","assets/images/feilong/l45.png","assets/images/feilong/l46.png","assets/images/feilong/l47.png",
    "assets/images/feilong/l48.png","assets/images/feilong/l49.png","assets/images/feilong/l50.png","assets/images/feilong/l51.png","assets/images/feilong/l52.png","assets/images/feilong/l53.png",
    "assets/images/feilong/l54.png","assets/images/feilong/l55.png","assets/images/feilong/l56.png","assets/images/feilong/l57.png","assets/images/feilong/l58.png","assets/images/feilong/l59.png",
    "assets/images/feilong/l60.png","assets/images/feilong/l61.png","assets/images/feilong/l62.png","assets/images/feilong/l63.png","assets/images/feilong/l64.png","assets/images/feilong/l65.png",
    "assets/images/feilong/l66.png","assets/images/feilong/l67.png","assets/images/feilong/l68.png","assets/images/feilong/l69.png","assets/images/feilong/l70.png"];

  @override
  void initState() {
    super.initState();
    controller=AnimationController(vsync: this,duration:Duration(milliseconds: interval*images.length) );
    animation=Tween<double>(begin: 0,end: images.length.toDouble()).animate(controller);
    controller.forward();
    print('图片长度'+images.length.toDouble().toString());

    WidgetsBinding.instance!.addPostFrameCallback((_) {

    });

    controller.addListener(() {
      if (controller.status == AnimationStatus.completed) {
        print('返回结果***'+animation.value.toInt().toString());
        setState(() {
          index = 0;
        });
        //结束了
      } else if (controller.status == AnimationStatus.forward) {
        print('返回结果=='+animation.value.toInt().toString());
        setState(() {
          if(animation.value.toInt() < images.length){
            if(index != animation.value.toInt()){
              index = animation.value.toInt();
            }
          }
        });
        // print('forward');
      } else if (controller.status == AnimationStatus.reverse) {
        // print('reverse');
      }
    });

    // print('返回结果'+animation.value.toInt().toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Center(child: Image.asset(images[animation.value.toInt()]),);
    return Scaffold(
      backgroundColor: Colors.black38,
      body: SafeArea(
        child: Container(
          height: 500,
          width: 500,
          child: Image.asset(images[index],width: 500, height: 500,gaplessPlayback: true,),
        ),
      ),
    );
  }
}

////https://blog.csdn.net/calvin_zhou/article/details/116453403
