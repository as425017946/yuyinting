import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'mofang_jin_page.dart';
import 'mofang_lan_page.dart';

/// 魔方模块
class MoFangPage extends StatefulWidget {
  String roomID;
  MoFangPage({super.key, required this.roomID});

  @override
  State<MoFangPage> createState() => _MoFangPageState();
}

class _MoFangPageState extends State<MoFangPage> with TickerProviderStateMixin {
  bool page = false;

  int _currentIndex = 0;
  late final PageController _controller;


  var listen,listen2;
  bool isBack = false;

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

    listen2 = eventBus.on<ResidentBack>().listen((event) {
      setState(() {
        isBack = event.isBack;
      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listen2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.roomID == '0' ? Colors.black54 :Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            Container(
              height: ScreenUtil().setHeight(900),
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: PageView(
                reverse: false,
                physics: isBack ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    // 更新当前的索引值
                    _currentIndex = index;
                  });
                },
                children: [
                  MofangLanPage(roomId: widget.roomID,),
                  MofangJinPage(roomId: widget.roomID,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
