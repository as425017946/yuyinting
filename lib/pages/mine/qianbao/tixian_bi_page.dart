import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/feilvBean.dart';
import '../../../bean/isPayBean.dart';
import '../../../colors/my_colors.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/regex_formatter.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/pay_ts_page.dart';
import '../setting/password_pay_page.dart';

/// 金币提现
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
  TextEditingController controllerYHKH = TextEditingController();
  TextEditingController controllerYHName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  String daozhang = '0';
  var listenTX, listenMM, listensl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGetRate();
    appBar = WidgetUtils.getAppBar('提现', true, context, false, 0);
    listenTX = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '申请提现') {
        if (controllerName.text.isEmpty) {
          MyToastUtils.showToastBottom('请输入姓名');
          return;
        }
        if (methodID == '2') {
          if (controllerAccount.text.isEmpty) {
            MyToastUtils.showToastBottom('请输入账号');
            return;
          }
          if (controllerNumber.text.isEmpty) {
            MyToastUtils.showToastBottom('请输入币数量');
            return;
          }
          if (double.parse(controllerNumber.text.toString()) >= 1100) {
            setState(() {
              daozhang =
                  (double.parse(controllerNumber.text.toString()) / 10 * (1-double.parse(feilv)))
                      .toInt()
                      .toString();
            });
          } else {
            MyToastUtils.showToastBottom('提现数量不足1100个，无法发起提现申请');
            return;
          }
          //先判断是否有支付密码
          doPostPayPwd();
        } else {
          if (controllerYHKH.text.isEmpty) {
            MyToastUtils.showToastBottom('请输入银行账号');
            return;
          }
          if (controllerYHName.text.isEmpty) {
            MyToastUtils.showToastBottom('请输入开户支行名称');
            return;
          }
          if (controllerNumber.text.isEmpty) {
            MyToastUtils.showToastBottom('请输入币数量');
            return;
          }
          if (double.parse(controllerNumber.text.toString()) >= 1100) {
            setState(() {
              daozhang =
                  (double.parse(controllerNumber.text.toString()) / 10 * (1-double.parse(feilv)))
                      .toInt()
                      .toString();
            });
          } else {
            MyToastUtils.showToastBottom('提现数量不足1100个，无法发起提现申请');
            return;
          }
          //先判断是否有支付密码
          doPostPayPwd();
        }
      }
    });
    listenMM = eventBus.on<RoomBack>().listen((event) {
      if (event.title == '发红包已输入密码') {
        MyUtils.hideKeyboard(context);
        doPostWithdrawal(event.index!);
      }
    });

    listensl = eventBus.on<InfoBack>().listen((event) {
      setState(() {
        if (event.info.isEmpty) {
          daozhang = '0';
        } else {
          daozhang = (double.parse(event.info) / 10 * (1-double.parse(feilv))).toInt().toString();
        }
      });
    });
  }

  late List<String> listTD = [];
  // String method = '支付宝', methodID = '2'; //提现方式 2 支付宝 3银行卡
  String method = '', methodID = '';
  ///data设置数据源，selectData设置选中下标，type 0代表第一个家长，1代表第二个家长 ，2代表选择性别
  void _onClickItem(var data, var selectData) {
    Pickers.showSinglePicker(
      context,
      data: data,
      selectData: selectData,
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {
        print('longer >>> 返回数据下标：$position');
        print('longer >>> 返回数据：$p');
        print('longer >>> 返回数据类型：${p.runtimeType}');
        setState(() {
          if (p == '支付宝') {
            method = p;
            methodID = '2';
          } else if (p == '银行卡') {
            method = p;
            methodID = '3';
          }
        });
        updrawalSave();
      },
    );
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
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: isOk ? SingleChildScrollView(
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
                        'assets/images/mine_wallet_bbj.png',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.h)),
                          ),
                          child: WidgetUtils.showImages(
                              'assets/images/mine_wallet_bb.png', 650.h, 65.h),
                        ),
                        WidgetUtils.commonSizedBox(0, 15),
                        Expanded(
                            child: Column(
                          children: [
                            const Expanded(child: Text('')),
                            Row(
                              children: [
                                WidgetUtils.onlyText(
                                    '金币',
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
                    //     '10金币=1元',
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
                // height: methodID == '2' ? 550.h : 650.h,
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
                        WidgetUtils.onlyText(
                            '通道',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g9,
                                fontSize: ScreenUtil().setSp(32))),
                        const Expanded(child: Text('')),
                        GestureDetector(
                            onTap: (() {
                              _onClickItem(listTD, '支付宝');
                            }),
                            child: WidgetUtils.onlyText(
                                method,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.g9,
                                    fontSize: ScreenUtil().setSp(32)))),
                        WidgetUtils.commonSizedBox(0, 10.h),
                        WidgetUtils.showImages(
                            'assets/images/mine_more.png',
                            ScreenUtil().setHeight(22),
                            ScreenUtil().setHeight(10))
                      ],
                    ),
                    WidgetUtils.myLine(),
                    Row(
                      children: [
                        WidgetUtils.onlyText(
                            methodID == '3' ? '卡主姓名' : '账号姓名',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g9,
                                fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: TextField(
                            controller: controllerName,
                            inputFormatters: [
                              // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                            ],
                            style: StyleUtils.loginTextStyle,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              // labelText: "请输入用户名",
                              // icon: Icon(Icons.people), //前面的图标
                              hintText:
                                  methodID == '3' ? '请填写真实卡主姓名' : '请填写真实姓名',
                              hintStyle: StyleUtils.loginHintTextStyle,

                              contentPadding:
                                  const EdgeInsets.only(top: 0, bottom: 0),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
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
                    WidgetUtils.onlyText(
                        methodID == '3'
                            ? '(请填写卡号对应真实姓名，误填将导致提现失败)'
                            : '(请填写账号准确实名全称，误填将导致提现失败)',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.red,
                            fontSize: ScreenUtil().setSp(22))),
                    WidgetUtils.myLine(),
                    methodID == '2'
                        ? Row(
                            children: [
                              WidgetUtils.onlyText(
                                  '支付宝账号',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.g9,
                                      fontSize: ScreenUtil().setSp(32))),
                              WidgetUtils.commonSizedBox(0, 20),
                              Expanded(
                                child: TextField(
                                  controller: controllerAccount,
                                  inputFormatters: [
                                    RegexFormatter(
                                        regex: MyUtils.regexFirstNotNull),
                                  ],
                                  style: StyleUtils.loginTextStyle,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    // labelText: "请输入用户名",
                                    // icon: Icon(Icons.people), //前面的图标
                                    hintText: '请输入账号',
                                    hintStyle: StyleUtils.loginHintTextStyle,

                                    contentPadding: const EdgeInsets.only(
                                        top: 0, bottom: 0),
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
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
                          )
                        : WidgetUtils.commonSizedBox(0, 0),
                    methodID == '3'
                        ? Row(
                            children: [
                              WidgetUtils.onlyText(
                                  '银行卡号',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.g9,
                                      fontSize: ScreenUtil().setSp(32))),
                              WidgetUtils.commonSizedBox(0, 20),
                              Expanded(
                                child: TextField(
                                  controller: controllerYHKH,
                                  inputFormatters: [
                                    RegexFormatter(
                                        regex: MyUtils.regexFirstNotNull),
                                  ],
                                  keyboardType: TextInputType.number,
                                  style: StyleUtils.loginTextStyle,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    hintText: '请输入银行卡号',
                                    hintStyle: StyleUtils.loginHintTextStyle,

                                    contentPadding: const EdgeInsets.only(
                                        top: 0, bottom: 0),
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
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
                          )
                        : WidgetUtils.commonSizedBox(0, 0),
                    methodID == '3'
                        ? WidgetUtils.myLine()
                        : WidgetUtils.commonSizedBox(0, 0),
                    methodID == '3'
                        ? Row(
                            children: [
                              WidgetUtils.onlyText(
                                  '开户支行名称',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.g9,
                                      fontSize: ScreenUtil().setSp(32))),
                              WidgetUtils.commonSizedBox(0, 20),
                              Expanded(
                                child: TextField(
                                  controller: controllerYHName,
                                  inputFormatters: [
                                    RegexFormatter(
                                        regex: MyUtils.regexFirstNotNull),
                                  ],
                                  style: StyleUtils.loginTextStyle,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    // labelText: "请输入用户名",
                                    // icon: Icon(Icons.people), //前面的图标
                                    hintText: '请输入开户支行名称',
                                    hintStyle: StyleUtils.loginHintTextStyle,

                                    contentPadding: const EdgeInsets.only(
                                        top: 0, bottom: 0),
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
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
                          )
                        : WidgetUtils.commonSizedBox(0, 0),
                    WidgetUtils.myLine(),
                    WidgetUtils.onlyText(
                        '提取金币',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g9,
                            fontSize: ScreenUtil().setSp(32))),
                    Row(
                      children: [
                        WidgetUtils.showImages(
                            'assets/images/mine_wallet_bb.png',
                            ScreenUtil().setHeight(30),
                            ScreenUtil().setHeight(30)),
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: WidgetUtils.commonTextFieldNumber(
                              controller: controllerNumber,
                              hintText: '请输入金币数量'),
                        ),
                        GestureDetector(
                          onTap: (() {
                            if (double.parse(widget.shuliang) > 1100) {
                              setState(() {
                                controllerNumber.text =
                                    '${double.parse(widget.shuliang).toInt()}';
                                daozhang = (double.parse(
                                            controllerNumber.text.toString()) /
                                        10 *
                                    (1-double.parse(feilv)))
                                    .toInt()
                                    .toString();
                              });
                            } else {
                              MyToastUtils.showToastBottom('提现数量不足1100个');
                            }
                          }),
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
                            '到账金额',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g9,
                                fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.onlyText(
                            '￥$daozhang元',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(32),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(40.w, 20),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(20, 20),
              WidgetUtils.onlyText(
                  '注意',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText(
                  // '1.请确保支付宝账号和真实姓名一致，否则可能导致提现失败；（无需使用账号实名账户）',
                  '1.请确保银行卡卡号和真实姓名一致，否则可能导致提现失败；',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText(
                  '2.提取金币数必须≥1100 金币，否则无法发起申请',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText(
                  '3.金币提现收取${double.parse(feilv)*100}%手续费',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText(
                  '4.实际到账金额将精简到元，即抹除角分数值',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(5, 20),
              WidgetUtils.onlyText(
                  '5.提款次日到账，节假日另行通知',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.commonSizedBox(20, 20),
              WidgetUtils.commonSubmitButton2('申请提现', MyColors.walletWZBlue),
            ],
          ),
        )) : const Text(''),
      ),
    );
  }

  
  void updrawalSave() {
    switch (methodID) {
      case '3': // 银行卡
        final save = sp.getStringList('drawal_3_save');
        if (save == null || save.length != 3) return;
        controllerName.text = save[0];
        controllerYHKH.text = save[1];
        controllerYHName.text = save[2];
        break;
      case '2': // 支付宝
        final save = sp.getStringList('drawal_2_save');
        if (save == null || save.length != 2) return;
        controllerName.text = save[0];
        controllerAccount.text = save[1];
        break;
      default:
    }
  }
  /// 申请提现
  Future<void> doPostWithdrawal(mima) async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1', //1金币  2钻石
      'method': methodID, //提现方式 2 支付宝 3银行卡
      'num': controllerNumber.text.trim().toString(), //数量
      'account': methodID == '2'
          ? controllerAccount.text.trim().toString()
          : controllerYHKH.text.trim().toString(), //账号或钱包地址
      'name': controllerName.text.toString(), // 名字
      'pay_pwd': mima, //支付密码
      'bank': controllerYHName.text.trim().toString()
    };
    // 本地记录上次提现的账号信息
    switch (methodID) {
      case '3': // 银行卡
        sp.setStringList('drawal_3_save', [params['name'], params['account'], params['bank']]);
        break;
      case '2': // 支付宝
        sp.setStringList('drawal_2_save', [params['name'], params['account']]);
        break;
      default:
    }
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
          if (bean.data!.isSet == 1) {
            // 进入输入密码页面
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPage(context, const PayTSPage());
          } else {
            MyToastUtils.showToastBottom('请先设置支付密码！');
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(context, const PasswordPayPage());
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

  String feilv = '';
  bool isOk = false;
  /// 提现费率
  Future<void> doPostGetRate() async {
    try {
      feilvBean bean = await DataUtils.postGetRate();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            feilv = bean.data!.rate!;
            isOk = true;
            if(bean.data!.wdlMethod!.contains('2')){
              listTD.add('支付宝');
              method = '支付宝';
              methodID = '2';
            }
            if(bean.data!.wdlMethod!.contains('3')){
              listTD.add('银行卡');
              method = '银行卡';
              methodID = '3';
            }
          });
          updrawalSave();
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
