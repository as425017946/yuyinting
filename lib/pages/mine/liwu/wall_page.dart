import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 礼物墙
class WallPage extends StatefulWidget {
  const WallPage({Key? key}) : super(key: key);

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('礼物墙', true, context, false,0);
  }

  ///收藏使用
  Widget _initlistdata(context, index) {
    return Column(
      children: [
        WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(150), ScreenUtil().setHeight(150), 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
        WidgetUtils.onlyTextCenter('礼物名称', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
        WidgetUtils.onlyTextCenter('x10', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          itemCount: 40,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10, //设置列间距
            mainAxisSpacing: 10, //设置行间距
            childAspectRatio: 3/5,
          ),
          itemBuilder: _initlistdata),
    );
  }
}
