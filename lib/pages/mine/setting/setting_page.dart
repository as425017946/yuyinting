import 'package:flutter/material.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../../utils/widget_utils.dart';
/// 设置页面
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('设置', true, context, false, 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Column(
        children: [

        ],
      ),
    );
  }
}
