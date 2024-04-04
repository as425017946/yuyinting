import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import '../../bean/Common_bean.dart';
import '../../bean/joinRoomBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';

/// 公屏 邀请进入房间使用
class GPRoomPage extends StatefulWidget {
  String roomID;
  String roomUrl;
  String roomName;

  GPRoomPage(
      {super.key,
      required this.roomID,
      required this.roomUrl,
      required this.roomName});

  @override
  State<GPRoomPage> createState() => _GPRoomPageState();
}

class _GPRoomPageState extends State<GPRoomPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        // Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          height: 700.h,
          width: double.infinity,
          margin: EdgeInsets.only(right: 55.h, left: 55.h),
          decoration: const BoxDecoration(
            //设置Container修饰
            image: DecorationImage(
              //背景图片修饰
              image: AssetImage('assets/images/gp_room_bg.png'),
              fit: BoxFit.fill, //覆盖
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 500.h,
                  width: 500.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SVGASimpleImage(
                        assetsName: 'assets/svga/gp/gp_room2.svga',
                      ),
                      SizedBox(
                        height: 300.h,
                        child: Column(
                          children: [
                            WidgetUtils.commonSizedBox(60.h, 0),
                            WidgetUtils.CircleImageNet(
                                180.h, 180.h, 10.0, widget.roomUrl),
                            WidgetUtils.commonSizedBox(10.h, 0),
                            WidgetUtils.onlyTextCenter(
                                widget.roomName,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.a5,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600)),
                            const Spacer(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // 关闭按钮
              Positioned(
                top: 0.h,
                right: 0.h,
                child: GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        Navigator.pop(context);
                      }
                    }),
                    child: Container(
                      height: 60.h,
                      width: 60.h,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/login_colse.png', 30.h, 30.h),
                    )),
              ),
              // 进入房间按钮
              Positioned(
                bottom: 50.h,
                child: GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      doPostBeforeJoin(widget.roomID);
                    }
                  }),
                  child: Container(
                    height: 65.h,
                    width: (400 * 1.3).w,
                    margin: EdgeInsets.only(left: (40 * 1.3).w, right: (40 * 1.3).w),
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: MyColors.peopleBlue2,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(28.h)),
                    ),
                    child: WidgetUtils.onlyTextCenter(
                        '邀请你进入房间',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    //判断房间id是否为空的
    if (roomID == null || roomID.isEmpty) {
      return;
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
    try {
      Loading.show();
      joinRoomBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(roomID, '', '', bean.data!.rtc!);
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          MyToastUtils.showToastBottom('此房间需要密码~');
          // // ignore: use_build_context_synchronously
          //   MyUtils.goTransparentPageCom(
          //       context,
          //       RoomTSMiMaPage(
          //           roomID: roomID,
          //           roomToken: bean.data!.rtc!,
          //           anchorUid: ''));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间
  Future<void> doPostRoomJoin(
      roomID, password, String anchorUid, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password,
      'anchor_uid': anchorUid
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
              context,
              RoomPage(
                roomId: roomID,
                beforeId: '',
                roomToken: roomToken,
              ));
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
