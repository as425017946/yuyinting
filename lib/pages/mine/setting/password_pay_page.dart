import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/my_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 支付密码
class PasswordPayPage extends StatefulWidget {
  const PasswordPayPage({Key? key}) : super(key: key);

  @override
  State<PasswordPayPage> createState() => _PasswordPayPageState();
}

class _PasswordPayPageState extends State<PasswordPayPage> {
  bool isShow = false;
  TextEditingController controllerPas1 = TextEditingController();
  TextEditingController controllerPas2 = TextEditingController();
  TextEditingController controllerPas3 = TextEditingController();
  var appBar;
  var listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('设置支付密码', true, context, false, 0);
    listen = eventBus.on<InfoBack>().listen((event) {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
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
                Expanded(child: WidgetUtils.commonTextFieldNumber(
                    controller: controllerPas1, hintText: '请输入旧密码(未设置可不填)', enabled: true, obscureText: true)),
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
                Expanded(child: WidgetUtils.commonTextFieldNumber(
                    controller: controllerPas2, hintText: '请输入新密码', enabled: true, obscureText: true)),
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
                Expanded(child: WidgetUtils.commonTextFieldNumber(
                    controller: controllerPas3, hintText: '请输入确认密码', enabled: true, obscureText: true)),
              ],
            ),
          ),
          WidgetUtils.myLine(endIndent: 20, indent: 20),
          WidgetUtils.commonSizedBox(10, 0),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: WidgetUtils.onlyText('*密码长度为6位数字', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontSize: ScreenUtil().setSp(28))),
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

    if (p2.length>6 || p3.length>6 || p2.length<6 || p3.length<6) {
      MyToastUtils.showToastBottom("密码长度只能为6位数字");
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
      CommonBean commonBean = await DataUtils.postModifyPayPwd(params);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
