import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/luckUserBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';

/// 中奖横页面
class ZhongJiangHPage extends StatefulWidget {
  int type;
  ZhongJiangHPage({super.key, required this.type});

  @override
  State<ZhongJiangHPage> createState() => _ZhongJiangHPageState();
}

class _ZhongJiangHPageState extends State<ZhongJiangHPage> {
  int length = 3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostCarLuckyUser();
    Future.delayed(const Duration(seconds: 4),(){
      if(mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: GestureDetector(
          onTap: (() {
            Navigator.pop(context);
          }),
          child: Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  Container(
                    height: 240,
                    width: 260,
                    color: Colors.transparent,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        WidgetUtils.showImages(
                            widget.type == 6 ? 'assets/images/car/car_zj_maliao.png' :  widget.type == 5 ? 'assets/images/car/car_zj_lv.png' :  widget.type == 4 ? 'assets/images/car/car_zj_fen.png' :  widget.type == 3 ? 'assets/images/car/car_zj_hou.png' :  widget.type == 2 ? 'assets/images/car/car_zj_ji.png' :  widget.type == 1 ? 'assets/images/car/car_zj_wugui.png' : 'assets/images/car/car_zj_gui.png', 240, 260),
                        Column(
                          children: [
                            const Spacer(),
                            list.isEmpty ?
                            const Text('') : list.length == 1 ? Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      WidgetUtils.CircleHeadImage(45, 45,
                                          'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
                                      SizedBox(
                                        height: 12,
                                        child: Stack(
                                          children: [
                                            WidgetUtils.showImagesFill(
                                                'assets/images/car_btn2.png',
                                                12,
                                                45),
                                            WidgetUtils
                                                .onlyTextCenter(
                                                list[0].amount.toString(),
                                                StyleUtils
                                                    .getCommonTextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize:
                                                    8.sp)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ) : length == 2 ? Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      WidgetUtils.CircleHeadImage(45, 45,
                                          'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
                                      SizedBox(
                                        height: 12,
                                        child: Stack(
                                          children: [
                                            WidgetUtils.showImagesFill(
                                                'assets/images/car_btn2.png',
                                                12,
                                                45),
                                            WidgetUtils
                                                .onlyTextCenter(
                                                list[0].amount.toString(),
                                                StyleUtils
                                                    .getCommonTextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize:
                                                    8.sp)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      WidgetUtils.CircleHeadImage(45, 45,
                                          'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
                                      SizedBox(
                                        height: 12,
                                        child: Stack(
                                          children: [
                                            WidgetUtils.showImagesFill(
                                                'assets/images/car_btn2.png',
                                                12,
                                                45),
                                            WidgetUtils
                                                .onlyTextCenter(
                                                list[1].amount.toString(),
                                                StyleUtils
                                                    .getCommonTextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize:
                                                    8.sp)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ) : Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      WidgetUtils.CircleHeadImage(45, 45,
                                          'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
                                      SizedBox(
                                        height: 12,
                                        child: Stack(
                                          children: [
                                            WidgetUtils.showImagesFill(
                                                'assets/images/car_btn2.png',
                                                12,
                                                45),
                                            WidgetUtils
                                                .onlyTextCenter(
                                                list[0].amount.toString(),
                                                StyleUtils
                                                    .getCommonTextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize:
                                                    8.sp)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      WidgetUtils.CircleHeadImage(45, 45,
                                          'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
                                      SizedBox(
                                        height: 12,
                                        child: Stack(
                                          children: [
                                            WidgetUtils.showImagesFill(
                                                'assets/images/car_btn2.png',
                                                12,
                                                45),
                                            WidgetUtils
                                                .onlyTextCenter(
                                                list[1].amount.toString(),
                                                StyleUtils
                                                    .getCommonTextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize:
                                                    8.sp)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      WidgetUtils.CircleHeadImage(45, 45,
                                          'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
                                      SizedBox(
                                        height: 12,
                                        child: Stack(
                                          children: [
                                            WidgetUtils.showImagesFill(
                                                'assets/images/car_btn2.png',
                                                12,
                                                45),
                                            WidgetUtils
                                                .onlyTextCenter(
                                                list[2].amount.toString(),
                                                StyleUtils
                                                    .getCommonTextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    fontSize:
                                                    8.sp)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            WidgetUtils.commonSizedBox(15, 0),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              WidgetUtils.commonSizedBox(15, 0),
              GestureDetector(
                onTap: ((){
                  Navigator.pop(context);
                }),
                child: WidgetUtils.showImages(
                    'assets/images/car/car_guanbi.png', 35, 35),
              ),
              const Spacer(),
            ],
          ),
        ));
  }

  List<LuckyList> list = [];
  // 金币 钻石 蘑菇币
  String jinbi = '',
      zuanshi = '',
      mogubi = '',
      jinbi2 = '',
      zuanshi2 = '',
      mogubi2 = '';
  /// 赛车中奖用户
  Future<void> doPostCarLuckyUser() async {
    try {
      luckUserBean bean = await DataUtils.postCarLuckyUser();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list = bean.data!.luckyList!;
            jinbi = bean.data!.wallet!.goldBean!;
            if (double.parse(bean.data!.wallet!.goldBean!) > 10000) {
              jinbi2 = '${(double.parse(bean.data!.wallet!.goldBean!) / 10000)}';
              jinbi2 = '${jinbi2.substring(0,jinbi2.lastIndexOf('.')+3)}w';
            } else {
              jinbi2 = bean.data!.wallet!.goldBean!;
            }
            zuanshi = bean.data!.wallet!.diamond!;
            if (double.parse(bean.data!.wallet!.diamond!) > 10000) {
              zuanshi2 = '${(double.parse(bean.data!.wallet!.diamond!) / 10000)}';
              zuanshi2 = '${zuanshi2.substring(0,zuanshi2.lastIndexOf('.')+3)}w';
            } else {
              zuanshi2 = bean.data!.wallet!.diamond!;
            }
            mogubi = bean.data!.wallet!.mushroom!;
            if (double.parse(bean.data!.wallet!.mushroom!) > 10000) {
              mogubi2 = '${(double.parse(bean.data!.wallet!.mushroom!) / 10000)}';
              mogubi2 = '${mogubi2.substring(0,mogubi2.lastIndexOf('.')+3)}w';
            } else {
              mogubi2 = bean.data!.wallet!.mushroom!;
            }
            sp.setString('car_jinbi', jinbi);
            sp.setString('car_zuanshi', zuanshi);
            sp.setString('car_mogu', mogubi);
            sp.setString('car_jinbi2', jinbi2);
            sp.setString('car_zuanshi2', zuanshi2);
            sp.setString('car_mogu2', mogubi2);
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
