import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/redu_caifu_page.dart';
import 'package:yuyinting/pages/room/redu_meili_page.dart';
import 'package:yuyinting/pages/room/redu_zaixian_page.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 房间内的热度
class RoomReDuPage extends StatefulWidget {
  const RoomReDuPage({super.key});

  @override
  State<RoomReDuPage> createState() => _RoomReDuPageState();
}

class _RoomReDuPageState extends State<RoomReDuPage> {
  int _currentIndex = 0;
  late final PageController _controller ;
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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(150),
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
          Expanded(
            child: Container(
              height: double.infinity,
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
                  WidgetUtils.commonSizedBox(20, 0),
                  /// 顶部三个按钮
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                          child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                _currentIndex = 0;
                                _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                              });
                            }),
                            child: Opacity(
                              opacity: _currentIndex == 0 ? 1 : 0.5,
                              child: WidgetUtils.onlyTextCenter(
                                  '在线列表',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(32))),
                            ),
                          )),
                      Expanded(
                          child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                _currentIndex = 1;
                                _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                              });
                            }),
                            child: Opacity(
                              opacity: _currentIndex == 1 ? 1 : 0.5,
                              child: WidgetUtils.onlyTextCenter(
                                  '财富榜',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(32))),
                            ),
                          )),
                      Expanded(
                          child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                _currentIndex = 2;
                                _controller.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                              });
                            }),
                            child: Opacity(
                              opacity: _currentIndex == 2 ? 1 : 0.5,
                              child: WidgetUtils.onlyTextCenter(
                                  '魅力榜',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(32))),
                            ),
                          )),
                      WidgetUtils.commonSizedBox(0, 20),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(20, 0),
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
                        ReDuZaiXianPage(),
                        ReDuCaiFuPage(),
                        ReDuMeiLiPage(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
