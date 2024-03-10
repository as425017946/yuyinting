import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/tgMyShareBean.dart';
import '../../../bean/tgmBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';

/// 推广页
class ShareTuiguangPage extends StatefulWidget {
  const ShareTuiguangPage({Key? key}) : super(key: key);

  @override
  State<ShareTuiguangPage> createState() => _ShareTuiguangPageState();
}

class _ShareTuiguangPageState extends State<ShareTuiguangPage> {
  String url = '', code = '';
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('推广分享', true, context, false, 0);
    // doPostGetPromotionCode();
    doPostGetPromoUrl();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: appBar,
    //   backgroundColor: MyColors.homeBG,
    //   body: Column(
    //     children: [
    //       WidgetUtils.commonSizedBox(20, 20),
    //       Container(
    //         height: 650.h,
    //         width: double.infinity,
    //         margin: EdgeInsets.all(20.h),
    //         child: WidgetUtils.CircleImageNet(
    //             650.h,
    //             double.infinity,
    //             ScreenUtil().setHeight(20),
    //             imgUrl),
    //       ),
    //       WidgetUtils.commonSizedBox(20, 20),
    //       /// 保存按钮
    //       Container(
    //         margin: const EdgeInsets.only(left: 20, right: 20),
    //         child: Row(
    //           children: [
    //             GestureDetector(
    //               onTap: (() {
    // if(MyUtils.checkClick()) {
    //   MyUtils.saveNetworkImageToGallery(imgUrl);
    // }
    //               }),
    //               child: WidgetUtils.myContainer(
    //                   ScreenUtil().setHeight(70),
    //                   ScreenUtil().setHeight(200),
    //                   MyColors.dailiShare,
    //                   MyColors.dailiShare,
    //                   '保存图片',
    //                   ScreenUtil().setSp(33),
    //                   Colors.black),
    //             ),
    //             WidgetUtils.commonSizedBox(0, 20),
    //             Expanded(
    //               child: GestureDetector(
    //                 onTap: (() {
    //                   Clipboard.setData(ClipboardData(
    //                     text: address,
    //                   ));
    //                   MyToastUtils.showToastBottom('已成功复制到剪切板');
    //                 }),
    //                 child: WidgetUtils.myContainer(
    //                     ScreenUtil().setHeight(70),
    //                     double.infinity,
    //                     MyColors.homeTopBG,
    //                     MyColors.homeTopBG,
    //                     '复制推广网址',
    //                     ScreenUtil().setSp(33),
    //                     Colors.white),
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          WidgetUtils.showImagesFill('assets/images/mine_tuiguang_bg.jpg',
              double.infinity, double.infinity),
          Column(
            children: [
              const Spacer(),
              Container(
                width: double.infinity.h,
                color: Colors.transparent,
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 40.h),
                    Container(
                      color: Colors.transparent,
                      child: WidgetUtils.onlyText(url, StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 26.sp,)),
                    ),
                    WidgetUtils.commonSizedBox(0, 15.h),
                    GestureDetector(
                      onTap: (() {
                        Clipboard.setData(ClipboardData(
                          text: url,
                        ));
                        MyToastUtils.showToastBottom('已成功复制到剪切板');
                      }),
                      child: Container(
                        width: 80.h,
                        height: 30.h,
                        alignment: Alignment.center,
                        //边框设置
                        decoration: BoxDecoration(
                          //背景
                          color: Colors.transparent,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                          //设置四周边框
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        child: WidgetUtils.onlyTextCenter('复制', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 22.sp,)),
                      ),
                    ),

                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(70.h, 0),
              Container(
                width: double.infinity.h,
                color: Colors.transparent,
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 40.h),
                    Container(
                      color: Colors.transparent,
                      child: WidgetUtils.onlyText(code, StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 70.sp, fontWeight: FontWeight.w600)),
                    ),
                    WidgetUtils.commonSizedBox(0, 40.h),
                    GestureDetector(
                      onTap: (() {
                        Clipboard.setData(ClipboardData(
                          text: code,
                        ));
                        MyToastUtils.showToastBottom('已成功复制到剪切板');
                      }),
                      child: Container(
                        width: 80.h,
                        height: 30.h,
                        alignment: Alignment.center,
                        //边框设置
                        decoration: BoxDecoration(
                          //背景
                          color: Colors.transparent,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                          //设置四周边框
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        child: WidgetUtils.onlyTextCenter('复制', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 22.sp,)),
                      ),
                    ),

                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(30.h, 0),
            ],
          )
        ],
      ),
    );
  }

  // /// 推广码
  // Future<void> doPostGetPromotionCode() async {
  //   Loading.show();
  //   try {
  //     tgmBean bean = await DataUtils.postGetPromotionCode();
  //     switch (bean.code) {
  //       case MyHttpConfig.successCode:
  //         setState(() {
  //           imgUrl = bean.data!.qrCode!;
  //           address = bean.data!.url!;
  //         });
  //         break;
  //       case MyHttpConfig.errorloginCode:
  //       // ignore: use_build_context_synchronously
  //         MyUtils.jumpLogin(context);
  //         break;
  //       default:
  //         MyToastUtils.showToastBottom(bean.msg!);
  //         break;
  //     }
  //     Loading.dismiss();
  //   } catch (e) {
  //     Loading.dismiss();
  //     // MyToastUtils.showToastBottom(MyConfig.errorTitle);
  //   }
  // }


  /// 推广码
  Future<void> doPostGetPromoUrl() async {
    Loading.show();
    try {
      tgMyShareBean bean = await DataUtils.postGetPromoUrl();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            url = bean.data!.url!;
            code = bean.data!.code!;
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
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

}
