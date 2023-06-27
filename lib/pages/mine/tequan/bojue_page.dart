import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
class BojuePage extends StatefulWidget {
  const BojuePage({Key? key}) : super(key: key);

  @override
  State<BojuePage> createState() => _BojuePageState();
}

class _BojuePageState extends State<BojuePage>  with TickerProviderStateMixin {
  /// 会重复播放的控制器
  late AnimationController _repeatController;

  /// 线性动画
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// 动画持续时间是 3秒，此处的this指 TickerProviderStateMixin
    _repeatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(); // 设置动画重复播放

    // 创建一个从0到360弧度的补间动画 v * 2 * π
    _animation = Tween<double>(begin: 0, end: 1).animate(_repeatController);
  }

  @override
  void dispose() {
    _repeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetUtils.commonSizedBox(0, 15),
            GestureDetector(
              onTap: ((){
                eventBus.fire(GuizuButtonBack(index: 2, title: '左'));
              }),
              child:  WidgetUtils.showImages('assets/images/guizu_left.png',
                  ScreenUtil().setHeight(52), ScreenUtil().setHeight(26)),
            ),
            const Expanded(child: Text('')),
            Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: _animation,
                  child: WidgetUtils.showImages(
                      'assets/images/guizu_faguang.png',
                      ScreenUtil().setHeight(271),
                      ScreenUtil().setHeight(266)),
                ),
                WidgetUtils.showImages('assets/images/tequan_bojue.png',
                    ScreenUtil().setHeight(223), ScreenUtil().setHeight(209)),
              ],
            ),
            const Expanded(child: Text('')),
            GestureDetector(
              onTap: ((){
                eventBus.fire(GuizuButtonBack(index: 2, title: '右'));
              }),
              child: WidgetUtils.showImages('assets/images/guizu_right.png',
                  ScreenUtil().setHeight(52), ScreenUtil().setHeight(26)),
            ),
            WidgetUtils.commonSizedBox(0, 15),
          ],
        ),
        WidgetUtils.commonSizedBox(20, 15),
        WidgetUtils.onlyTextCenter(
            '伯爵',
            StyleUtils.getCommonTextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(33),
                fontWeight: FontWeight.bold)),

        /// 特权展示
        WidgetUtils.commonSizedBox(70, 0),
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_xunzhang.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '贵族专属勋章',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            const Expanded(child: Text('')),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_guangquan.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '发言光圈',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            const Expanded(child: Text('')),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_fayan.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '无发言间隔',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            WidgetUtils.commonSizedBox(0, 20),
          ],
        ),
        WidgetUtils.commonSizedBox(10, 0),
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_liwu.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '贵族专属礼物',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            const Expanded(child: Text('')),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_guangbo.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '开通公屏广播',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            const Expanded(child: Text('')),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_texiao.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '进场特效',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            WidgetUtils.commonSizedBox(0, 20),
          ],
        ),
        WidgetUtils.commonSizedBox(10, 0),
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_jiasu.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '升级经验加速',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            const Expanded(child: Text('')),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_renqi.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '房间人气加成',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            const Expanded(child: Text('')),
            SizedBox(
                width: ScreenUtil().setWidth(200),
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/guizu_touxiang.png',
                        ScreenUtil().setHeight(103),
                        ScreenUtil().setHeight(103)),
                    WidgetUtils.onlyTextCenter(
                        '贵族头像框',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
            WidgetUtils.commonSizedBox(0, 20),
          ],
        ),
      ],
    );
  }
}

