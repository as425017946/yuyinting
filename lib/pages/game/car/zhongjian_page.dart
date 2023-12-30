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

/// 中奖页面
class ZhongJiangPage extends StatefulWidget {
  int type;
  ZhongJiangPage({super.key, required this.type});

  @override
  State<ZhongJiangPage> createState() => _ZhongJiangPageState();
}

class _ZhongJiangPageState extends State<ZhongJiangPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostCarLuckyUser();
    // 4秒后关闭页面
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
              Expanded(
                  child: Container(
                color: Colors.transparent,
              )),
              Center(
                child: Container(
                  height: 630.h,
                  margin: EdgeInsets.only(left: 20.h, right: 20.h),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      WidgetUtils.showImages(
                          widget.type == 6 ? 'assets/images/car/car_zj_maliao.png' :  widget.type == 5 ? 'assets/images/car/car_zj_lv.png' :  widget.type == 4 ? 'assets/images/car/car_zj_fen.png' :  widget.type == 3 ? 'assets/images/car/car_zj_hou.png' :  widget.type == 2 ? 'assets/images/car/car_zj_ji.png' :  widget.type == 1 ? 'assets/images/car/car_zj_wugui.png' : 'assets/images/car/car_zj_gui.png', 630.h, 675.h),
                      Column(
                        children: [
                          const Spacer(),
                          list.isEmpty ?
                          const Text('') : list.length == 1 ? Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 90.h,
                                width: 90.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.CircleHeadImage(90.h, 90.h,
                                        list[0].avatar!),
                                    SizedBox(
                                      height: 25.h,
                                      child: Stack(
                                        children: [
                                          WidgetUtils.showImagesFill(
                                              'assets/images/car_btn2.png',
                                              25.h,
                                              90.h),
                                          Row(
                                            children: [
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                              // WidgetUtils.showImages(
                                              //     'assets/images/car_mogubi.png',
                                              //     15.h,
                                              //     15.h),
                                              Expanded(
                                                  child: WidgetUtils
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
                                                          20.sp))),
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ) : list.length == 2 ? Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 90.h,
                                width: 90.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.CircleHeadImage(90.h, 90.h,
                                        list[0].avatar!),
                                    SizedBox(
                                      height: 25.h,
                                      child: Stack(
                                        children: [
                                          WidgetUtils.showImagesFill(
                                              'assets/images/car_btn2.png',
                                              25.h,
                                              90.h),
                                          Row(
                                            children: [
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                              // WidgetUtils.showImages(
                                              //     'assets/images/car_mogubi.png',
                                              //     15.h,
                                              //     15.h),
                                              Expanded(
                                                  child: WidgetUtils
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
                                                          20.sp))),
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 90.h,
                                width: 90.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.CircleHeadImage(90.h, 90.h,
                                        list[1].avatar!),
                                    SizedBox(
                                      height: 25.h,
                                      child: Stack(
                                        children: [
                                          WidgetUtils.showImagesFill(
                                              'assets/images/car_btn2.png',
                                              25.h,
                                              90.h),
                                          Row(
                                            children: [
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                              // WidgetUtils.showImages(
                                              //     'assets/images/car_mogubi.png',
                                              //     15.h,
                                              //     15.h),
                                              Expanded(
                                                  child: WidgetUtils
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
                                                          20.sp))),
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                            ],
                                          )
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
                                height: 90.h,
                                width: 90.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.CircleHeadImage(90.h, 90.h,
                                        list[0].avatar!),
                                    SizedBox(
                                      height: 25.h,
                                      child: Stack(
                                        children: [
                                          WidgetUtils.showImagesFill(
                                              'assets/images/car_btn2.png',
                                              25.h,
                                              90.h),
                                          Row(
                                            children: [
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                              // WidgetUtils.showImages(
                                              //     'assets/images/car_mogubi.png',
                                              //     15.h,
                                              //     15.h),
                                              Expanded(
                                                  child: WidgetUtils
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
                                                          20.sp))),
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 90.h,
                                width: 90.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.CircleHeadImage(90.h, 90.h,
                                        list[1].avatar!),
                                    SizedBox(
                                      height: 25.h,
                                      child: Stack(
                                        children: [
                                          WidgetUtils.showImagesFill(
                                              'assets/images/car_btn2.png',
                                              25.h,
                                              90.h),
                                          Row(
                                            children: [
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                              // WidgetUtils.showImages(
                                              //     'assets/images/car_mogubi.png',
                                              //     15.h,
                                              //     15.h),
                                              Expanded(
                                                  child: WidgetUtils
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
                                                          20.sp))),
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 90.h,
                                width: 90.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.CircleHeadImage(90.h, 90.h,
                                        list[2].avatar!),
                                    SizedBox(
                                      height: 25.h,
                                      child: Stack(
                                        children: [
                                          WidgetUtils.showImagesFill(
                                              'assets/images/car_btn2.png',
                                              25.h,
                                              90.h),
                                          Row(
                                            children: [
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                              // WidgetUtils.showImages(
                                              //     'assets/images/car_mogubi.png',
                                              //     15.h,
                                              //     15.h),
                                              Expanded(
                                                  child: WidgetUtils
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
                                                          20.sp))),
                                              WidgetUtils.commonSizedBox(
                                                  0, 20.h),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          WidgetUtils.commonSizedBox(80.h, 0),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              WidgetUtils.commonSizedBox(30.h, 0),
              GestureDetector(
                onTap: ((){
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
        ));
  }

  List<LuckyList> list = [];
  /// 赛车中奖用户
  // 金币 钻石 蘑菇币
  String jinbi = '',
      zuanshi = '',
      mogubi = '',
      jinbi2 = '',
      zuanshi2 = '',
      mogubi2 = '';
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
              jinbi2 =
              '${(double.parse(bean.data!.wallet!.goldBean!) / 10000).toStringAsFixed(2)}w';
            } else {
              jinbi2 = bean.data!.wallet!.goldBean!;
            }
            zuanshi = bean.data!.wallet!.diamond!;
            if (double.parse(bean.data!.wallet!.diamond!) > 10000) {
              zuanshi2 =
              '${(double.parse(bean.data!.wallet!.diamond!) / 10000).toStringAsFixed(2)}w';
            } else {
              zuanshi2 = bean.data!.wallet!.diamond!;
            }
            mogubi = bean.data!.wallet!.mushroom!;
            if (double.parse(bean.data!.wallet!.mushroom!) > 10000) {
              mogubi2 =
              '${(double.parse(bean.data!.wallet!.mushroom!) / 10000).toStringAsFixed(2)}w';
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
