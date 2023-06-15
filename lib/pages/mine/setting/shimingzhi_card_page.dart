import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 实名制上传身份证
class ShimingzhiCardPage extends StatefulWidget {
  const ShimingzhiCardPage({Key? key}) : super(key: key);

  @override
  State<ShimingzhiCardPage> createState() => _ShimingzhiCardPageState();
}

class _ShimingzhiCardPageState extends State<ShimingzhiCardPage> {
  var appBar;
  bool isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('实名认证', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(100),
            alignment: Alignment.center,
            child: Row(
              children: [
                const Expanded(child: Text('')),
                SizedBox(
                  height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setHeight(60),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: ScreenUtil().setHeight(40),
                        height: ScreenUtil().setHeight(40),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.homeTopBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      WidgetUtils.onlyTextCenter(
                          '1',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(30))),
                    ],
                  ),
                ),
                WidgetUtils.onlyText(
                    '填写身份资料',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                WidgetUtils.commonSizedBox(0, 5),
                WidgetUtils.onlyText(
                    '-----',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g9, fontSize: ScreenUtil().setSp(29))),
                WidgetUtils.commonSizedBox(0, 5),
                SizedBox(
                  height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setHeight(60),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: ScreenUtil().setHeight(40),
                        height: ScreenUtil().setHeight(40),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.homeTopBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      WidgetUtils.onlyTextCenter(
                          '2',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(30))),
                    ],
                  ),
                ),
                WidgetUtils.onlyText(
                    '身份认证',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                const Expanded(child: Text('')),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                WidgetUtils.onlyText(
                    '身份证人面像面照片',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                WidgetUtils.commonSizedBox(10, 10),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: DottedBorder(
                    color: MyColors.g9,
                    dashPattern: const [8,5],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetUtils.commonSizedBox(10, 10),
                        WidgetUtils.showImages('assets/images/setting_zm.png', ScreenUtil().setHeight(292), double.infinity),
                        WidgetUtils.commonSizedBox(10, 10),
                        Row(
                          children: [
                            const Expanded(child: Text('')),
                            WidgetUtils.showImages('assets/images/setting_xj.png', ScreenUtil().setHeight(29), ScreenUtil().setHeight(35)),
                            WidgetUtils.commonSizedBox(10, 10),
                            WidgetUtils.onlyText(
                                '点击上传身份证人像面图片',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                            const Expanded(child: Text('')),
                          ],
                        ),
                        WidgetUtils.commonSizedBox(10, 10),
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(20, 10),
                WidgetUtils.onlyText(
                    '身份证国徽面照片',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                WidgetUtils.commonSizedBox(10, 10),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: DottedBorder(
                    color: MyColors.g9,
                    dashPattern: const [8,5],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetUtils.commonSizedBox(10, 10),
                        WidgetUtils.showImages('assets/images/setting_fm.png', ScreenUtil().setHeight(292), double.infinity),
                        WidgetUtils.commonSizedBox(10, 10),
                        Row(
                          children: [
                            const Expanded(child: Text('')),
                            WidgetUtils.showImages('assets/images/setting_xj.png', ScreenUtil().setHeight(29), ScreenUtil().setHeight(35)),
                            WidgetUtils.commonSizedBox(10, 10),
                            WidgetUtils.onlyText(
                                '点击上传身份证国徽面图片',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                            const Expanded(child: Text('')),
                          ],
                        ),
                        WidgetUtils.commonSizedBox(10, 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(20, 10),
          GestureDetector(
            onTap: (() {}),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: WidgetUtils.myContainer(
                  ScreenUtil().setHeight(80),
                  double.infinity,
                  isShow == true ? MyColors.homeTopBG : MyColors.d8,
                  isShow == true ? MyColors.homeTopBG : MyColors.d8,
                  '提交',
                  ScreenUtil().setSp(33),
                  Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
