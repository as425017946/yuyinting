import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/mine/zhuangban/head_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/qipao_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/shengbo_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/zuojia_page.dart';

import '../../../main.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 我的装扮
class ZhuangbanPage extends StatefulWidget {
  const ZhuangbanPage({Key? key}) : super(key: key);

  @override
  State<ZhuangbanPage> createState() => _ZhuangbanPageState();
}

class _ZhuangbanPageState extends State<ZhuangbanPage> {
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
    /// 是不是点击装扮商城
    sp.setString('isShop', '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.zhuangbanBg,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              WidgetUtils.commonSizedBox(35, 0),

              ///头部信息
              Container(
                padding: const EdgeInsets.only(left: 10, right: 20),
                height: ScreenUtil().setHeight(60),
                width: double.infinity,
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    Container(
                      width: ScreenUtil().setHeight(150),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                        onPressed: (() {
                          Navigator.of(context).pop();
                          MyUtils.hideKeyboard(context);
                        }),
                      ),
                    ),
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter(
                        '装扮商城',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(34),
                            fontWeight: FontWeight.bold)),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pushNamed(context, 'ShopPage');
                      }),
                      child: Container(
                        width: ScreenUtil().setWidth(150),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '背包',
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(25),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(20, 0),
              SizedBox(
                height: ScreenUtil().setHeight(60),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 0;
                          _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        });
                      }),
                      child: WidgetUtils.myContainerZhuangban(
                          _currentIndex == 0
                              ? MyColors.zhuangbanWZBg
                              : MyColors.zhuangbanBg,
                          '座驾',
                          StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 0
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                    ),
                    WidgetUtils.commonSizedBox(0, 10),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 1;
                          _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        });
                      }),
                      child: WidgetUtils.myContainerZhuangban(
                          _currentIndex == 1
                              ? MyColors.zhuangbanWZBg
                              : MyColors.zhuangbanBg,
                          '头像框',
                          StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 1
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                    ),
                    WidgetUtils.commonSizedBox(0, 10),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 2;
                          _controller.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        });
                      }),
                      child: WidgetUtils.myContainerZhuangban(
                          _currentIndex == 2
                              ? MyColors.zhuangbanWZBg
                              : MyColors.zhuangbanBg,
                          '公屏气泡',
                          StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 2
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                    ),
                    WidgetUtils.commonSizedBox(0, 10),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 3;
                          _controller.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        });
                      }),
                      child: WidgetUtils.myContainerZhuangban(
                          _currentIndex == 3
                              ? MyColors.zhuangbanWZBg
                              : MyColors.zhuangbanBg,
                          '麦上声波',
                          StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 3
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(10, 0),
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
                    ZuojiaPage(),
                    HeadPage(),
                    QipaoPage(),
                    ShengboPage()
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(80, 0),
            ],
          ),
          Container(
            height: ScreenUtil().setHeight(110),
            width: double.infinity,
            color: MyColors.zhuangbanBottomBG,
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                    child: Column(
                      children: [
                        const Expanded(child: Text('')),
                        Row(
                          children: [
                            WidgetUtils.onlyText(
                                '1000',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(50))),
                            WidgetUtils.commonSizedBox(0, 10),
                            WidgetUtils.onlyText(
                                '钻/豆',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(25))),
                          ],
                        ),
                        GestureDetector(
                          onTap: ((){
                            Navigator.pushNamed(context, 'DouPayPage');
                          }),
                          child: WidgetUtils.onlyText(
                              '0 钻 | 充值 >',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.zhuangbanWZ,
                                  fontSize: ScreenUtil().setSp(25))),
                        ),
                        WidgetUtils.commonSizedBox(10, 0),
                      ],
                    )),
                GestureDetector(
                  onTap: (() {}),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(70),
                      ScreenUtil().setHeight(200),
                      MyColors.homeTopBG,
                      MyColors.homeTopBG,
                      '立即购买',
                      ScreenUtil().setSp(33),
                      Colors.white),
                ),
                WidgetUtils.commonSizedBox(0, 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
