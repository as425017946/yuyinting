import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 我的公会
class MyGonghuiPage extends StatefulWidget {
  const MyGonghuiPage({Key? key}) : super(key: key);

  @override
  State<MyGonghuiPage> createState() => _MyGonghuiPageState();
}

class _MyGonghuiPageState extends State<MyGonghuiPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('我的公会', true, context, true, 4);
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
                      WidgetUtils.CircleImageNet(ScreenUtil().setHeight(144), ScreenUtil().setHeight(144), 28, 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                WidgetUtils.onlyText('公会名称', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold)),
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
                      GestureDetector(
                        onTap: ((){
                            Navigator.pushNamed(context, 'SettingGonghuiPage');
                        }),
                        child: WidgetUtils.showImages('assets/images/gonghui_bianji.png', ScreenUtil().setHeight(38), ScreenUtil().setHeight(38)),
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
                        WidgetUtils.onlyText('公会简介(10)', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                        WidgetUtils.commonSizedBox(10, 20),
                        GestureDetector(
                          onTap: ((){
                            Navigator.pushNamed(context, 'GonghuiPeoplePage');
                          }),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setHeight(100), 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                                  WidgetUtils.onlyTextCenter('张三', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25),)),
                                ],
                              ),
                              WidgetUtils.commonSizedBox(0, 10),
                              Column(
                                children: [
                                  WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setHeight(100), 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                                  WidgetUtils.onlyTextCenter('张三', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25),)),
                                ],
                              ),
                              WidgetUtils.commonSizedBox(0, 10),
                              Column(
                                children: [
                                  WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setHeight(100), 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                                  WidgetUtils.onlyTextCenter('张三', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25),)),
                                ],
                              ),
                              WidgetUtils.commonSizedBox(0, 10),
                              Column(
                                children: [
                                  WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setHeight(100), 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                                  WidgetUtils.onlyTextCenter('张三', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25),)),
                                ],
                              ),
                              WidgetUtils.commonSizedBox(0, 10),
                              Column(
                                children: [
                                  WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setHeight(100), 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                                  WidgetUtils.onlyTextCenter('张三', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25),)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(30, 20),
                        WidgetUtils.onlyText('公会房间(10)', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                        WidgetUtils.commonSizedBox(20, 20),
                        GestureDetector(
                          onTap: ((){
                              Navigator.pushNamed(context, 'RoomMorePage');
                          }),
                          child: Row(
                            children: [
                              WidgetUtils.CircleImageNet(ScreenUtil().setHeight(110), ScreenUtil().setHeight(110), 28, 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                              WidgetUtils.commonSizedBox(10, 20),
                              WidgetUtils.onlyText('房间名称', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10, 20),
                        WidgetUtils.myLine(color: MyColors.f4),
                        GestureDetector(
                          onTap: ((){
                            Navigator.pushNamed(context, 'RoomMorePage');
                          }),
                          child: Row(
                            children: [
                              WidgetUtils.CircleImageNet(ScreenUtil().setHeight(110), ScreenUtil().setHeight(110), 28, 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                              WidgetUtils.commonSizedBox(10, 20),
                              WidgetUtils.onlyText('房间名称2', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10, 20),
                        WidgetUtils.myLine(color: MyColors.f4),
                        GestureDetector(
                          onTap: ((){
                            Navigator.pushNamed(context, 'RoomMorePage');
                          }),
                          child: Row(
                            children: [
                              WidgetUtils.CircleImageNet(ScreenUtil().setHeight(110), ScreenUtil().setHeight(110), 28, 'http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg'),
                              WidgetUtils.commonSizedBox(10, 20),
                              WidgetUtils.onlyText('房间名称3', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10, 20),
                        WidgetUtils.myLine(color: MyColors.f4),
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
                      Navigator.pushNamed(context, 'KefuPage');
                    }),
                    child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '开设房间', ScreenUtil().setSp(33), Colors.white) ,
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                  child: GestureDetector(
                    onTap: ((){
                      Navigator.pushNamed(context, 'ShenhePage');
                    }),
                    child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '入驻审核', ScreenUtil().setSp(33), Colors.white) ,
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                  child: GestureDetector(
                    onTap: ((){
                      Navigator.pushNamed(context, 'JiesuanPage');
                    }),
                    child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '结算账单', ScreenUtil().setSp(33), Colors.white) ,
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
