import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/isPayBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/pay_ts_page.dart';
import '../setting/password_pay_page.dart';
/// 币转豆 页面
class BiZhuanDouPage extends StatefulWidget {
  String shuliang;
  BiZhuanDouPage({Key? key,required this.shuliang}) : super(key: key);

  @override
  State<BiZhuanDouPage> createState() => _BiZhuanDouPageState();
}

class _BiZhuanDouPageState extends State<BiZhuanDouPage> {
  TextEditingController controllerNumber = TextEditingController();
  var appBar;
  String daozhang = '0';
  var listenTX, listenMM,listensl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('V币兑换V豆', true, context, false, 0);
    listenTX = eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '确认兑换'){
        LogE('数量 ${controllerNumber.text.toString()}');
        if(controllerNumber.text.toString().isEmpty){
          MyToastUtils.showToastBottom('请输入币数量');
          return;
        }
        setState(() {
          daozhang = double.parse(controllerNumber.text.toString()).toStringAsFixed(0);
        });
        //先判断是否有支付密码
        doPostPayPwd();
      }
    });
    listenMM = eventBus.on<RoomBack>().listen((event) {
      if(event.title == '发红包已输入密码'){
        MyUtils.hideKeyboard(context);
        doPostExchangeCurrency(event.index!);
      }
    });
    listensl = eventBus.on<InfoBack>().listen((event) {
      setState(() {
        if(event.info.isEmpty){
          daozhang = '0';
        }else{
          daozhang = double.parse(event.info).toStringAsFixed(0);
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
      appBar: appBar,
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Column(
          children: [
            WidgetUtils.myLine(thickness: 10),
            Container(
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
                        Container(
                          margin: const EdgeInsets.only(right: 15, bottom: 15),
                          child: Text(
                            '1V币=1V豆',
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
                    height: ScreenUtil().setHeight(280),
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
                        WidgetUtils.commonSizedBox(30, 20),
                        WidgetUtils.onlyText('提取V币', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                        Row(
                          children: [
                            WidgetUtils.showImages('assets/images/mine_wallet_bb.png', ScreenUtil().setHeight(48), ScreenUtil().setHeight(48)),
                            WidgetUtils.commonSizedBox(0, 20),
                            Expanded(
                              child: WidgetUtils.commonTextFieldNumber(
                                  controller: controllerNumber, hintText: '请输入V币数量'),
                            ),
                            GestureDetector(
                              onTap: ((){
                                if(double.parse(widget.shuliang) > 1){
                                  setState(() {
                                    //舍弃当前变量的小数部分
                                    controllerNumber.text = double.parse(widget.shuliang).toInt().toString();
                                    daozhang = (double.parse(widget.shuliang).truncate()).toInt().toString();
                                  });
                                }else{
                                  MyToastUtils.showToastBottom('提现数量不足1个');
                                }
                              }),
                              child: WidgetUtils.onlyText('全部', StyleUtils.getCommonTextStyle(color: MyColors.walletWZBlue, fontSize: ScreenUtil().setSp(32))),
                            ),
                          ],
                        ),
                        WidgetUtils.myLine(),
                        WidgetUtils.commonSizedBox(20, 20),
                        Row(
                          children: [
                            WidgetUtils.onlyText('到账', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                            WidgetUtils.showImages('assets/images/mine_wallet_dd.png', ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                            WidgetUtils.commonSizedBox(0, 10),
                            WidgetUtils.onlyText('$daozhang V豆', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                          ],
                        )
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(20, 20),
                  WidgetUtils.commonSubmitButton2('确认兑换', MyColors.walletWZBlue),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 币转豆
  Future<void> doPostExchangeCurrency(String mima) async {
    Map<String, dynamic> params = <String, dynamic>{
      'gold_coin': controllerNumber.text.toString(), // 兑换金币数量
      'pay_pwd' : mima,
    };
    try {
      CommonBean bean = await DataUtils.postExchangeCurrency(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('兑换成功！');
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
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
            MyUtils.goTransparentPage(context, PayTSPage());
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
