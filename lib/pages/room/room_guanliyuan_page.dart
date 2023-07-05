import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 厅内管理员列表
class RoomGuanLiYuanPage extends StatefulWidget {
  /// 0 用户查看管理员页面，1厅主查看
  int type;
  RoomGuanLiYuanPage({super.key, required this.type});

  @override
  State<RoomGuanLiYuanPage> createState() => _RoomGuanLiYuanPageState();
}

class _RoomGuanLiYuanPageState extends State<RoomGuanLiYuanPage> {

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
                    ScreenUtil().setHeight(80),
                    ScreenUtil().setHeight(80),
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
                                    fontSize: ScreenUtil().setSp(25))),
                          ],
                        ),
                      ),
                      const Expanded(child: Text(''))
                    ],
                  ),
                ),
                widget.type == 1 ? Container(
                  width: ScreenUtil().setHeight(100),
                  height: ScreenUtil().setHeight(45),
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: Colors.transparent,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    //设置四周边框
                    border: Border.all(width: 1, color: MyColors.loginPurple),
                  ),
                  child: WidgetUtils.onlyTextCenter('解除', StyleUtils.getCommonTextStyle(color: MyColors.loginPurple, fontSize: ScreenUtil().setSp(25))),
                ): const Text(''),
                WidgetUtils.commonSizedBox(0, 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(917),
            width: double.infinity,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(15, 0),
                WidgetUtils.onlyTextCenter(
                    '管理员列表',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(32))),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(20)),
                    itemBuilder: _itemTuiJian,
                    itemCount: 10,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
