import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/redu_caifu_page.dart';
import 'package:yuyinting/pages/room/redu_meili_page.dart';
import 'package:yuyinting/pages/room/redu_online_page.dart';
import 'package:yuyinting/pages/room/redu_zaixian_page.dart';
import '../../bean/roomInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../main.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 房间内的热度
class RoomReDuPage extends StatefulWidget {
  String roomID;
  List<MikeList> listm;
  RoomReDuPage({super.key, required this.roomID, required this.listm});

  @override
  State<RoomReDuPage> createState() => _RoomReDuPageState();
}

class _RoomReDuPageState extends State<RoomReDuPage> {
  int _currentIndex = 0;
  late final PageController _controller;
  // 用户身份
  String identity = 'user';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //更新身份
    setState(() {
      identity = sp.getString('user_identity').toString();
    });
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
            height: ScreenUtil().setHeight(400),
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
              decoration: BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage((_currentIndex == 0 || _currentIndex == 3)
                      ? "assets/images/room_tc1.png"
                      : 'assets/images/room_ph_bg.png'),
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
                              '房间在线',
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
                            _controller.jumpToPage(2);
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
                      identity != 'user' ? Expanded(
                          child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                _currentIndex = 3;
                                _controller.jumpToPage(3);
                              });
                            }),
                            child: Opacity(
                              opacity: _currentIndex == 3 ? 1 : 0.5,
                              child: WidgetUtils.onlyTextCenter(
                                  '全服在线',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(32))),
                            ),
                          )) : WidgetUtils.commonSizedBox(0, 0),
                      WidgetUtils.commonSizedBox(0, 20),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(20, 0),
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
                        ReDuZaiXianPage(roomID: widget.roomID,listM:widget.listm),
                        ReDuCaiFuPage(roomID: widget.roomID),
                        ReDuMeiLiPage(roomID: widget.roomID),
                        const ReDuOnLinePage(),
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
