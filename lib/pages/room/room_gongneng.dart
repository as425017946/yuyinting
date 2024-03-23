import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/room_clean_meili_page.dart';
import 'package:yuyinting/pages/room/room_manager_page.dart';
import 'package:yuyinting/pages/room/room_password_page.dart';
import 'package:yuyinting/pages/room/room_pk_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 房间内功能
class RoomGongNeng extends StatefulWidget {
  int isShow;
  int isBoss;
  int type;
  String roomID;
  bool roomDX;
  bool roomSY;
  bool mima;
  int isLiXian; //0否 1是

  RoomGongNeng(
      {super.key,
      required this.type,
      required this.roomID,
      required this.isShow,
      required this.isBoss,
      required this.roomDX,
      required this.roomSY,
      required this.mima,
      required this.isLiXian});

  @override
  State<RoomGongNeng> createState() => _RoomGongNengState();
}

class _RoomGongNengState extends State<RoomGongNeng> {
  var mima = false;
  var laobanwei = true;
  int is_show = 1, is_boss = 1, lixian = 0;
  bool roomDX = true, roomSY = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      is_show = widget.isShow;
      is_boss = widget.isBoss;
      roomDX = widget.roomDX;
      roomSY = widget.roomSY;
      mima = widget.mima;
      lixian = widget.isLiXian;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                if (MyUtils.checkClick()) {
                  Navigator.pop(context);
                }
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          widget.type == 1
              ? Container(
                  height: ScreenUtil().setHeight(450),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image: AssetImage("assets/images/room_tc2.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(15, 0),
                      WidgetUtils.onlyTextCenter(
                          '功能',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(32))),
                      WidgetUtils.commonSizedBox(30, 0),

                      /// 展示的功能
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                doPostSetShow();
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_shouye.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                    Container(
                                      height: ScreenUtil().setHeight(25),
                                      width: ScreenUtil().setHeight(70),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomBlue,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: WidgetUtils.onlyTextCenter(
                                          is_show == 1 ? '已开启' : '已关闭',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(18))),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '首页展示',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                Navigator.pop(context);
                                Future.delayed(const Duration(seconds: 0), () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return RoomPasswordPage(
                                          type: 1,
                                          roomID: widget.roomID,
                                        );
                                      }));
                                });
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_mima.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                    Opacity(
                                      opacity: mima == false ? 0 : 1,
                                      child: Container(
                                        height: ScreenUtil().setHeight(25),
                                        width: ScreenUtil().setHeight(70),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: MyColors.roomBlue,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: WidgetUtils.onlyTextCenter(
                                            '已开启',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(18))),
                                      ),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '房间密码',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              // eventBus.fire(SubmitButtonBack(title: '清除公屏'));
                              if (MyUtils.checkClick()) {
                                doPostCleanPublicScreen();
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_qingchu.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '清除公屏',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              // eventBus.fire(SubmitButtonBack(title: '清除魅力'));
                              // if (MyUtils.checkClick()) {
                              //   doPostCleanCharm();
                              // }
                              MyUtils.goTransparentPageCom(context,
                                  RoomCleanMeiLiPage(roomID: widget.roomID));
                              Navigator.pop(context);
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_meili.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '清除魅力',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                doPostSetBoss();
                                setState(() {
                                  if (is_boss == 1) {
                                    eventBus
                                        .fire(SubmitButtonBack(title: '老板位0'));
                                  } else {
                                    eventBus
                                        .fire(SubmitButtonBack(title: '老板位1'));
                                  }
                                });
                                eventBus.fire(SubmitButtonBack(title: '老板位'));
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_laoban.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                    Opacity(
                                      opacity: laobanwei == false ? 0 : 1,
                                      child: Container(
                                        height: ScreenUtil().setHeight(25),
                                        width: ScreenUtil().setHeight(70),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: MyColors.roomBlue,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: WidgetUtils.onlyTextCenter(
                                            is_boss == 1 ? '已开启' : '已关闭',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(18))),
                                      ),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '老板位',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(30, 20),

                      /// 第二排
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                setState(() {
                                  roomDX = !roomDX;
                                });
                                if (roomDX) {
                                  MyToastUtils.showToastBottom('动效已开启');
                                  eventBus
                                      .fire(SubmitButtonBack(title: '动效已开启'));
                                } else {
                                  MyToastUtils.showToastBottom('动效已关闭');
                                  eventBus
                                      .fire(SubmitButtonBack(title: '动效已关闭'));
                                }
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_dongxiao.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                    Container(
                                      height: ScreenUtil().setHeight(25),
                                      width: ScreenUtil().setHeight(70),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomBlue,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: WidgetUtils.onlyTextCenter(
                                          roomDX ? '已开启' : '已关闭',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(18))),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '动效',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                setState(() {
                                  roomSY = !roomSY;
                                });
                                if (roomSY) {
                                  MyToastUtils.showToastBottom('房间声音已开启');
                                  eventBus
                                      .fire(SubmitButtonBack(title: '房间声音已开启'));
                                } else {
                                  MyToastUtils.showToastBottom('房间声音已关闭');
                                  eventBus
                                      .fire(SubmitButtonBack(title: '房间声音已关闭'));
                                }
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_shengyin.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                    Container(
                                      height: ScreenUtil().setHeight(25),
                                      width: ScreenUtil().setHeight(70),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomBlue,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: WidgetUtils.onlyTextCenter(
                                          roomSY ? '已开启' : '已关闭',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(18))),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '房间声音',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                Navigator.pop(context);
                                Future.delayed(const Duration(seconds: 0), () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return RoomManagerPage(
                                          type: 1,
                                          roomID: widget.roomID,
                                        );
                                      }));
                                });
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_shezhi.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '房间设置',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          Opacity(
                            opacity:
                                (sp.getString('role').toString() == 'leader' ||
                                        sp.getString('role').toString() ==
                                            'president')
                                    ? 1
                                    : 0,
                            child: GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick()) {
                                  doPostSetLockMic();
                                }
                              }),
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/room_lixina.png',
                                          ScreenUtil().setHeight(80),
                                          ScreenUtil().setHeight(80)),
                                      Container(
                                        height: ScreenUtil().setHeight(25),
                                        width: ScreenUtil().setHeight(70),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: MyColors.roomBlue,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: WidgetUtils.onlyTextCenter(
                                            lixian == 0 ? '已关闭' : '已开启',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(18))),
                                      )
                                    ],
                                  ),
                                  WidgetUtils.commonSizedBox(5, 0),
                                  WidgetUtils.onlyTextCenter(
                                      '离线模式',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomTCWZ3,
                                          fontSize: ScreenUtil().setSp(18))),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(child: Text('')),
                          Opacity(
                            opacity: 1,
                            child: GestureDetector(
                              onTap: ((){
                                if (MyUtils.checkClick()) {
                                  Navigator.pop(context);
                                  MyUtils.goTransparentPage(context, RoomPKPage(roomID: widget.roomID,));
                                }
                              }),
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/room_pk_btn.png',
                                          ScreenUtil().setHeight(80),
                                          ScreenUtil().setHeight(80)),
                                      // Container(
                                      //   height: ScreenUtil().setHeight(25),
                                      //   width: ScreenUtil().setHeight(70),
                                      //   //边框设置
                                      //   decoration: const BoxDecoration(
                                      //     //背景
                                      //     color: MyColors.roomBlue,
                                      //     //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      //     borderRadius: BorderRadius.all(
                                      //         Radius.circular(20.0)),
                                      //   ),
                                      //   child: WidgetUtils.onlyTextCenter(
                                      //       '已开启',
                                      //       StyleUtils.getCommonTextStyle(
                                      //           color: Colors.white,
                                      //           fontSize:
                                      //               ScreenUtil().setSp(18))),
                                      // )
                                    ],
                                  ),
                                  WidgetUtils.commonSizedBox(5, 0),
                                  WidgetUtils.onlyTextCenter(
                                      '房内PK',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomTCWZ3,
                                          fontSize: ScreenUtil().setSp(18))),
                                ],
                              ),
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      )
                    ],
                  ),
                )
              : Container(
                  height: ScreenUtil().setHeight(300),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image: AssetImage("assets/images/room_tc3.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(15, 0),
                      WidgetUtils.onlyTextCenter(
                          '功能',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(32))),
                      WidgetUtils.commonSizedBox(40, 0),

                      /// 展示的功能
                      /// 第二排
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                setState(() {
                                  roomDX = !roomDX;
                                });
                                if (roomDX) {
                                  MyToastUtils.showToastBottom('动效已开启');
                                  eventBus
                                      .fire(SubmitButtonBack(title: '动效已开启'));
                                } else {
                                  MyToastUtils.showToastBottom('动效已关闭');
                                  eventBus
                                      .fire(SubmitButtonBack(title: '动效已关闭'));
                                }
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_dongxiao.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                    Container(
                                      height: ScreenUtil().setHeight(25),
                                      width: ScreenUtil().setHeight(70),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomBlue,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: WidgetUtils.onlyTextCenter(
                                          roomDX ? '已开启' : '已关闭',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(18))),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '动效',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                setState(() {
                                  roomSY = !roomSY;
                                });
                                if (roomSY) {
                                  MyToastUtils.showToastBottom('房间声音已开启');
                                  eventBus
                                      .fire(SubmitButtonBack(title: '房间声音已开启'));
                                } else {
                                  MyToastUtils.showToastBottom('房间声音已关闭');
                                  eventBus
                                      .fire(SubmitButtonBack(title: '房间声音已关闭'));
                                }
                              }
                            }),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_shengyin.png',
                                        ScreenUtil().setHeight(80),
                                        ScreenUtil().setHeight(80)),
                                    Container(
                                      height: ScreenUtil().setHeight(25),
                                      width: ScreenUtil().setHeight(70),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomBlue,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: WidgetUtils.onlyTextCenter(
                                          roomSY ? '已开启' : '已关闭',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(18))),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '房间声音',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          Opacity(
                            opacity: 0,
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_shezhi.png',
                                        ScreenUtil().setHeight(100),
                                        ScreenUtil().setHeight(100)),
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '房间设置',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          Opacity(
                            opacity: 0,
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_shouye.png',
                                        ScreenUtil().setHeight(100),
                                        ScreenUtil().setHeight(100)),
                                    Container(
                                      height: ScreenUtil().setHeight(25),
                                      width: ScreenUtil().setHeight(70),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomBlue,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: WidgetUtils.onlyTextCenter(
                                          '已开启',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(18))),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '首页展示',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          Opacity(
                            opacity: 0,
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_shouye.png',
                                        ScreenUtil().setHeight(100),
                                        ScreenUtil().setHeight(100)),
                                    Container(
                                      height: ScreenUtil().setHeight(25),
                                      width: ScreenUtil().setHeight(70),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomBlue,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      child: WidgetUtils.onlyTextCenter(
                                          '已开启',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(18))),
                                    )
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(5, 0),
                                WidgetUtils.onlyTextCenter(
                                    '首页展示',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(18))),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }

  /// 首页展示
  Future<void> doPostSetShow() async {
    setState(() {
      if (is_show == 1) {
        is_show = 0;
      } else {
        is_show = 1;
      }
    });
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'is_show': is_show,
    };
    try {
      CommonBean bean = await DataUtils.postSetShow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (is_show == 1) {
              MyToastUtils.showToastBottom('首页展示已开启');
              eventBus.fire(SubmitButtonBack(title: '首页展示已开启'));
            } else {
              MyToastUtils.showToastBottom('首页展示已关闭');
              eventBus.fire(SubmitButtonBack(title: '首页展示已关闭'));
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 清除魅力值
  Future<void> doPostCleanCharm() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postCleanCharm(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('魅力值已清除');
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 清除公屏信息
  Future<void> doPostCleanPublicScreen() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postCleanPublicScreen(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('公屏信息已清空');
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 老板位
  Future<void> doPostSetBoss() async {
    String status = '';
    setState(() {
      if (is_boss == 1) {
        is_boss = 0;
        status = 'no';
      } else {
        is_boss = 1;
        status = 'yes';
      }
    });
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'status': status,
    };
    try {
      CommonBean bean = await DataUtils.postSetBoss(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (is_boss == 1) {
              MyToastUtils.showToastBottom('老板位已开启');
            } else {
              MyToastUtils.showToastBottom('老板位已关闭');
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 离线模式
  Future<void> doPostSetLockMic() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'lock_mic': lixian == 0 ? "1" : "0",
    };
    try {
      CommonBean bean = await DataUtils.postSetLockMic(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (lixian == 0) {
              MyToastUtils.showToastBottom('离线模式已开启，关闭APP将不会掉麦');
            } else {
              MyToastUtils.showToastBottom('离线模式已关闭');
            }
            eventBus.fire(SubmitButtonBack(title: '离线模式'));
            Navigator.pop(context);
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
