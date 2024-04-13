import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/shopListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/style_utils.dart';
import '../qianbao/dou_pay_page.dart';

/// 展示3中时间的装扮
class ShowLiWuPage extends StatefulWidget {
  String imgUrl;
  String imgSVGAUrl;
  String dressID;
  List<StepPriceDay> list;
  String yue;

  ShowLiWuPage(
      {super.key,
      required this.imgUrl,
      required this.imgSVGAUrl,
      required this.dressID,
      required this.list,
      required this.yue});

  @override
  State<ShowLiWuPage> createState() => _ShowLiWuPageState();
}

class _ShowLiWuPageState extends State<ShowLiWuPage> {
  List<bool> listB = [false, false, false];
  bool isShow = false;

  /// 是否有选中的
  bool isChoose = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick()) {
                Navigator.pop(context);
              }
            }),
            child: Container(
              color: Colors.transparent,
            ),
          )),
          Container(
            height: widget.imgSVGAUrl.isNotEmpty ? 650.h : 550.h,
            width: double.infinity,
            padding: EdgeInsets.only(left: 30.h, right: 20.h),
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20.h, 20.w),
                widget.imgSVGAUrl.isNotEmpty
                    ? GestureDetector(
                        onTap: (() {
                          setState(() {
                            isShow = true;
                          });
                        }),
                        child: Row(
                          children: [
                            const Spacer(),
                            WidgetUtils.showImages(
                                'assets/images/zb_show.png', 44.h, 157.w),
                            WidgetUtils.commonSizedBox(0, 20.w),
                          ],
                        ),
                      )
                    : const Text(''),
                isShow == false
                    ? WidgetUtils.showImagesNet(
                        widget.imgUrl,
                        widget.imgSVGAUrl.isNotEmpty ? 200.h : 100.h,
                        widget.imgSVGAUrl.isNotEmpty ? 200.h : 100.h)
                    : const Text(''),
                isShow
                    ? SizedBox(
                        height: 200.h,
                        width: 200.h,
                        child: SVGASimpleImage(
                          resUrl: widget.imgSVGAUrl,
                        ))
                    : const Text(''),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          useDayLW = widget.list[0].useDay1!;
                          priceLW = widget.list[0].price1!;
                          isChoose = true;
                          isShow = false;
                          listB[0] = true;
                          if (listB.length > 1) {
                            listB[1] = false;
                          } else if (listB.length > 2) {
                            listB[2] = false;
                          }
                        });
                      }),
                      child: Container(
                        width: ScreenUtil().setHeight(180),
                        height: ScreenUtil().setHeight(120),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          //设置Container修饰
                          image: DecorationImage(
                            //背景图片修饰
                            image: AssetImage(listB[0] == true
                                ? "assets/images/zhuangban_bg2.png"
                                : "assets/images/zhuangban_bg1.png"),
                            fit: BoxFit.fill, //覆盖
                          ),
                        ),
                        child: Column(
                          children: [
                            WidgetUtils.commonSizedBox(20.h, 20),
                            WidgetUtils.onlyTextCenter(
                                '${widget.list[0].useDay1}天',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.newLoginblue2,
                                    fontSize: ScreenUtil().setSp(30))),
                            WidgetUtils.commonSizedBox(10.h, 20),
                            Row(
                              children: [
                                const Spacer(),
                                WidgetUtils.onlyTextCenter(
                                    widget.list[0].price1!,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(30))),
                                WidgetUtils.showImages(
                                    'assets/images/mine_wallet_dd.png',
                                    25.h,
                                    25.h),
                                const Spacer(),
                              ],
                            ),
                            WidgetUtils.commonSizedBox(10, 20),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    listB.length > 1
                        ? GestureDetector(
                            onTap: (() {
                              setState(() {
                                useDayLW = widget.list[0].useDay2!;
                                priceLW = widget.list[0].price2!;
                                isChoose = true;
                                isShow = false;
                                listB[0] = false;
                                listB[1] = true;
                                if (listB.length > 2) {
                                  listB[2] = false;
                                }
                              });
                            }),
                            child: Container(
                              width: ScreenUtil().setHeight(180),
                              height: ScreenUtil().setHeight(120),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                //设置Container修饰
                                image: DecorationImage(
                                  //背景图片修饰
                                  image: AssetImage(listB[1] == true
                                      ? "assets/images/zhuangban_bg2.png"
                                      : "assets/images/zhuangban_bg1.png"),
                                  fit: BoxFit.fill, //覆盖
                                ),
                              ),
                              child: Column(
                                children: [
                                  WidgetUtils.commonSizedBox(20.h, 20),
                                  WidgetUtils.onlyTextCenter(
                                      '${widget.list[0].useDay2}天',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.newLoginblue2,
                                          fontSize: ScreenUtil().setSp(30))),
                                  WidgetUtils.commonSizedBox(10.h, 20),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      WidgetUtils.onlyTextCenter(
                                          widget.list[0].price2!,
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(30))),
                                      WidgetUtils.showImages(
                                          'assets/images/mine_wallet_dd.png',
                                          25.h,
                                          25.h),
                                      const Spacer(),
                                    ],
                                  ),
                                  WidgetUtils.commonSizedBox(10, 20),
                                ],
                              ),
                            ),
                          )
                        : const Text(''),
                    const Spacer(),
                    listB.length > 2
                        ? GestureDetector(
                            onTap: (() {
                              setState(() {
                                useDayLW = widget.list[0].useDay3!;
                                priceLW = widget.list[0].price3!;
                                isChoose = true;
                                isShow = false;
                                listB[0] = false;
                                listB[1] = false;
                                listB[2] = true;
                              });
                            }),
                            child: Container(
                              width: ScreenUtil().setHeight(180),
                              height: ScreenUtil().setHeight(120),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                //设置Container修饰
                                image: DecorationImage(
                                  //背景图片修饰
                                  image: AssetImage(listB[2] == true
                                      ? "assets/images/zhuangban_bg2.png"
                                      : "assets/images/zhuangban_bg1.png"),
                                  fit: BoxFit.fill, //覆盖
                                ),
                              ),
                              child: Column(
                                children: [
                                  WidgetUtils.commonSizedBox(20.h, 20),
                                  WidgetUtils.onlyTextCenter(
                                      '${widget.list[0].useDay3}天',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.newLoginblue2,
                                          fontSize: ScreenUtil().setSp(30))),
                                  WidgetUtils.commonSizedBox(10.h, 20),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      WidgetUtils.onlyTextCenter(
                                          widget.list[0].price3!,
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(30))),
                                      WidgetUtils.showImages(
                                          'assets/images/mine_wallet_dd.png',
                                          25.h,
                                          25.h),
                                      const Spacer(),
                                    ],
                                  ),
                                  WidgetUtils.commonSizedBox(10, 20),
                                ],
                              ),
                            ),
                          )
                        : const Text(''),
                  ],
                ),
                WidgetUtils.commonSizedBox(40.h, 20.w),
                Row(
                  children: [
                    const Spacer(),
                    WidgetUtils.showImages(
                        'assets/images/mine_wallet_dd.png', 25.h, 25.h),
                    WidgetUtils.commonSizedBox(0, 5.w),
                    WidgetUtils.onlyTextCenter(
                        '金豆余额：',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(30))),
                    WidgetUtils.onlyTextCenter(
                        widget.yue,
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(30))),
                    WidgetUtils.commonSizedBox(0, 20.w),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          MyUtils.goTransparentPageCom(
                              context,
                              DouPayPage(
                                shuliang: widget.yue,
                              ));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          '去充值',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.newLoginblue2,
                              fontSize: ScreenUtil().setSp(30))),
                    ),
                    const Spacer(),
                  ],
                ),
                WidgetUtils.commonSizedBox(40.h, 20.w),
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      doPostBuyDress();
                    }
                  }),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(70),
                      ScreenUtil().setHeight(600),
                      MyColors.homeTopBG,
                      MyColors.homeTopBG,
                      '立即购买',
                      ScreenUtil().setSp(33),
                      Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String useDayLW = '0', priceLW = '0';

  /// 购买装扮
  Future<void> doPostBuyDress() async {
    if (isChoose == false) {
      MyToastUtils.showToastBottom('请选择要购买的装扮');
      return;
    }
    Map<String, dynamic> params = <String, dynamic>{
      'dress_id': widget.dressID, //装扮id
      'use_day': useDayLW,
      'price': priceLW
    };
    try {
      CommonBean bean = await DataUtils.postBuyDress(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          MyToastUtils.showToastBottom(MyConfig.buySuccess);
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
}
