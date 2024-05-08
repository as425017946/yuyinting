import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/event_utils.dart';
import '../../../utils/getx_tools.dart';

// ignore: must_be_immutable
class RoomPlayPage extends StatelessWidget with GetAntiCombo {
  final list = _Model.getList();
  RoomPlayPage({super.key});
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(30.w);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.w),
      decoration: BoxDecoration(
        color: const Color(0xFF13181E),
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(),
          SizedBox(height: 10.w),
          SizedBox(
            height: 600.h,
            child: ListView(children: _content()),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Text(
      '玩法列表',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  List<Widget> _content() {
    final nameStyle = TextStyle(color: Colors.white, fontSize: 36.w);
    final contentStyle = TextStyle(color: Colors.white60, fontSize: 20.w);
    return list
        .map((e) => GestureDetector(
              onTap: () => action(() {
                eventBus.fire(SendRoomInfoBack(info: '我想${e.name}，有没有人陪一下'));
                Get.back();
              }),
              child: Container(
                width: double.infinity,
                height: 140.w,
                margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.w),
                padding: EdgeInsets.only(left: 20.w, right: 60.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.w),
                  gradient: const LinearGradient(colors: [Color(0xFF2F3147), Color(0xFF181C27)]),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/room_play_icon_${e.icon}.png', width: 120.w, fit: BoxFit.contain),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.name, style: nameStyle),
                            SizedBox(height: 10.w),
                            Text(e.content, style: contentStyle),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 120.w,
                      height: 50.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/room_play_btn.png'), fit: BoxFit.fill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/cp_heart.png', width: 28.w, height: 24.w),
                          SizedBox(width: 8.w),
                          Text('想玩', style: TextStyle(color: Colors.white, fontSize: 26.w)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
  }
}

class _Model {
  final String name;
  final String icon;
  final String content;
  _Model(this.name, this.icon, this.content);

  static List<_Model> getList() {
    return [
      _Model('听试音', 'tsy', '主播全部开麦向你自我介绍'),
      _Model('听才艺', 'tcy', '魅力主播为你展示30秒怦然心动的声音'),
      _Model('听唱歌', 'tcg', '专业主播歌手为你独唱一首歌'),
      _Model('选心动', 'zcp', '上麦畅聊找到心动的TA'),
      _Model('全麦游戏', 'qmyx', '狼人杀 萝卜蹲 数字炸弹 明杀暗杀等'),
      _Model('找搭子', 'zpw', '王者，和平，金铲铲，lol，永劫等'),
    ];
  }
}
