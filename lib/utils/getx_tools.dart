import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../bean/Common_bean.dart';
import '../bean/joinRoomBean.dart';
import '../colors/my_colors.dart';
import '../http/data_utils.dart';
import '../http/my_http_config.dart';
import '../main.dart';
import '../pages/room/room_page.dart';
import '../pages/room/room_ts_mima_page.dart';
import 'event_utils.dart';
import 'loading.dart';
import 'log_util.dart';
import 'my_toast_utils.dart';
import 'my_utils.dart';

mixin GetAntiCombo {
  // final Rx<int> _action = 0.obs;
  // Worker? _worker;

  // void action(void Function() a) {
  //   if (_worker == null) {
  //     done() {
  //       _worker?.dispose();
  //       _worker = null;
  //       _action.value = 0;
  //     }

  //     _worker = interval(_action, (_) => done(), onError: () => done());
  //     a();
  //   }
  //   _action.value++;
  // }
  bool get canTap => _canTap && _canTapAction;
  set canTap(bool value) => _canTap = value;
  bool _canTap = true;
  bool _canTapAction = true;
  void action(void Function() a) {
    if (canTap) {
      _canTapAction = false;
      Future.delayed(const Duration(milliseconds: 500), () => _canTapAction = true);
      a();
    }
  }

  void joinRoom(int id, BuildContext context) async {
    if (sp.getBool('joinRoom') == false) {
      sp.setBool('joinRoom', true);
      try {
        Loading.show();
        final String roomID = id.toString();
        final roomToken = await _doPostBeforeJoin(roomID, context);
        if (roomToken.isNotEmpty) {
          // ignore: use_build_context_synchronously
          await _doPostRoomJoin(roomID, '', roomToken, context);
        }
      } catch (e) {
        LogE(e.toString());
        sp.setBool('joinRoom', false);
      } finally {
        Loading.dismiss();
      }
      
    }
  }

  /// 加入房间前
  Future<String> _doPostBeforeJoin(roomID, BuildContext context) async {
    //判断房间id是否为空的
    if (roomID == null || roomID.toString().isEmpty) {
      throw 'roomID 为空';
    } else {
      // 不是空的，并且不是之前进入的房间
      if (sp.getString('roomID').toString() != roomID) {
        sp.setString('roomID', roomID);
        eventBus.fire(SubmitButtonBack(title: '加入其他房间'));
      }
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    joinRoomBean bean = await DataUtils.postBeforeJoin(params);
    switch (bean.code) {
      case MyHttpConfig.successCode:
        if (sp.getString('sqRoomID').toString() == roomID) {
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
            context,
            RoomPage(
              roomId: roomID,
              beforeId: '',
              roomToken: bean.data!.rtc!,
            ),
          );
        } else {
          return bean.data!.rtc!;
        }
        return '';
      case MyHttpConfig.errorRoomCode: //需要密码
        // ignore: use_build_context_synchronously
        MyUtils.goTransparentPageCom(
          context,
          RoomTSMiMaPage(roomID: roomID, roomToken: bean.data!.rtc!, anchorUid: ''),
        );
        throw '需要密码';
      case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
        throw '未登录';
      default:
        MyToastUtils.showToastBottom(bean.msg!);
        throw bean.msg!;
    }
  }

  /// 加入房间
  Future<void> _doPostRoomJoin(roomID, password, roomToken, BuildContext context) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password
    };
    CommonBean bean = await DataUtils.postRoomJoin(params);
    switch (bean.code) {
      case MyHttpConfig.successCode:
        sp.setBool('joinRoom', false);
        // ignore: use_build_context_synchronously
        MyUtils.goTransparentRFPage(
          context,
          RoomPage(
            roomId: roomID,
            beforeId: '',
            roomToken: roomToken,
          ),
        );
        break;
      case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
        throw '未登录';
      default:
        MyToastUtils.showToastBottom(bean.msg!);
        throw bean.msg!;
    }
  }

  Future<T> doRequest<T>(Future<T> Function() request, {bool Function(int)? showErrMsg}) async {
    final bean = await request() as GetBean;
    switch (bean.code) {
      case MyHttpConfig.successCode:
        return bean as T;
      case MyHttpConfig.errorloginCode:
        final context = Get.context;
        if (context != null) {
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
        }
        throw '未登录';
      default:
        if ((showErrMsg == null || showErrMsg(bean.code)) && bean.msg.isNotEmpty) {
          MyToastUtils.showToastBottom(bean.msg);
        }
        throw bean;
    }
  }

  void hideKeyboard() {
    final context = Get.context;
    if (context != null) {
      MyUtils.hideKeyboard(context);
    }
  }
}

String charmLevelIcon(int level) {
  if (level <= 10) {
    return '1-10';
  } else if (level <= 15) {
    return '11-15';
  } else if (level <= 20) {
    return '16-20';
  } else if (level <= 25) {
    return '21-25';
  } else if (level <= 30) {
    return '26-30';
  } else if (level <= 35) {
    return '31-35';
  } else if (level <= 40) {
    return '36-40';
  } else if (level <= 45) {
    return '41-45';
  } else {
    return '46-50';
  }
}

int wealthLevelIcon(int level) {
  if (level <= 9) {
    return 1;
  } else if (level <= 15) {
    return 2;
  } else if (level <= 23) {
    return 3;
  } else if (level <= 31) {
    return 4;
  } else if (level <= 36) {
    return 5;
  } else if (level <= 40) {
    return 6;
  } else if (level <= 46) {
    return 7;
  } else {
    return 8;
  }
}

class CharmLevelFlag extends StatelessWidget {
  final int level;
  final double? width;
  final double? height;
  const CharmLevelFlag({super.key, required this.level, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    if (level == 0) {
      return SizedBox(
        width: width,
        height: height,
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 100,
          height: 40,
          child: Stack(
            children: [
              Image(
                image: AssetImage('assets/images/dj/dj_c_${charmLevelIcon(level)}.png'),
                fit: BoxFit.fill,
              ),
              Positioned(
                left: 55,
                bottom: 5,
                child: Stack(
                  children: [
                    Text(
                      level.toString(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = MyColors.djTwoM,
                      ),
                    ),
                    Text(
                      level.toString(),
                      style: const TextStyle(
                        color: MyColors.djOne,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WealthLevelFlag extends StatelessWidget {
  final int level;
  final double? width;
  final double? height;
  const WealthLevelFlag({super.key, required this.level, this.width, this.height});

  @override
  Widget build(BuildContext context) { // 697 x 358
    if (level == 0) {
      return SizedBox(
        width: width,
        height: height,
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 100,//40 * 697.0 / 358.0,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: const Offset(0, 2),
                child: Transform.scale(
                  scale: 1.3,
                  child: Image(
                    image: AssetImage('assets/images/bigclient_icon_bg_${wealthLevelIcon(level)}.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                left: 62,
                bottom: 5,
                child: Stack(
                  children: [
                    Text(
                      level.toString(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = MyColors.djTwoM,
                      ),
                    ),
                    Text(
                      level.toString(),
                      style: const TextStyle(
                        color: MyColors.djOne,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CharmLevelTag extends StatelessWidget with _Tag {
  final int level;
  final double? width;
  final double? height;
  final double scale;
  const CharmLevelTag({super.key, required this.level, this.width, this.height, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    final img = 'assets/images/dj/dj_${charmLevelIcon(level)}.png';
    return tag(img, level, width, height, scale);
  }
}

class WealthLevelTag extends StatelessWidget with _Tag {
  final int level;
  final double? width;
  final double? height;
  final double scale;
  const WealthLevelTag({super.key, required this.level, this.width, this.height, this.scale = 1.3});

  @override
  Widget build(BuildContext context) {
    final img = 'assets/images/bigclient_icon_${wealthLevelIcon(level)}.png';
    return tag(img, level, width, height, scale);
  }
}

mixin _Tag {
  Widget tag(String img, int level, double? width, double? height, double scale) {
    if (level == 0) {
      return SizedBox(
        width: width,
        height: height,
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 35,
          height: 35,
          child: Stack(
            children: [
              Transform.scale(
                scale: scale,
                child: Image(
                  image: AssetImage(img),
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Stack(
                  children: [
                    Text(
                      level.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = MyColors.djTwoM,
                      ),
                    ),
                    Text(
                      level.toString(),
                      style: const TextStyle(
                        color: MyColors.djOne,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserFrameHead extends StatelessWidget {
  final double size;
  final String avatar;
  final String avatarFrameGifImg;
  final String avatarFrameImg;
  const UserFrameHead({super.key, required this.size, required this.avatar, this.avatarFrameGifImg = '', this.avatarFrameImg = ''});
  @override
  Widget build(BuildContext context) {
    const scale = 4.0 / 3.0;
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          WidgetUtils.CircleHeadImage(size, size, avatar),
          if (avatarFrameGifImg.isNotEmpty) // 头像框动态图
            Transform.scale(
              scale: scale,
              child: SVGASimpleImage(
                resUrl: avatarFrameGifImg,
              ),
            )
          else if (avatarFrameImg.isNotEmpty) // 头像框静态图
            Transform.scale(
              scale: scale,
              child: WidgetUtils.CircleHeadImage(size, size, avatarFrameImg),
            )
        ],
      ),
    );
  }
}

class UserGenderCircle extends StatelessWidget {
  final double size;
  final int gender;
  const UserGenderCircle({super.key, required this.size, required this.gender});
  @override
  Widget build(BuildContext context) {
    final isNv = gender != 1;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size / 6.0),
      decoration: BoxDecoration(
        color: isNv ? MyColors.dtPink : MyColors.dtBlue,
        borderRadius: BorderRadius.all(Radius.circular(size / 2.0)),
      ),
      child: Image.asset(isNv ? 'assets/images/nv.png' : 'assets/images/nan.png'),
    );
  }
}

mixin GetBean {
  late int code;
  late String msg;
  fromJson(Map<String, dynamic>? map, [void Function(dynamic)? callback]) {
    if (map == null) {
      throw '数据错误';
    }
    code = map['code'] ?? -1;
    msg = map['msg'] ?? '';
    if (callback != null) {
      final data = map['data'];
      if (data != null) {
        callback(map['data']);
      }
    }
  }
}
class GetXBean with GetBean {
  GetXBean._private();
  factory GetXBean.fromJson(Map<String, dynamic>? map) {
    return GetXBean._private()..fromJson(map);
  }
}

class VoiceCardBtn extends StatelessWidget {
  final bool isPlay;
  final double? top;
  const VoiceCardBtn({super.key, required this.isPlay, this.top});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.w,
      width: 220.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      margin: EdgeInsets.only(top: top ?? 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E13F),
        borderRadius: BorderRadius.all(Radius.circular(22.w)),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/makefriends_${isPlay ? 'pause' : 'play'}.png',
            width: 30.w,
            height: 30.w,
          ),
          Expanded(
            child: SVGASimpleImage(
              assetsName: 'assets/svga/audio_${isPlay ? 'xintiao' : 'xindiaotu'}.svga',
            ),
          ),
        ],
      ),
    );
  }
}

EdgeInsets get getxWindowPadding => MediaQueryData.fromWindow(window).padding;

class GetPickSheetItem {
  final String title;
  final Color? color;
  final void Function() action;
  GetPickSheetItem({required this.title, required this.action, this.color});
}
class GetPickSheet extends StatelessWidget {
  final List<GetPickSheetItem> list;
  const GetPickSheet({super.key, required this.list});
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(30.w);
    final line = SizedBox(height: 5.h);
    List<Widget> children = [];
    for (var i = 0; i < list.length; i++) {
      if (i > 0) {
        children.add(line);
      }
      children.add(_btn(list[i]));
    }
    return Container(
      width: double.infinity,
      height: Get.bottomBarHeight + 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }

  Widget _btn(GetPickSheetItem item) {
    return GestureDetector(
      onTap: item.action,
      child: Container(
        width: double.infinity,
        height: 60.h,
        color: Colors.white,
        child: Center(
          child: Text(
            item.title.split('').join('  '),
            style: TextStyle(
              color: item.color ?? Colors.black,
              fontSize: 26.h,
            ),
          ),
        ),
      ),
    );
  }
}