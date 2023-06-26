import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../utils/my_toast_utils.dart';
import '../../widget/OptionGridView.dart';

/// 厅内礼物
class RoomLiWuPage extends StatefulWidget {
  const RoomLiWuPage({super.key});

  @override
  State<RoomLiWuPage> createState() => _RoomLiWuPageState();
}

class _RoomLiWuPageState extends State<RoomLiWuPage> {
  int leixing = 0;

  Widget _itemPeople(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        MyToastUtils.showToastBottom('点击了');
      }),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        height: ScreenUtil().setHeight(60),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            WidgetUtils.CircleHeadImage(
                ScreenUtil().setHeight(50),
                ScreenUtil().setHeight(50),
                'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
            WidgetUtils.showImages('assets/images/room_tingzhu.png',
                ScreenUtil().setHeight(20), ScreenUtil().setHeight(20)),
            Container(
              width: ScreenUtil().setHeight(20),
              height: ScreenUtil().setHeight(20),
              alignment: Alignment.center,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.roomCirle,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(width: 0.5, color: MyColors.roomTCWZ2),
              ),
              child: Text(
                '1',
                style: StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(14)),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 礼物
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {}),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setHeight(150),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(5, 0),
                  WidgetUtils.showImagesNet('https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500',
                      ScreenUtil().setHeight(100), ScreenUtil().setHeight(140)),
                  WidgetUtils.onlyTextCenter('礼物名称', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyTextCenter('1999钻', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(21))),
                ],
              ),
            ),
            WidgetUtils.showImagesFill('assets/images/room_liwu_bg.png',
                ScreenUtil().setHeight(200), ScreenUtil().setHeight(150)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(640),
            width: double.infinity,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(10, 0),
                Container(
                  height: ScreenUtil().setHeight(60),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: _itemPeople,
                            itemCount: 10,
                          )),
                      GestureDetector(
                        onTap: (() {}),
                        child: SizedBox(
                          height: ScreenUtil().setHeight(60),
                          width: ScreenUtil().setHeight(80),
                          child: WidgetUtils.onlyTextCenter(
                              '全麦',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(28))),
                        ),
                      )
                    ],
                  ),
                ),
                WidgetUtils.myLine(
                    color: MyColors.roomTCWZ3,
                    endIndent: 20,
                    indent: 20,
                    thickness: 0.5),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          leixing = 0;
                        });
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          '经典',
                          StyleUtils.getCommonTextStyle(
                              color: leixing == 0
                                  ? MyColors.roomTCWZ2
                                  : MyColors.roomTCWZ3,
                              fontSize: leixing == 0 ? ScreenUtil().setSp(28) : ScreenUtil().setSp(25))),
                    ),
                    WidgetUtils.commonSizedBox(0, 5),
                    Container(
                      height: ScreenUtil().setHeight(10),
                      width: ScreenUtil().setWidth(1),
                      color: MyColors.roomTCWZ3,
                    ),
                    WidgetUtils.commonSizedBox(0, 5),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          leixing = 1;
                        });
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          '背包',
                          StyleUtils.getCommonTextStyle(
                              color: leixing == 1
                                  ? MyColors.roomTCWZ2
                                  : MyColors.roomTCWZ3,
                              fontSize: leixing == 1 ? ScreenUtil().setSp(28) : ScreenUtil().setSp(25))),
                    ),
                    WidgetUtils.commonSizedBox(0, 5),
                    Container(
                      height: ScreenUtil().setHeight(10),
                      width: ScreenUtil().setWidth(1),
                      color: MyColors.roomTCWZ3,
                    ),
                    WidgetUtils.commonSizedBox(0, 5),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          leixing = 2;
                        });
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          '特权',
                          StyleUtils.getCommonTextStyle(
                              color: leixing == 2
                                  ? MyColors.roomTCWZ2
                                  : MyColors.roomTCWZ3,
                              fontSize: leixing == 2 ? ScreenUtil().setSp(28) : ScreenUtil().setSp(25))),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        setState(() {});
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          '赠送全部',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomMessageYellow,
                              fontSize: ScreenUtil().setSp(28))),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                ),
                /// 展示礼物
                Expanded(child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20, //设置列间距
                      mainAxisSpacing: 10, //设置行间距
                    ),
                    itemBuilder: _initlistdata)),
                /// 底部送礼
                Container(
                  height: ScreenUtil().setHeight(100),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                        child: Row(
                          children: [
                            WidgetUtils.showImages(
                                'assets/images/room_liwu_dou.png',
                                ScreenUtil().setHeight(26),
                                ScreenUtil().setHeight(24)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyTextCenter(
                                '10000',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(25))),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages(
                                'assets/images/room_liwu_zuan.png',
                                ScreenUtil().setHeight(26),
                                ScreenUtil().setHeight(24)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyTextCenter(
                                '100',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(25))),
                            WidgetUtils.commonSizedBox(0, 5),
                            Image(
                              image: const AssetImage(
                                  'assets/images/mine_more.png'),
                              width: ScreenUtil().setHeight(8),
                              height: ScreenUtil().setHeight(15),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(58),
                        width: ScreenUtil().setHeight(250),
                        decoration: const BoxDecoration(
                          //设置Container修饰
                          image: DecorationImage(
                            //背景图片修饰
                            image: AssetImage(
                                "assets/images/room_liwu_songli.png"),
                            fit: BoxFit.fill, //覆盖
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Row(children: [
                              const Expanded(child: Text('')),
                              WidgetUtils.onlyTextCenter('1',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(25))),
                              WidgetUtils.commonSizedBox(0, 10),
                              WidgetUtils.showImages(
                                  'assets/images/room_liwu_shang.png',
                                  ScreenUtil().setHeight(16),
                                  ScreenUtil().setHeight(9)),
                              const Expanded(child: Text('')),
                            ],)),
                            Expanded(child:WidgetUtils.onlyTextCenter('送礼',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(31)))),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 20),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
