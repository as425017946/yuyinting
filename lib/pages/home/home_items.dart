import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import '../../bean/hengFuBean.dart';
import '../../utils/SVGASimpleImage3.dart';

class HomeItems {
  /// 公屏送礼推送
  static Widget itemAnimation(String url, AnimationController controller,
      Animation<Offset> animation, String name, hengFuBean hf,String titleType,String roomID) {
    LogE('名称 == $name');
    String info = '';
    double gd = 0, topHD = 0;
    switch (name) {
      case '抽奖超级转盘':
        gd = 120.h;
        topHD = 130.h;
        info =
        '${hf.fromNickname}在${hf.roomName}获得价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '抽奖心动转盘':
        gd = 120.h;
        topHD = 130.h;
        info =
        '${hf.fromNickname}在${hf.roomName}获得价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
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
        gd = 20.h;
        topHD = 130.h;
        info =
            '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '金魔方':
        gd = 100.h;
        topHD = 130.h;
        info =
            '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}送出价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '抽奖蓝魔方':
        gd = 50.h;
        topHD = 135.h;
        info =
        '${hf.fromNickname}在${hf.roomName}获得价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '抽奖金魔方':
        gd = 100.h;
        topHD = 130.h;
        info =
        '${hf.fromNickname}在${hf.roomName}获得价值${hf.giftInfo![0].giftPrice}${hf.giftInfo![0].giftName} x${hf.giftInfo![0].giftNumber}';
        break;
      case '1q直刷':
        gd = 20.h;
        topHD = 140.h;
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
      case '盲盒礼物横幅':
        gd = 35.h;
        topHD = 135.h;
        info =
        '${hf.fromNickname}在${hf.roomName}向${hf.toNickname}惊喜礼盒爆出${hf.giftInfo![0].giftName}(${hf.giftInfo![0].giftPrice}) x${hf.giftInfo![0].giftNumber}';
        break;
    }
    return IgnorePointer(
      ignoring: false,
      child: Container(
        height: 300.h,
        width: double.infinity,
        margin: EdgeInsets.only(left: 20.h, right: 20.h),
        child: SlideTransition(
          position: animation,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              IgnorePointer(
                ignoring: true,
                child: SVGASimpleImage3(
                  assetsName: url,
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: Padding(
                  padding: EdgeInsets.only(top: topHD, left: gd, right: 50.h),
                  child: Marquee(
                    // 文本
                    text:  name == '低贵族' ||
                        name == '高贵族' ||
                        name == '马里奥' ||
                        name == '白鬼' ? '恭喜$info' : info,
                    // 文本样式
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
                    // 滚动轴：水平或者竖直
                    scrollAxis: Axis.horizontal,
                    // 轴对齐方式start
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // 空白间距
                    blankSpace: 20.0,
                    // 速度
                    velocity: 100.0,
                    // 暂停时长
                    pauseAfterRound: Duration(seconds: 1),
                    // startPadding
                    startPadding: 10.0,
                    // 加速时长
                    accelerationDuration: Duration(seconds: 1),
                    // 加速Curve
                    accelerationCurve: Curves.linear,
                    // 减速时长
                    decelerationDuration: Duration(milliseconds: 500),
                    // 减速Curve
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  LogE('横幅点击 ${hf.roomId} === $roomID');
                  LogE('横幅点击*** $titleType');
                  if(MyUtils.checkClick() && hf.roomId != roomID && hf.roomId != '0'){
                    eventBus.fire(hfJoinBack(roomID: hf.roomId!, title: titleType));
                  }
                }),
                child: Container(
                  height: 50.h,
                  width: double.infinity,
                  color: Colors.transparent,
                )
              ),
              // GestureDetector(
              //   onTap: ((){
              //     MyToastUtils.showToastBottom('======');
              //   }),
              //   child: Container(
              //     height: 50.h,
              //     width: 50.h,
              //     color: Colors.red,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  /// 爆出礼物
  static Widget itemBig(hengFuBean hf,int type, String titleType, String roomID) {
    // type 0爆出 1送出
    String info = '';
    if(type == 0) {
      info =
          '${hf.fromNickname!}在${hf.roomName!}的超级转盘玩法中赢得价值${hf.giftInfo![0].giftPrice}的瑞麟*${hf.giftInfo![0].giftNumber}';
    }else{
      info =
      '神豪降临${hf.fromNickname!}在${hf.roomName!}送给了${hf.toNickname!}价值${hf.giftInfo![0].giftPrice}的瑞麟*${hf.giftInfo![0].giftNumber} 快来围观吧！';
    }
    return IgnorePointer(
        ignoring: false,
        child: SizedBox(
          height: 340.h,
          width: double.infinity,
          child: Stack(
            children: [
              IgnorePointer(
                ignoring: true,
                child: SVGASimpleImage(
                  assetsName: type == 0 ? 'assets/svga/gp/gp_52hf.svga' : 'assets/svga/gp/gp_52.svga',
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: Padding(
                  padding: EdgeInsets.only(top: type == 0 ? 220.h : 185.h, left: 60.h, right: 50.h),
                  child: Marquee(
                    // 文本
                    text: type == 0 ? '恭喜$info' : info,
                    // 文本样式
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
                    // 滚动轴：水平或者竖直
                    scrollAxis: Axis.horizontal,
                    // 轴对齐方式start
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // 空白间距
                    blankSpace: 20.0,
                    // 速度
                    velocity: 100.0,
                    // 暂停时长
                    pauseAfterRound: Duration(seconds: 1),
                    // startPadding
                    startPadding: 10.0,
                    // 加速时长
                    accelerationDuration: Duration(seconds: 1),
                    // 加速Curve
                    accelerationCurve: Curves.linear,
                    // 减速时长
                    decelerationDuration: Duration(milliseconds: 500),
                    // 减速Curve
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (() {
                  if(MyUtils.checkClick() && hf.roomId != roomID && hf.roomId != '0'){
                    eventBus.fire(hfJoinBack(roomID: hf.roomId!, title: titleType));
                  }
                }),
                child: Container(
                  height: 50.h,
                  width: double.infinity,
                  color: Colors.transparent,
                )
              ),
            ],
          ),
        ));
  }
}
