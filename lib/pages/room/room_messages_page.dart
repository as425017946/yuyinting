import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/room_messages_more_page.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 厅内消息列表
class RoomMessagesPage extends StatefulWidget {
  const RoomMessagesPage({super.key});

  @override
  State<RoomMessagesPage> createState() => _RoomMessagesPageState();
}

class _RoomMessagesPageState extends State<RoomMessagesPage> {


  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            Future.delayed(const Duration(seconds: 0), () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const RoomMessagesMorePage();
                  }));
            });
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: [
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(90),
                    ScreenUtil().setHeight(90),
                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                '用户名$i',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(28))),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages('assets/images/room_nan.png', ScreenUtil().setHeight(31), ScreenUtil().setHeight(29)),
                            const Expanded(child: Text('')),
                            WidgetUtils.onlyText(
                                '13:54:14',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ3,
                                    fontSize: ScreenUtil().setSp(25)))
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      WidgetUtils.onlyText(
                          '消息内容展示',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ3,
                              fontSize: ScreenUtil().setSp(25))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        WidgetUtils.commonSizedBox(20, 0),
      ],
    );
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
            height: ScreenUtil().setHeight(856),
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
                    '消息列表',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(32))),
                /// 展示在线用户
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(10)),
                    itemBuilder: _itemTuiJian,
                    itemCount: 10,
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
