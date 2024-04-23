import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/zhuangban/qipao_bb_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/shengbo_bb_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/zhuangban_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/zuojia_bd_page.dart';
import '../../../colors/my_colors.dart';
import '../../../main.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import 'head_bb_page.dart';
import 'hengfu_bb_page.dart';

/// 背包
class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with ZhuangbanContent {
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
          WidgetUtils.commonSizedBox(10, 0),
          content([
            ZhuangbanContentItem(name: '座驾', build: () => const ZuojiaBBPage()),
            ZhuangbanContentItem(name: '头像框', build: () => const HeadBBPage()),
            ZhuangbanContentItem(name: '公屏气泡', build: () => const QiPaoBBPage()),
            ZhuangbanContentItem(name: '麦上声波', build: () => const ShengBoBBPage()),
            ZhuangbanContentItem(name: '进厅横幅', build: () => const HengfuBBPage()),
          ]),
        ],
      ),
    );
  }
}
