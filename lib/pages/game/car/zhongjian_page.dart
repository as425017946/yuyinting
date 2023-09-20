import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

/// 中奖页面
class ZhongJiangPage extends StatefulWidget {
  int type;
  ZhongJiangPage({super.key, required this.type});

  @override
  State<ZhongJiangPage> createState() => _ZhongJiangPageState();
}

class _ZhongJiangPageState extends State<ZhongJiangPage> {
  int length = 3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                          length == 0 ?
                          const Text('') : length == 1 ? Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 90.h,
                                width: 90.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.CircleHeadImage(90.h, 90.h,
                                        'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
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
                                                  0, 5.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/car_mogubi.png',
                                                  15.h,
                                                  15.h),
                                              Expanded(
                                                  child: WidgetUtils
                                                      .onlyTextCenter(
                                                      '10',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize:
                                                          14.sp))),
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
                          ) : length == 2 ? Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                height: 90.h,
                                width: 90.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    WidgetUtils.CircleHeadImage(90.h, 90.h,
                                        'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
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
                                                  0, 5.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/car_mogubi.png',
                                                  15.h,
                                                  15.h),
                                              Expanded(
                                                  child: WidgetUtils
                                                      .onlyTextCenter(
                                                      '10',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize:
                                                          14.sp))),
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
                                        'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
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
                                                  0, 5.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/car_mogubi.png',
                                                  15.h,
                                                  15.h),
                                              Expanded(
                                                  child: WidgetUtils
                                                      .onlyTextCenter(
                                                      '10000',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize:
                                                          14.sp))),
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
                                        'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
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
                                                  0, 5.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/car_mogubi.png',
                                                  15.h,
                                                  15.h),
                                              Expanded(
                                                  child: WidgetUtils
                                                      .onlyTextCenter(
                                                      '10',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize:
                                                          14.sp))),
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
                                        'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
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
                                                  0, 5.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/car_mogubi.png',
                                                  15.h,
                                                  15.h),
                                              Expanded(
                                                  child: WidgetUtils
                                                      .onlyTextCenter(
                                                      '10000',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize:
                                                          14.sp))),
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
                                        'http://image.nbd.com.cn/uploads/articles/images/673466/500352700_banner.jpg'),
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
                                                  0, 5.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/car_mogubi.png',
                                                  15.h,
                                                  15.h),
                                              Expanded(
                                                  child: WidgetUtils
                                                      .onlyTextCenter(
                                                      '10000',
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize:
                                                          14.sp))),
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
}
