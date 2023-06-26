import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 热度-财富榜
class ReDuCaiFuPage extends StatefulWidget {
  const ReDuCaiFuPage({super.key});

  @override
  State<ReDuCaiFuPage> createState() => _ReDuCaiFuPageState();
}

class _ReDuCaiFuPageState extends State<ReDuCaiFuPage> {

  int showPage = 0;

  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            // MyToastUtils.showToastBottom('点击了');
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(130),
            child: Row(
              children: [
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(90),
                    ScreenUtil().setHeight(90),
                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                '用户名$i',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(28))),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(2, 0),
                      Row(
                        children: [
                          WidgetUtils.showImages(
                              'assets/images/room_fangguan.png',
                              ScreenUtil().setHeight(33),
                              ScreenUtil().setHeight(33)),
                          const Expanded(child: Text(''))
                        ],
                      ),
                      const Expanded(child: Text(''))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          /// 日榜 周榜 月榜
          Row(
            children: [
              const Expanded(child: Text('')),
              Stack(
                children: [
                  Opacity(
                    opacity: 0.2,
                    child: Row(
                      children: [
                        Container(
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: Colors.grey,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: WidgetUtils.commonSizedBox(ScreenUtil().setHeight(50), ScreenUtil().setHeight(270)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setHeight(270),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: showPage == 0 ? 0.2 : 0,
                                child: Container(
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              GestureDetector(
                                onTap: ((){
                                  setState(() {
                                    showPage = 0;
                                  });
                                }),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: WidgetUtils.onlyTextCenter('日榜', StyleUtils.getCommonTextStyle(color: showPage == 0 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: showPage == 1 ? 0.2 : 0,
                                child: Container(
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              GestureDetector(
                                onTap: ((){
                                  setState(() {
                                    showPage = 1;
                                  });
                                }),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: WidgetUtils.onlyTextCenter('周榜', StyleUtils.getCommonTextStyle(color: showPage == 1 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: showPage == 2 ? 0.2 : 0,
                                child: Container(
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              GestureDetector(
                                onTap: ((){
                                  setState(() {
                                    showPage = 2;
                                  });
                                }),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: WidgetUtils.onlyTextCenter('月榜', StyleUtils.getCommonTextStyle(color: showPage == 2 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Expanded(child: Text('')),
            ],
          ),
          WidgetUtils.commonSizedBox(20, 20),
          SizedBox(
            height: ScreenUtil().setHeight(323),
            width: double.infinity,
            child: Row(
              children: [
                const Expanded(child: Text('')),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.showImages('assets/images/py_two.png',
                        ScreenUtil().setHeight(102), ScreenUtil().setHeight(107)),
                    Stack(
                      children: [
                        WidgetUtils.showImagesFill(
                            'assets/images/room_two.png',
                            ScreenUtil().setHeight(104),
                            ScreenUtil().setHeight(155)),
                        Container(
                          width: ScreenUtil().setHeight(155),
                          margin: const EdgeInsets.only(top: 5),
                          alignment: Alignment.topCenter,
                          child: WidgetUtils.onlyTextCenter(
                              '用户名1',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomPHWZBlack,
                                  fontSize: ScreenUtil().setSp(21),
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
                const Expanded(child: Text('')),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.showImages('assets/images/py_one.png',
                        ScreenUtil().setHeight(158), ScreenUtil().setHeight(160)),
                    Stack(
                      children: [
                        WidgetUtils.showImages(
                            'assets/images/room_one.png',
                            ScreenUtil().setHeight(165),
                            ScreenUtil().setHeight(192)),
                        Container(
                          width: ScreenUtil().setHeight(192),
                          margin: const EdgeInsets.only(top: 5),
                          alignment: Alignment.topCenter,
                          child: WidgetUtils.onlyTextCenter(
                              '用户名2',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomPHWZBlack,
                                  fontSize: ScreenUtil().setSp(21),
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
                const Expanded(child: Text('')),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.showImages('assets/images/py_three.png',
                        ScreenUtil().setHeight(102), ScreenUtil().setHeight(107)),
                    Stack(
                      children: [
                        WidgetUtils.showImagesFill(
                            'assets/images/room_three.png',
                            ScreenUtil().setHeight(104),
                            ScreenUtil().setHeight(155)),
                        Container(
                          width: ScreenUtil().setHeight(155),
                          margin: const EdgeInsets.only(top: 5),
                          alignment: Alignment.topCenter,
                          child: WidgetUtils.onlyTextCenter(
                              '用户名3',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomPHWZBlack,
                                  fontSize: ScreenUtil().setSp(21),
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
                const Expanded(child: Text('')),
              ],
            ),
          ),
          /// 展示在线用户
          ListView.builder(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(20)),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: _itemTuiJian,
            itemCount: 10,
          )
        ],
      ),
    );
  }
}
