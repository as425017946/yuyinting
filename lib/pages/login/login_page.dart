import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yuyinting/pages/navigator/tabnavigator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import '../../bean/Common_bean.dart';
import '../../bean/addressIPBean.dart';
import '../../bean/loginBean.dart';
import '../../bean/pdAddressBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/SVGASimpleImage.dart';
import '../home/agree_ts_page.dart';

///登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerSmg = TextEditingController();
  TextEditingController controllerAccount = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  /// 判断点击的是哪个 0没有点击 1发送验证码 2立即登录
  int type = 0;
  var zhanghao = '账号登录';
  String quhao = '+86';
  bool gz = true;
  bool isClick = false;
  bool isMiMa = false;
  var listen,listen2;
  String IP = '', IMEI = '';
  @override
  void initState() {
    setState(() {
      sp.setBool('joinRoom', false);
    });
    // TODO: implement initState
    super.initState();
    doPostPdAddress();
    // getIPAddress();
    getDeviceIMEI();
    // 在登录页先设置所有游戏的音频开关默认开启，false为开始，true为关闭
    sp.setBool('zp_xin', false);
    sp.setBool('zp_super', false);
    sp.setBool('mf_lan', false);
    sp.setBool('mf_jin', false);
    sp.setBool('car_play', false);

    listen = eventBus.on<AddressBack>().listen((event) {
      setState(() {
        quhao = event.info;
      });
    });

    listen2 = eventBus.on<LoginBack>().listen((event) {
      // Future.value(true);
      exit(0);
    });

    if (sp.getString(MyConfig.userOneToken).toString() == 'null') {
      sp.setString(MyConfig.userOneToken, '');
    }
    if (sp.getString(MyConfig.userTwoToken).toString() == 'null') {
      sp.setString(MyConfig.userTwoToken, '');
    }
    if (sp.getString(MyConfig.userThreeToken).toString() == 'null') {
      sp.setString(MyConfig.userThreeToken, '');
    }
    if (sp.getString('user_token').toString() == 'null') {
      sp.setString('user_token', '');
    }

    if (sp.getString('user_token').toString().isNotEmpty &&
        MyConfig.issAdd == false) {
      doGo();
    }

    // if (sp.getString('myAgree').toString() == 'null' || sp.getString('myAgree').toString() == '0') {
    //   MyUtils.goTransparentPageCom(context, const AgreeTSPage());
    // }
    // 首次预下载使用
    if(sp.getString("isFirstDown").toString() == 'null'){
      sp.setString("isFirstDown",'1');
    }
    ceshi();
  }

  String pid = '';
  void ceshi() async{
    List<String> uirlInfo = [];
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain!);
    if (data != null) {
      setState(() {
        if(data.text!.contains('?')){
          uirlInfo = data.text!.split('?');
          // 有代理有房间id
          if(uirlInfo[1].contains('&')){
            uirlInfo = uirlInfo[1].split('&');
            pid = uirlInfo[0].split('=')[1];
            LogE('代理id $pid');
            sp.setString('daili_roomid', uirlInfo[1].split('=')[1]);
            LogE('房间id ${uirlInfo[1].split('=')[1]}');
          }else{
            // 只有代理id
            pid = uirlInfo[1].split('=')[1];
            LogE('代理id $pid');
            sp.setString('daili_roomid', '');
          }

        }
      });
    }else{
      // MyToastUtils.showToastBottom('没有获取到剪切板信息');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listen2.cancel();
  }

  Timer? _timer;
  int _timeCount = 60;
  var _autoCodeText = '发送验证码';

  void _startTimer() {
    MyToastUtils.showToastBottom('短信验证码已发送，请注意查收');
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_timeCount <= 0) {
                  _autoCodeText = '重新获取';
                  _timer!.cancel();
                  _timeCount = 60;
                } else {
                  _timeCount -= 1;
                  _autoCodeText = "${_timeCount}s";
                }
              })
            });
  }

  // void getIPAddress() async {
  //   for (var interface in await NetworkInterface.list()) {
  //     for (var addr in interface.addresses) {
  //       if (addr.type == InternetAddressType.IPv4) {
  //         setState(() {
  //           IP = addr.address;
  //         });
  //         print('IP地址: ${addr.address}');
  //       }
  //     }
  //   }
  // }
  void getDeviceIMEI() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // String imei = '${androidInfo.id}:${androidInfo.device}:${androidInfo.model}:${androidInfo.product}:${androidInfo.isPhysicalDevice}:${sp.getString('miyao')}'; // 获取 Android 设备的 IMEI
      String imei = androidInfo.id;
      setState(() {
        IMEI = imei;
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      String identifierForVendor = iosInfo.identifierForVendor.toString(); // 获取 iOS 设备的 IMEI
      setState(() {
        IMEI = identifierForVendor;
      });
      print('IMEI: $identifierForVendor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: MyColors.loginBG,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (() {
                      MyUtils.hideKeyboard(context);
                    }),
                    child: Container(
                      height: 630.h,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: const SVGASimpleImage(
                        assetsName: 'assets/svga/login.svga',
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(80),
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 10, left: 40, right: 40, bottom: 20),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: isClick == false
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: (() {
                                  // Navigator.pushNamed(
                                  //     context, 'ChooseCountryPage');
                                }),
                                child: Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 15),
                                    WidgetUtils.onlyText(
                                        quhao,
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.g3,
                                            fontSize: ScreenUtil().setSp(30),
                                            fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    // WidgetUtils.showImages(
                                    //     'assets/images/login_xia.png',
                                    //     ScreenUtil().setHeight(12),
                                    //     ScreenUtil().setHeight(18))
                                  ],
                                ),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                              Expanded(
                                child: Container(
                                  height: ScreenUtil().setHeight(60),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    enabled: true,
                                    obscureText: false,
                                    controller: controllerPhone,
                                    inputFormatters: [
                                      RegexFormatter(regex: MyUtils.regexFirstNotNull),
                                      FilteringTextInputFormatter.digitsOnly,
                                      //设置只能输入11位
                                      LengthLimitingTextInputFormatter(11),
                                    ],
                                    keyboardType: TextInputType.number,
                                    //设置键盘为数字
                                    style: StyleUtils.loginTextStyle,
                                    onChanged: (value) {

                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '请输入手机号',
                                      hintStyle: StyleUtils.loginHintTextStyle,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              Expanded(
                                child: Container(
                                  height: ScreenUtil().setHeight(60),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: WidgetUtils.commonTextField(
                                      controllerAccount, '请输入账号'),
                                ),
                              )
                            ],
                          ),
                  ),
                  isMiMa == false && isClick == false
                      ? SizedBox(
                          height: ScreenUtil().setHeight(80),
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 40),
                              Expanded(
                                child: Container(
                                    height: ScreenUtil().setHeight(80),
                                    padding: const EdgeInsets.only(left: 15),
                                    width: double.infinity,
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25.0)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child:
                                                WidgetUtils.commonTextFieldNumber(
                                                    controller: controllerSmg,
                                                    hintText: '请输入验证码')),
                                        GestureDetector(
                                          onTap: (() {
                                            if(MyUtils.checkClick()) {
                                              setState(() {
                                                type = 1;
                                              });
                                              if (_autoCodeText == '发送验证码' ||
                                                  _autoCodeText == '重新获取') {
                                                if (controllerPhone.text
                                                    .trim()
                                                    .isEmpty) {
                                                  MyToastUtils.showToastBottom(
                                                      '请输入手机号');
                                                } else if (!MyUtils.chinaPhoneNumber(controllerPhone.text.trim())) {
                                                  MyToastUtils.showToastBottom(
                                                      '输入的手机号码格式错误');
                                                } else {
                                                  //没有ip
                                                  if(sp.getString('userIP').toString().isEmpty){
                                                    doPostPdAddress();
                                                  }else{
                                                    doPostLoginSms();
                                                  }
                                                }
                                              }
                                            }
                                          }),
                                          child: Container(
                                            height: 60.h,
                                            width: ScreenUtil().setHeight(150),
                                            //边框设置
                                            decoration: const BoxDecoration(
                                              //背景
                                              color: MyColors.dailiBaobiao,
                                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0)),
                                            ),
                                            child: WidgetUtils.onlyTextCenter(
                                                _autoCodeText,
                                                StyleUtils.getCommonTextStyle(
                                                    color: MyColors.homeTopBG,
                                                    fontSize: 26.sp)),
                                          ),
                                        ),
                                        WidgetUtils.commonSizedBox(0, 5),
                                      ],
                                    )),
                              ),
                              WidgetUtils.commonSizedBox(0, 10),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    isMiMa = !isMiMa;
                                  });
                                }),
                                child: Container(
                                  width: 100.h,
                                  color: Colors.transparent,
                                  child: WidgetUtils.onlyText('密码登录', StyleUtils.getCommonTextStyle(color: MyColors.homeTopBG,
                                      fontSize: 26.sp, fontWeight: FontWeight.w600)),
                                )
                                // WidgetUtils.showImages(
                                //     isMiMa
                                //         ? 'assets/images/login_sms.png'
                                //         : 'assets/images/login_password.png',
                                //     80.h,
                                //     50.h),
                              ),
                              WidgetUtils.commonSizedBox(0, 40),
                            ],
                          ),
                        )
                      : Container(
                          height: ScreenUtil().setHeight(80),
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                height: ScreenUtil().setHeight(80),
                                padding: EdgeInsets.only(left: 15, top: 5.h),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                                child: WidgetUtils.commonTextFieldIsShow(
                                    controllerPass, '请输入密码', true),
                              )),
                              WidgetUtils.commonSizedBox(0, 10),
                              zhanghao == '账号登录' ? GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    isMiMa = !isMiMa;
                                  });
                                }),
                                child: Container(
                                  width: 110.h,
                                  color: Colors.transparent,
                                  child: WidgetUtils.onlyText(isMiMa ? '验证码登录' : '密码', StyleUtils.getCommonTextStyle(color: MyColors.homeTopBG,
                                      fontSize: 26.sp, fontWeight: FontWeight.w600)),
                                ),
                              ) : const Text(''),
                            ],
                          )),
                  WidgetUtils.commonSizedBox(30, 0),
                  GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        setState(() {
                          type = 2;
                        });
                        //没有ip
                        if(sp.getString('userIP').toString().isEmpty){
                          doPostPdAddress();
                        }else{
                          doLogin();
                        }
                      }
                    }),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      height: ScreenUtil().setHeight(80),
                      alignment: Alignment.center,
                      width: double.infinity,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.loginBtnP,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Text(
                        '立即登录',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(20, 0),
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    child: Row(
                      children: [
                        // const Expanded(child: Text('')),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              isClick = !isClick;
                              if (zhanghao == '账号登录') {
                                zhanghao = '手机号登录';
                              } else {
                                zhanghao = '账号登录';
                              }
                            });
                          }),
                          child: WidgetUtils.onlyText(
                              zhanghao,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeTopBG,
                                  fontSize: ScreenUtil().setSp(28))),
                        ),
                        const Expanded(child: Text('')),
                        zhanghao == '账号登录' ? GestureDetector(
                          onTap: (() {
                            Navigator.pushNamed(context, 'ForgotPasswordPage');
                          }),
                          child: WidgetUtils.onlyText(
                              '忘记密码',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.g6,
                                  fontSize: ScreenUtil().setSp(28))),
                        ) : const Text(''),
                      ],
                    ),
                  ),
                  const Expanded(child: Text('')),
                  WidgetUtils.commonSizedBox(15, 0),
                  Row(
                    children: [
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            gz = !gz;
                          });
                        }),
                        child: WidgetUtils.showImages(
                            gz == false
                                ? 'assets/images/login_ck1.png'
                                : 'assets/images/login_ck2.png',
                            15,
                            15),
                      ),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.onlyText(
                          '继续即表示同意',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(28))),
                      GestureDetector(
                        onTap: (() {
                          Navigator.pushNamed(context, 'YonghuPage');
                        }),
                        child: WidgetUtils.onlyText(
                            '用户协议',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.homeTopBG,
                                fontSize: ScreenUtil().setSp(25))),
                      ),
                      WidgetUtils.onlyText(
                          '和',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(25))),
                      GestureDetector(
                        onTap: (() {
                          Navigator.pushNamed(context, 'YinsiPage');
                        }),
                        child: WidgetUtils.onlyText(
                            '隐私协议',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.homeTopBG,
                                fontSize: ScreenUtil().setSp(25))),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(20, 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> doGo() async {
    Future.delayed(const Duration(microseconds: 500), () {
      //跳转并关闭当前页面
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Tab_Navigator()),
        // ignore: unnecessary_null_comparison
        (route) => route == null,
      );
    });
  }

  ///登录
  Future<void> doLogin() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versions = packageInfo.version;
    sp.setString('myVersion1', versions);

    final String userName = controllerAccount.text.trim();
    final String passWord = controllerPass.text.trim();
    final String userPhone = controllerPhone.text.trim();
    final String userMsg = controllerSmg.text.trim();
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> params;

    // ceshi();


    if (isClick) {
      if (userName.isEmpty) {
        MyToastUtils.showToastBottom("用户名不能为空");
        return;
      }
      if (passWord.isEmpty) {
        MyToastUtils.showToastBottom("用户密码不能为空");
        return;
      }
      params = <String, dynamic>{
        'username': userName,
        'password': passWord,
        'type': '1',
        'imei': IMEI,
        'pid': RegExp(r'^-?[0-9.]+$').hasMatch(pid) ? pid : '',
        'ip' : IP.isEmpty ? sp.getString('userIP').toString() : IP
      };
    } else {
      String type = '';
      if (userPhone.isEmpty) {
        MyToastUtils.showToastBottom("手机号不能为空");
        return;
      }

      if (isMiMa == false) {
        type = '2';
        if (userMsg.isEmpty) {
          MyToastUtils.showToastBottom("验证码不能为空");
          return;
        }
      } else {
        type = '3';
        if (passWord.isEmpty) {
          MyToastUtils.showToastBottom("用户密码不能为空");
          return;
        }
      }

      params = <String, dynamic>{
        'phone': userPhone,
        'password': passWord,
        'type': type,
        'area_code': quhao,
        'code': userMsg,
        'imei': IMEI,
        'pid': RegExp(r'^-?[0-9.]+$').hasMatch(pid) ? pid : '',
        'ip' : IP.isEmpty ? sp.getString('userIP').toString() : IP
      };
    }

    try {
      Loading.show("登录中...");
      LoginBean loginBean = await DataUtils.login(params);
      switch (loginBean.code) {
        case MyHttpConfig.successCode:
          LogE('登录${MyConfig.issAdd}');
          LogE('登录${sp.getString(MyConfig.userOneToken).toString()}');
          if (MyConfig.issAdd == false) {
            if(loginBean.data!.uid.toString() == sp.getString(MyConfig.userOneUID).toString()){
              //如果是直接覆盖
              sp.setString(MyConfig.userOneUID, loginBean.data!.uid.toString());
              sp.setString(
                  MyConfig.userOneHeaderImg, loginBean.data!.avatarUrl!);
              sp.setString(MyConfig.userOneName, loginBean.data!.nickname!);
              sp.setString(MyConfig.userOneToken, loginBean.data!.token!);
              sp.setString(
                  MyConfig.userOneID, loginBean.data!.number.toString());
            }else if(loginBean.data!.uid.toString() == sp.getString(MyConfig.userTwoUID).toString()){
              // 判断登录的账号是不是存在了第2个信息里面
              // 如果是直接覆盖
              sp.setString(
                  MyConfig.userTwoUID, loginBean.data!.uid.toString());
              sp.setString(
                  MyConfig.userTwoHeaderImg, loginBean.data!.avatarUrl!);
              sp.setString(MyConfig.userTwoName, loginBean.data!.nickname!);
              sp.setString(MyConfig.userTwoToken, loginBean.data!.token!);
              sp.setString(
                  MyConfig.userTwoID, loginBean.data!.number.toString());
            }else if(loginBean.data!.uid.toString() == sp.getString(MyConfig.userThreeUID).toString()){
              // 判断登录的账号是不是存在了第3个信息里面
              // 如果是直接覆盖
              sp.setString(
                  MyConfig.userThreeUID, loginBean.data!.uid.toString());
              sp.setString(
                  MyConfig.userThreeHeaderImg, loginBean.data!.avatarUrl!);
              sp.setString(
                  MyConfig.userThreeName, loginBean.data!.nickname!);
              sp.setString(MyConfig.userThreeToken, loginBean.data!.token!);
              sp.setString(
                  MyConfig.userThreeID, loginBean.data!.number.toString());
            }else{
              // 都没有直接存第一个
              sp.setString(MyConfig.userOneUID, loginBean.data!.uid.toString());
              sp.setString(
                  MyConfig.userOneHeaderImg, loginBean.data!.avatarUrl!);
              sp.setString(MyConfig.userOneName, loginBean.data!.nickname!);
              sp.setString(MyConfig.userOneToken, loginBean.data!.token!);
              sp.setString(
                  MyConfig.userOneID, loginBean.data!.number.toString());
            }
          } else {
            if (sp.getString(MyConfig.userOneToken).toString().isEmpty) {
              sp.setString(MyConfig.userOneUID, loginBean.data!.uid.toString());
              sp.setString(
                  MyConfig.userOneHeaderImg, loginBean.data!.avatarUrl!);
              sp.setString(MyConfig.userOneName, loginBean.data!.nickname!);
              sp.setString(MyConfig.userOneToken, loginBean.data!.token!);
              sp.setString(
                  MyConfig.userOneID, loginBean.data!.number.toString());
            } else {
              // 判断登录的账号是不是存在了第一个信息里面
              if(loginBean.data!.uid.toString() == sp.getString(MyConfig.userOneUID).toString()){
                //如果是直接覆盖
                sp.setString(MyConfig.userOneUID, loginBean.data!.uid.toString());
                sp.setString(
                    MyConfig.userOneHeaderImg, loginBean.data!.avatarUrl!);
                sp.setString(MyConfig.userOneName, loginBean.data!.nickname!);
                sp.setString(MyConfig.userOneToken, loginBean.data!.token!);
                sp.setString(
                    MyConfig.userOneID, loginBean.data!.number.toString());
              }else if(loginBean.data!.uid.toString() == sp.getString(MyConfig.userTwoUID).toString()){
                // 判断登录的账号是不是存在了第2个信息里面
                // 如果是直接覆盖
                sp.setString(
                    MyConfig.userTwoUID, loginBean.data!.uid.toString());
                sp.setString(
                    MyConfig.userTwoHeaderImg, loginBean.data!.avatarUrl!);
                sp.setString(MyConfig.userTwoName, loginBean.data!.nickname!);
                sp.setString(MyConfig.userTwoToken, loginBean.data!.token!);
                sp.setString(
                    MyConfig.userTwoID, loginBean.data!.number.toString());
              }else if(loginBean.data!.uid.toString() == sp.getString(MyConfig.userThreeUID).toString()){
                // 判断登录的账号是不是存在了第3个信息里面
                // 如果是直接覆盖
                sp.setString(
                    MyConfig.userThreeUID, loginBean.data!.uid.toString());
                sp.setString(
                    MyConfig.userThreeHeaderImg, loginBean.data!.avatarUrl!);
                sp.setString(
                    MyConfig.userThreeName, loginBean.data!.nickname!);
                sp.setString(MyConfig.userThreeToken, loginBean.data!.token!);
                sp.setString(
                    MyConfig.userThreeID, loginBean.data!.number.toString());
              }else{
                //账号信息都没存过
                if (sp.getString(MyConfig.userOneToken).toString().isNotEmpty &&
                    sp.getString(MyConfig.userTwoToken).toString().isEmpty) {
                  sp.setString(
                      MyConfig.userTwoUID, loginBean.data!.uid.toString());
                  sp.setString(
                      MyConfig.userTwoHeaderImg, loginBean.data!.avatarUrl!);
                  sp.setString(MyConfig.userTwoName, loginBean.data!.nickname!);
                  sp.setString(MyConfig.userTwoToken, loginBean.data!.token!);
                  sp.setString(
                      MyConfig.userTwoID, loginBean.data!.number.toString());
                } else if (sp
                    .getString(MyConfig.userOneToken)
                    .toString()
                    .isNotEmpty &&
                    sp.getString(MyConfig.userTwoToken).toString().isNotEmpty &&
                    sp.getString(MyConfig.userThreeToken).toString().isEmpty) {
                  sp.setString(
                      MyConfig.userThreeUID, loginBean.data!.uid.toString());
                  sp.setString(
                      MyConfig.userThreeHeaderImg, loginBean.data!.avatarUrl!);
                  sp.setString(MyConfig.userThreeName, loginBean.data!.nickname!);
                  sp.setString(MyConfig.userThreeToken, loginBean.data!.token!);
                  sp.setString(
                      MyConfig.userThreeID, loginBean.data!.number.toString());
                } else if (sp
                    .getString(MyConfig.userOneToken)
                    .toString()
                    .isNotEmpty &&
                    sp.getString(MyConfig.userTwoToken).toString().isNotEmpty &&
                    sp.getString(MyConfig.userThreeToken).toString().isEmpty) {
                  if (MyConfig.clickIndex == 1) {
                    sp.setString(
                        MyConfig.userOneUID, loginBean.data!.uid.toString());
                    sp.setString(
                        MyConfig.userOneHeaderImg, loginBean.data!.avatarUrl!);
                    sp.setString(MyConfig.userOneName, loginBean.data!.nickname!);
                    sp.setString(MyConfig.userOneToken, loginBean.data!.token!);
                    sp.setString(
                        MyConfig.userOneID, loginBean.data!.number.toString());
                  }
                  if (MyConfig.clickIndex == 2) {
                    sp.setString(
                        MyConfig.userTwoUID, loginBean.data!.uid.toString());
                    sp.setString(
                        MyConfig.userTwoHeaderImg, loginBean.data!.avatarUrl!);
                    sp.setString(MyConfig.userTwoName, loginBean.data!.nickname!);
                    sp.setString(MyConfig.userTwoToken, loginBean.data!.token!);
                    sp.setString(
                        MyConfig.userTwoID, loginBean.data!.number.toString());
                  }
                  if (MyConfig.clickIndex == 3) {
                    sp.setString(
                        MyConfig.userThreeUID, loginBean.data!.uid.toString());
                    sp.setString(
                        MyConfig.userThreeHeaderImg, loginBean.data!.avatarUrl!);
                    sp.setString(
                        MyConfig.userThreeName, loginBean.data!.nickname!);
                    sp.setString(MyConfig.userThreeToken, loginBean.data!.token!);
                    sp.setString(
                        MyConfig.userThreeID, loginBean.data!.number.toString());
                  }
                }
              }
            }
            setState(() {
              MyConfig.issAdd = false;
            });
          }

          // MyToastUtils.showToastBottom("登录成功");
          sp.setString("user_account", userName);
          sp.setString("user_id", loginBean.data!.uid.toString());
          sp.setString("em_pwd", loginBean.data!.emPwd.toString());
          sp.setString("em_token", loginBean.data!.emToken.toString());
          sp.setString("user_password", passWord);
          if (loginBean.data!.gender == 0) {
            sp.setBool("isFirst", true);
          } else {
            sp.setBool("isFirst", false);
          }
          sp.setString('user_phone', loginBean.data!.phone!);
          sp.setString('nickname', loginBean.data!.nickname!);
          sp.setString("user_token", loginBean.data!.token!);
          sp.setString("user_headimg", loginBean.data!.avatarUrl!);
          sp.setString("user_headimg_id", loginBean.data!.avatar!.toString());
          sp.setInt("user_gender", loginBean.data!.gender!);
          // 保存身份
          sp.setString("user_identity", loginBean.data!.identity!);
          //跳转并关闭当前页面
          //ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Tab_Navigator()),
            // ignore: unnecessary_null_comparison
            (route) => route == null,
          );
          break;
        default:
          MyToastUtils.showToastBottom(loginBean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      LogE('登录返回*${e.toString()}');
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }


  /// 发送短信验证码
  Future<void> doPostLoginSms() async {
    Map<String, dynamic> params = <String, dynamic>{
      'phone': controllerPhone.text.trim(),
      'area_code': quhao,
      'ip': IP.isEmpty ? sp.getString('userIP').toString() : IP
    };
    try {
      CommonBean bean = await DataUtils.postLoginSms(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          //短信发送成功请求倒计时
          _startTimer();
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

  /// 判断当前网络，然后给返回适配的网络地址
  Future<void> doPostPdAddress() async {
    try {
      FormData formdata = FormData.fromMap(
        {
          'type': 'go',
        },
      );
      Dio dio = Dio();
      var respone = dio.post(MyHttpConfig.pdAddress, data: formdata);
      Map<String, dynamic> map = json.decode(respone.toString());
      addressIPBean bean = addressIPBean.fromJson(map);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if(bean.nodes!.isNotEmpty){
            setState(() {
              sp.setString('isDian', bean.nodes!);
              sp.setString('userIP', bean.address!);
              IP = bean.address!;
            });
            if(type ==1){
              doPostLoginSms();
            }else if(type == 2){
              doLogin();
            }
          }else{
            MyToastUtils.showToastBottom('IP为空');
          }
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorHttpTitle);
    }
  }
}
