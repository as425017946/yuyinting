import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/gameStoreBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';
import '../../../widget/duihuan_queren_page.dart';

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
    return Column(
      children: [
        Container(
          height: 150 * 1.25.w,
          width: 150 * 1.25.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(10 * 2.w)),
            //设置四周边框
            border: Border.all(width: 1, color: MyColors.CarZJ),
          ),
          child: WidgetUtils.showImagesNet(
              list[i].img!, 130 * 1.25.w, 130 * 1.25.w),
        ),
        WidgetUtils.commonSizedBox(10 * 1.25.w, 0 * 1.25.w),
        WidgetUtils.onlyTextCenter(
            list[i].goodsName!,
            StyleUtils.getCommonTextStyle(
                color: MyColors.g3,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600)),
        WidgetUtils.commonSizedBox(10 * 1.25.w, 0.h),
        SizedBox(
          width: 150 * 1.25.w,
          child: Row(
            children: [
              const Spacer(),
              WidgetUtils.showImages(
                  'assets/images/car_mogubi.png', 20 * 1.25.w, 20 * 1.25.w),
              WidgetUtils.commonSizedBox(0, 5 * 1.25.w),
              WidgetUtils.onlyText(
                  list[i].exchangeCost!.toString(),
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g3,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(10 * 1.25.w, 0.h),
        GestureDetector(
          onTap: (() {
            MyUtils.goTransparentPageCom(
                context,
                DuiHuanQueRenPage(
                  goodsId: list[i].goodsId.toString(),
                  goodsType: list[i].goodsType.toString(),
                  exchangeCost: list[i].exchangeCost!,
                  title: '赛车游戏',
                ));
          }),
          child: Container(
            height: 35 * 1.25.w,
            width: 120 * 1.25.w,
            decoration: const BoxDecoration(
              //背景
              color: MyColors.CarZJ,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(21)),
            ),
            child: WidgetUtils.onlyTextCenter(
                '兑换',
                StyleUtils.getCommonTextStyle(
                    color: Colors.white, fontSize: 24.sp)),
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
            height: 750 * 1.3.w,
            width: double.infinity,
            margin: EdgeInsets.all(20 * 1.25.w),
            decoration: const BoxDecoration(
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage('assets/images/car/car_jl_bg.png'),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(40 * 1.25.w, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 350 * 1.25.w),
                    WidgetUtils.showImages('assets/images/car_mogubi.png',
                        40 * 1.25.w, 40 * 1.25.w),
                    WidgetUtils.commonSizedBox(0, 5 * 1.25.w),
                    WidgetUtils.onlyText(
                        sp.getString('car_mogu2').toString(),
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g3,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                WidgetUtils.commonSizedBox(40 * 1.25.w, 0.h),
                WidgetUtils.onlyTextCenter(
                    '在金蘑菇商店里兑换的礼物，价值与金豆相等',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: 25.sp)),
                WidgetUtils.commonSizedBox(30 * 1.25.w, 0.h),
                Expanded(
                    child: OptionGridView(
                  padding:
                      EdgeInsets.only(left: 50 * 1.25.w, right: 50 * 1.25.w),
                  itemCount: list.length,
                  rowCount: 3,
                  mainAxisSpacing: 20 * 1.25.w,
                  // 上下间距
                  crossAxisSpacing: 20 * 1.25.w,
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
                'assets/images/car/car_guanbi.png', 70 * 1.25.w, 70 * 1.25.w),
          ),
          Expanded(
              child: Container(
            color: Colors.transparent,
          )),
        ],
      ),
    );
  }

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
            // if(double.parse(bean.data!.amount!) > 10000){
            //   mogubi = '${double.parse(bean.data!.amount!)/10000}w';
            // }else{
            //   mogubi = bean.data!.amount!.toString();
            // }
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 兑换
  Future<void> doPostExchangeGoods(
      String goodsID, String goodsType, int sl) async {
    Map<String, dynamic> params = <String, dynamic>{
      'store_id': '3', //商店id 1小转盘 2大转盘 3赛车
      'goods_id': goodsID, //商品id
      'goods_type': goodsType, //1礼物 2装扮
    };
    try {
      CommonBean bean = await DataUtils.postExchangeGoods(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // 蘑菇币
          String mogubi = '';
          MyToastUtils.showToastBottom('兑换成功！');
          setState(() {
            if (sp.getString('car_mogu2').toString().contains('w')) {
              // 目的是先把 1w 转换成 10000
              String a = sp.getString('car_mogu2').toString().substring(
                  0, sp.getString('car_mogu2').toString().length - 1);
              LogE('余额= $a');
              double b = sl / 10000;
              LogE('余额/ $b');
              double c = double.parse(a) - b;
              LogE('余额* $c');
              sp.setString('car_mogu2', '${c.toStringAsFixed(2)}w');
            } else {
              mogubi = (double.parse(sp.getString('car_mogu2').toString()) - sl)
                  .toString();
              LogE('余额 $mogubi');
              sp.setString('car_mogu2', mogubi);
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
    } catch (e) {}
  }
}
