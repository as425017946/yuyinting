import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';

/// 声音录制
class EditAudioPage extends StatefulWidget {
  const EditAudioPage({Key? key}) : super(key: key);

  @override
  State<EditAudioPage> createState() => _EditAudioPageState();
}

class _EditAudioPageState extends State<EditAudioPage> {
  var appBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('声音录制', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// 头部
          Stack(
            children: [
              WidgetUtils.showImagesFill('assets/images/mine_audio_bg.jpg',
                  ScreenUtil().setHeight(280), double.infinity),
              Container(
                height: ScreenUtil().setHeight(280),
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(20, 0),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 5, //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyText(
                            '我的声音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(36),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(20, 0),
                    WidgetUtils.onlyTextCenter(
                        '你还没有录制声音哦~',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w600)),
                    WidgetUtils.commonSizedBox(10, 0),
                    Container(
                      height: ScreenUtil().setHeight(50),
                      width: ScreenUtil().setWidth(220),
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.only(left: 8),
                      alignment: Alignment.topLeft,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.peopleYellow,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Row(
                        children: [
                          WidgetUtils.showImages(
                              'assets/images/people_bofang.png',
                              ScreenUtil().setHeight(35),
                              ScreenUtil().setWidth(35)),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText(
                              '晴天少女',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

          /// 语音录制
          Transform.translate(
            offset: Offset(0, -20),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(20, 0),
                  Container(
                    height: ScreenUtil().setHeight(178),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: WidgetUtils.showImages('assets/images/mine_audio_star.png', ScreenUtil().setHeight(178), ScreenUtil().setHeight(178)),
                  ),
                  WidgetUtils.commonSizedBox(20, 0),
                  WidgetUtils.onlyText(
                      '声音标签',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(32))),
                  WidgetUtils.commonSizedBox(10, 0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '软萌萝莉音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '青春少女音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '慵懒御姐音',
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
                            '调皮卖萌音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '活泼软萌音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '清软甜糯音',
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
                            '纯净御姐音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '傲娇少女音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '三好青年音',
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
                            '沉稳大叔音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '浑厚低沉音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '儒雅公子音',
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
                            '活力正太音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '磁性大叔音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '烟嗓男神音',
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
                            '知性沉稳音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '阳光学长音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){

                        }),
                        child: WidgetUtils.myContainerZishiying2(
                            Colors.white,
                            MyColors.f2,
                            '治愈男友音',
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
                            '霸道总裁音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
