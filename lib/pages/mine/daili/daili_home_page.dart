import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/daili/baobiao_page.dart';
import 'package:yuyinting/pages/mine/daili/kaihui_page.dart';
import 'package:yuyinting/pages/mine/daili/tuiguang_page.dart';
import 'package:yuyinting/pages/mine/daili/zonglan_page.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 全民代理
class DailiHomePage extends StatefulWidget {
  const DailiHomePage({Key? key}) : super(key: key);

  @override
  State<DailiHomePage> createState() => _DailiHomePageState();
}

class _DailiHomePageState extends State<DailiHomePage> {
  var appBar;
  int _currentIndex = 0;
  late final PageController _controller ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('全民代理', true, context, false, 0);

    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      _currentIndex = 0;
                      _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.myContainer(ScreenUtil().setHeight(50), ScreenUtil().setHeight(120), _currentIndex == 0 ? MyColors.homeTopBG : Colors.white, _currentIndex == 0 ? MyColors.homeTopBG : Colors.white, '我的推广', ScreenUtil().setSp(25), _currentIndex == 0 ? Colors.white : Colors.black),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      _currentIndex = 1;
                      _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.myContainer(ScreenUtil().setHeight(50), ScreenUtil().setHeight(120), _currentIndex == 1 ? MyColors.homeTopBG : Colors.white, _currentIndex == 1 ? MyColors.homeTopBG : Colors.white, '团队总览', ScreenUtil().setSp(25), _currentIndex == 1 ? Colors.white : Colors.black),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      _currentIndex = 2;
                      _controller.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.myContainer(ScreenUtil().setHeight(50), ScreenUtil().setHeight(120), _currentIndex == 2 ? MyColors.homeTopBG : Colors.white, _currentIndex == 2 ? MyColors.homeTopBG : Colors.white, '团队报表', ScreenUtil().setSp(25), _currentIndex == 2 ? Colors.white : Colors.black),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      _currentIndex = 3;
                      _controller.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.myContainer(ScreenUtil().setHeight(50), ScreenUtil().setHeight(120), _currentIndex == 3 ? MyColors.homeTopBG : Colors.white, _currentIndex == 3 ? MyColors.homeTopBG : Colors.white, '手工开户', ScreenUtil().setSp(25), _currentIndex == 3 ? Colors.white : Colors.black),
                ),
                const Expanded(child: Text('')),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0,-10),
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    // 更新当前的索引值
                    _currentIndex = index;
                  });
                },
                children: const [
                  TuiguangPage(),
                  ZonglanPage(),
                  BaobiaoPage(),
                  KaihuiPage()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}