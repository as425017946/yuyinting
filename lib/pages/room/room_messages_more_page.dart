import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';

/// 厅内消息详情
class RoomMessagesMorePage extends StatefulWidget {
  const RoomMessagesMorePage({super.key});

  @override
  State<RoomMessagesMorePage> createState() => _RoomMessagesMorePageState();
}

class _RoomMessagesMorePageState extends State<RoomMessagesMorePage> {
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        Column(
          children: [
            WidgetUtils.commonSizedBox(10, 0),
            WidgetUtils.onlyTextCenter(
                '2023年6月21日14:29:56',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.roomTCWZ3,
                    fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.commonSizedBox(10, 0),
            Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20),
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(60),
                    ScreenUtil().setHeight(60),
                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.4,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.roomMessageLiaotian,
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
              ],
            ),
          ],
        ),
        WidgetUtils.commonSizedBox(20, 0),
      ],
    );
  }

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
          Container(
            height: ScreenUtil().setHeight(700),
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
                /// 头部展示
                SizedBox(
                  height: ScreenUtil().setHeight(80),
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 20),
                      WidgetUtils.showImages(
                          'assets/images/room_message_left.png',
                          ScreenUtil().setHeight(22),
                          ScreenUtil().setHeight(13)),
                      WidgetUtils.commonSizedBox(0, 20),
                      WidgetUtils.onlyText(
                          '用户名昵称',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(28))),
                      const Expanded(child: Text('')),
                      Stack(
                        children: [
                          Opacity(
                            opacity: 0.7,
                            child: Container(
                              height: ScreenUtil().setHeight(42),
                              width: ScreenUtil().setWidth(106),
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.roomMessageYellow,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          ),
                          Container(
                            height: ScreenUtil().setHeight(42),
                            width: ScreenUtil().setWidth(106),
                            //边框设置
                            decoration: BoxDecoration(
                              //背景
                              color: Colors.transparent,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30.0)),
                              //设置四周边框
                              border: Border.all(
                                  width: 1, color: MyColors.roomMessageYellow),
                            ),
                            child: WidgetUtils.onlyTextCenter(
                                '关注',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomMessageYellow2,
                                    fontSize: ScreenUtil().setSp(25))),
                          ),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(0, 20),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    color: MyColors.roomMessageBlackBG,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      itemBuilder: _itemTuiJian,
                      itemCount: 1,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
