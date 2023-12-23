import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../utils/my_utils.dart';

/// 房间内弹窗公告
class RoomTSGongGaoPage extends StatefulWidget {
  String notice;

  RoomTSGongGaoPage({super.key, required this.notice});

  @override
  State<RoomTSGongGaoPage> createState() => _RoomTSGongGaoPageState();
}

class _RoomTSGongGaoPageState extends State<RoomTSGongGaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                if (MyUtils.checkClick()) {
                  Navigator.pop(context);
                }
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            padding:
                const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
            width: double.infinity,
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: Colors.black87,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WidgetUtils.onlyTextCenter(
                      '房间公告',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(30))),
                  WidgetUtils.commonSizedBox(5, 0),
                  Text(widget.notice.isEmpty ? '暂无公告信息' : widget.notice,
                      style: TextStyle(
                          color: MyColors.jianbian3,
                          fontSize: ScreenUtil().setSp(22),
                          height: 2)),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (() {
                if (MyUtils.checkClick()) {
                  Navigator.pop(context);
                }
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
