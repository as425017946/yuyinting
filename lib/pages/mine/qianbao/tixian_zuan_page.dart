import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/qianbao/pay_mima_page.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 提现钻石
class TixianZuanPage extends StatefulWidget {
  const TixianZuanPage({Key? key}) : super(key: key);

  @override
  State<TixianZuanPage> createState() => _TixianZuanPageState();
}

class _TixianZuanPageState extends State<TixianZuanPage> {
  var appBar;
  int type = 0;
  TextEditingController controllerAccount = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('提现', true, context, false, 0);

    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      LogE('申请提现***${event.title}');
      if(event.title == '申请提现'){
        Future.delayed(const Duration(seconds: 0), () {
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return const PayMiMaPage();
              }));
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 豆子
            SizedBox(
              height: ScreenUtil().setHeight(250),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  WidgetUtils.showImagesFill(
                      'assets/images/mine_wallet_zbj.jpg',
                      ScreenUtil().setHeight(250),
                      double.infinity),
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 20),
                      WidgetUtils.showImages(
                          'assets/images/mine_wallet_zz.png',
                          ScreenUtil().setHeight(100),
                          ScreenUtil().setHeight(100)),
                      WidgetUtils.commonSizedBox(0, 15),
                      Expanded(
                          child: Column(
                        children: [
                          const Expanded(child: Text('')),
                          Row(
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(250),
                                padding: const EdgeInsets.only(top: 50),
                                child: Text(
                                  '币',
                                  style: StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(38)),
                                ),
                              ),
                              WidgetUtils.commonSizedBox(0, 50),
                              WidgetUtils.onlyText(
                                  '1000000',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(56),
                                      fontWeight: FontWeight.bold)),
                              const Expanded(child: Text('')),
                            ],
                          ),
                          const Expanded(child: Text('')),
                        ],
                      )),
                    ],
                  ),

                  /// 兑换提示
                  Container(
                    margin: const EdgeInsets.only(right: 15, bottom: 15),
                    child: Text(
                      '钻石=充值USDT*实时汇率*10',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(21),
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(20, 20),
            Container(
              height: ScreenUtil().setHeight(500),
              padding: const EdgeInsets.only(left: 30, right: 30),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: MyColors.walletGrayBG,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(20, 20),
                  Row(
                    children: [
                      WidgetUtils.onlyText(
                          '提现币种',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(32))),
                      WidgetUtils.commonSizedBox(0, 20),
                      WidgetUtils.onlyText(
                          'USDT-TRC20',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(32))),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: (() {}),
                        child: WidgetUtils.onlyText(
                            '更换',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.walletWZBlue,
                                fontSize: ScreenUtil().setSp(32))),
                      ),
                    ],
                  ),
                  WidgetUtils.myLine(),
                  WidgetUtils.onlyText(
                      '提现地址',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g9,
                          fontSize: ScreenUtil().setSp(32))),
                  WidgetUtils.commonTextField(controllerAccount, '请输入USDT钱包地址'),
                  WidgetUtils.myLine(),
                  WidgetUtils.onlyText(
                      '提取钻石数量',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g9,
                          fontSize: ScreenUtil().setSp(32))),
                  Row(
                    children: [
                      WidgetUtils.showImages(
                          'assets/images/mine_wallet_zuanshi.png',
                          ScreenUtil().setHeight(48),
                          ScreenUtil().setHeight(48)),
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                        child: WidgetUtils.commonTextField(
                            controllerNumber, '请输入钻石数量'),
                      ),
                      GestureDetector(
                        onTap: (() {}),
                        child: WidgetUtils.onlyText(
                            '全部',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.walletWZBlue,
                                fontSize: ScreenUtil().setSp(32))),
                      ),
                    ],
                  ),
                  WidgetUtils.myLine(),
                  Row(
                    children: [
                      WidgetUtils.onlyText(
                          '人民币金额：xx元',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(28))),
                      const Expanded(child: Text('')),
                      WidgetUtils.onlyText(
                          '汇率：6.98',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(28))),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 20),
                  WidgetUtils.onlyText(
                      '交易数量：xx USDT',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g9,
                          fontSize: ScreenUtil().setSp(28))),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(20, 20),
            WidgetUtils.onlyText(
                '钻石提现规则',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
            type == 0
                ? Column(
                    children: [
                      WidgetUtils.commonSizedBox(5, 20),
                      WidgetUtils.onlyText(
                          '1.USDT提现申请将在10分钟内即时到账',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(25))),
                      WidgetUtils.commonSizedBox(5, 20),
                      WidgetUtils.onlyText(
                          '2.提取金额无任何要求；',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(25))),
                      WidgetUtils.commonSizedBox(5, 20),
                      WidgetUtils.onlyText(
                          '3.钻石提现USDT，不收取提现手续费；',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(25))),
                      WidgetUtils.commonSizedBox(20, 20),
                    ],
                  )
                : Column(
                    children: [
                      WidgetUtils.commonSizedBox(5, 20),
                      WidgetUtils.onlyText(
                          '1.请确保支付宝账号和真实姓名一致，否则可能导致提现失败；（无需使用账号实名账户）',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(25))),
                      WidgetUtils.commonSizedBox(5, 20),
                      WidgetUtils.onlyText(
                          '2.提取金额必须为10的倍数且大于等于50，否则无法申请；',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(25))),
                      WidgetUtils.commonSizedBox(5, 20),
                      WidgetUtils.onlyText(
                          '3.钻石提现人民币，收取5%提现手续费；',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(25))),
                      WidgetUtils.commonSizedBox(5, 20),
                      WidgetUtils.onlyText(
                          '4.提款次日到账，节假日另行通知',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(25))),
                      WidgetUtils.commonSizedBox(20, 20),
                    ],
                  ),
            WidgetUtils.commonSubmitButton2(
                '申请提现', MyColors.walletWZBlue),
          ],
        ),
      )),
    );
  }
}
