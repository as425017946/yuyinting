
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/widget/SVGASimpleImage3.dart';

import '../../widget/Marquee.dart';
import '../../widget/SVGASimpleImage.dart';

class HomeItems{
  /// 公屏送礼推送
  static Widget itemAnimation(String url, AnimationController controller, Animation<Offset> animation,String title, String name){
    double gd = 0, topHD = 0;
    switch(name){
      case '超级转盘':
        gd = 120.h;
        topHD = 130.h;
        break;
      case '心动转盘':
        gd = 120.h;
        topHD = 130.h;
        break;
      case '马里奥':
        gd = 120.h;
        topHD = 130.h;
        break;
      case '白鬼':
        gd = 120.h;
        topHD = 130.h;
        break;
      case '低贵族':
        gd = 20.h;
        topHD = 130.h;
        break;
      case '高贵族':
        gd = 50.h;
        topHD = 160.h;
        break;
      case '蓝魔方':
        gd = 130.h;
        topHD = 130.h;
        break;
      case '金魔方':
        gd = 130.h;
        topHD = 130.h;
        break;
      case '1q直刷':
        gd = 20.h;
        topHD = 135.h;
        break;
      case '1w直刷':
        gd = 20.h;
        topHD = 175.h;
        break;
    }
    return IgnorePointer(
      ignoring: true,
      child: Container(
        height: 300.h,
        width: double.infinity,
        margin: EdgeInsets.only(left: 20.h, right: 20.h),
        child: SlideTransition(
          position: animation,
          child: Stack(
            children: [
              SVGASimpleImage(
                assetsName: url,
              ),
              GestureDetector(
                onTap: ((){
                  controller.forward();
                }),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: topHD,
                      left: gd,
                      right: 50.h
                  ),
                  child: Marquee(
                    speed: 10,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
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

  /// 爆出5w2的礼物
  static Widget itemBig(String title){
    return IgnorePointer(
      ignoring: true,
      child:  SizedBox(
        height: 340.h,
        width: double.infinity,
        child: Stack(
          children: [
            const SVGASimpleImage3(
              assetsName: 'assets/svga/gp/gp_52hf.svga',
            ),
            GestureDetector(
              onTap: ((){
              }),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 220.h,
                    left: 60.h,
                    right: 50.h
                ),
                child: Marquee(
                  speed: 10,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
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
      )
    );
  }
}