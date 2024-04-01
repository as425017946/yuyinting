import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 忘记密码
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var appBar;
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerMsg = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  var listen, listen2;
  String quhao = '+86';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('忘记密码', true, context, false, 0);
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      // LogE('忘记密码${event.title}');
      if (event.title == '确定') {
        doForgetPassword();
      }
    });

    listen2 = eventBus.on<AddressBack>().listen((event) {
      setState(() {
        quhao = event.info;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen2.cancel();
  }

  late Timer _timer;
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
                  _timer.cancel();
                  _timeCount = 60;
                } else {
                  _timeCount -= 1;
                  _autoCodeText = "$_timeCount" + 's';
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    final height = ScreenUtil().setHeight(80);
    return Scaffold(
      appBar: appBar,
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
            Container(
              height: height,
              width: double.infinity,
              margin: const EdgeInsets.only(
                  top: 70, left: 40, right: 40, bottom: 20),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.homeBG,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(height / 2)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (() {
                      // Navigator.pushNamed(context, 'ChooseCountryPage');
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
                    child: SizedBox(
                      height: ScreenUtil().setHeight(60),
                      width: double.infinity,
                      child: WidgetUtils.commonTextFieldNumber(
                          controller: controllerPhone, hintText: '请输入手机号'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height,
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 40),
                  Expanded(
                    child: Container(
                      height: height,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 15, bottom: 3),
                      width: double.infinity,
                      //边框设置
                      decoration: BoxDecoration(
                        //背景
                        color: MyColors.homeBG,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                            BorderRadius.all(Radius.circular(height / 2)),
                      ),
                      child: WidgetUtils.commonTextFieldNumber(
                          controller: controllerMsg, hintText: '请输入验证码'),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 20),
                  GestureDetector(
                    onTap: (() {
                      if (_autoCodeText == '发送验证码' || _autoCodeText == '重新获取') {
                        if (controllerPhone.text.trim().isEmpty) {
                          MyToastUtils.showToastBottom('请输入手机号');
                        } else if (!MyUtils.chinaPhoneNumber(
                            controllerPhone.text.trim())) {
                          MyToastUtils.showToastBottom('输入的手机号码格式错误');
                        } else {
                          doPostSendSms();
                        }
                      }
                    }),
                    child: Container(
                      // width: ScreenUtil().setHeight(150),
                      constraints:
                          BoxConstraints(minWidth: ScreenUtil().setHeight(150)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: WidgetUtils.onlyText(
                          _autoCodeText,
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.newLoginblue2,
                              fontSize: ScreenUtil().setSp(28))),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 40),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(20, 15),
            Container(
              height: height,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 15, bottom: 3),
              margin: const EdgeInsets.only(left: 40, right: 40),
              width: double.infinity,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.homeBG,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(height / 2)),
              ),
              child: WidgetUtils.commonTextFieldIsShow(
                  controllerPass, '请输入密码', true),
            ),
            WidgetUtils.commonSizedBox(30, 0),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: WidgetUtils.commonSubmitButton('确定'),
            ),
          ],
        ),
      ),
    );
  }

  /// 忘记密码
  Future<void> doForgetPassword() async {
    String userPhone = controllerPhone.text.trim();
    String userMsg = controllerMsg.text.trim();
    String userPass = controllerPass.text.trim();
    if (userPhone.isEmpty) {
      MyToastUtils.showToastBottom("手机号不能为空");
      return;
    }
    if (userMsg.isEmpty) {
      MyToastUtils.showToastBottom("验证码不能为空");
      return;
    }
    if (userPass.isEmpty) {
      MyToastUtils.showToastBottom("密码不能为空");
      return;
    }
    Map<String, dynamic> params = <String, dynamic>{
      'phone': userPhone,
      'password': userPass,
      'area_code': quhao,
      'code': userMsg
    };
    try {
      Loading.show("提交中...");
      CommonBean commonBean = await DataUtils.forgetPassword(params);
      switch (commonBean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('密码修改成功！');
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(commonBean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 发送短信验证码
  Future<void> doPostSendSms() async {
    Map<String, dynamic> params = <String, dynamic>{
      'phone': controllerPhone.text.trim(),
      'area_code': quhao,
      'ip': sp.getString('userIP').toString()
    };
    try {
      CommonBean bean = await DataUtils.postSendSms(params);
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
}
