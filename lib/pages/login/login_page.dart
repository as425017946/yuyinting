import 'dart:async';

import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/pages/navigator/tabnavigator.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

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
  var qiehuan = '密码登录';
  var zhanghao = '账号登录';
  var listen;
  bool gz = true;
  bool isClick = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (MyUtils.compare('立即登录', event.title) == 0) {
        //跳转并关闭当前页面
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Tab_Navigator()),
          // ignore: unnecessary_null_comparison
          (route) => route == null,
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  late Timer _timer;
  int _timeCount = 10;
  var _autoCodeText = '发送验证码';

  void _startTimer() {
    MyToastUtils.showToastBottom('短信验证码已发送，请注意查收');
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_timeCount <= 0) {
                  _autoCodeText = '重新获取';
                  _timer.cancel();
                  _timeCount = 10;
                } else {
                  _timeCount -= 1;
                  _autoCodeText = "$_timeCount" + 's';
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    //设置字体大小根据系统的“字体大小”辅助选项来进行缩放,默认为false : 字体随着系统的“字体大小”辅助选项来进行缩放
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/login_bg.jpg"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(100, 0),
            WidgetUtils.showImages('assets/images/login_top.png',
                ScreenUtil().setHeight(136), ScreenUtil().setHeight(153)),
            WidgetUtils.commonSizedBox(10, 0),
            Container(
              width: ScreenUtil().setHeight(370),
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('')),
                      WidgetUtils.showImages(
                          'assets/images/login_xin.png',
                          ScreenUtil().setHeight(17),
                          ScreenUtil().setHeight(19))
                    ],
                  ),
                  WidgetUtils.showImages('assets/images/login_wz.png',
                      ScreenUtil().setHeight(43), ScreenUtil().setHeight(356)),
                ],
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(80),
              width: double.infinity,
              margin: const EdgeInsets.only(
                  top: 70, left: 40, right: 40, bottom: 20),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: isClick == false
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: (() {
                            Navigator.pushNamed(context, 'ChooseCountryPage');
                          }),
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 15),
                              WidgetUtils.onlyText(
                                  '+86',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.g3,
                                      fontSize: ScreenUtil().setSp(38),
                                      fontWeight: FontWeight.bold)),
                              WidgetUtils.commonSizedBox(0, 5),
                              WidgetUtils.showImages(
                                  'assets/images/login_xia.png',
                                  ScreenUtil().setHeight(15),
                                  ScreenUtil().setHeight(26))
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: WidgetUtils.commonTextFieldNumber(
                              controller: controllerPhone, hintText: '请输入手机号'),
                        )
                      ],
                    )
                  : Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: WidgetUtils.commonTextFieldNumber(
                              controller: controllerAccount, hintText: '请输入账号'),
                        )
                      ],
                    ),
            ),
            qiehuan == '密码登录'
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
                                  BorderRadius.all(Radius.circular(30.0)),
                            ),
                            child: WidgetUtils.commonTextFieldNumber(
                                controller: controllerSmg, hintText: '请输入验证码'),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                        GestureDetector(
                          onTap: (() {
                            if (_autoCodeText == '发送验证码' ||
                                _autoCodeText == '重新获取') {
                              _startTimer();
                            }
                          }),
                          child: SizedBox(
                            width: ScreenUtil().setHeight(150),
                            child: WidgetUtils.onlyText(
                                _autoCodeText,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.homeTopBG,
                                    fontSize: ScreenUtil().setSp(33))),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 40),
                      ],
                    ),
                  )
                : Container(
                    height: ScreenUtil().setHeight(80),
                    padding: const EdgeInsets.only(left: 15),
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    width: double.infinity,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: WidgetUtils.commonTextFieldNumber(
                        controller: controllerPass, hintText: '请输入密码'),
                  ),
            WidgetUtils.commonSizedBox(30, 0),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: WidgetUtils.commonSubmitButton('立即登录'),
            ),
            WidgetUtils.commonSizedBox(15, 0),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                children: [
                  isClick == false
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              if (qiehuan == '密码登录') {
                                qiehuan = '短信登录';
                              } else {
                                qiehuan = '密码登录';
                              }
                            });
                          }),
                          child: WidgetUtils.onlyText(
                              qiehuan,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeTopBG,
                                  fontSize: ScreenUtil().setSp(28))),
                        )
                      : const Text(''),
                  const Expanded(child: Text('')),
                  GestureDetector(
                    onTap: (() {
                      Navigator.pushNamed(context, 'ForgotPasswordPage');
                    }),
                    child: WidgetUtils.onlyText(
                        '忘记密码',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g6,
                            fontSize: ScreenUtil().setSp(28))),
                  ),
                ],
              ),
            ),
            const Expanded(child: Text('')),
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
              child: WidgetUtils.onlyTextCenter(
                  zhanghao,
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(32))),
            ),
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
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
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
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
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
    );
  }
}
