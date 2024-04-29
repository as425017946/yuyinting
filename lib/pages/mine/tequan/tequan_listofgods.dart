import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../../utils/getx_tools.dart';
import '../../../utils/loading.dart';

class TequanListofgodsPage extends StatefulWidget {
  const TequanListofgodsPage({Key? key}) : super(key: key);

  @override
  State<TequanListofgodsPage> createState() => _TequanListofgodsPageState();
}

class _TequanListofgodsPageState extends State<TequanListofgodsPage> {
  final List<String> list = List.filled(8, '懒洋洋爱睡觉');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: (() {
            Loading.dismiss();
            Get.back();
          }),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/tequan_fengshen_bg.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 85.w,
            width: 580.w,
            top: 320.h,
            height: 42.h,
            child: _marquee(),
          ),
          Positioned(
            left: 75.w,
            width: 600.w,
            top: 514.h,
            height: 744.h,
            child: _list(),
          ),
        ],
      ),
    );
  }

  Widget _marquee() {
    return Marquee(
      // 文本
      text: '04月25日00:20 | 恭喜小帅升级',
      // 文本样式
      style: TextStyle(
        color: Colors.white,
        fontSize: 25.h,
        shadows: const [
          Shadow(
            color: Colors.black54,
            offset: Offset(2, 2),
            blurRadius: 3,
          ),
        ],
      ),
      // 滚动轴：水平或者竖直
      scrollAxis: Axis.horizontal,
      // 轴对齐方式start
      crossAxisAlignment: CrossAxisAlignment.start,
      // 空白间距
      blankSpace: 20.0,
      // 速度
      velocity: 100.0,
      // 暂停时长
      pauseAfterRound: const Duration(seconds: 1),
      // startPadding
      startPadding: 10.0,
      // 加速时长
      accelerationDuration: const Duration(seconds: 1),
      // 加速Curve
      accelerationCurve: Curves.linear,
      // 减速时长
      decelerationDuration: const Duration(milliseconds: 500),
      // 减速Curve
      decelerationCurve: Curves.easeOut,
    );
  }

  Widget _list() {
    if (list.isEmpty) {
      return const Text('');
    }
    return ListView.builder(
      padding: EdgeInsets.all(40.w),
      itemBuilder: _builder,
      itemCount: list.length,
    );
  }

  Widget _builder(BuildContext context, int index) {
    final item = list[index];
    return SizedBox(
      height: 130.w,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(width: 30.w),
                UserFrameHead(size: 80.w, avatar: 'https://oawawb.cn/image/202404/03/660d1a3cc7678.png'),
                SizedBox(width: 20.w),
                Image.asset('assets/images/tequan_chuanshuo.png', width: 30.w, height: 30.w,),
                SizedBox(width: 20.w),
                Text(
                  item,
                  style: TextStyle(
                    color: const Color(0xFFEAD1BA),
                    fontSize: 22.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFF7C6E69),
          ),
        ],
      ),
    );
  }
}
