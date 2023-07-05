import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/config/config_screen_util.dart';
import 'package:yuyinting/pages/home/paidui_page.dart';
import 'package:yuyinting/pages/home/shoucang_page.dart';
import 'package:yuyinting/pages/home/tuijian_page.dart';
import 'package:yuyinting/pages/home/youxi_page.dart';
import 'package:yuyinting/pages/home/zaixian_page.dart';
import 'package:yuyinting/pages/login/edit_info_page.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../widget/customrefreshfooter.dart';
import '../../widget/customrefreshheader.dart';

///首页
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final PageController _controller;

  bool isFirst = true;

  // 是否开始拖拽
  bool isDragNow = false;

  // 是否将要删除
  bool isRemove = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
    // if(isFirst){
    //   Future.delayed(const Duration(seconds: 0), (){
    //     Navigator.of(context).push(PageRouteBuilder(
    //         opaque: false,
    //         pageBuilder: (context, animation, secondaryAnimation) {
    //           return const EditInfoPage();
    //         }));
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.homeTopBG,
        body: Stack(
          children: [
            Column(
              children: [
                ///头部
                Container(
                  color: MyColors.homeTopBG,
                  height: ScreenUtil().setHeight(140),
                  width: double.infinity,
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(35, 0),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(67),
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _currentIndex = 0;
                                  _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                });
                              }),
                              child: WidgetUtils.onlyTextBottom(
                                  '收藏',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: _currentIndex == 0
                                          ? ScreenUtil().setSp(38)
                                          : ScreenUtil().setSp(32),
                                      fontWeight: _currentIndex == 4 ? FontWeight.bold : FontWeight.normal)),
                            ),
                            const Expanded(flex: 1, child: Text('')),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _currentIndex = 1;
                                  _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                });
                              }),
                              child: WidgetUtils.onlyTextBottom(
                                  '推荐',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: _currentIndex == 1
                                          ? ScreenUtil().setSp(38)
                                          : ScreenUtil().setSp(32),
                                      fontWeight: _currentIndex == 4 ? FontWeight.bold : FontWeight.normal)),
                            ),
                            const Expanded(flex: 1, child: Text('')),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _currentIndex = 2;
                                  _controller.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                });
                              }),
                              child: WidgetUtils.onlyTextBottom(
                                  '派对',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: _currentIndex == 2
                                          ? ScreenUtil().setSp(38)
                                          : ScreenUtil().setSp(32),
                                      fontWeight: _currentIndex == 4 ? FontWeight.bold : FontWeight.normal)),
                            ),
                            const Expanded(flex: 1, child: Text('')),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _currentIndex = 3;
                                  _controller.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                });
                              }),
                              child: Container(
                                width: ScreenUtil().setHeight(111),
                                height: ScreenUtil().setHeight(38),
                                alignment: Alignment.bottomCenter,
                                child: _currentIndex == 3
                                    ? WidgetUtils.showImages(
                                        'assets/images/home_yx2.png',
                                        ScreenUtil().setHeight(40),
                                        ScreenUtil().setHeight(80))
                                    : WidgetUtils.showImagesFill(
                                        'assets/images/home_yx1.png',
                                        ScreenUtil().setHeight(28),
                                        ScreenUtil().setHeight(65)),
                              ),
                            ),
                            const Expanded(flex: 1, child: Text('')),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _currentIndex = 4;
                                  _controller.animateToPage(4, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                });
                              }),
                              child: WidgetUtils.onlyTextBottom(
                                  '在线',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: _currentIndex == 4
                                          ? ScreenUtil().setSp(38)
                                          : ScreenUtil().setSp(32),
                                  fontWeight: _currentIndex == 4 ? FontWeight.bold : FontWeight.normal)),
                            ),
                            const Expanded(flex: 2, child: Text('')),
                            GestureDetector(
                              onTap: (() {
                                Navigator.pushNamed(context, 'RankingPage');
                              }),
                              child: WidgetUtils.showImages(
                                  "assets/images/b7y.png", 26, 30),
                            ),
                            WidgetUtils.commonSizedBox(0, 20),
                          ],
                        ),
                      ),
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
                      ShoucangPage(),
                      TuijianPage(),
                      PaiduiPage(),
                      YouxiPage(),
                      ZaixianPage(),
                    ],
                  ),
                )
              ],
            ),
            /// 房间图标转动
            Positioned(
              bottom: 200,
              right: 20,
              child: Draggable(
                  //当拖动对象开始被拖动时调用
                  onDragStarted: () {
                    setState(() {
                      isDragNow = true;
                    });
                  },
                  //当拖动对象被放下时调用
                  onDragEnd: (va) {
                    setState(() {
                      isDragNow = false;
                    });
                  },
                  //当draggable 被放置并被【DragTarget】 接受时调用
                  onDragCompleted: (){

                  },
                  //当draggable 被放置但未被【DragTarget】 接受时调用
                  onDraggableCanceled: (velocity, offset){

                  },

                  //拖动显示
                  feedback: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(3)),
                    child: WidgetUtils.CircleHeadImage(
                        ScreenUtil().setHeight(100),
                        ScreenUtil().setHeight(100),
                        'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg'),
                  ),
                  //拖动占位
                  childWhenDragging: Opacity(
                    opacity: 0,
                    child: WidgetUtils.CircleHeadImage(
                        ScreenUtil().setHeight(100),
                        ScreenUtil().setHeight(100),
                        'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg'),
                  ),
                  child: WidgetUtils.CircleHeadImage(
                      ScreenUtil().setHeight(100),
                      ScreenUtil().setHeight(100),
                      'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg')),
            ),
            // /// 删除栏
            // Container(
            //   height: ScreenUtil().setHeight(200),
            //   width: double.infinity,
            //   color: Colors.red[200],
            // ),
          ],
        ));
  }
}
