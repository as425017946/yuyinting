import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../bean/isFirstOrderBean.dart';
import '../../bean/orderPayBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostIsFirstOrder();
  }
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
              // type == 0
              //     ? SizedBox(
              //   height: 400.h,
              //   child: Column(
              //     children: [
              //       WidgetUtils.commonSizedBox(110.h, 0),
              //       SizedBox(
              //         height: 65.h,
              //         child: Row(
              //           children: [
              //             WidgetUtils.commonSizedBox(100.h, 0),
              //             const Spacer(),
              //             Text(
              //               '原价75元',
              //               style: TextStyle(
              //                   decoration: TextDecoration.lineThrough,
              //                   decorationColor: Colors.red,
              //                   decorationThickness: 2.0,
              //                   color: Colors.white,
              //                   fontSize: 20.sp),
              //             ),
              //             WidgetUtils.commonSizedBox(0, 10.h),
              //             Text(
              //               '限时优惠30元',
              //               style: TextStyle(
              //                   color: Colors.white, fontSize: 24.sp),
              //             ),
              //             WidgetUtils.commonSizedBox(0, 90.h),
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         height: 200.h,
              //         child: Row(
              //           children: [
              //             WidgetUtils.commonSizedBox(0, 70.h),
              //             SizedBox(
              //               width: 160.h,
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     children: [
              //                       WidgetUtils.commonSizedBox(0, 40.h),
              //                       WidgetUtils.showImages(
              //                           'assets/images/mine_wallet_dd.png',
              //                           120.h,
              //                           120.h),
              //                     ],
              //                   ),
              //                   const Spacer(),
              //                   Row(
              //                     children: [
              //                       WidgetUtils.commonSizedBox(0, 25.h),
              //                       WidgetUtils.onlyText(
              //                           '赠送300V豆',
              //                           StyleUtils.getCommonTextStyle(
              //                               color: Colors.white,
              //                               fontSize: 18.sp)),
              //                     ],
              //                   ),
              //                   WidgetUtils.commonSizedBox(7.h, 100.h),
              //                 ],
              //               ),
              //             ),
              //             Column(
              //               children: [
              //                 Row(
              //                   children: [
              //                     WidgetUtils.commonSizedBox(0, 65.h),
              //                     Column(
              //                       children: [
              //                         Row(
              //                           children: [
              //                             WidgetUtils.commonSizedBox(
              //                                 0, 20.h),
              //                             WidgetUtils.showImages(
              //                                 'assets/images/shouchong_emo.png',
              //                                 60.h,
              //                                 60.h)
              //                           ],
              //                         ),
              //                         WidgetUtils.onlyText(
              //                             '小恶魔头像框3天',
              //                             StyleUtils.getCommonTextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: 14.sp)),
              //                       ],
              //                     ),
              //                     WidgetUtils.commonSizedBox(0, 28.h),
              //                     Column(
              //                       children: [
              //                         Row(
              //                           children: [
              //                             WidgetUtils.commonSizedBox(
              //                                 0, 25.h),
              //                             WidgetUtils.showImages(
              //                                 'assets/images/shouchong_wajueji.png',
              //                                 60.h,
              //                                 60.h)
              //                           ],
              //                         ),
              //                         WidgetUtils.onlyText(
              //                             '炫酷挖掘机3天',
              //                             StyleUtils.getCommonTextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: 14.sp)),
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //                 WidgetUtils.commonSizedBox(35.h, 0),
              //                 SizedBox(
              //                   width: 230.h,
              //                   child: Row(
              //                     children: [
              //                       Column(
              //                         children: [
              //                           Row(
              //                             children: [
              //                               WidgetUtils.commonSizedBox(0, 28.h),
              //                               WidgetUtils.showImages(
              //                                   'assets/images/shouchong_guangbo.png',
              //                                   60.h,
              //                                   60.h)
              //                             ],
              //                           ),
              //                           WidgetUtils.onlyText(
              //                               '麦上光波3天',
              //                               StyleUtils.getCommonTextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 14.sp)),
              //                         ],
              //                       ),
              //                       WidgetUtils.commonSizedBox(0, 22.h),
              //                       Column(
              //                         children: [
              //                           WidgetUtils.commonSizedBox(15.h, 0),
              //                           Row(
              //                             children: [
              //                               WidgetUtils.commonSizedBox(
              //                                   0, 25.h),
              //                               WidgetUtils.showImages(
              //                                   'assets/images/shouchong_xinrui.png',
              //                                   40.h,
              //                                   80.h)
              //                             ],
              //                           ),
              //                           WidgetUtils.commonSizedBox(5.h, 0),
              //                           WidgetUtils.onlyText(
              //                               '新锐徽章3天',
              //                               StyleUtils.getCommonTextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 14.sp)),
              //                         ],
              //                       )
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             )
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // )
              //     : type == 1
              //     ? SizedBox(
              //   height: 400.h,
              //   child: Column(
              //     children: [
              //       WidgetUtils.commonSizedBox(110.h, 0),
              //       SizedBox(
              //         height: 65.h,
              //         child: Row(
              //           children: [
              //             WidgetUtils.commonSizedBox(100.h, 0),
              //             const Spacer(),
              //             Text(
              //               '原价158元',
              //               style: TextStyle(
              //                   decoration: TextDecoration.lineThrough,
              //                   decorationColor: Colors.red,
              //                   decorationThickness: 2.0,
              //                   color: Colors.white,
              //                   fontSize: 20.sp),
              //             ),
              //             WidgetUtils.commonSizedBox(0, 10.h),
              //             Text(
              //               '限时优惠68元',
              //               style: TextStyle(
              //                   color: Colors.white, fontSize: 24.sp),
              //             ),
              //             WidgetUtils.commonSizedBox(0, 90.h),
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         height: 200.h,
              //         child: Row(
              //           children: [
              //             WidgetUtils.commonSizedBox(0, 70.h),
              //             SizedBox(
              //               width: 160.h,
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     children: [
              //                       WidgetUtils.commonSizedBox(0, 40.h),
              //                       WidgetUtils.showImages(
              //                           'assets/images/mine_wallet_dd.png',
              //                           120.h,
              //                           120.h),
              //                     ],
              //                   ),
              //                   const Spacer(),
              //                   Row(
              //                     children: [
              //                       WidgetUtils.commonSizedBox(0, 25.h),
              //                       WidgetUtils.onlyText(
              //                           '赠送680V豆',
              //                           StyleUtils.getCommonTextStyle(
              //                               color: Colors.white,
              //                               fontSize: 18.sp)),
              //                     ],
              //                   ),
              //                   WidgetUtils.commonSizedBox(7.h, 100.h),
              //                 ],
              //               ),
              //             ),
              //             Column(
              //               children: [
              //                 Row(
              //                   children: [
              //                     WidgetUtils.commonSizedBox(0, 65.h),
              //                     Column(
              //                       children: [
              //                         Row(
              //                           children: [
              //                             WidgetUtils.commonSizedBox(
              //                                 0, 20.h),
              //                             WidgetUtils.showImages(
              //                                 'assets/images/shouchong_emo.png',
              //                                 60.h,
              //                                 60.h)
              //                           ],
              //                         ),
              //                         WidgetUtils.onlyText(
              //                             '小恶魔头像框7天',
              //                             StyleUtils.getCommonTextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: 14.sp)),
              //                       ],
              //                     ),
              //                     WidgetUtils.commonSizedBox(0, 28.h),
              //                     Column(
              //                       children: [
              //                         Row(
              //                           children: [
              //                             WidgetUtils.commonSizedBox(
              //                                 0, 25.h),
              //                             WidgetUtils.showImages(
              //                                 'assets/images/shouchong_wajueji.png',
              //                                 60.h,
              //                                 60.h)
              //                           ],
              //                         ),
              //                         WidgetUtils.onlyText(
              //                             '炫酷挖掘机7天',
              //                             StyleUtils.getCommonTextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: 14.sp)),
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //                 WidgetUtils.commonSizedBox(35.h, 0),
              //                 SizedBox(
              //                   width: 230.h,
              //                   child: Row(
              //                     children: [
              //                       WidgetUtils.commonSizedBox(0, 10.h),
              //                       Column(
              //                         children: [
              //                           Row(
              //                             children: [
              //                               WidgetUtils.commonSizedBox(
              //                                   0, 20.h),
              //                               WidgetUtils.showImages(
              //                                   'assets/images/shouchong_guangbo.png',
              //                                   60.h,
              //                                   60.h)
              //                             ],
              //                           ),
              //                           WidgetUtils.onlyText(
              //                               '麦上光波7天',
              //                               StyleUtils
              //                                   .getCommonTextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 14.sp)),
              //                         ],
              //                       ),
              //                       WidgetUtils.commonSizedBox(0, 20.h),
              //                       Column(
              //                         children: [
              //                           WidgetUtils.commonSizedBox(
              //                               15.h, 0),
              //                           Row(
              //                             children: [
              //                               WidgetUtils.commonSizedBox(
              //                                   0, 25.h),
              //                               WidgetUtils.showImages(
              //                                   'assets/images/shouchong_xinrui.png',
              //                                   40.h,
              //                                   80.h)
              //                             ],
              //                           ),
              //                           WidgetUtils.commonSizedBox(
              //                               5.h, 0),
              //                           WidgetUtils.onlyText(
              //                               '新锐徽章7天',
              //                               StyleUtils
              //                                   .getCommonTextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 14.sp)),
              //                         ],
              //                       )
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             )
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // )
              //     : SizedBox(
              //   height: 400.h,
              //   child: Column(
              //     children: [
              //       WidgetUtils.commonSizedBox(110.h, 0),
              //       SizedBox(
              //         height: 65.h,
              //         child: Row(
              //           children: [
              //             WidgetUtils.commonSizedBox(100.h, 0),
              //             const Spacer(),
              //             Text(
              //               '原价228元',
              //               style: TextStyle(
              //                   decoration: TextDecoration.lineThrough,
              //                   decorationColor: Colors.red,
              //                   decorationThickness: 2.0,
              //                   color: Colors.white,
              //                   fontSize: 20.sp),
              //             ),
              //             WidgetUtils.commonSizedBox(0, 10.h),
              //             Text(
              //               '限时优惠98元',
              //               style: TextStyle(
              //                   color: Colors.white, fontSize: 24.sp),
              //             ),
              //             WidgetUtils.commonSizedBox(0, 90.h),
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         height: 200.h,
              //         child: Row(
              //           children: [
              //             WidgetUtils.commonSizedBox(0, 70.h),
              //             SizedBox(
              //               width: 160.h,
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     children: [
              //                       WidgetUtils.commonSizedBox(0, 40.h),
              //                       WidgetUtils.showImages(
              //                           'assets/images/mine_wallet_dd.png',
              //                           120.h,
              //                           120.h),
              //                     ],
              //                   ),
              //                   const Spacer(),
              //                   Row(
              //                     children: [
              //                       WidgetUtils.commonSizedBox(0, 25.h),
              //                       WidgetUtils.onlyText(
              //                           '赠送980V豆',
              //                           StyleUtils.getCommonTextStyle(
              //                               color: Colors.white,
              //                               fontSize: 18.sp)),
              //                     ],
              //                   ),
              //                   WidgetUtils.commonSizedBox(7.h, 100.h),
              //                 ],
              //               ),
              //             ),
              //             Column(
              //               children: [
              //                 Row(
              //                   children: [
              //                     WidgetUtils.commonSizedBox(0, 59.h),
              //                     Column(
              //                       children: [
              //                         Row(
              //                           children: [
              //                             WidgetUtils.commonSizedBox(
              //                                 0, 20.h),
              //                             WidgetUtils.showImages(
              //                                 'assets/images/shouchong_98emo.png',
              //                                 60.h,
              //                                 60.h)
              //                           ],
              //                         ),
              //                         WidgetUtils.onlyText(
              //                             '黄金骑士头像框7天',
              //                             StyleUtils.getCommonTextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: 14.sp)),
              //                       ],
              //                     ),
              //                     WidgetUtils.commonSizedBox(0, 25.h),
              //                     Column(
              //                       children: [
              //                         Row(
              //                           children: [
              //                             WidgetUtils.commonSizedBox(
              //                                 0, 25.h),
              //                             WidgetUtils.showImages(
              //                                 'assets/images/shouchong_feichuan.png',
              //                                 60.h,
              //                                 60.h)
              //                           ],
              //                         ),
              //                         WidgetUtils.onlyText(
              //                             '光速飞船7天',
              //                             StyleUtils.getCommonTextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: 14.sp)),
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //                 WidgetUtils.commonSizedBox(35.h, 0),
              //                 SizedBox(
              //                   width: 230.h,
              //                   child: Row(
              //                     children: [
              //                       Column(
              //                         children: [
              //                           Row(
              //                             children: [
              //                               WidgetUtils.commonSizedBox(
              //                                   0, 25.h),
              //                               WidgetUtils.showImages(
              //                                   'assets/images/shouchong_98gq.png',
              //                                   60.h,
              //                                   60.h)
              //                             ],
              //                           ),
              //                           WidgetUtils.onlyText(
              //                               '麦上光波7天',
              //                               StyleUtils
              //                                   .getCommonTextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 14.sp)),
              //                         ],
              //                       ),
              //                       WidgetUtils.commonSizedBox(0, 25.h),
              //                       Column(
              //                         children: [
              //                           WidgetUtils.commonSizedBox(
              //                               15.h, 0),
              //                           Row(
              //                             children: [
              //                               WidgetUtils.commonSizedBox(
              //                                   0, 25.h),
              //                               WidgetUtils.showImages(
              //                                   'assets/images/shouchong_xingui.png',
              //                                   40.h,
              //                                   80.h)
              //                             ],
              //                           ),
              //                           WidgetUtils.commonSizedBox(
              //                               5.h, 0),
              //                           WidgetUtils.onlyText(
              //                               '新贵徽章7天',
              //                               StyleUtils
              //                                   .getCommonTextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 14.sp)),
              //                         ],
              //                       )
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             )
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // ),
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
          isShow
              ? GestureDetector(
                  onTap: (() {
                    doPostOrderCreate();
                  }),
                  child: (sc12 == 0 && type == 0)
                      ? WidgetUtils.showImages(
                          'assets/images/shouchong_btn1.png', 100.h, 260.h)
                      : (sc12 == 1 && type == 0)
                          ? WidgetUtils.showImages(
                              'assets/images/shouchong_btn2.png', 100.h, 260.h)
                          : (sc100 == 0 && type == 1)
                              ? WidgetUtils.showImages(
                                  'assets/images/shouchong_btn1.png',
                                  100.h,
                                  260.h)
                              : (sc100 == 1 && type == 1)
                                  ? WidgetUtils.showImages(
                                      'assets/images/shouchong_btn2.png',
                                      100.h,
                                      260.h)
                                  : (sc266 == 0 && type == 2)
                                      ? WidgetUtils.showImages(
                                          'assets/images/shouchong_btn1.png',
                                          100.h,
                                          260.h)
                                      : WidgetUtils.showImages(
                                          'assets/images/shouchong_btn2.png',
                                          100.h,
                                          260.h),
                )
              : const Text(''),
          const Spacer(),
        ],
      ),
    );
  }

  /// 充值接口
  /// 支付方式 zfb(支付宝) wx(微信) yhk(银行卡) ysf(云闪付)
  /// 充值金额
  /// 充值类型 1人民币 2u币
  /// 货币类型 1金豆 2钻石
  /// 金豆数量
  /// 充值订单用途 1游戏币 2购买贵族
  /// 是否首充 1是 0否
  Future<void> doPostOrderCreate() async {
    String money = '', moneyDou = '';
    setState(() {
      if (type == 0) {
        money = '12';
        moneyDou = '100';
      } else if (type == 1) {
        money = '100';
        moneyDou = '1000';
      } else if (type == 2) {
        money = '266';
        moneyDou = '2660';
      }
    });
    Map<String, dynamic> params = <String, dynamic>{
      'recharge_method': 'zfb',
      'recharge_cur_amount': money,
      'recharge_cur_type': '1',
      'game_cur_type': '1',
      'game_cur_amount': moneyDou,
      'use': '1',
      'is_first': '1',
    };
    try {
      Loading.show();
      orderPayBean bean = await DataUtils.postOrderCreate(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // // ignore: use_build_context_synchronously
          // MyUtils.goTransparentPageCom(context, WebPage(url: bean.data!.payUrl!));
          if (await canLaunch(bean.data!.payUrl!)) {
            await launch(bean.data!.payUrl!, forceSafariVC: false);
          } else {
            throw 'Could not launch $bean.data!.payUrl!';
          }
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
    }
  }

  // 首充金额12、100、266状态0未首充1冲过了
  int sc12 = 0, sc100 = 0, sc266 = 0;

  // 是否显示充值按钮
  bool isShow = false;

  /// 首充
  Future<void> doPostIsFirstOrder() async {
    try {
      isFirstOrderBean bean = await DataUtils.postIsFirstOrder();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isShow = true;
            sc12 = bean.data!.twelve as int;
            sc100 = bean.data!.oneHundred as int;
            sc266 = bean.data!.twoSixSix as int;
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
