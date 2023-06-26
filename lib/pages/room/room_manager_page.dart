import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/room_bg_page.dart';
import 'package:yuyinting/pages/room/room_black_page.dart';
import 'package:yuyinting/pages/room/room_gonggao_page.dart';
import 'package:yuyinting/pages/room/room_guanliyuan_page.dart';
import 'package:yuyinting/pages/room/room_jinyan_page.dart';
import 'package:yuyinting/pages/room/room_password_page.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 房间管理
class RoomManagerPage extends StatefulWidget {
  int type;
  RoomManagerPage({super.key, required this.type});

  @override
  State<RoomManagerPage> createState() => _RoomManagerPageState();
}

class _RoomManagerPageState extends State<RoomManagerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          widget.type == 0 ? Container(
            height: ScreenUtil().setHeight(350),
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
                    '房间管理',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(32))),
                WidgetUtils.commonSizedBox(15, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.CircleImageNet(
                        ScreenUtil().setHeight(122),
                        ScreenUtil().setHeight(122),
                        15,
                        'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 15),
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '房间名称',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(30))),
                          WidgetUtils.commonSizedBox(20, 0),
                          Row(
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/room_id.png',
                                  ScreenUtil().setHeight(26),
                                  ScreenUtil().setHeight(18)),
                              WidgetUtils.commonSizedBox(0, 2),
                              WidgetUtils.onlyText(
                                  '12345678',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25),
                                      fontWeight: FontWeight.bold)),
                              WidgetUtils.commonSizedBox(0, 5),
                              WidgetUtils.showImages(
                                  'assets/images/room_fuzhu.png',
                                  ScreenUtil().setHeight(18),
                                  ScreenUtil().setHeight(18)),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                WidgetUtils.commonSizedBox(15, 0),
                Opacity(
                  opacity: 0.2,
                  child: WidgetUtils.myLine(color: MyColors.g9),
                ),
                Expanded(
                    child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.onlyText(
                        '房间管理员',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCWZ2,
                            fontSize: ScreenUtil().setSp(25))),
                    const Expanded(child: Text('')),
                    WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 2),
                    WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 2),
                    WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 10),
                    Image(
                      image: const AssetImage('assets/images/mine_more.png'),
                      width: ScreenUtil().setHeight(12),
                      height: ScreenUtil().setHeight(20),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                )),
              ],
            ),
          )
              :
          Container(
            height: ScreenUtil().setHeight(917),
            width: double.infinity,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(15, 0),
                WidgetUtils.onlyTextCenter(
                    '房间管理',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(32))),
                WidgetUtils.commonSizedBox(15, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.CircleImageNet(
                        ScreenUtil().setHeight(122),
                        ScreenUtil().setHeight(122),
                        15,
                        'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 15),
                    Expanded(
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '房间名称',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(30))),
                          WidgetUtils.commonSizedBox(20, 0),
                          Row(
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/room_id.png',
                                  ScreenUtil().setHeight(26),
                                  ScreenUtil().setHeight(18)),
                              WidgetUtils.commonSizedBox(0, 2),
                              WidgetUtils.onlyText(
                                  '12345678',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25),
                                      fontWeight: FontWeight.bold)),
                              WidgetUtils.commonSizedBox(0, 5),
                              WidgetUtils.showImages(
                                  'assets/images/room_fuzhu.png',
                                  ScreenUtil().setHeight(18),
                                  ScreenUtil().setHeight(18)),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                WidgetUtils.commonSizedBox(15, 0),
                Opacity(
                  opacity: 0.2,
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return RoomGuanLiYuanPage(type: 1);
                          }));
                    });
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.onlyText(
                            '房间管理员',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                        WidgetUtils.commonSizedBox(0, 2),
                        WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                        WidgetUtils.commonSizedBox(0, 2),
                        WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                        WidgetUtils.commonSizedBox(0, 10),
                        Image(
                          image: const AssetImage('assets/images/mine_more.png'),
                          width: ScreenUtil().setHeight(12),
                          height: ScreenUtil().setHeight(20),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    Navigator.pop(context);
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const RoomGongGaoPage();
                          }));
                    });
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.onlyText(
                            '房间公告',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        Image(
                          image: const AssetImage('assets/images/mine_more.png'),
                          width: ScreenUtil().setHeight(12),
                          height: ScreenUtil().setHeight(20),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.2,
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const RoomBGPage();
                          }));
                    });
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.onlyText(
                            '房间背景',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        Image(
                          image: const AssetImage('assets/images/mine_more.png'),
                          width: ScreenUtil().setHeight(12),
                          height: ScreenUtil().setHeight(20),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.2,
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    Navigator.pop(context);
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return RoomPasswordPage(type: 0,);
                          }));
                    });
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.onlyText(
                            '房间密码',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        Image(
                          image: const AssetImage('assets/images/mine_more.png'),
                          width: ScreenUtil().setHeight(12),
                          height: ScreenUtil().setHeight(20),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.2,
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return RoomBlackPage();
                          }));
                    });
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.onlyText(
                            '房间黑名单',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        Image(
                          image: const AssetImage('assets/images/mine_more.png'),
                          width: ScreenUtil().setHeight(12),
                          height: ScreenUtil().setHeight(20),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    Future.delayed(const Duration(seconds: 0), () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const RoomJinYanPage();
                          }));
                    });
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.onlyText(
                            '禁言列表',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        Image(
                          image: const AssetImage('assets/images/mine_more.png'),
                          width: ScreenUtil().setHeight(12),
                          height: ScreenUtil().setHeight(20),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.2,
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
