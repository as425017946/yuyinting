import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 手工开户
class KaihuiPage extends StatefulWidget {
  const KaihuiPage({Key? key}) : super(key: key);

  @override
  State<KaihuiPage> createState() => _KaihuiPageState();
}

class _KaihuiPageState extends State<KaihuiPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '创建'){
        if(controllerName.text.toString().isEmpty || controllerPass.text.toString().isEmpty){
          MyToastUtils.showToastBottom('账号或者密码不能为空');
        }else{
          doPostOpenAccount();
        }
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
    return Column(
      children: [
        WidgetUtils.commonSizedBox(50, 10),
        WidgetUtils.onlyTextCenter('为下级代理创建账号', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29))),
        WidgetUtils.commonSizedBox(20, 10),
        Container(
          height: 300.h,
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.all(20),
          //边框设置
          decoration: const BoxDecoration(
            //背景
            color: MyColors.dailiBlue,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  WidgetUtils.onlyTextCenter('会员账号', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
                  WidgetUtils.commonSizedBox(0, 20),
                  Expanded(child: WidgetUtils.commonTextField(controllerName, '请输入账号')),
                ],
              ),
              WidgetUtils.myLine(color: MyColors.g6),
              Row(
                children: [
                  WidgetUtils.onlyTextCenter('会员密码', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
                  WidgetUtils.commonSizedBox(0, 20),
                  Expanded(child: WidgetUtils.commonTextField(controllerPass, '请输入密码')),
                ],
              ),
              WidgetUtils.myLine(color: MyColors.g6),
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(100, 10),
        WidgetUtils.commonSubmitButton('创建')
      ],
    );
  }

  /// 手工开户
  Future<void> doPostOpenAccount() async {
    Loading.show('数据上传中...');
    Map<String, dynamic> params = <String, dynamic>{
      'username': controllerName.text.toString(),
      'password': controllerPass.text.toString(),
    };
    try {
      CommonBean bean = await DataUtils.postOpenAccount(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            controllerName.text = '';
            controllerPass.text = '';
          });
          MyToastUtils.showToastBottom('开户成功！');
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
