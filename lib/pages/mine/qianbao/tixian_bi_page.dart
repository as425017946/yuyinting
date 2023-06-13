import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 金币提现
class TixianBiPage extends StatefulWidget {
  const TixianBiPage({Key? key}) : super(key: key);

  @override
  State<TixianBiPage> createState() => _TixianBiPageState();
}

class _TixianBiPageState extends State<TixianBiPage> {
  var appBar;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAccount = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('提现', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
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
                        'assets/images/mine_wallet_bbj.jpg',
                        ScreenUtil().setHeight(250),
                        double.infinity),
                    Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.showImages(
                            'assets/images/mine_wallet_bb.png',
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
                        '10币=1元',
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
                  color: Colors.white,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(20, 20),
                    Row(
                      children: [
                        WidgetUtils.onlyText('通道', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText('支付宝', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                      ],
                    ),
                    WidgetUtils.myLine(),
                    Row(
                      children: [
                        WidgetUtils.onlyText('姓名', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: WidgetUtils.commonTextField(
                              controllerName,  '请输入姓名'),
                        ),
                      ],
                    ),
                    WidgetUtils.myLine(),
                    Row(
                      children: [
                        WidgetUtils.onlyText('支付宝账号', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: WidgetUtils.commonTextField(
                              controllerAccount,  '请输入账号'),
                        ),
                      ],
                    ),
                    WidgetUtils.myLine(),
                    WidgetUtils.onlyText('提取金币', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                    Row(
                      children: [
                        WidgetUtils.showImages('assets/images/mine_wallet_jinbi.png', ScreenUtil().setHeight(48), ScreenUtil().setHeight(48)),
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: WidgetUtils.commonTextField(
                              controllerNumber,  '请输入币数量'),
                        ),
                        GestureDetector(
                          onTap: ((){

                          }),
                          child: WidgetUtils.onlyText('全部', StyleUtils.getCommonTextStyle(color: MyColors.walletWZBlue, fontSize: ScreenUtil().setSp(32))),
                        ),
                      ],
                    ),
                    WidgetUtils.myLine(),
                    Row(
                      children: [
                        WidgetUtils.onlyText('到账金币', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.onlyText('￥0', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(20, 20),
              WidgetUtils.onlyText('注意', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText('1.请确保支付宝账号和真实姓名一致，否则可能导致提现失败；（无需使用账号实名账户）', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText('2.提取金额必须为10的倍数且大于等于50，否则无法申请', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText('3.金币提现收取', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText('4.提款次日到账，节假日另行通知', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(20, 20),
              WidgetUtils.commonSubmitButton2('申请提现', MyColors.walletWZBlue),
            ],
          ),
        )
      ),
    );
  }
}
