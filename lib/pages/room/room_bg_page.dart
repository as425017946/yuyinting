import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/room_bg1_page.dart';
import 'package:yuyinting/pages/room/room_bg2_page.dart';
import 'package:yuyinting/pages/room/room_manager_page.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 房间背景
class RoomBGPage extends StatefulWidget {
  const RoomBGPage({super.key});

  @override
  State<RoomBGPage> createState() => _RoomBGPageState();
}

class _RoomBGPageState extends State<RoomBGPage> {
  int _currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
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
            height: ScreenUtil().setHeight(1072),
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
                Row(
                  children: [
                    Container(
                      width: ScreenUtil().setHeight(180),
                    ),
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter(
                        '房间背景',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCWZ2,
                            fontSize: ScreenUtil().setSp(32))),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: Container(
                        width: ScreenUtil().setHeight(180),
                        padding:
                            EdgeInsets.only(right: ScreenUtil().setHeight(40)),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '确定',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ3,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      ),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(20, 0),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            _currentIndex = 0;
                            _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          });
                        }),
                        child: Column(
                          children: [
                            Text(
                              '默认背景',
                              style: StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 0 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3,
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.bold),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            Opacity(
                              opacity: _currentIndex == 0 ? 1 : 0,
                              child: Container(
                                height: ScreenUtil().setHeight(6),
                                width: ScreenUtil().setWidth(26),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomTCWZ2,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 50),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            _currentIndex = 1;
                            _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          });
                        }),
                        child: Column(
                          children: [
                            Text(
                              '我的背景',
                              style: StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 1 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3,
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.bold),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            Opacity(
                              opacity: _currentIndex == 1 ? 1 : 0,
                              child: Container(
                                height: ScreenUtil().setHeight(6),
                                width: ScreenUtil().setWidth(26),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomTCWZ2,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        // 更新当前的索引值
                        _currentIndex = index;
                      });
                    },
                    children: const [
                      RoomBG1Page(),
                      RoomBG2Page(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
