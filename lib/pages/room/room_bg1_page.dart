import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/OptionGridView.dart';
/// 默认背景
class RoomBG1Page extends StatefulWidget {
  const RoomBG1Page({super.key});

  @override
  State<RoomBG1Page> createState() => _RoomBG1PageState();
}

class _RoomBG1PageState extends State<RoomBG1Page> {

  ///收藏使用
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: ((){

      }),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              WidgetUtils.CircleImageNet(ScreenUtil().setHeight(320),ScreenUtil().setHeight(180),20.0,'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
              WidgetUtils.showImagesFill('assets/images/room_bg_xzk.png', ScreenUtil().setHeight(320),ScreenUtil().setHeight(180)),
            ],
          ),
          WidgetUtils.commonSizedBox(5, 0),
          WidgetUtils.onlyTextCenter('默认一', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(28))),
          WidgetUtils.commonSizedBox(15, 0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: OptionGridView(
          itemCount: 12,
          rowCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: _initlistdata,
        ),
      ),
    );
  }
}
