import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';

/// 首充页面
class ShouChongPage extends StatefulWidget {
  const ShouChongPage({super.key});

  @override
  State<ShouChongPage> createState() => _ShouChongPageState();
}

class _ShouChongPageState extends State<ShouChongPage> {
  int type = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          const Spacer(),
          Stack(
            children: [
              type == 0
                  ? Container(
                height: 400.h,
                margin: EdgeInsets.only(left: 20.h, right: 20.h),
                child: WidgetUtils.showImages(
                    'assets/images/shouchong_30.png',
                    400.h,
                    double.infinity),
              )
                  : type == 1
                  ? Container(
                height: 400.h,
                margin: EdgeInsets.only(left: 20.h, right: 20.h),
                child: WidgetUtils.showImages(
                    'assets/images/shouchong_68.png',
                    400.h,
                    double.infinity),
              )
                  : Container(
                height: 400.h,
                margin: EdgeInsets.only(left: 20.h, right: 20.h),
                child: WidgetUtils.showImages(
                    'assets/images/shouchong_98.png',
                    400.h,
                    double.infinity),
              ),
              type == 0
                  ? SizedBox(
                height: 400.h,
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(110.h, 0),
                    SizedBox(
                      height: 65.h,
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(100.h, 0),
                          const Spacer(),
                          Text(
                            '原价75元',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                decorationThickness: 2.0,
                                color: Colors.white,
                                fontSize: 20.sp),
                          ),
                          WidgetUtils.commonSizedBox(0, 10.h),
                          Text(
                            '限时优惠30元',
                            style: TextStyle(
                                color: Colors.white, fontSize: 24.sp),
                          ),
                          WidgetUtils.commonSizedBox(0, 90.h),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 70.h),
                          SizedBox(
                            width: 160.h,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 40.h),
                                    WidgetUtils.showImages(
                                        'assets/images/mine_wallet_dd.png',
                                        120.h,
                                        120.h),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 25.h),
                                    WidgetUtils.onlyText(
                                        '赠送300V豆',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp)),
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(7.h, 100.h),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  WidgetUtils.commonSizedBox(0, 65.h),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          WidgetUtils.commonSizedBox(
                                              0, 20.h),
                                          WidgetUtils.showImages(
                                              'assets/images/shouchong_emo.png',
                                              60.h,
                                              60.h)
                                        ],
                                      ),
                                      WidgetUtils.onlyText(
                                          '小恶魔头像框3天',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp)),
                                    ],
                                  ),
                                  WidgetUtils.commonSizedBox(0, 28.h),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          WidgetUtils.commonSizedBox(
                                              0, 25.h),
                                          WidgetUtils.showImages(
                                              'assets/images/shouchong_wajueji.png',
                                              60.h,
                                              60.h)
                                        ],
                                      ),
                                      WidgetUtils.onlyText(
                                          '炫酷挖掘机3天',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp)),
                                    ],
                                  )
                                ],
                              ),
                              WidgetUtils.commonSizedBox(35.h, 0),
                              SizedBox(
                                width: 230.h,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            WidgetUtils.commonSizedBox(0, 28.h),
                                            WidgetUtils.showImages(
                                                'assets/images/shouchong_guangbo.png',
                                                60.h,
                                                60.h)
                                          ],
                                        ),
                                        WidgetUtils.onlyText(
                                            '麦上光波3天',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp)),
                                      ],
                                    ),
                                    WidgetUtils.commonSizedBox(0, 22.h),
                                    Column(
                                      children: [
                                        WidgetUtils.commonSizedBox(15.h, 0),
                                        Row(
                                          children: [
                                            WidgetUtils.commonSizedBox(
                                                0, 25.h),
                                            WidgetUtils.showImages(
                                                'assets/images/shouchong_xinrui.png',
                                                40.h,
                                                80.h)
                                          ],
                                        ),
                                        WidgetUtils.commonSizedBox(5.h, 0),
                                        WidgetUtils.onlyText(
                                            '新锐徽章3天',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
                  : type == 1
                  ? SizedBox(
                height: 400.h,
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(110.h, 0),
                    SizedBox(
                      height: 65.h,
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(100.h, 0),
                          const Spacer(),
                          Text(
                            '原价158元',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                decorationThickness: 2.0,
                                color: Colors.white,
                                fontSize: 20.sp),
                          ),
                          WidgetUtils.commonSizedBox(0, 10.h),
                          Text(
                            '限时优惠68元',
                            style: TextStyle(
                                color: Colors.white, fontSize: 24.sp),
                          ),
                          WidgetUtils.commonSizedBox(0, 90.h),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 70.h),
                          SizedBox(
                            width: 160.h,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 40.h),
                                    WidgetUtils.showImages(
                                        'assets/images/mine_wallet_dd.png',
                                        120.h,
                                        120.h),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 25.h),
                                    WidgetUtils.onlyText(
                                        '赠送680V豆',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp)),
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(7.h, 100.h),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  WidgetUtils.commonSizedBox(0, 65.h),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          WidgetUtils.commonSizedBox(
                                              0, 20.h),
                                          WidgetUtils.showImages(
                                              'assets/images/shouchong_emo.png',
                                              60.h,
                                              60.h)
                                        ],
                                      ),
                                      WidgetUtils.onlyText(
                                          '小恶魔头像框7天',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp)),
                                    ],
                                  ),
                                  WidgetUtils.commonSizedBox(0, 28.h),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          WidgetUtils.commonSizedBox(
                                              0, 25.h),
                                          WidgetUtils.showImages(
                                              'assets/images/shouchong_wajueji.png',
                                              60.h,
                                              60.h)
                                        ],
                                      ),
                                      WidgetUtils.onlyText(
                                          '炫酷挖掘机7天',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp)),
                                    ],
                                  )
                                ],
                              ),
                              WidgetUtils.commonSizedBox(35.h, 0),
                              SizedBox(
                                width: 230.h,
                                child: Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 10.h),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            WidgetUtils.commonSizedBox(
                                                0, 20.h),
                                            WidgetUtils.showImages(
                                                'assets/images/shouchong_guangbo.png',
                                                60.h,
                                                60.h)
                                          ],
                                        ),
                                        WidgetUtils.onlyText(
                                            '麦上光波7天',
                                            StyleUtils
                                                .getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp)),
                                      ],
                                    ),
                                    WidgetUtils.commonSizedBox(0, 20.h),
                                    Column(
                                      children: [
                                        WidgetUtils.commonSizedBox(
                                            15.h, 0),
                                        Row(
                                          children: [
                                            WidgetUtils.commonSizedBox(
                                                0, 25.h),
                                            WidgetUtils.showImages(
                                                'assets/images/shouchong_xinrui.png',
                                                40.h,
                                                80.h)
                                          ],
                                        ),
                                        WidgetUtils.commonSizedBox(
                                            5.h, 0),
                                        WidgetUtils.onlyText(
                                            '新锐徽章7天',
                                            StyleUtils
                                                .getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
                  : SizedBox(
                height: 400.h,
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(110.h, 0),
                    SizedBox(
                      height: 65.h,
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(100.h, 0),
                          const Spacer(),
                          Text(
                            '原价228元',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                decorationThickness: 2.0,
                                color: Colors.white,
                                fontSize: 20.sp),
                          ),
                          WidgetUtils.commonSizedBox(0, 10.h),
                          Text(
                            '限时优惠98元',
                            style: TextStyle(
                                color: Colors.white, fontSize: 24.sp),
                          ),
                          WidgetUtils.commonSizedBox(0, 90.h),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 70.h),
                          SizedBox(
                            width: 160.h,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 40.h),
                                    WidgetUtils.showImages(
                                        'assets/images/mine_wallet_dd.png',
                                        120.h,
                                        120.h),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 25.h),
                                    WidgetUtils.onlyText(
                                        '赠送980V豆',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp)),
                                  ],
                                ),
                                WidgetUtils.commonSizedBox(7.h, 100.h),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  WidgetUtils.commonSizedBox(0, 59.h),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          WidgetUtils.commonSizedBox(
                                              0, 20.h),
                                          WidgetUtils.showImages(
                                              'assets/images/shouchong_98emo.png',
                                              60.h,
                                              60.h)
                                        ],
                                      ),
                                      WidgetUtils.onlyText(
                                          '黄金骑士头像框7天',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp)),
                                    ],
                                  ),
                                  WidgetUtils.commonSizedBox(0, 25.h),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          WidgetUtils.commonSizedBox(
                                              0, 25.h),
                                          WidgetUtils.showImages(
                                              'assets/images/shouchong_feichuan.png',
                                              60.h,
                                              60.h)
                                        ],
                                      ),
                                      WidgetUtils.onlyText(
                                          '光速飞船7天',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp)),
                                    ],
                                  )
                                ],
                              ),
                              WidgetUtils.commonSizedBox(35.h, 0),
                              SizedBox(
                                width: 230.h,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            WidgetUtils.commonSizedBox(
                                                0, 25.h),
                                            WidgetUtils.showImages(
                                                'assets/images/shouchong_98gq.png',
                                                60.h,
                                                60.h)
                                          ],
                                        ),
                                        WidgetUtils.onlyText(
                                            '麦上光波7天',
                                            StyleUtils
                                                .getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp)),
                                      ],
                                    ),
                                    WidgetUtils.commonSizedBox(0, 25.h),
                                    Column(
                                      children: [
                                        WidgetUtils.commonSizedBox(
                                            15.h, 0),
                                        Row(
                                          children: [
                                            WidgetUtils.commonSizedBox(
                                                0, 25.h),
                                            WidgetUtils.showImages(
                                                'assets/images/shouchong_xingui.png',
                                                40.h,
                                                80.h)
                                          ],
                                        ),
                                        WidgetUtils.commonSizedBox(
                                            5.h, 0),
                                        WidgetUtils.onlyText(
                                            '新贵徽章7天',
                                            StyleUtils
                                                .getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 100.h),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        type = 0;
                      });
                    }),
                    child: Container(
                      height: 50.h,
                      width: 120.h,
                      color: Colors.transparent,
                    ),
                  ),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        type = 1;
                      });
                    }),
                    child: Container(
                      height: 50.h,
                      width: 120.h,
                      color: Colors.transparent,
                    ),
                  ),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        type = 2;
                      });
                    }),
                    child: Container(
                      height: 50.h,
                      width: 120.h,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: 30.h,
                  right: 20.h,
                  child: GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: 50.h,
                      width: 50.h,
                      color: Colors.transparent,
                    ),
                  )),
            ],
          ),
          GestureDetector(
            onTap: ((){

            }),
            child: WidgetUtils.showImages('assets/images/shouchong_btn1.png', 100.h, 260.h),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
