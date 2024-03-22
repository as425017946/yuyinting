import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bean/Common_bean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/regex_formatter.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 登录密码
class PasswordPage extends StatefulWidget {
  String title;

  PasswordPage({Key? key, required this.title}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool isShow = false;
  TextEditingController controllerPas1 = TextEditingController();
  TextEditingController controllerPas2 = TextEditingController();
  TextEditingController controllerPas3 = TextEditingController();
  var appBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar(widget.title, true, context, false, 0);
    eventBus.on<InfoBack>().listen((event) {
      if (event.info.length >= 4) {
        setState(() {
          isShow = true;
        });
      } else {
        setState(() {
          isShow = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
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
            WidgetUtils.commonSizedBox(20, 0),
            Container(
              height: ScreenUtil().setHeight(90),
              margin: const EdgeInsets.only(left: 20, right: 20),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //设置四周边框
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Row(
                children: [
                  WidgetUtils.onlyText('旧密码', StyleUtils.getCommonTextStyle(color: MyColors.g3,fontSize: ScreenUtil().setSp(33))),
                  WidgetUtils.commonSizedBox(0, 20),
                  Expanded(child: TextField(
                    obscureText: true,
                    controller: controllerPas1,
                    inputFormatters: [
                      // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                    ],
                    style: StyleUtils.loginTextStyle,
                    onChanged: (value) {
                      // eventBus.fire(InfoBack(infos: value));
                    },
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      // labelText: "请输入用户名",
                      // icon: Icon(Icons.people), //前面的图标
                      hintText: '请输入旧密码（未设置可不填）',
                      hintStyle: StyleUtils.loginHintTextStyle,

                      contentPadding: const EdgeInsets.only(bottom: 0),
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
                  )),
                ],
              ),
            ),
            WidgetUtils.myLine(endIndent: 20, indent: 20),
            Container(
              height: ScreenUtil().setHeight(90),
              margin: const EdgeInsets.only(left: 20, right: 20),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //设置四周边框
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Row(
                children: [
                  WidgetUtils.onlyText('新密码', StyleUtils.getCommonTextStyle(color: MyColors.g3,fontSize: ScreenUtil().setSp(33))),
                  WidgetUtils.commonSizedBox(0, 20),
                  Expanded(child: TextField(
                    obscureText: true,
                    controller: controllerPas2,
                    inputFormatters: [
                      // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                    ],
                    style: StyleUtils.loginTextStyle,
                    onChanged: (value) {
                      // eventBus.fire(InfoBack(infos: value));
                    },
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      // labelText: "请输入用户名",
                      // icon: Icon(Icons.people), //前面的图标
                      hintText: '请输入新密码',
                      hintStyle: StyleUtils.loginHintTextStyle,

                      contentPadding: const EdgeInsets.only(bottom: 0),
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
                  )),
                ],
              ),
            ),
            WidgetUtils.myLine(endIndent: 20, indent: 20),
            Container(
              height: ScreenUtil().setHeight(90),
              margin: const EdgeInsets.only(left: 20, right: 20),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //设置四周边框
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Row(
                children: [
                  WidgetUtils.onlyText('确认密码', StyleUtils.getCommonTextStyle(color: MyColors.g3,fontSize: ScreenUtil().setSp(33))),
                  WidgetUtils.commonSizedBox(0, 20),
                  Expanded(child: TextField(
                    obscureText: true,
                    controller: controllerPas3,
                    inputFormatters: [
                      // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                    ],
                    style: StyleUtils.loginTextStyle,
                    onChanged: (value) {
                      // eventBus.fire(InfoBack(infos: value));
                    },
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      // labelText: "请输入用户名",
                      // icon: Icon(Icons.people), //前面的图标
                      hintText: '请输入确认密码',
                      hintStyle: StyleUtils.loginHintTextStyle,

                      contentPadding: const EdgeInsets.only(bottom: 0),
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
                  )),
                ],
              ),
            ),
            WidgetUtils.myLine(endIndent: 20, indent: 20),
            WidgetUtils.commonSizedBox(10, 0),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: WidgetUtils.onlyText('*密码长度6-16位，至少含数字/字母', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontSize: ScreenUtil().setSp(28))),
            ),
            WidgetUtils.commonSizedBox(100, 0),
            GestureDetector(
              onTap: (() {
                doForgetPassword();
              }),
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(80),
                    double.infinity,
                    MyColors.homeTopBG,
                    MyColors.homeTopBG,
                    '确定',
                    ScreenUtil().setSp(33),
                    Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 设置交易密码
  Future<void> doForgetPassword() async {
    String p1 = controllerPas1.text.trim();
    String p2 = controllerPas2.text.trim();
    String p3 = controllerPas3.text.trim();
    if (p2.isEmpty) {
      MyToastUtils.showToastBottom("新密码不能为空");
      return;
    }
    if (p3.isEmpty) {
      MyToastUtils.showToastBottom("确认密码不能为空");
      return;
    }

    if (p2.length>16 || p3.length>16 || p2.length<6 || p3.length<6) {
      MyToastUtils.showToastBottom("密码长度只能为6-16位");
      return;
    }

    if (p2 != p3) {
      MyToastUtils.showToastBottom("俩次密码输入的不一致");
      return;
    }
    MyUtils.hideKeyboard(context);
    Map<String, dynamic> params = <String, dynamic>{
      'old_pwd': p1,
      'new_pwd': p2,
      'confirm_pwd': p3,
    };
    try {
      Loading.show("提交中...");
      CommonBean commonBean = await DataUtils.postUpdatePwd(params);
      switch (commonBean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('设置成功！');
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
}
