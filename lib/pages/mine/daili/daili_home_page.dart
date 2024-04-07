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
  late final PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('邀请有礼', true, context, false, 0);

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

  Widget _btn(String text, int index) {
    final bool isSelect = index == _currentIndex;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _controller.jumpToPage(index);
          });
        },
        child: WidgetUtils.myContainer(
          49.w,
          139.w,
          isSelect ? MyColors.homeTopBG : Colors.white,
          isSelect ? MyColors.homeTopBG : Colors.white,
          text,
          25.sp,
          isSelect ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      body: Column(
        children: [
          SizedBox(
            height: 85.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _btn('我的推广', 0),
                _btn('团队总览', 1),
                _btn('团队报表', 2),
              ],
            ),
          ),
          Expanded(
            child:PageView(
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
                  // KaihuiPage()
                ],
              ),
          )
        ],
      ),
    );
  }
}
