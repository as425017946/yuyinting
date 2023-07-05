import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_toast_utils.dart';
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
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('忘记密码', true, context, false,0);
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '确认'){
        
      }
    });
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
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(80),
            width: double.infinity,
            margin: const EdgeInsets.only(
                top: 70, left: 40, right: 40, bottom: 20),
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: MyColors.homeBG,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: Row(
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
                              fontWeight: FontWeight.w600)),
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
                  child: SizedBox(
                    height: ScreenUtil().setHeight(60),
                    width: double.infinity,
                    child: WidgetUtils.commonTextFieldNumber(
                        controller: controllerPhone, hintText: '请输入手机号'),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 40),
                Expanded(
                  child: Container(
                    height: ScreenUtil().setHeight(80),
                    padding: const EdgeInsets.only(left: 15, bottom: 3),
                    width: double.infinity,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.homeBG,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius:
                      BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: WidgetUtils.commonTextFieldNumber(
                        controller: controllerMsg, hintText: '请输入验证码'),
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
          ),
          WidgetUtils.commonSizedBox(20, 15),
          Container(
            height: ScreenUtil().setHeight(80),
            padding: const EdgeInsets.only(left: 15, bottom: 3),
            margin: const EdgeInsets.only(left: 40, right: 40),
            width: double.infinity,
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: MyColors.homeBG,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: WidgetUtils.commonTextFieldNumber(
                controller: controllerPass, hintText: '请输入密码'),
          ),
          WidgetUtils.commonSizedBox(30, 0),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: WidgetUtils.commonSubmitButton('确定'),
          ),
        ],
      ),
    );
  }
}
