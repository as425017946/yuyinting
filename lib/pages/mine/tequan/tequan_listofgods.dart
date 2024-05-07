import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../../bean/rankListGZBean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/getx_tools.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';

/// 封神榜
class TequanListofgodsPage extends StatefulWidget {
  const TequanListofgodsPage({Key? key}) : super(key: key);

  @override
  State<TequanListofgodsPage> createState() => _TequanListofgodsPageState();
}

class _TequanListofgodsPageState extends State<TequanListofgodsPage> {
  // final List<String> list = List.filled(8, '懒洋洋爱睡觉');
  List<Rank> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRankListGZ();
  }

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
          image: AssetImage('assets/images/tequan_fengshen_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          // Positioned(
          //   left: 85.w,
          //   width: 580.w,
          //   top: 320.h,
          //   height: 42.h,
          //   child: _marquee(),
          // ),
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
                UserFrameHead(size: 80.w, avatar: item.avatar!),
                SizedBox(width: 20.w),
                item.nobleID.toString() == "1"
                    ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_xuanxian.png', 38.h, 38.h)
                    : item.nobleID.toString() == "2"
                        ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_shangxian.png',
                            38.h,
                            38.h)
                        : item.nobleID.toString() == "3"
                            ? WidgetUtils.showImages(
                                'assets/images/tequan_icon_jinxian.png',
                                38.h,
                                38.h)
                            : item.nobleID.toString() == "4"
                                ? WidgetUtils.showImages(
                                    'assets/images/tequan_icon_xiandi.png',
                                    38.h,
                                    38.h)
                                : item.nobleID.toString() == "5"
                                    ? WidgetUtils.showImages(
                                        'assets/images/tequan_icon_zhushen.png',
                                        38.h,
                                        38.h)
                                    : item.nobleID.toString() == "6"
                                        ? WidgetUtils.showImages(
                                            'assets/images/tequan_icon_tianshen.png',
                                            38.h,
                                            38.h)
                                        : item.nobleID.toString() == "7"
                                            ? WidgetUtils.showImages(
                                                'assets/images/tequan_icon_shenwang.png',
                                                38.h,
                                                38.h)
                                            : item.nobleID.toString() == "8"
                                                ? WidgetUtils.showImages(
                                                    'assets/images/tequan_icon_shenhuang.png',
                                                    38.h,
                                                    38.h)
                                                : item.nobleID.toString() == "9"
                                                    ? WidgetUtils.showImages(
                                                        'assets/images/tequan_icon_tianzun.png', 38.h, 38.h)
                                                    : WidgetUtils.showImages('assets/images/tequan_icon_chuanshuo.png', 38.h, 38.h),
                SizedBox(width: 20.w),
                Text(
                  item.nickname!,
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

  /// 我的贵族
  Future<void> doPostRankListGZ() async {
    Loading.show();
    try {
      rankListGZBean bean = await DataUtils.postRankListGZ();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list.addAll(bean.data!.rank!);
            LogE('長度-==-  ${list.length}');
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
