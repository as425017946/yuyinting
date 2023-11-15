import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/balanceBean.dart';
import '../../../bean/gameStoreBean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';
import '../../../widget/duihuan_queren_page.dart';
import '../../../widget/queren_page.dart';
///赛车商城
class CarShopPage extends StatefulWidget {
  const CarShopPage({super.key});

  @override
  State<CarShopPage> createState() => _CarShopPageState();
}

class _CarShopPageState extends State<CarShopPage> {
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGameStore();
    listen = eventBus.on<DHQuerenBack>().listen((event) {
      // 开始去兑换
      doPostExchangeGoods(event.goodsId.toString(), event.goodsType.toString(), event.exchangeCost!);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  Widget jiangChiWidget(BuildContext context, int i) {
    return Column(
      children: [
        Container(
          height: 150.h,
          width: 150.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: const BorderRadius.all(
                Radius.circular(10)),
            //设置四周边框
            border: Border.all(width: 1, color: MyColors.CarZJ),
          ),
          child: WidgetUtils.showImagesNet(list[i].img!, 130.h, 130.h),
        ),
        WidgetUtils.commonSizedBox(10.h, 0.h),
        SizedBox(
          width: 150.h,
          child: Row(
            children: [
              const Spacer(),
              WidgetUtils.showImages('assets/images/car_mogubi.png', 20.h, 20.h),
              WidgetUtils.commonSizedBox(0, 5.h),
              WidgetUtils.onlyText(list[i].exchangeCost!.toString(), StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 22.sp, fontWeight: FontWeight.w600)),
              const Spacer(),
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(10.h, 0.h),
        GestureDetector(
          onTap: ((){
            MyUtils.goTransparentPageCom(
                context, DuiHuanQueRenPage(goodsId: list[i].goodsId.toString(), goodsType: list[i].goodsType.toString(), exchangeCost: list[i].exchangeCost!, title: '赛车游戏',));
          }),
          child: Container(
            height: 35.h,
            width: 120.h,
            decoration: const BoxDecoration(
              //背景
              color: MyColors.CarZJ,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(
                  Radius.circular(21)),
            ),
            child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 24.sp)),
          ),
        )
      ],
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
              child: Container(
                color: Colors.transparent,
              )),
          Container(
            height: 750.h,
            width: double.infinity,
            margin: EdgeInsets.all(20.h),
            decoration: const BoxDecoration(
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage('assets/images/car/car_jl_bg.png'),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(40.h, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 350.h),
                    WidgetUtils.showImages('assets/images/car_mogubi.png', 40.h, 40.h),
                    WidgetUtils.commonSizedBox(0, 5.h),
                    WidgetUtils.onlyText(mogubi, StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 40.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
                WidgetUtils.commonSizedBox(40.h, 0.h),
                WidgetUtils.onlyTextCenter('在金蘑菇商店里兑换的礼物，价值与V豆相等', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 25.sp)),
                WidgetUtils.commonSizedBox(30.h, 0.h),
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
          ),
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: WidgetUtils.showImages(
                'assets/images/car/car_guanbi.png', 70.h, 70.h),
          ),
          Expanded(
              child: Container(
                color: Colors.transparent,
              )),
        ],
      ),
    );
  }


  // 蘑菇币
  String mogubi = '';
  List<GoodsList> list = [];
  /// 游戏商店
  Future<void> doPostGameStore() async {
    Map<String, dynamic> params = <String, dynamic>{
      'store_id': '3',
    };
    try {
      gameStoreBean bean = await DataUtils.postGameStore(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list = bean.data!.goodsList!;
            if(bean.data!.amount! > 10000){
              mogubi = '${bean.data!.amount!/10000}w';
            }else{
              mogubi = bean.data!.amount!.toString();
            }
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

  /// 兑换
  Future<void> doPostExchangeGoods(String goodsID, String goodsType, int sl) async {
    Map<String, dynamic> params = <String, dynamic>{
      'store_id': '3', //商店id 1小转盘 2大转盘 3赛车
      'goods_id': goodsID, //商品id
      'goods_type': goodsType, //1礼物 2装扮
    };
    try {
      CommonBean bean = await DataUtils.postExchangeGoods(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('兑换成功！');
          setState(() {
            if(mogubi.contains('w')){
              // 目的是先把 1w 转换成 10000
              mogubi = (double.parse(mogubi.substring(0,mogubi.length - 1)) * 1000).toString();
              // 减去花费的V豆
              mogubi = '${(double.parse(mogubi) - sl)/1000}w';
            }else{
              mogubi = (double.parse(mogubi) - sl).toString();
            }
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
