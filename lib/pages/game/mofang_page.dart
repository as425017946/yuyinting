import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'mofang_jin_page.dart';
import 'mofang_lan_page.dart';

/// 魔方模块
class MoFangPage extends StatefulWidget {
  const MoFangPage({super.key});

  @override
  State<MoFangPage> createState() => _MoFangPageState();
}

class _MoFangPageState extends State<MoFangPage> with TickerProviderStateMixin {
  bool page = false;

  int _currentIndex = 0;
  late final PageController _controller;

  var listen;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );

    listen = eventBus.on<MofangBack>().listen((event) {
      LogE('魔方${event.info}');
        setState(() {
          _currentIndex = event.info;
          _controller.jumpToPage(_currentIndex);
        });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            Container(
              height: ScreenUtil().setHeight(900),
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    // 更新当前的索引值
                    _currentIndex = index;
                  });
                },
                children: const [
                  MofangLanPage(),
                  MofangJinPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
