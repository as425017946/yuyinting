import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 房间列表
class RoomMorePage extends StatefulWidget {
  const RoomMorePage({Key? key}) : super(key: key);

  @override
  State<RoomMorePage> createState() => _RoomMorePageState();
}

class _RoomMorePageState extends State<RoomMorePage> {
  var appBar;
  var length = 10;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会房间', true, context, false, 0);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _itemPeople(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          WidgetUtils.CircleImageNet(ScreenUtil().setHeight(110), ScreenUtil().setHeight(110), 28, 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
          WidgetUtils.commonSizedBox(10, 20),
          WidgetUtils.onlyText('房间名称3', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.bold)),
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
            WidgetUtils.onlyTextCenter('暂无公会房间', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
            const Expanded(child: Text('')),
          ],
        ),
      ),
    );
  }
}

