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
      backgroundColor: MyColors.homeTopBG,
        body: Column(
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
                      onTap: ((){
                        setState(() {
                          _currentIndex = 0;
                          _controller.jumpToPage(0);
                        });
                      }),
                      child:  WidgetUtils.onlyTextBottom(
                          '收藏',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: _currentIndex == 0 ? ScreenUtil().setSp(46) : ScreenUtil().setSp(32))),
                    ),
                    const Expanded(flex: 1, child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        setState(() {
                          _currentIndex = 1;
                          _controller.jumpToPage(1);
                        });
                      }),
                      child:  WidgetUtils.onlyTextBottom(
                          '推荐',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: _currentIndex == 1 ? ScreenUtil().setSp(46) : ScreenUtil().setSp(32))),
                    ),
                    const Expanded(flex: 1, child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        setState(() {
                          _currentIndex = 2;
                          _controller.jumpToPage(2);
                        });
                      }),
                      child:  WidgetUtils.onlyTextBottom(
                          '派对',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: _currentIndex == 2? ScreenUtil().setSp(46) : ScreenUtil().setSp(32))),
                    ),
                    const Expanded(flex: 1, child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        setState(() {
                          _currentIndex = 3;
                          _controller.jumpToPage(3);
                        });
                      }),
                      child:  Container(
                        width: ScreenUtil().setHeight(111),
                        height: ScreenUtil().setHeight(44),
                        alignment: Alignment.bottomCenter,
                        child:_currentIndex == 3 ? WidgetUtils.showImages('assets/images/home_yx2.png', ScreenUtil().setHeight(44), ScreenUtil().setHeight(111)) : WidgetUtils.showImagesFill('assets/images/home_yx1.png', ScreenUtil().setHeight(30), ScreenUtil().setHeight(74)),
                      ),
                    ),
                    const Expanded(flex: 1, child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        setState(() {
                          _currentIndex = 4;
                          _controller.jumpToPage(4);
                        });
                      }),
                      child:  WidgetUtils.onlyTextBottom(
                          '在线',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: _currentIndex == 4 ? ScreenUtil().setSp(46) : ScreenUtil().setSp(32))),
                    ),
                    const Expanded(flex: 2, child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        Navigator.pushNamed(context, 'RankingPage');
                      }),
                      child: WidgetUtils.showImages("assets/images/b7y.png", 26, 30),
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
    ));
  }
}
