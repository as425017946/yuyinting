import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/widget_utils.dart';

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

  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
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
                    padding: const EdgeInsets.all(15),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.roomMaiLiao,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '信息',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.transparent, fontSize: ScreenUtil().setSp(21))),
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
                  padding: const EdgeInsets.all(15),
                  //边框设置
                  decoration: const BoxDecoration(
                    //背景
                    color: Colors.transparent,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(Radius.circular(17)),
                  ),
                  child: Row(
                    children: [
                      WidgetUtils.onlyText(
                          '信息',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white, fontSize: ScreenUtil().setSp(21))),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),

        WidgetUtils.commonSizedBox(20, 0),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            image: AssetImage("assets/images/room_bg.jpg"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(35, 0),
            Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20),
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(40),
                    ScreenUtil().setHeight(40),
                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
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
                Container(
                  width: ScreenUtil().setHeight(90),
                  height: ScreenUtil().setHeight(30),
                  //边框设置
                  decoration: const BoxDecoration(
                    //背景
                    color: MyColors.roomHot,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
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
                WidgetUtils.commonSizedBox(0, 20),
                WidgetUtils.showImagesFill('assets/images/room_dian.png',
                    ScreenUtil().setHeight(32), ScreenUtil().setHeight(7)),
                WidgetUtils.commonSizedBox(0, 20),
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
                            child: Container(
                              width: ScreenUtil().setHeight(80),
                              height: ScreenUtil().setHeight(30),
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.roomHot,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
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
                                          fontSize: ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
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
                      WidgetUtils.commonSizedBox(0, 20),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(200),
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
                                : WidgetUtils.CircleHeadImage2(
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100),
                                    'assets/images/room_mai.png'),
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
                        height: ScreenUtil().setHeight(200),
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
                                : WidgetUtils.CircleHeadImage2(
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100),
                                    'assets/images/room_mai.png'),
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
                        height: ScreenUtil().setHeight(200),
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
                                : WidgetUtils.CircleHeadImage2(
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100),
                                    'assets/images/room_mai.png'),
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
                        height: ScreenUtil().setHeight(200),
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
                                : WidgetUtils.CircleHeadImage2(
                                    ScreenUtil().setHeight(100),
                                    ScreenUtil().setHeight(100),
                                    'assets/images/room_mai.png'),
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
                      WidgetUtils.commonSizedBox(0, 20),
                    ],
                  ),

                  /// 第二排麦序
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        SizedBox(
                          width: ScreenUtil().setHeight(140),
                          height: ScreenUtil().setHeight(200),
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
                                  : WidgetUtils.CircleHeadImage2(
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100),
                                      'assets/images/room_mai.png'),
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
                          height: ScreenUtil().setHeight(200),
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
                                  : WidgetUtils.CircleHeadImage2(
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100),
                                      'assets/images/room_mai.png'),
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
                          height: ScreenUtil().setHeight(200),
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
                                  : WidgetUtils.CircleHeadImage2(
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100),
                                      'assets/images/room_mai.png'),
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
                                      : WidgetUtils.commonSizedBox(0, 0),
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
                        SizedBox(
                          width: ScreenUtil().setHeight(140),
                          height: ScreenUtil().setHeight(200),
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
                                  : WidgetUtils.CircleHeadImage2(
                                      ScreenUtil().setHeight(100),
                                      ScreenUtil().setHeight(100),
                                      'assets/images/room_mai.png'),
                              Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  m8 == false
                                      ? WidgetUtils.onlyTextCenter(
                                          '8号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m8 == false
                                      ? WidgetUtils.commonSizedBox(10, 0)
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m8 == true
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
                                  m8 == true
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
                        WidgetUtils.commonSizedBox(0, 20),
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
                    child: WidgetUtils.showImages('assets/images/room_hudong.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(150)),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 15,
                    child: WidgetUtils.showImages('assets/images/room_hudong.png', ScreenUtil().setHeight(63), ScreenUtil().setHeight(112)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(80),
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.showImagesFill('assets/images/room_message.png',
                      ScreenUtil().setHeight(60), ScreenUtil().setHeight(200)),
                  const Expanded(child: Text('')),
                  WidgetUtils.showImages('assets/images/room_message.png',
                      ScreenUtil().setHeight(60), ScreenUtil().setHeight(60)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.showImages('assets/images/room_message.png',
                      ScreenUtil().setHeight(60), ScreenUtil().setHeight(67)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.showImages('assets/images/room_message.png',
                      ScreenUtil().setHeight(60), ScreenUtil().setHeight(60)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.showImages('assets/images/room_gongneng.png',
                      ScreenUtil().setHeight(60), ScreenUtil().setHeight(60)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.showImagesFill('assets/images/room_message.png',
                      ScreenUtil().setHeight(60), ScreenUtil().setHeight(80)),
                  WidgetUtils.commonSizedBox(0, 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
