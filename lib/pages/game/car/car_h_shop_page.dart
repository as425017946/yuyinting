import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/gameStoreBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';
import '../../../widget/duihuan_queren_h_page.dart';
import '../../../widget/duihuan_queren_page.dart';
import '../../../widget/queren_page.dart';
/// 横屏赛车商店
class CarHShopPage extends StatefulWidget {
  const CarHShopPage({super.key});

  @override
  State<CarHShopPage> createState() => _CarHShopPageState();
}

class _CarHShopPageState extends State<CarHShopPage> {
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
          height: 75,
          width: 75,
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
          child: WidgetUtils.showImagesNet(list[i].img!, 65, 65),
        ),
        WidgetUtils.commonSizedBox(5, 0),
        SizedBox(
          width: 75,
          child: Row(
            children: [
              const Spacer(),
              WidgetUtils.showImages('assets/images/car_mogubi.png', 15, 15),
              WidgetUtils.commonSizedBox(0, 2.5),
              WidgetUtils.onlyText(list[i].exchangeCost!.toString(), StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 9, fontWeight: FontWeight.w600)),
              const Spacer(),
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(5, 0),
        GestureDetector(
          onTap: ((){
            MyUtils.goTransparentPageCom(
                context, DuiHuanQueRenHPage(goodsId: list[i].goodsId.toString(), goodsType: list[i].goodsType.toString(), exchangeCost: list[i].exchangeCost!, title: '赛车游戏',));
          }),
          child: Container(
            height: 16,
            width: 60,
            decoration: const BoxDecoration(
              //背景
              color: MyColors.CarZJ,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(
                  Radius.circular(9)),
            ),
            child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
          ),
        )
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Row(
        children: [
          const Spacer(),
          Opacity(
            opacity: 0,
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: WidgetUtils.showImages(
                  'assets/images/car/car_guanbi.png', 35, 35),
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: Container(
                    color: Colors.transparent,
                  )),
              Container(
                height: 320,
                width: 290,
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage('assets/images/car_h_shop.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(12, 0),
                    Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 175),
                        WidgetUtils.showImages('assets/images/car_mogubi.png', 18, 18),
                        WidgetUtils.commonSizedBox(0, 2.5),
                        WidgetUtils.onlyText(mogubi, StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    WidgetUtils.onlyTextCenter('在金蘑菇商店里兑换的礼物，价值与V豆相等', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 10)),
                    WidgetUtils.commonSizedBox(10, 0),
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
              Expanded(
                  child: Container(
                    color: Colors.transparent,
                  )),
            ],
          ),
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              height: double.infinity,
              width: 35,
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 20),
              child: WidgetUtils.showImages(
                  'assets/images/car/car_guanbi.png', 35, 35),
            ),
          ),
          const Spacer(),
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
