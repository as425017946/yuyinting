import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/daili/baobiao_page.dart';
import 'package:yuyinting/pages/mine/daili/tuiguang_page.dart';
import 'package:yuyinting/pages/mine/daili/zonglan_page.dart';
import '../../../colors/my_colors.dart';
import '../../../utils/widget_utils.dart';

/// 邀请有礼
class DailiHomePage extends StatefulWidget {
  const DailiHomePage({Key? key}) : super(key: key);

  @override
  State<DailiHomePage> createState() => _DailiHomePageState();
}

class _DailiHomePageState extends State<DailiHomePage> {
  var appBar;
  late int _currentIndex;
  late final PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('邀请有礼', true, context, false, 0);

    _currentIndex = 0;
    _controller = PageController(
      initialPage: _currentIndex,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _btn(double width, int index) {
    final bool isSelect = index == _currentIndex;
    return GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _controller.jumpToPage(index);
          });
        },
        child: Container(
          width: width,
          height: 153,
          color: Colors.transparent,
        ),
      );
  }

  Widget _topBg(String img, int index) {
    return Opacity(
      opacity: index == _currentIndex ? 1 : 0,
      child: Image.asset(
        'assets/images/mine_yq_top_$img.png',
        width: 997,
        height: 153,
      ),
    );
  }

  Widget _top() {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Stack(
          children: [
            _topBg('zl', 0),
            _topBg('tg', 1),
            _topBg('bb', 2),
            Row(
              children: [
                _btn(327, 0),
                _btn(336, 1),
                _btn(334, 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: const Color(0xFFF6F3FF),
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      body: Column(
        children: [
          _top(),
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
                ZonglanPage(),
                TuiguangPage(),
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
