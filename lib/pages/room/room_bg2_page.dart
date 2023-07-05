import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/OptionGridView.dart';

/// 我的背景
class RoomBG2Page extends StatefulWidget {
  const RoomBG2Page({super.key});

  @override
  State<RoomBG2Page> createState() => _RoomBG2PageState();
}

class _RoomBG2PageState extends State<RoomBG2Page> {
  int length = 2;

  ///收藏使用
  Widget _initlistdata(context, index) {
    LogE('返回下标$index');
    return index == length - 1
        ? GestureDetector(
            onTap: (() {}),
            child: Column(
              children: [
                WidgetUtils.showImagesFill('assets/images/room_my_jia.png',
                    ScreenUtil().setHeight(320), ScreenUtil().setHeight(180)),
                WidgetUtils.commonSizedBox(5, 0),
                WidgetUtils.onlyTextCenter(
                    '添加',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(28))),
                WidgetUtils.commonSizedBox(15, 0),
              ],
            ),
          )
        : GestureDetector(
            onTap: (() {}),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    WidgetUtils.CircleImageNet(
                        ScreenUtil().setHeight(320),
                        ScreenUtil().setHeight(180),
                        20.0,
                        'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                    WidgetUtils.showImagesFill(
                        'assets/images/room_bg_xzk.png',
                        ScreenUtil().setHeight(320),
                        ScreenUtil().setHeight(180)),
                  ],
                ),
                WidgetUtils.commonSizedBox(5, 0),
                WidgetUtils.onlyTextCenter(
                    '默认一',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(28))),
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
          itemCount: 2,
          rowCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: _initlistdata,
        ),
      ),
    );
  }
}
