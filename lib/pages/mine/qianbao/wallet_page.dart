import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/mine/qianbao/bi_zhuan_dou_page.dart';
import 'package:yuyinting/pages/mine/qianbao/dou_pay_page.dart';
import 'package:yuyinting/pages/mine/qianbao/tixian_bi_page.dart';
import 'package:yuyinting/pages/mine/qianbao/tixian_zuan_page.dart';
import 'package:yuyinting/pages/mine/qianbao/tq_dou_pay_page.dart';
import 'package:yuyinting/pages/mine/qianbao/wallet_more_page.dart';
import 'package:yuyinting/pages/mine/qianbao/zuan_pay_page.dart';
import 'package:yuyinting/utils/loading.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/balanceBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/my_toast_utils.dart';
import '../mine_smz_page.dart';
/// 我的钱包
class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('我的钱包', true, context, true, 2);
    eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '账单明细'){
          if(mounted){
            MyUtils.goTransparentPageCom(context, const WalletMorePage());
          }
      }else if(event.title == '金币提现成功'){
        doPostBalance();
      }
    });
    doPostBalance();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.myLine(thickness: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
              child: Column(
                children: [
                  /// 豆子
                  SizedBox(
                    height: ScreenUtil().setHeight(250),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        WidgetUtils.showImagesFill('assets/images/mine_wallet_dbj.jpg', ScreenUtil().setHeight(250), double.infinity),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            Container(
                              height: 100.h,
                              width: 100.h,
                              alignment: Alignment.center,
                              //边框设置
                              decoration: BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius: BorderRadius.all(Radius.circular(50.h)),
                              ),
                              child: WidgetUtils.showImages('assets/images/mine_wallet_dd.png', 65.h, 65.h),
                            ),
                            WidgetUtils.commonSizedBox(0, 15),
                            Expanded(child: Column(
                              children: [
                                const Expanded(child: Text('')),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText('V豆', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(38))),
                                    const Expanded(child: Text('')),
                                    WidgetUtils.onlyText(jinbi, StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56), fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(0, 15),
                                  ],
                                ),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText('可用于游戏和打赏礼物', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                                const Expanded(child: Text('')),
                              ],
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            /// 特权充值
                            (sp.getString('user_identity').toString() != 'president' || sp.getString('user_identity').toString() != 'leader') ? GestureDetector(
                              onTap: ((){
                                if (MyUtils.checkClick()) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return TQDouPayPage(shuliang: jinbi);
                                      })).then((value) {
                                    doPostBalance();
                                  });
                                }
                              }),
                              child: Container(
                                width: ScreenUtil().setHeight(150),
                                height: ScreenUtil().setHeight(50),
                                margin: const EdgeInsets.only(right: 15,bottom: 15),
                                alignment: Alignment.center,
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Text(
                                  '特权充值',
                                  style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletPurple),
                                ),
                              ),
                            ) : const Text(''),
                            /// 充值按钮
                            GestureDetector(
                              onTap: ((){
                                if (MyUtils.checkClick()) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return DouPayPage(shuliang: jinbi);
                                      })).then((value) {
                                    doPostBalance();
                                  });
                                }
                              }),
                              child: Container(
                                width: ScreenUtil().setHeight(115),
                                height: ScreenUtil().setHeight(50),
                                margin: const EdgeInsets.only(right: 15,bottom: 15),
                                alignment: Alignment.center,
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Text(
                                  '充值',
                                  style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletPurple),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(20, 20),
                  /// V币
                  SizedBox(
                    height: ScreenUtil().setHeight(250),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        WidgetUtils.showImagesFill('assets/images/mine_wallet_bbj.jpg', ScreenUtil().setHeight(250), double.infinity),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            Container(
                              height: 100.h,
                              width: 100.h,
                              alignment: Alignment.center,
                              //边框设置
                              decoration: BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius: BorderRadius.all(Radius.circular(50.h)),
                              ),
                              child: WidgetUtils.showImages('assets/images/mine_wallet_bb.png', 650.h, 65.h),
                            ),
                            WidgetUtils.commonSizedBox(0, 15),
                            Expanded(child: Column(
                              children: [
                                const Expanded(child: Text('')),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText('V币', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(38))),
                                    const Expanded(child: Text('')),
                                    WidgetUtils.onlyText(shouyi, StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56), fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(0, 15),
                                  ],
                                ),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText('礼物/全民代理/公会收益', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                                const Expanded(child: Text('')),
                              ],
                            )),
                          ],
                        ),
                        /// 提现
                        GestureDetector(
                          onTap: ((){
                            if(sp.getString('shimingzhi').toString() == '1'){
                              if (MyUtils.checkClick()) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return TixianBiPage(shuliang: shouyi);
                                    })).then((value) {
                                  doPostBalance();
                                });
                              }
                            }else if(sp.getString('shimingzhi').toString() == '0'){
                              MyToastUtils.showToastBottom('审核中，请耐心等待！');
                            }else{
                              MyUtils.goTransparentPageCom(context, const MineSMZPage());
                            }
                          }),
                          child: Container(
                            width: ScreenUtil().setHeight(115),
                            height: ScreenUtil().setHeight(50),
                            margin: const EdgeInsets.only(right: 105,bottom: 15),
                            alignment: Alignment.center,
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: Colors.white,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Text(
                              '提现',
                              style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletPink),
                            ),
                          ),
                        ),
                        /// 兑换
                        GestureDetector(
                          onTap: ((){
                            if (MyUtils.checkClick()) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return BiZhuanDouPage(shuliang: shouyi);
                                  })).then((value) {
                                doPostBalance();
                              });
                            }
                          }),
                          child: Container(
                            width: ScreenUtil().setHeight(115),
                            height: ScreenUtil().setHeight(50),
                            margin: EdgeInsets.only(right: 15,bottom: 15),
                            alignment: Alignment.center,
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: Colors.white,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Text(
                              '兑换',
                              style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletPink),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(20, 20),
                  // /// 钻石
                  // SizedBox(
                  //   height: ScreenUtil().setHeight(250),
                  //   child: Stack(
                  //     alignment: Alignment.bottomRight,
                  //     children: [
                  //       WidgetUtils.showImagesFill('assets/images/mine_wallet_zbj.jpg', ScreenUtil().setHeight(250), double.infinity),
                  //       Row(
                  //         children: [
                  //           WidgetUtils.commonSizedBox(0, 20),
                  //           Container(
                  //             height: 100.h,
                  //             width: 100.h,
                  //             alignment: Alignment.center,
                  //             //边框设置
                  //             decoration: BoxDecoration(
                  //               //背景
                  //               color: Colors.white,
                  //               //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  //               borderRadius: BorderRadius.all(Radius.circular(50.h)),
                  //             ),
                  //             child: WidgetUtils.showImages('assets/images/mine_wallet_zz.png', 650.h, 65.h),
                  //           ),
                  //           WidgetUtils.commonSizedBox(0, 15),
                  //           Expanded(child: Column(
                  //             children: [
                  //               const Expanded(child: Text('')),
                  //               Row(
                  //                 children: [
                  //                   WidgetUtils.onlyText('钻石', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(38))),
                  //                   const Expanded(child: Text('')),
                  //                   WidgetUtils.onlyText(zuanshi, StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56), fontWeight: FontWeight.w600)),
                  //                   WidgetUtils.commonSizedBox(0, 15),
                  //                 ],
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   WidgetUtils.onlyText('美元数字货币USDT交易', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25))),
                  //                   const Expanded(child: Text('')),
                  //                 ],
                  //               ),
                  //               const Expanded(child: Text('')),
                  //             ],
                  //           )),
                  //         ],
                  //       ),
                  //       /// 提现
                  //       GestureDetector(
                  //         onTap: ((){
                  //           MyUtils.goTransparentPageCom(context, TixianZuanPage(shuliang: zuanshi));
                  //         }),
                  //         child: Container(
                  //           width: ScreenUtil().setHeight(115),
                  //           height: ScreenUtil().setHeight(50),
                  //           margin: const EdgeInsets.only(right: 105,bottom: 15),
                  //           alignment: Alignment.center,
                  //           //边框设置
                  //           decoration: const BoxDecoration(
                  //             //背景
                  //             color: Colors.white,
                  //             //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //           ),
                  //           child: Text(
                  //             '提现',
                  //             style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletBlue),
                  //           ),
                  //         ),
                  //       ),
                  //       /// 充值
                  //       GestureDetector(
                  //         onTap: ((){
                  //           MyUtils.goTransparentPageCom(context, ZuanPayPage(shuliang: zuanshi));
                  //         }),
                  //         child: Container(
                  //           width: ScreenUtil().setHeight(115),
                  //           height: ScreenUtil().setHeight(50),
                  //           margin: EdgeInsets.only(right: 15,bottom: 15),
                  //           alignment: Alignment.center,
                  //           //边框设置
                  //           decoration: const BoxDecoration(
                  //             //背景
                  //             color: Colors.white,
                  //             //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //           ),
                  //           child: Text(
                  //             '充值',
                  //             style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletBlue),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // WidgetUtils.commonSizedBox(20, 20),
                  // WidgetUtils.onlyText('注意', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
                  // WidgetUtils.commonSizedBox(5, 20),
                  // WidgetUtils.onlyText('1.如果商城内无法完成支付，若遇到充值问题请联系在线客服', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
                  // WidgetUtils.commonSizedBox(5, 20),
                  // WidgetUtils.onlyText('2.非官方渠道充值一经发现一律封号', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
                  // WidgetUtils.commonSizedBox(5, 20),
                  // WidgetUtils.onlyText('3.充值即代表同意《用户充值协议》', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 金币 钻石
  String jinbi = '', zuanshi = '', shouyi  = '';
  /// 钱包余额
  Future<void> doPostBalance() async {
    Loading.show();
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            jinbi = bean.data!.goldBean!;
            // zuanshi = bean.data!.diamond!;
            shouyi = bean.data!.goldCoin!;
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
