import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../utils/event_utils.dart';
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
      if(MyUtils.compare(event.title, '账单明细') == 0){
          Navigator.pushNamed(context, 'WalletMorePage');
      }
    });
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
                            WidgetUtils.showImages('assets/images/mine_wallet_dd.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
                            WidgetUtils.commonSizedBox(0, 15),
                            Expanded(child: Column(
                              children: [
                                const Expanded(child: Text('')),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText('豆', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(38))),
                                    const Expanded(child: Text('')),
                                    WidgetUtils.onlyText('1000000', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56), fontWeight: FontWeight.w600)),
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
                        /// 充值按钮
                        GestureDetector(
                          onTap: ((){
                              Navigator.pushNamed(context, 'DouPayPage');
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
                              '充值',
                              style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletPurple),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(20, 20),
                  /// 金币
                  SizedBox(
                    height: ScreenUtil().setHeight(250),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        WidgetUtils.showImagesFill('assets/images/mine_wallet_bbj.jpg', ScreenUtil().setHeight(250), double.infinity),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            WidgetUtils.showImages('assets/images/mine_wallet_bb.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
                            WidgetUtils.commonSizedBox(0, 15),
                            Expanded(child: Column(
                              children: [
                                const Expanded(child: Text('')),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText('币', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(38))),
                                    const Expanded(child: Text('')),
                                    WidgetUtils.onlyText('1000000', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56), fontWeight: FontWeight.w600)),
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
                              Navigator.pushNamed(context, 'TixianBiPage');
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
                              Navigator.pushNamed(context, 'BiZhuanDouPage');
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
                  /// 钻石
                  SizedBox(
                    height: ScreenUtil().setHeight(250),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        WidgetUtils.showImagesFill('assets/images/mine_wallet_zbj.jpg', ScreenUtil().setHeight(250), double.infinity),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            WidgetUtils.showImages('assets/images/mine_wallet_zz.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
                            WidgetUtils.commonSizedBox(0, 15),
                            Expanded(child: Column(
                              children: [
                                const Expanded(child: Text('')),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText('钻', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(38))),
                                    const Expanded(child: Text('')),
                                    WidgetUtils.onlyText('1000000', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56), fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(0, 15),
                                  ],
                                ),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText('美元数字货币USDT交易', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25))),
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
                            Navigator.pushNamed(context, 'TixianZuanPage');
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
                              style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletBlue),
                            ),
                          ),
                        ),
                        /// 充值
                        GestureDetector(
                          onTap: ((){
                            Navigator.pushNamed(context, 'ZuanPayPage');
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
                              '充值',
                              style: TextStyle(fontSize: ScreenUtil().setSp(29), color: MyColors.walletBlue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(20, 20),
                  WidgetUtils.onlyText('注意', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.commonSizedBox(5, 20),
                  WidgetUtils.onlyText('1.如果商城内无法完成支付，若遇到充值问题请联系在线客服', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.commonSizedBox(5, 20),
                  WidgetUtils.onlyText('2.非官方渠道充值一经发现一律封号', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.commonSizedBox(5, 20),
                  WidgetUtils.onlyText('3.充值即代表同意《用户充值协议》', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
