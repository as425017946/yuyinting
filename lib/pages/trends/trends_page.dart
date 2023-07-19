import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/trends/trends_guanzhu_page.dart';
import 'package:yuyinting/pages/trends/trends_tuijian_page.dart';

import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

///动态
class TrendsPage extends StatefulWidget {
  const TrendsPage({Key? key}) : super(key: key);

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;
  late final PageController _controller;

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
      backgroundColor: Colors.white,
      body:Column(
        children: [
          WidgetUtils.commonSizedBox(35, 0),
          ///头部信息
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            height: ScreenUtil().setHeight(60),
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            child:Row(
              children: [
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      _currentIndex = 0;
                      _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.onlyTextBottom(
                      '关注',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: _currentIndex == 0
                              ? ScreenUtil().setSp(42)
                              : ScreenUtil().setSp(32),
                          fontWeight: _currentIndex == 0 ? FontWeight.w600 : FontWeight.normal)),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      _currentIndex = 1;
                      _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.onlyTextBottom(
                      '推荐',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: _currentIndex == 1
                              ? ScreenUtil().setSp(42)
                              : ScreenUtil().setSp(32),
                          fontWeight: _currentIndex == 1 ? FontWeight.w600 : FontWeight.normal)),
                ),
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: ((){
                    Navigator.pushNamed(context, 'TrendsSendPage');
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(60),
                    width: ScreenUtil().setWidth(174),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        WidgetUtils.showImages('assets/images/trends_fabu_btn.png', ScreenUtil().setHeight(60), ScreenUtil().setWidth(174)),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages('assets/images/trends_xiangji.webp', 30, 30),
                            WidgetUtils.onlyText('发动态', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.w600)),
                            const Expanded(child: Text('')),

                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              _currentIndex == 0 ? SizedBox(
                width: ScreenUtil().setHeight(68),
                height: ScreenUtil().setHeight(10),
                child: Row(
                  children: [
                    const Expanded(child: Text('')),
                    Container(
                      width: ScreenUtil().setHeight(20),
                      height: ScreenUtil().setHeight(4),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.homeTopBG,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
              ) : WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10), ScreenUtil().setHeight(68)),
              WidgetUtils.commonSizedBox(0, 5),
              _currentIndex == 1 ? SizedBox(
                width: ScreenUtil().setHeight(68),
                height: ScreenUtil().setHeight(10),
                child: Row(
                  children: [
                    const Expanded(child: Text('')),
                    Container(
                      width: ScreenUtil().setHeight(20),
                      height: ScreenUtil().setHeight(4),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.homeTopBG,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
              ) : WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10), ScreenUtil().setHeight(68))
            ],
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
                TrendsGuanZhuPage(),
                TrendsTuiJianPage()
              ],
            ),
          )
        ],
      ),
    );
  }
}

