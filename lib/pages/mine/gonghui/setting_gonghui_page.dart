import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 公会设置
class SettingGonghuiPage extends StatefulWidget {
  const SettingGonghuiPage({Key? key}) : super(key: key);

  @override
  State<SettingGonghuiPage> createState() => _SettingGonghuiPageState();
}

class _SettingGonghuiPageState extends State<SettingGonghuiPage> {
  var appBar;
  TextEditingController controllerGG = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会设置', true, context, false, 0);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              WidgetUtils.commonSizedBox(20, 20),
              Expanded(child: WidgetUtils.onlyText('公会头像', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.bold))),
              WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setHeight(100), 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
              WidgetUtils.commonSizedBox(10, 10),
              Image(
                image: const AssetImage('assets/images/mine_more.png'),
                width: ScreenUtil().setHeight(16),
                height: ScreenUtil().setHeight(27),
              ),
              WidgetUtils.commonSizedBox(20, 20),
            ],
          ),
          WidgetUtils.myLine(color: MyColors.f4),
          Column(
            children: [
               Row(
                 children: [
                   WidgetUtils.commonSizedBox(20, 20),
                   Expanded(child: WidgetUtils.onlyText('公会公告', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.bold))),
                 ],
               ),
              Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20),
                  Expanded(child: WidgetUtils.commonTextField(controllerGG, '输入签名，展示你的独特个性吧')),
                ],
              )
            ],
          ),
          WidgetUtils.myLine(color: MyColors.f4),
        ],
      ),
    );
  }
}
