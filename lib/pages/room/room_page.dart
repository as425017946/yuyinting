import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/room/room_back_page.dart';
import 'package:yuyinting/pages/room/room_gongneng.dart';
import 'package:yuyinting/pages/room/room_liwu_page.dart';
import 'package:yuyinting/pages/room/room_manager_page.dart';
import 'package:yuyinting/pages/room/room_messages_page.dart';
import 'package:yuyinting/pages/room/room_people_info_page.dart';
import 'package:yuyinting/pages/room/room_redu_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../utils/log_util.dart';
import '../../utils/style_utils.dart';

/// 厅内
class RoomPage extends StatefulWidget {
  int type;

  RoomPage({Key? key, required this.type}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool m1 = false,
      m2 = false,
      m3 = false,
      m4 = false,
      m5 = false,
      m6 = false,
      m7 = false,
      m8 = false;
  bool isBoss = true;
  var listen;

  Widget _itemTuiJian(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        Future.delayed(const Duration(seconds: 0), () {
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return const RoomPeopleInfoPage();
              }));
        });
      }),
      child: Column(
        children: [
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.onlyText(
                  '昵称',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(24)))
            ],
          ),
          WidgetUtils.commonSizedBox(5, 0),
          Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.roomMaiLiao,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            topRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24)),
                      ),
                      child: Row(
                        children: [
                          WidgetUtils.onlyText(
                              '信息',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.transparent,
                                  fontSize: ScreenUtil().setSp(21))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.transparent,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '信息',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(21))),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          WidgetUtils.commonSizedBox(20, 0),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '清除公屏') {
      } else if (event.title == '清除魅力') {
      } else if (event.title == '老板位') {
        setState(() {
          isBoss = !isBoss;
        });
      } else if (event.title == '动效') {
      } else if (event.title == '房间声音') {

      } else if (event.title == '退出房间') {
        Navigator.pop(context);
      } else if (event.title == '收起房间') {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/room_bg.webp"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(35, 0),
            Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20),
                GestureDetector(
                  onTap: (() {
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return RoomManagerPage(type: 1);
                          }));
                    });
                  }),
                  child: WidgetUtils.CircleHeadImage(
                      ScreenUtil().setHeight(40),
                      ScreenUtil().setHeight(40),
                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                ),
                WidgetUtils.commonSizedBox(0, 5),
                Column(
                  children: [
                    SizedBox(
                      width: ScreenUtil().setHeight(120),
                      child: WidgetUtils.onlyText(
                          '房间名称',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(25),
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: ScreenUtil().setHeight(120),
                      child: WidgetUtils.onlyText(
                          'ID 298113',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomID,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  ],
                ),
                SizedBox(
                  width: ScreenUtil().setHeight(80),
                  height: ScreenUtil().setHeight(40),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.showImagesFill(
                          'assets/images/room_shoucang.png',
                          double.infinity,
                          double.infinity),
                      WidgetUtils.onlyTextCenter(
                          '收藏',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomID,
                              fontSize: ScreenUtil().setSp(21)))
                    ],
                  ),
                ),
                const Expanded(child: Text('')),

                /// 热度
                Stack(
                  children: [
                    Opacity(
                        opacity: 0.6,
                        child: Container(
                          width: ScreenUtil().setHeight(90),
                          height: ScreenUtil().setHeight(30),
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: MyColors.roomHot,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        )),
                    GestureDetector(
                      onTap: (() {
                        LogE('热度点击');
                        Future.delayed(const Duration(seconds: 0), () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return const RoomReDuPage();
                              }));
                        });
                      }),
                      child: SizedBox(
                        width: ScreenUtil().setHeight(90),
                        height: ScreenUtil().setHeight(30),
                        child: Row(
                          children: [
                            const Expanded(child: Text('')),
                            WidgetUtils.showImagesFill(
                                'assets/images/room_hot.png',
                                ScreenUtil().setHeight(18),
                                ScreenUtil().setHeight(15)),
                            WidgetUtils.commonSizedBox(0, 2),
                            WidgetUtils.onlyTextCenter(
                                '1800',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomID,
                                    fontSize: ScreenUtil().setSp(18))),
                            const Expanded(child: Text('')),
                          ],
                        ),
                      ),
                    )
                  ],
                ),


                /// 退出的点
                GestureDetector(
                  onTap: (() {
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const RoomBackPage();
                          }));
                    });
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(32),
                    width: ScreenUtil().setHeight(79),
                    child: WidgetUtils.showImages(
                        'assets/images/room_dian.png',
                        ScreenUtil().setHeight(32),
                        ScreenUtil().setHeight(7))
                  ),
                ),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 0),

            /// 公告 和 厅主
            Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                    child: Row(
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(240),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (() {}),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: 0.6,
                                  child: Container(
                                    width: ScreenUtil().setHeight(80),
                                    height: ScreenUtil().setHeight(30),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.roomMaiLiao2,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setHeight(80),
                                  height: ScreenUtil().setHeight(30),
                                  child: Row(
                                    children: [
                                      const Expanded(child: Text('')),
                                      WidgetUtils.showImagesFill(
                                          'assets/images/room_gonggao.png',
                                          ScreenUtil().setHeight(30),
                                          ScreenUtil().setHeight(30)),
                                      WidgetUtils.onlyTextCenter(
                                          '公告',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomID,
                                              fontSize:
                                                  ScreenUtil().setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                )),

                /// 厅主
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: SizedBox(
                    width: ScreenUtil().setHeight(180),
                    height: ScreenUtil().setHeight(240),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const SVGASimpleImage(
                            assetsName: 'assets/svga/wave_normal.svga'),
                        WidgetUtils.CircleHeadImage(
                            ScreenUtil().setHeight(120),
                            ScreenUtil().setHeight(120),
                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                        Column(
                          children: [
                            const Expanded(child: Text('')),
                            Row(
                              children: [
                                const Expanded(child: Text('')),
                                WidgetUtils.showImages(
                                    'assets/images/room_tingzhu.png',
                                    ScreenUtil().setHeight(27),
                                    ScreenUtil().setHeight(25)),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    '名称',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(child: Text('')),
                                WidgetUtils.showImages(
                                    'assets/images/room_xin.png',
                                    ScreenUtil().setHeight(17),
                                    ScreenUtil().setHeight(15)),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    '100',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Column(
                children: [
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 10),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(220),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m1 == true
                                ? const SVGASimpleImage(
                                    assetsName: 'assets/svga/wave_normal.svga')
                                : const Text(''),
                            m1 == true
                                ? WidgetUtils.CircleHeadImage(
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100),
                                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                : WidgetUtils.showImages(
                                    'assets/images/room_mai.png',
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100)),
                            Column(
                              children: [
                                const Expanded(child: Text('')),
                                m1 == false
                                    ? WidgetUtils.onlyTextCenter(
                                        '1号麦',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomMaiWZ,
                                            fontSize: ScreenUtil().setSp(19)))
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m1 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m1 == true
                                    ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil().setHeight(27),
                                              ScreenUtil().setHeight(25)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m1 == true
                                    ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil().setHeight(17),
                                              ScreenUtil().setHeight(15)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '100',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(220),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m2 == true
                                ? const SVGASimpleImage(
                                    assetsName: 'assets/svga/wave_normal.svga')
                                : const Text(''),
                            m2 == true
                                ? WidgetUtils.CircleHeadImage(
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100),
                                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                : WidgetUtils.showImages(
                                    'assets/images/room_mai.png',
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100)),
                            Column(
                              children: [
                                const Expanded(child: Text('')),
                                m2 == false
                                    ? WidgetUtils.onlyTextCenter(
                                        '2号麦',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomMaiWZ,
                                            fontSize: ScreenUtil().setSp(19)))
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m2 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m2 == true
                                    ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil().setHeight(27),
                                              ScreenUtil().setHeight(25)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m2 == true
                                    ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil().setHeight(17),
                                              ScreenUtil().setHeight(15)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '100',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(220),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m3 == true
                                ? const SVGASimpleImage(
                                    assetsName: 'assets/svga/wave_normal.svga')
                                : const Text(''),
                            m3 == true
                                ? WidgetUtils.CircleHeadImage(
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100),
                                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                : WidgetUtils.showImages(
                                    'assets/images/room_mai.png',
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100)),
                            Column(
                              children: [
                                const Expanded(child: Text('')),
                                m3 == false
                                    ? WidgetUtils.onlyTextCenter(
                                        '3号麦',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomMaiWZ,
                                            fontSize: ScreenUtil().setSp(19)))
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m3 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m3 == true
                                    ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil().setHeight(27),
                                              ScreenUtil().setHeight(25)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m3 == true
                                    ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil().setHeight(17),
                                              ScreenUtil().setHeight(15)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '100',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(220),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m4 == true
                                ? const SVGASimpleImage(
                                    assetsName: 'assets/svga/wave_normal.svga')
                                : const Text(''),
                            m4 == true
                                ? WidgetUtils.CircleHeadImage(
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100),
                                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                : WidgetUtils.showImages(
                                    'assets/images/room_mai.png',
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100)),
                            Column(
                              children: [
                                const Expanded(child: Text('')),
                                m4 == false
                                    ? WidgetUtils.onlyTextCenter(
                                        '4号麦',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomMaiWZ,
                                            fontSize: ScreenUtil().setSp(19)))
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m4 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m4 == true
                                    ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil().setHeight(27),
                                              ScreenUtil().setHeight(25)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m4 == true
                                    ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil().setHeight(17),
                                              ScreenUtil().setHeight(15)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '100',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            )
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                    ],
                  ),

                  /// 第二排麦序
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 10),
                        SizedBox(
                          width: ScreenUtil().setHeight(140),
                          height: ScreenUtil().setHeight(220),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              m5 == true
                                  ? const SVGASimpleImage(
                                      assetsName:
                                          'assets/svga/wave_normal.svga')
                                  : const Text(''),
                              m5 == true
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                  : WidgetUtils.showImages(
                                      'assets/images/room_mai.png',
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100)),
                              Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  m5 == false
                                      ? WidgetUtils.onlyTextCenter(
                                          '5号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m5 == false
                                      ? WidgetUtils.commonSizedBox(10, 0)
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m5 == true
                                      ? Row(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.showImages(
                                                'assets/images/room_fangguan.png',
                                                ScreenUtil().setHeight(27),
                                                ScreenUtil().setHeight(25)),
                                            WidgetUtils.commonSizedBox(0, 5),
                                            WidgetUtils.onlyText(
                                                '名称',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setSp(21))),
                                            const Expanded(child: Text('')),
                                          ],
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m5 == true
                                      ? Row(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.showImages(
                                                'assets/images/room_xin.png',
                                                ScreenUtil().setHeight(17),
                                                ScreenUtil().setHeight(15)),
                                            WidgetUtils.commonSizedBox(0, 5),
                                            WidgetUtils.onlyText(
                                                '100',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setSp(21))),
                                            const Expanded(child: Text('')),
                                          ],
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Expanded(child: Text('')),
                        SizedBox(
                          width: ScreenUtil().setHeight(140),
                          height: ScreenUtil().setHeight(220),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              m6 == true
                                  ? const SVGASimpleImage(
                                      assetsName:
                                          'assets/svga/wave_normal.svga')
                                  : const Text(''),
                              m6 == true
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                  : WidgetUtils.showImages(
                                      'assets/images/room_mai.png',
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100)),
                              Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  m6 == false
                                      ? WidgetUtils.onlyTextCenter(
                                          '6号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m6 == false
                                      ? WidgetUtils.commonSizedBox(10, 0)
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m6 == true
                                      ? Row(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.showImages(
                                                'assets/images/room_fangguan.png',
                                                ScreenUtil().setHeight(27),
                                                ScreenUtil().setHeight(25)),
                                            WidgetUtils.commonSizedBox(0, 5),
                                            WidgetUtils.onlyText(
                                                '名称',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setSp(21))),
                                            const Expanded(child: Text('')),
                                          ],
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m6 == true
                                      ? Row(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.showImages(
                                                'assets/images/room_xin.png',
                                                ScreenUtil().setHeight(17),
                                                ScreenUtil().setHeight(15)),
                                            WidgetUtils.commonSizedBox(0, 5),
                                            WidgetUtils.onlyText(
                                                '100',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setSp(21))),
                                            const Expanded(child: Text('')),
                                          ],
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Expanded(child: Text('')),
                        SizedBox(
                          width: ScreenUtil().setHeight(140),
                          height: ScreenUtil().setHeight(220),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              m7 == true
                                  ? const SVGASimpleImage(
                                      assetsName:
                                          'assets/svga/wave_normal.svga')
                                  : const Text(''),
                              m7 == true
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                  : WidgetUtils.showImages(
                                      'assets/images/room_mai.png',
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100)),
                              Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  m7 == false
                                      ? WidgetUtils.onlyTextCenter(
                                          '7号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m7 == false
                                      ? WidgetUtils.commonSizedBox(10, 0)
                                      : WidgetUtils.commonSizedBox(10, 0),
                                  m7 == true
                                      ? Row(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.showImages(
                                                'assets/images/room_fangguan.png',
                                                ScreenUtil().setHeight(27),
                                                ScreenUtil().setHeight(25)),
                                            WidgetUtils.commonSizedBox(0, 5),
                                            WidgetUtils.onlyText(
                                                '名称',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setSp(21))),
                                            const Expanded(child: Text('')),
                                          ],
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m7 == true
                                      ? Row(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.showImages(
                                                'assets/images/room_xin.png',
                                                ScreenUtil().setHeight(17),
                                                ScreenUtil().setHeight(15)),
                                            WidgetUtils.commonSizedBox(0, 5),
                                            WidgetUtils.onlyText(
                                                '100',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setSp(21))),
                                            const Expanded(child: Text('')),
                                          ],
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Expanded(child: Text('')),
                        isBoss == true
                            ? SizedBox(
                                width: ScreenUtil().setHeight(140),
                                height: ScreenUtil().setHeight(220),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    m8 == true
                                        ? const SVGASimpleImage(
                                            assetsName:
                                                'assets/svga/wave_normal.svga')
                                        : const Text(''),
                                    m8 == true
                                        ? WidgetUtils.CircleHeadImage(
                                            ScreenUtil().setHeight(100),
                                            ScreenUtil().setHeight(100),
                                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                        : SizedBox(
                                            height: ScreenUtil().setHeight(100),
                                            width: ScreenUtil().setHeight(100),
                                            child: const SVGASimpleImage(
                                                assetsName:
                                                    'assets/svga/laobanwei.svga'),
                                          ),
                                    Column(
                                      children: [
                                        const Expanded(child: Text('')),
                                        m8 == false
                                            ? WidgetUtils.onlyTextCenter(
                                                '老板位',
                                                StyleUtils.getCommonTextStyle(
                                                    color: MyColors.roomMaiWZ,
                                                    fontSize:
                                                        ScreenUtil().setSp(19)))
                                            : WidgetUtils.commonSizedBox(0, 0),
                                        m8 == false
                                            ? WidgetUtils.commonSizedBox(10, 0)
                                            : WidgetUtils.commonSizedBox(0, 0),
                                        m8 == true
                                            ? Row(
                                                children: [
                                                  const Expanded(
                                                      child: Text('')),
                                                  WidgetUtils.showImages(
                                                      'assets/images/room_fangguan.png',
                                                      ScreenUtil()
                                                          .setHeight(27),
                                                      ScreenUtil()
                                                          .setHeight(25)),
                                                  WidgetUtils.commonSizedBox(
                                                      0, 5),
                                                  WidgetUtils.onlyText(
                                                      '名称',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          21))),
                                                  const Expanded(
                                                      child: Text('')),
                                                ],
                                              )
                                            : WidgetUtils.commonSizedBox(0, 0),
                                        m8 == true
                                            ? Row(
                                                children: [
                                                  const Expanded(
                                                      child: Text('')),
                                                  WidgetUtils.showImages(
                                                      'assets/images/room_xin.png',
                                                      ScreenUtil()
                                                          .setHeight(17),
                                                      ScreenUtil()
                                                          .setHeight(15)),
                                                  WidgetUtils.commonSizedBox(
                                                      0, 5),
                                                  WidgetUtils.onlyText(
                                                      '100',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          21))),
                                                  const Expanded(
                                                      child: Text('')),
                                                ],
                                              )
                                            : WidgetUtils.commonSizedBox(0, 0),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                width: ScreenUtil().setHeight(140),
                                height: ScreenUtil().setHeight(220),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    m8 == true
                                        ? const SVGASimpleImage(
                                            assetsName:
                                                'assets/svga/wave_normal.svga')
                                        : const Text(''),
                                    m8 == true
                                        ? WidgetUtils.CircleHeadImage(
                                            ScreenUtil().setHeight(100),
                                            ScreenUtil().setHeight(100),
                                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                        : WidgetUtils.showImages(
                                            'assets/images/room_mai.png',
                                            ScreenUtil().setHeight(100),
                                            ScreenUtil().setHeight(100)),
                                    Column(
                                      children: [
                                        const Expanded(child: Text('')),
                                        m8 == false
                                            ? WidgetUtils.onlyTextCenter(
                                                '8号麦',
                                                StyleUtils.getCommonTextStyle(
                                                    color: MyColors.roomMaiWZ,
                                                    fontSize:
                                                        ScreenUtil().setSp(19)))
                                            : WidgetUtils.commonSizedBox(0, 0),
                                        m8 == false
                                            ? WidgetUtils.commonSizedBox(10, 0)
                                            : WidgetUtils.commonSizedBox(10, 0),
                                        m8 == true
                                            ? Row(
                                                children: [
                                                  const Expanded(
                                                      child: Text('')),
                                                  WidgetUtils.showImages(
                                                      'assets/images/room_fangguan.png',
                                                      ScreenUtil()
                                                          .setHeight(27),
                                                      ScreenUtil()
                                                          .setHeight(25)),
                                                  WidgetUtils.commonSizedBox(
                                                      0, 5),
                                                  WidgetUtils.onlyText(
                                                      '名称',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          21))),
                                                  const Expanded(
                                                      child: Text('')),
                                                ],
                                              )
                                            : WidgetUtils.commonSizedBox(0, 0),
                                        m8 == true
                                            ? Row(
                                                children: [
                                                  const Expanded(
                                                      child: Text('')),
                                                  WidgetUtils.showImages(
                                                      'assets/images/room_xin.png',
                                                      ScreenUtil()
                                                          .setHeight(17),
                                                      ScreenUtil()
                                                          .setHeight(15)),
                                                  WidgetUtils.commonSizedBox(
                                                      0, 5),
                                                  WidgetUtils.onlyText(
                                                      '100',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          21))),
                                                  const Expanded(
                                                      child: Text('')),
                                                ],
                                              )
                                            : WidgetUtils.commonSizedBox(0, 0),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                        WidgetUtils.commonSizedBox(0, 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  /// 消息列表
                  ListView.builder(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    itemBuilder: _itemTuiJian,
                    itemCount: 15,
                  ),
                  Positioned(
                    top: 10,
                    right: 15,
                    child: WidgetUtils.showImages(
                        'assets/images/room_hudong.png',
                        ScreenUtil().setHeight(100),
                        ScreenUtil().setHeight(150)),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 15,
                    child: WidgetUtils.showImages(
                        'assets/images/room_hudong.png',
                        ScreenUtil().setHeight(63),
                        ScreenUtil().setHeight(112)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(90),
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Row(
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(60),
                              width: ScreenUtil().setHeight(150),
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.roomMaiLiao2,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            )
                          ],
                        ),
                      ),
                      WidgetUtils.onlyTextCenter(
                          '聊聊...',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomMaiLiao3,
                              fontSize: ScreenUtil().setSp(21))),
                    ],
                  ),
                  const Expanded(child: Text('')),
                  Stack(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(70),
                        width: ScreenUtil().setHeight(70),
                        child: const SVGASimpleImage(
                            assetsName: 'assets/svga/room_liwu.svga'),
                      ),
                      GestureDetector(
                        onTap: ((){
                          Future.delayed(const Duration(seconds: 0), () {
                            Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const RoomLiWuPage();
                                }));
                          });
                        }),
                        child:Container(
                          height: ScreenUtil().setHeight(70),
                          width: ScreenUtil().setHeight(70),
                          color: Colors.transparent
                        ),
                      )
                    ],
                  ),
                  WidgetUtils.commonSizedBox(0, 5),
                  Stack(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(60),
                        width: ScreenUtil().setHeight(60),
                        child: const SVGASimpleImage(
                            assetsName: 'assets/svga/room_huodong.svga'),
                      ),
                      GestureDetector(
                        onTap: ((){
                          Future.delayed(const Duration(seconds: 0), () {
                            Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const RoomLiWuPage();
                                }));
                          });
                        }),
                        child:Container(
                            height: ScreenUtil().setHeight(60),
                            width: ScreenUtil().setHeight(60),
                            color: Colors.transparent
                        ),
                      )
                    ],
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                  GestureDetector(
                    onTap: (() {
                      Future.delayed(const Duration(seconds: 0), () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const RoomMessagesPage();
                            }));
                      });
                    }),
                    child: WidgetUtils.showImages(
                        'assets/images/room_message.png',
                        ScreenUtil().setHeight(60),
                        ScreenUtil().setHeight(60)),
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                  GestureDetector(
                    onTap: (() {
                      Future.delayed(const Duration(seconds: 0), () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return RoomGongNeng(
                                type: 1,
                              );
                            }));
                      });
                    }),
                    child: WidgetUtils.showImages(
                        'assets/images/room_gongneng.png',
                        ScreenUtil().setHeight(60),
                        ScreenUtil().setHeight(60)),
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Row(
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(60),
                              width: ScreenUtil().setHeight(80),
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.roomMaiLiao2,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            )
                          ],
                        ),
                      ),
                      WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomShangMaiWZ,
                              fontSize: ScreenUtil().setSp(21))),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                ],
              ),
            )
          ],
        ),
      ),


      // body: Container(
      //   height: double.infinity,
      //   child: SVGASimpleImage(
      //     assetsName: 'assets/svga/twin_card_bg1.svga',
      //   ),
      // ),
    );
  }
}
