import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/mine/liwu/liwu_songchu_page.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../utils/style_utils.dart';
import 'liwu_shoudao_page.dart';
/// 礼物记录
class LiwuPage extends StatefulWidget {
  const LiwuPage({Key? key}) : super(key: key);

  @override
  State<LiwuPage> createState() => _LiwuPageState();
}

class _LiwuPageState extends State<LiwuPage> {
  var appBar;
  int _currentIndex = 0;
  late final PageController _controller ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('礼物', true, context, false, 0);

    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );

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
                Expanded(
                  child: GestureDetector(
                    onTap: ((){
                      setState(() {
                        _currentIndex = 0;
                        _controller.jumpToPage(0);
                      });
                    }),
                    child: Column(
                      children: [
                        Container(
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setHeight(5),
                          color: Colors.white,
                        ),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyTextCenter('收到', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(33), fontWeight: _currentIndex == 0 ? FontWeight.bold : FontWeight.w400)),
                        const Expanded(child: Text('')),
                        Container(
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setHeight(5),
                          color: _currentIndex == 0 ? MyColors.homeTopBG : Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: ((){
                      setState(() {
                        _currentIndex = 1;
                        _controller.jumpToPage(1);
                      });
                    }),
                    child: Column(
                      children: [
                        Container(
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setHeight(5),
                          color: Colors.white,
                        ),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyTextCenter('送出', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(33), fontWeight: _currentIndex == 1 ? FontWeight.bold : FontWeight.w400)),
                        const Expanded(child: Text('')),
                        Container(
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setHeight(5),
                          color: _currentIndex == 1 ? MyColors.homeTopBG : Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0,-5),
            child: WidgetUtils.myLine(),
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
                  LiwuShoudaoPage(),
                  LiwuSongchuPage(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
