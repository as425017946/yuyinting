import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/luckUserBean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
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
  /// 赛车中奖用户
  Future<void> doPostCarLuckyUser() async {
    try {
      luckUserBean bean = await DataUtils.postCarLuckyUser();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list = bean.data!.luckyList!;
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
