import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/loading.dart';
import '../../../bean/mofangJCBean.dart';
import '../../../colors/my_colors.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';

/// 转盘的奖池
class ZhuanPanNewJC2Page extends StatefulWidget {
  const ZhuanPanNewJC2Page({super.key});

  @override
  State<ZhuanPanNewJC2Page> createState() => _ZhuanPanNewJC2PageState();
}

class _ZhuanPanNewJC2PageState extends State<ZhuanPanNewJC2Page> {
  // 钥匙数量
  int nums = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGameStore();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget jiangChiWidget(BuildContext context, int i) {
    return Container(
      height: 240.h,
      width: 161.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/zhuanpan_jc_btn_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 120.h,
            width: 161.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.showImagesNet(list[i].img!, 120.h, 120.h),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(10.h, 0),
          WidgetUtils.onlyTextCenter(
              '${list[i].price!}V豆',
              StyleUtils.getCommonTextStyle(
                  color: Colors.white, fontSize: 18.sp)),
          WidgetUtils.commonSizedBox(5.h, 0),
          WidgetUtils.onlyTextCenter(
              list[i].name!,
              StyleUtils.getCommonTextStyle(
                  color: MyColors.zpGZYellow, fontSize: 22.sp)),
          WidgetUtils.commonSizedBox(10.h, 0),
          WidgetUtils.onlyTextCenter(
              list[i].gl!,
              StyleUtils.getCommonTextStyle(
                  color: Colors.white, fontSize: 18.sp)),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: 820.h,
            padding: EdgeInsets.only(bottom: 30.h),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/zhuanpan_jc_bg2.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetUtils.commonSizedBox(170.h, 0),
                //标题
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: Container(
                        height: 50.h,
                        width: 80.h,
                        color: Colors.transparent,
                        padding: EdgeInsets.only(right: 20.h),
                        alignment: Alignment.centerRight,
                        child: WidgetUtils.showImages(
                            'assets/images/back_white.png', 30.h, 20.h),
                      ),
                    ),
                    const Spacer(),
                    WidgetUtils.onlyTextCenter(
                        '奖池一览',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.loginBlue2, fontSize: 36.sp)),
                    const Spacer(),
                    WidgetUtils.commonSizedBox(0, 80.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(20.h, 0),
                Expanded(
                    child: SingleChildScrollView(
                      child: OptionGridView(
                        padding: EdgeInsets.only(left: 50.h, right: 50.h, bottom: 50.h),
                        itemCount: list.length,
                        rowCount: 3,
                        mainAxisSpacing: 20.h,
                        // 上下间距
                        crossAxisSpacing: 20.h,
                        //左右间距
                        itemBuilder: jiangChiWidget,
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Data> list = [];
  /// 游戏商店
  Future<void> doPostGameStore() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'game_id': '2',
      'price_id': '1', //1小金额 2大金额
    };
    try {
      mofangJCBean bean = await DataUtils.postRoulettePrizeList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list = bean.data!;
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
