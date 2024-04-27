import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/pages/mine/tequan/tequan_shuoming_page.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
class GuowangPage extends StatefulWidget {
  const GuowangPage({Key? key}) : super(key: key);

  @override
  State<GuowangPage> createState() => _GuowangPageState();
}

class _GuowangPageState extends State<GuowangPage>  with TickerProviderStateMixin {
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
      eventBus.fire(GuizuButtonBack(index: 5, title: '左'));
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
                SizedBox(
                  height: 260.h,
                  width: 260.h,
                  child: const SVGASimpleImage(
                    assetsName: 'assets/svga/gz/gz_tianshen.svga',
                  ),
                )
              ],
            ),
            const Expanded(child: Text('')),
            GestureDetector(
              onTap: ((){
                eventBus.fire(GuizuButtonBack(index: 5, title: '右'));
              }),
              child: WidgetUtils.showImages('assets/images/guizu_right.png',
                  ScreenUtil().setHeight(52), ScreenUtil().setHeight(26)),
            ),
            WidgetUtils.commonSizedBox(0, 15),
          ],
        ),
        WidgetUtils.commonSizedBox(20, 15),
        GestureDetector(
          onTap: ((){
            if(MyUtils.checkClick()){
              MyUtils.goTransparentPage(context, TeQuanShuoMingPage(title: '贵族值说明',));
            }
          }),
          child: Container(
            height: 30.h,
            width: 200.w,
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: MyColors.newGZ,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(15.h)),
            ),
            child: Row(
              children: [
                const Spacer(),
                WidgetUtils.onlyTextCenter(
                    '150000',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(22))),
                WidgetUtils.onlyTextCenter(
                    '贵族值',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(22))),
                WidgetUtils.showImages('assets/images/tequan_wen2.png', 30.h, 30.h),
                const Spacer(),
              ],
            ),
          ),
        ),

        /// 特权展示
        WidgetUtils.commonSizedBox(70, 0),
        SizedBox(
          height: ScreenUtil().setHeight(500),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    SizedBox(
                        width: ScreenUtil().setWidth(200),
                        child: Column(
                          children: [
                            WidgetUtils.showImages(
                                'assets/images/tequan_xz.png',
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
                                'assets/images/tequan_lw.png',
                                ScreenUtil().setHeight(103),
                                ScreenUtil().setHeight(103)),
                            WidgetUtils.onlyTextCenter(
                                '特权礼物',
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
                                'assets/images/tequan_jc.png',
                                ScreenUtil().setHeight(103),
                                ScreenUtil().setHeight(103)),
                            WidgetUtils.onlyTextCenter(
                                '专属进场横幅',
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
                                'assets/images/tequan_bq.png',
                                ScreenUtil().setHeight(103),
                                ScreenUtil().setHeight(103)),
                            WidgetUtils.onlyTextCenter(
                                '限定表情包',
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
                                'assets/images/tequan_gb.png',
                                ScreenUtil().setHeight(103),
                                ScreenUtil().setHeight(103)),
                            WidgetUtils.onlyTextCenter(
                                '全服播报',
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
                                'assets/images/tequan_qp.png',
                                ScreenUtil().setHeight(103),
                                ScreenUtil().setHeight(103)),
                            WidgetUtils.onlyTextCenter(
                                '特权公屏气泡',
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
                                'assets/images/tequan_mp.png',
                                ScreenUtil().setHeight(103),
                                ScreenUtil().setHeight(103)),
                            WidgetUtils.onlyTextCenter(
                                '奢华名片栏',
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
                                'assets/images/tequan_mw.png',
                                ScreenUtil().setHeight(103),
                                ScreenUtil().setHeight(103)),
                            WidgetUtils.onlyTextCenter(
                                '炫彩麦位昵称',
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
                                'assets/images/tequan_hm.png',
                                ScreenUtil().setHeight(103),
                                ScreenUtil().setHeight(103)),
                            WidgetUtils.onlyTextCenter(
                                '好友红名',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.guizuYellow,
                                    fontSize: ScreenUtil().setSp(25))),
                          ],
                        )),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                ),
                WidgetUtils.commonSizedBox(60, 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


