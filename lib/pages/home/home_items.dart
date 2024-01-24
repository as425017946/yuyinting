import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/widget/SVGASimpleImage3.dart';

import '../../bean/hengFuBean.dart';
import '../../utils/widget_utils.dart';
import '../../widget/Marquee.dart';
import '../../widget/SVGASimpleImage.dart';

class HomeItems {
  /// 公屏送礼推送
  static Widget itemAnimation(String url, AnimationController controller,
      Animation<Offset> animation, String name, hengFuBean hf) {
    LogE('名称 == $name');
    String info = '';
    double gd = 0, topHD = 0;
    switch (name) {
      case '超级转盘':
        gd = 120.h;
        topHD = 130.h;
        info =
        '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '心动转盘':
        gd = 120.h;
        topHD = 130.h;
        info =
            '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '马里奥':
        gd = 120.h;
        topHD = 130.h;
        info =
        '${hf.fromNickname}在竞速马里奥中赢得${hf.amount}蘑菇';
        break;
      case '白灵':
        gd = 120.h;
        topHD = 130.h;
        info =
        '${hf.fromNickname}在竞速马里奥白灵玩法中赢得${hf.amount}蘑菇';
        break;
      case '低贵族':
        gd = 20.h;
        topHD = 130.h;
        if (hf.nobleId! == 2) {
          info = '晋升为骑士';
        } else if (hf.nobleId! == 3) {
          info = '晋升为伯爵';
        } else if (hf.nobleId! == 4) {
          info = '晋升为侯爵';
        }
        break;
      case '高贵族':
        gd = 50.h;
        topHD = 160.h;
        if (hf.nobleId! == 5) {
          info = '晋升为公爵';
        } else if (hf.nobleId! == 6) {
          info = '晋升为国王';
        } else if (hf.nobleId! == 7) {
          info = '晋升为帝王';
        }
        break;
      case '蓝魔方':
        gd = 130.h;
        topHD = 130.h;
        info =
            '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '金魔方':
        gd = 130.h;
        topHD = 130.h;
        info =
            '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '1q直刷':
        gd = 20.h;
        topHD = 135.h;
        info =
            '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '1w直刷':
        gd = 20.h;
        topHD = 175.h;
        info =
            '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '5000_9990背包礼物':
        gd = 30.h;
        topHD = 150.h;
        info =
        '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '10000_49990背包礼物':
        gd = 30.h;
        topHD = 150.h;
        info =
        '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '50000_99990背包礼物':
        gd = 30.h;
        topHD = 150.h;
        info =
        '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '100000_380000背包礼物':
        gd = 20.h;
        topHD = 155.h;
        info =
        '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '388800背包礼物':
        gd = 20.h;
        topHD = 175.h;
        info =
        '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
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
                onTap: (() {
                  // controller.forward();
                }),
                child: Padding(
                  padding: EdgeInsets.only(top: topHD, left: gd, right: 50.h),
                  child: Marquee(
                    speed: 10,
                    child: name == '低贵族' ||
                            name == '高贵族' ||
                            name == '马里奥' ||
                            name == '白鬼'
                        ? RichText(
                            text: TextSpan(children: [
                            WidgetSpan(
                                child: Transform.translate(
                              offset: Offset(0, 0.h),
                              child: Text(
                                '恭喜',
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
                            )),
                            // // 显示头像
                            // WidgetSpan(
                            //     child: WidgetUtils.CircleImageNet(30.h, 30.h,
                            //         15.h, hf.avatar!)),
                            // 昵称
                            // WidgetSpan(
                            //     child: Transform.translate(
                            //   offset: Offset(0, 0.h),
                            //   child: Text(
                            //     hf.fromNickname!,
                            //     style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 30.sp,
                            //       shadows: const [
                            //         Shadow(
                            //           color: Colors.black54,
                            //           offset: Offset(2, 2),
                            //           blurRadius: 3,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // )),
                            // 提示信息
                            WidgetSpan(
                                child: Transform.translate(
                              offset: Offset(0, 0.h),
                              child: Text(
                                info,
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
                            )),
                          ]))
                        : Text(
                            info,
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
  static Widget itemBig(hengFuBean hf,int type) {
    // type 0爆出 1送出
    String info = '';
    if(type == 0) {
      info =
          '在${hf.roomName}的超级转盘玩法中赢得价值388800的瑞麟*1';
    }else{
      info =
      '神豪降临${hf.fromNickname!}在${hf.roomName!}送给了${hf.toNickname!}价值388800的瑞麟*1 快来围观吧！';
    }
    return IgnorePointer(
        ignoring: true,
        child: SizedBox(
          height: 340.h,
          width: double.infinity,
          child: Stack(
            children: [
              SVGASimpleImage3(
                assetsName: type == 0 ? 'assets/svga/gp/gp_52hf.svga' : 'assets/svga/gp/gp_52.svga',
              ),
              GestureDetector(
                onTap: (() {}),
                child: Padding(
                  padding: EdgeInsets.only(top: type == 0 ? 220.h : 185.h, left: 60.h, right: 50.h),
                  child: Marquee(
                    speed: 10,
                    child: RichText(
                        text: TextSpan(children: [
                      WidgetSpan(
                          child: Transform.translate(
                        offset: Offset(0, 0.h),
                        child: Text(
                          type == 0 ? '恭喜' : '',
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
                      )),
                      // // 显示头像
                      // WidgetSpan(
                      //     child: type == 0 ? WidgetUtils.CircleImageNet(
                      //         30.h, 30.h, 15.h, hf.avatar!) : const Text('')),
                      // 昵称
                      WidgetSpan(
                          child: Transform.translate(
                        offset: Offset(0, 0.h),
                        child: type == 0 ? Text(
                          hf.fromNickname!,
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
                        ) : const Text(''),
                      )),
                      // 提示信息
                      WidgetSpan(
                          child: Transform.translate(
                        offset: Offset(0, 0.h),
                        child: Text(
                          info,
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
                      )),
                    ])),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
