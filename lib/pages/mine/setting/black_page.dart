import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 黑名单
class BlackPage extends StatefulWidget {
  const BlackPage({Key? key}) : super(key: key);

  @override
  State<BlackPage> createState() => _BlackPageState();
}

class _BlackPageState extends State<BlackPage> {
  var appBar;
  var length = 10;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('黑名单', true, context, false, 0);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _itemPeople(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
      width: double.infinity,
      height: ScreenUtil().setHeight(120),
      child: Row(
        children: [
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setWidth(100), 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
          WidgetUtils.commonSizedBox(0, 10),
          Expanded(
            child: Column(
              children: [
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('用户名$i', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: 14)),
                WidgetUtils.commonSizedBox(5, 10),
                WidgetUtils.onlyText('ID: 123456', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 12)),
                const Expanded(child: Text('')),
              ],
            ),
          ),
          GestureDetector(
            onTap: ((){

            }),
            child: WidgetUtils.myContainer(ScreenUtil().setHeight(45), ScreenUtil().setHeight(100), Colors.white, MyColors.homeTopBG, '解除', ScreenUtil().setSp(25), MyColors.homeTopBG),
          ),
          WidgetUtils.commonSizedBox(0, 20),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: length > 0 ? ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        itemBuilder: _itemPeople,
        itemCount: length,
      )
          :
      Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: [
            const Expanded(child: Text('')),
            WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
            WidgetUtils.commonSizedBox(10, 0),
            WidgetUtils.onlyTextCenter('暂无黑名单人员', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
            const Expanded(child: Text('')),
          ],
        ),
      ),
    );
  }
}
