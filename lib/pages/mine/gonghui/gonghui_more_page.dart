import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../utils/widget_utils.dart';
/// 无工会的详情
class GonghuiMorePage extends StatefulWidget {
  const GonghuiMorePage({Key? key}) : super(key: key);

  @override
  State<GonghuiMorePage> createState() => _GonghuiMorePageState();
}

class _GonghuiMorePageState extends State<GonghuiMorePage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会详情', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  WidgetUtils.showImagesFill('assets/images/gonghui_more_bg.jpg', ScreenUtil().setHeight(300), double.infinity),
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(20, 20),
                      WidgetUtils.CircleImageNet(ScreenUtil().setHeight(144), ScreenUtil().setHeight(144), 10, 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                WidgetUtils.onlyText('公会名称', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.w600)),
                                // WidgetUtils.showImages(, height, width)
                              ],
                            ),
                            WidgetUtils.commonSizedBox(10, 20),
                            WidgetUtils.onlyText('ID: 888', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25),)),
                            WidgetUtils.commonSizedBox(10, 20),
                            WidgetUtils.onlyText('创建时间: 2023-06-15', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25),)),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(20, 20),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0,-15),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.white ,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        WidgetUtils.commonSizedBox(20, 20),
                        WidgetUtils.onlyText('公会简介', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                        WidgetUtils.commonSizedBox(10, 20),
                        WidgetUtils.onlyText('暂未设置公会简介', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(26),)),
                        WidgetUtils.commonSizedBox(20, 20),
                        WidgetUtils.onlyText('公会会长', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                        WidgetUtils.commonSizedBox(10, 20),
                        Row(
                          children: [
                            WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(120), ScreenUtil().setHeight(120), 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                            WidgetUtils.commonSizedBox(10, 20),
                            Expanded(
                              child: Column(
                                children: [
                                  WidgetUtils.onlyText('会长名称', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                                  WidgetUtils.commonSizedBox(10, 20),
                                  WidgetUtils.onlyText('ID: 888', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25),)),
                                ],
                              ),
                            )
                          ],
                        ),
                        WidgetUtils.commonSizedBox(30, 20),
                        WidgetUtils.onlyText('签约须知', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                        WidgetUtils.commonSizedBox(10, 20),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '1.请先完成实名制认证，才能申请公会签约。',
                              maxLines: 20,
                              style: StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          /// 应聘咨询按钮
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: ((){
                      Navigator.pushNamed(context, 'ShareTuiguangPage');
                    }),
                    child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '应聘咨询', ScreenUtil().setSp(33), Colors.white) ,
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                  child: GestureDetector(
                    onTap: ((){

                    }),
                    child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '申请签约', ScreenUtil().setSp(33), Colors.white) ,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
