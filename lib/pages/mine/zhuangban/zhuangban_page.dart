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
import 'hengfu_page.dart';

/// 我的装扮
class ZhuangbanPage extends StatefulWidget {
  const ZhuangbanPage({Key? key}) : super(key: key);

  @override
  State<ZhuangbanPage> createState() => _ZhuangbanPageState();
}

class _ZhuangbanPageState extends State<ZhuangbanPage> with ZhuangbanContent {
  // int _currentIndex = 0;
  // late final PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _currentIndex = 0;
    // _controller = PageController(
    //   initialPage: 0,
    // );
    initContent();

    /// 是不是点击装扮商城
    sp.setString('isShop', '1');
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
                    Transform.translate(
                      offset: Offset(0, 10.h),
                      child: WidgetUtils.onlyTextCenter(
                          '装扮商城',
                          TextStyle(
                              fontSize: 40.sp,
                              color: Colors.white,
                              fontFamily: 'YOUSHEBIAOTIHEI')),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pushNamed(context, 'ShopPage');
                      }),
                      child: Container(
                        width: ScreenUtil().setWidth(150),
                        height: 60.h,
                        color: Colors.transparent,
                        alignment: Alignment.centerRight,
                        child: Transform.translate(
                            offset: Offset(0, 10.h),
                            child: WidgetUtils.showImages(
                                'assets/images/shop_bb.png', 50.h, 140.w)),
                      ),
                    )
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(10, 0),
              content([
                ZhuangbanContentItem(name: '座驾', build: () => const ZuojiaPage()),
                ZhuangbanContentItem(name: '头像框', build: () => const HeadPage()),
                ZhuangbanContentItem(name: '公屏气泡', build: () => const QipaoPage()),
                ZhuangbanContentItem(name: '麦上声波', build: () => const ShengboPage()),
                ZhuangbanContentItem(name: '进厅横幅', build: () => const HengfuPage()),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

mixin ZhuangbanContent<T extends StatefulWidget> on State<T> {
  late int _currentIndex;
  late final PageController _controller;
  void initContent() {
    _currentIndex = 0;
    _controller = PageController(
      initialPage: _currentIndex,
    );
  }

  Widget content(List<ZhuangbanContentItem> list) {
    final List<Widget> topChildren = [];
    final List<Widget> children = [];
    for(int i = 0; i < list.length; i++) {
      final item = list[i];
      children.add(item.build());
      final isSelect = _currentIndex == i;
      topChildren.add(
        SizedBox(
          height: 60.w,
          child: GestureDetector(
            onTap: (() {
              setState(() {
                _currentIndex = i;
                _controller.jumpToPage(i);
              });
            }),
            child: WidgetUtils.myContainerZhuangban(
              isSelect ? MyColors.zhuangbanWZBg : MyColors.zhuangbanBg,
              item.name,
              StyleUtils.getCommonTextStyle(
                color: isSelect ? Colors.white : MyColors.zhuangbanWZ,
                fontSize: 29.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
    return Expanded(
          child:Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.w),
            child: Row(children: topChildren),
          ),
        ),
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: children,
          ),
        ),
      ],
    ));
  }
}

class ZhuangbanContentItem {
  final String name;
  final Widget Function() build;
  ZhuangbanContentItem({required this.name, required this.build});
}