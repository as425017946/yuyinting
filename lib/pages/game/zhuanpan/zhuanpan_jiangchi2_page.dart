import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_shuoming2_page.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/gameStoreBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';
import '../../../widget/duihuan_queren_page.dart';

/// 转盘的奖池
class ZhuanPanJiangChi2Page extends StatefulWidget {
  const ZhuanPanJiangChi2Page({super.key});

  @override
  State<ZhuanPanJiangChi2Page> createState() => _ZhuanPanJiangChi2PageState();
}

class _ZhuanPanJiangChi2PageState extends State<ZhuanPanJiangChi2Page> {
  // 钥匙数量
  int nums = 0;
  var listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGameStore();
    listen = eventBus.on<DHQuerenBack>().listen((event) {
      // 开始去兑换
      doPostExchangeGoods(event.goodsId.toString(), event.goodsType.toString(),
          event.exchangeCost!);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  Widget jiangChiWidget(BuildContext context, int i) {
    return Container(
      height: 247.h,
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
                Positioned(
                  right: 10.w,
                  top: 5.h,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.47,
                        child: Container(
                          width: 80.h,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: MyColors.zpBG,
                            borderRadius: BorderRadius.circular(21),
                          ),
                        ),
                      ),
                      Container(
                          width: 80.h,
                          height: 30.h,
                          alignment: Alignment.centerLeft,
                          child: WidgetUtils.onlyTextCenter(
                              '${list[i].price!}V豆',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.peopleYellow, fontSize: 18.sp))
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(10.h, 0),
          Row(
            children: [
              const Spacer(),
              WidgetUtils.showImages(
                  'assets/images/zhuanpan_jc_ys2.png', 20.h, 20.h),
              WidgetUtils.commonSizedBox(0, 5.h),
              WidgetUtils.onlyText(
                  'x${list[i].exchangeCost}',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.white, fontSize: 20.sp)),
              const Spacer(),
            ],
          ),
          WidgetUtils.commonSizedBox(5.h, 0),
          WidgetUtils.onlyTextCenter(
              list[i].goodsName!,
              StyleUtils.getCommonTextStyle(
                  color: Colors.white, fontSize: 18.sp)),
          WidgetUtils.commonSizedBox(10.h, 0),
          GestureDetector(
            onTap: (() {
              MyUtils.goTransparentPageCom(
                  context,
                  DuiHuanQueRenPage(
                    goodsId: list[i].goodsId.toString(),
                    goodsType: list[i].goodsType.toString(),
                    exchangeCost: list[i].exchangeCost!,
                    title: '超级转盘',
                  ));
            }),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.showImages(
                    'assets/images/zhuanpan_jc_btn.png', 42.h, 133.h),
                WidgetUtils.onlyTextCenter(
                    '兑换',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.zpWZ1,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600))
              ],
            ),
          ),
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
              height: 450.h,
              width: double.infinity,
              color: Colors.transparent,
            ),
          )),
          Container(
            height: 820.h,
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
                WidgetUtils.commonSizedBox(130.h, 0),
                //头部信息
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 30.h),
                    Stack(
                      children: [
                        Opacity(
                          opacity: 0.47,
                          child: Container(
                            width: 120.h,
                            height: 45.h,
                            decoration: BoxDecoration(
                              color: MyColors.zpBG,
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        Container(
                          width: 120.h,
                          height: 45.h,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20.h),
                              WidgetUtils.showImages(
                                  'assets/images/zhuanpan_jc_ys2.png',
                                  32.h,
                                  32.h),
                              WidgetUtils.commonSizedBox(0, 10.h),
                              WidgetUtils.onlyText(
                                  nums.toString(),
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white, fontSize: 24.sp)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: (() {
                          MyUtils.goTransparentPageCom(context, const ZhuanPanShuoMing2Page());
                        }),
                        child: WidgetUtils.onlyText(
                            '帮助',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.zpGZYellow, fontSize: 24.sp))),
                    WidgetUtils.commonSizedBox(0, 30.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(20.h, 0),
                //标题
                WidgetUtils.showImages(
                    'assets/images/zhuanpan_jc_title3.png', 32.h, 320.h),
                WidgetUtils.commonSizedBox(50.h, 0),
                Expanded(
                    child: OptionGridView(
                  padding: EdgeInsets.only(left: 50.h, right: 50.h),
                  itemCount: list.length,
                  rowCount: 3,
                  mainAxisSpacing: 20.h,
                  // 上下间距
                  crossAxisSpacing: 20.h,
                  //左右间距
                  itemBuilder: jiangChiWidget,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  List<GoodsList> list = [];

  /// 游戏商店
  Future<void> doPostGameStore() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'store_id': '2',
    };
    try {
      gameStoreBean bean = await DataUtils.postGameStore(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list = bean.data!.goodsList!;
            nums = int.parse(bean.data!.amount!);
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
      LogE('钥匙错误信息$e');
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 兑换
  Future<void> doPostExchangeGoods(
      String goodsID, String goodsType, int sl) async {
    Map<String, dynamic> params = <String, dynamic>{
      'store_id': '2', //商店id 1小转盘 2大转盘 3赛车
      'goods_id': goodsID, //商品id
      'goods_type': goodsType, //1礼物 2装扮
    };
    try {
      CommonBean bean = await DataUtils.postExchangeGoods(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('兑换成功！');
          setState(() {
            nums = nums - sl;
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
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
