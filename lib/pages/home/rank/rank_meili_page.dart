import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/widget_utils.dart';
import 'meili_day_page.dart';
import 'meili_month_page.dart';
import 'meili_week_page.dart';
/// 魅力榜
class RankMeiLiPage extends StatefulWidget {
  const RankMeiLiPage({super.key});

  @override
  State<RankMeiLiPage> createState() => _RankMeiLiPageState();
}

class _RankMeiLiPageState extends State<RankMeiLiPage> {
  int _currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(
      initialPage: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 日榜 周榜 月榜
        Container(
          alignment: Alignment.center,
          height: ScreenUtil().setHeight(60),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (() {
                  setState(() {
                    _currentIndex = 0;
                    _controller.jumpToPage(0);
                  });
                }),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(60),
                    ScreenUtil().setWidth(160),
                    _currentIndex == 0 ? MyColors.riBangBg : MyColors.zhouBangBg,
                    _currentIndex == 0 ? MyColors.riBangBg : MyColors.zhouBangBg,
                    '日榜',
                    ScreenUtil().setSp(30),
                    Colors.white),
              ),
              WidgetUtils.commonSizedBox(0, 15),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    _currentIndex = 1;
                    _controller.jumpToPage(1);
                  });
                }),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(60),
                    ScreenUtil().setWidth(160),
                    _currentIndex == 1
                        ? MyColors.riBangBg
                        : MyColors.zhouBangBg,
                    _currentIndex == 1 ? MyColors.riBangBg : MyColors.zhouBangBg,
                    '周榜',
                    ScreenUtil().setSp(30),
                    Colors.white),
              ),
              WidgetUtils.commonSizedBox(0, 15),
              GestureDetector(
                onTap: (() {
                  setState(() {
                    _currentIndex = 2;
                    _controller.jumpToPage(2);
                  });
                }),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(60),
                    ScreenUtil().setWidth(160),
                    _currentIndex == 2 ? MyColors.riBangBg : MyColors.zhouBangBg,
                    _currentIndex == 2 ? MyColors.riBangBg : MyColors.zhouBangBg,
                    '月榜',
                    ScreenUtil().setSp(30),
                    Colors.white),
              ),
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(30.h, 0),
        Expanded(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                // 更新当前的索引值
                _currentIndex = index;
              });
            },
            children: [
              MeiLiDayPage(category: 'charm',),
              MeiLiWeekPage(category: 'charm',),
              MeiLiMonthPage(category: 'charm',)
            ],
          ),
        )
      ],
    );
  }
}
