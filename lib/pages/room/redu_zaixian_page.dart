import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 热度-在线列表
class ReDuZaiXianPage extends StatefulWidget {
  const ReDuZaiXianPage({super.key});

  @override
  State<ReDuZaiXianPage> createState() => _ReDuZaiXianPageState();
}

class _ReDuZaiXianPageState extends State<ReDuZaiXianPage> {

  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            // MyToastUtils.showToastBottom('点击了');
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(130),
            child: Row(
              children: [
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(90),
                    ScreenUtil().setHeight(90),
                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                '用户名$i',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(28))),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(2, 0),
                      Row(
                        children: [
                          WidgetUtils.showImages(
                              'assets/images/room_fangguan.png',
                              ScreenUtil().setHeight(33),
                              ScreenUtil().setHeight(33)),
                          const Expanded(child: Text(''))
                        ],
                      ),
                      const Expanded(child: Text(''))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 在线用户文字提示
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            WidgetUtils.onlyText(
                '在线用户（10人）',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.roomTCWZ3,
                    fontSize: ScreenUtil().setSp(21))),
          ],
        ),

        /// 展示在线用户
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(20)),
            itemBuilder: _itemTuiJian,
            itemCount: 10,
          ),
        )
      ],
    );
  }
}
