import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(50, 10),
        WidgetUtils.onlyTextCenter('为下级代理创建账号', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29))),
        WidgetUtils.commonSizedBox(20, 10),
        Container(
          height: ScreenUtil().setHeight(270),
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
                  Expanded(child: WidgetUtils.commonTextField(controllerName, '请输入密码')),
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
}
