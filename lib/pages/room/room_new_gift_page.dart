import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/gift_all_page.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import 'gift_page.dart';
/// 记录新的礼物展示
class RoomNewGiftPage extends StatefulWidget {
  String roomID;
  RoomNewGiftPage({super.key, required this.roomID});

  @override
  State<RoomNewGiftPage> createState() => _RoomNewGiftPageState();
}

class _RoomNewGiftPageState extends State<RoomNewGiftPage> {
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
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(
            height: 400.h,
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
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage('assets/images/room_tc1.png'),
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
                                // _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                _controller.jumpToPage(0);
                              });
                            }),
                            child: Opacity(
                              opacity: _currentIndex == 0 ? 1 : 0.5,
                              child: WidgetUtils.onlyTextCenter(
                                  '全部礼物',
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
                                _controller.jumpToPage(1);
                              });
                            }),
                            child: Opacity(
                              opacity: _currentIndex == 1 ? 1 : 0.5,
                              child: WidgetUtils.onlyTextCenter(
                                  '超过100金豆礼物',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(32))),
                            ),
                          )),
                      WidgetUtils.commonSizedBox(0, 20),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10.h, 0),
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      // 禁止左右滑动，只能点击
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          // 更新当前的索引值
                          _currentIndex = index;
                        });
                      },
                      children: [
                        GiftAllPage(roomID: widget.roomID,),
                        GiftPage(roomID: widget.roomID,),
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
