import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/zhuangban/shengbo_bb_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/zuojia_bd_page.dart';
import '../../../colors/my_colors.dart';
import '../../../main.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import 'head_bb_page.dart';

/// 背包
class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
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
    sp.setString('isShop', '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.zhuangbanBg,
      body: Column(
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
                    '背包',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(34),
                        fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: (() {}),
                  child: Container(
                    width: ScreenUtil().setWidth(150),
                    alignment: Alignment.centerRight,
                    child: Text(
                      '',
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
                  onTap: ((){
                    setState(() {
                      _currentIndex = 0;
                      _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.myContainerZhuangban(_currentIndex == 0 ? MyColors.zhuangbanWZBg : MyColors.zhuangbanBg, '座驾', StyleUtils.getCommonTextStyle(color: _currentIndex == 0 ? Colors.white : MyColors.zhuangbanWZ, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.w600)),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      _currentIndex = 1;
                      _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.myContainerZhuangban(_currentIndex == 1 ? MyColors.zhuangbanWZBg : MyColors.zhuangbanBg, '头像框', StyleUtils.getCommonTextStyle(color: _currentIndex == 1 ? Colors.white : MyColors.zhuangbanWZ, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.w600)),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                // GestureDetector(
                //   onTap: ((){
                //     setState(() {
                //       _currentIndex = 2;
                //       _controller.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                //     });
                //   }),
                //   child: WidgetUtils.myContainerZhuangban(_currentIndex == 2 ? MyColors.zhuangbanWZBg : MyColors.zhuangbanBg, '公屏气泡', StyleUtils.getCommonTextStyle(color: _currentIndex == 2 ? Colors.white : MyColors.zhuangbanWZ, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.w600)),
                // ),
                // WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      _currentIndex = 3;
                      _controller.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    });
                  }),
                  child: WidgetUtils.myContainerZhuangban(_currentIndex == 3 ? MyColors.zhuangbanWZBg : MyColors.zhuangbanBg, '麦上声波', StyleUtils.getCommonTextStyle(color: _currentIndex == 3 ? Colors.white : MyColors.zhuangbanWZ, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.w600)),
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
                ZuojiaBBPage(),
                HeadBBPage(),
                // QipaoPage(),
                ShengBoBBPage()
              ],
            ),
          )
        ],
      ),
    );
  }
}
