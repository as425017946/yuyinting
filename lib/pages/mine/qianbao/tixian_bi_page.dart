import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/isPayBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/regex_formatter.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/pay_ts_page.dart';
import '../setting/password_pay_page.dart';

/// V币提现
class TixianBiPage extends StatefulWidget {
  String shuliang;
  TixianBiPage({Key? key, required this.shuliang}) : super(key: key);

  @override
  State<TixianBiPage> createState() => _TixianBiPageState();
}

class _TixianBiPageState extends State<TixianBiPage> {
  var appBar;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAccount = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  String daozhang = '0';
  var listenTX, listenMM,listensl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('提现', true, context, false, 0);
    listenTX = eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '申请提现'){
        if(controllerName.text.isEmpty){
          MyToastUtils.showToastBottom('请输入姓名');
          return;
        }
        if(controllerAccount.text.isEmpty){
          MyToastUtils.showToastBottom('请输入账号');
          return;
        }
        if(controllerNumber.text.isEmpty){
          MyToastUtils.showToastBottom('请输入币数量');
          return;
        }
        if(double.parse(controllerNumber.text.toString()) >= 1100){
          setState(() {
            daozhang = (double.parse(controllerNumber.text.toString()) / 10*0.94).truncate().toStringAsFixed(0);
          });
        }else{
          MyToastUtils.showToastBottom('提现数量不足1100个，无法发起提现申请');
          return;
        }
        //先判断是否有支付密码
        doPostPayPwd();
      }
    });
    listenMM = eventBus.on<RoomBack>().listen((event) {
      if(event.title == '发红包已输入密码'){
        MyUtils.hideKeyboard(context);
        doPostWithdrawal(event.index!);
      }
    });

    listensl = eventBus.on<InfoBack>().listen((event) {
      setState(() {
        if(event.info.isEmpty){
          daozhang = '0';
        }else{
          daozhang = (double.parse(event.info) / 10*0.94).truncate().toStringAsFixed(0);
        }
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listenTX.cancel();
    listenMM.cancel();
    listensl.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        Expanded(
                            child: Column(
                              children: [
                                const Expanded(child: Text('')),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText(
                                        'V币',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(38))),
                                    const Spacer(),
                                    WidgetUtils.onlyText(
                                        widget.shuliang,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(56),
                                            fontWeight: FontWeight.w600)),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                                const Expanded(child: Text('')),
                              ],
                            )),
                      ],
                    ),

                    /// 兑换提示
                    // Container(
                    //   margin: const EdgeInsets.only(right: 15, bottom: 15),
                    //   child: Text(
                    //     '10V币=1元',
                    //     style: TextStyle(
                    //         fontSize: ScreenUtil().setSp(21),
                    //         color: Colors.white),
                    //   ),
                    // ),
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
                          child: TextField(
                            controller: controllerName,
                            inputFormatters: [
                              RegexFormatter(regex: MyUtils.regexFirstNotNull),
                            ],
                            style: StyleUtils.loginTextStyle,
                            onChanged: (value) {

                            },
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              // labelText: "请输入用户名",
                              // icon: Icon(Icons.people), //前面的图标
                              hintText: '请输入姓名',
                              hintStyle: StyleUtils.loginHintTextStyle,

                              contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                            ),
                          ),
                        ),
                      ],
                    ),
                    WidgetUtils.myLine(),
                    Row(
                      children: [
                        WidgetUtils.onlyText('支付宝账号', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: TextField(
                            controller: controllerAccount,
                            inputFormatters: [
                              RegexFormatter(regex: MyUtils.regexFirstNotNull),
                            ],
                            style: StyleUtils.loginTextStyle,
                            onChanged: (value) {

                            },
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              // labelText: "请输入用户名",
                              // icon: Icon(Icons.people), //前面的图标
                              hintText: '请输入账号',
                              hintStyle: StyleUtils.loginHintTextStyle,

                              contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                            ),
                          ),
                        ),
                      ],
                    ),
                    WidgetUtils.myLine(),
                    WidgetUtils.onlyText('提取V币', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                    Row(
                      children: [
                        WidgetUtils.showImages('assets/images/mine_wallet_bb.png', ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: WidgetUtils.commonTextFieldNumber(
                              controller: controllerNumber, hintText: '请输入V币数量'),
                        ),
                        GestureDetector(
                          onTap: ((){
                              if(double.parse(widget.shuliang) > 1100){
                                setState(() {
                                  controllerNumber.text = '${(double.parse(widget.shuliang).truncate() / 10).toStringAsFixed(0)}0';
                                  daozhang = (double.parse(widget.shuliang).truncate() / 10).toStringAsFixed(0);
                                });
                              }else{
                                MyToastUtils.showToastBottom('提现数量不足1100个');
                              }
                          }),
                          child: WidgetUtils.onlyText('全部', StyleUtils.getCommonTextStyle(color: MyColors.walletWZBlue, fontSize: ScreenUtil().setSp(32))),
                        ),
                      ],
                    ),
                    WidgetUtils.myLine(),
                    Row(
                      children: [
                        WidgetUtils.onlyText('到账金额', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.onlyText('￥$daozhang元', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
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
              WidgetUtils.onlyText('2.提取V币数必须≥1100 V币，否则无法发起申请', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText('3.V币提现收取6%手续费', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText('4.实际到账金额将精简到元，即抹除角分数值', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText('5.提款次日到账，节假日另行通知', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(20, 20),
              WidgetUtils.commonSubmitButton2('申请提现', MyColors.walletWZBlue),
            ],
          ),
        )
      ),
    );
  }

  /// 申请提现
  Future<void> doPostWithdrawal(mima) async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1', //1金币  2钻石
      'method': '2', //提现方式 2 支付宝 3银行卡
      'num': controllerNumber.text.toString(), //数量
      'account': controllerAccount.text.toString(), //账号或钱包地址
      'name': controllerName.text.toString(), // 名字
      'pay_pwd': mima, //支付密码
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postWithdrawal(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('已成功发起提现申请！');
          eventBus.fire(SubmitButtonBack(title: '金币提现成功'));
          Navigator.pop(context);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 是否设置了支付密码
  Future<void> doPostPayPwd() async {
    try {
      isPayBean bean = await DataUtils.postPayPwd();
      switch (bean.code) {
        case MyHttpConfig.successCode:
        //1已设置  0未设置
          if(bean.data!.isSet == 1){
            // 进入输入密码页面
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPage(context, const PayTSPage());
          }else{
            MyToastUtils.showToastBottom('请先设置支付密码！');
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(
                context,
                const PasswordPayPage());
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
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
