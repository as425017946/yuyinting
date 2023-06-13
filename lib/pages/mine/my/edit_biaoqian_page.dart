import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/widget_utils.dart';
/// 编辑标签页面
class EditBiaoqianPage extends StatefulWidget {
  const EditBiaoqianPage({Key? key}) : super(key: key);

  @override
  State<EditBiaoqianPage> createState() => _EditBiaoqianPageState();
}

class _EditBiaoqianPageState extends State<EditBiaoqianPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        body: Column(
          children: [
            const Expanded(child: Text('')),
            GestureDetector(
              onTap: ((){
                Navigator.pop(context);
              }),
              child: WidgetUtils.showImagesFill('assets/images/mine_biaoqian.png', ScreenUtil().setHeight(200), double.infinity),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      WidgetUtils.showImages('assets/images/mine_biaoqian_ren.png', ScreenUtil().setHeight(42), ScreenUtil().setHeight(42)),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.onlyText('你是？', StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(35))),
                      WidgetUtils.commonSizedBox(0, 10),
                      WidgetUtils.onlyText('0/3', StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(35))),

                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '好听的声音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '有趣的灵魂',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '声控',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '唠嗑达人',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '萌新求带',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '社交困难户',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '夜猫子',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '单身贵族',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '土豪',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '高冷猫',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '可盐可甜',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '软萌妹',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '游戏小天才',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '在校小可爱',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '打工人',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      WidgetUtils.commonSizedBox(0, 15),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '中二',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(60, 0),
                  WidgetUtils.commonSubmitButton('选好了'),
                  WidgetUtils.commonSizedBox(20, 0),
                ],
              ),
            )
          ],
        ));
  }
}
