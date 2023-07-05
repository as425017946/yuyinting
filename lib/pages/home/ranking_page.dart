import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 排行榜
class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  int index = 0;
  int showPage = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage(index == 0 ? "assets/images/py_meili_bg.jpg" :  "assets/images/py_caifu_bg.jpg"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(35, 0),

            ///头部
            SizedBox(
              height: ScreenUtil().setHeight(56),
              width: double.infinity,
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20),
                  GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: WidgetUtils.showImages('assets/images/back.jpg',
                        ScreenUtil().setHeight(35), ScreenUtil().setHeight(25)),
                  ),
                  const Expanded(child: Text('')),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        index = 0;
                      });
                    }),
                    child: WidgetUtils.onlyTextBottom(
                        '魅力榜',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: index == 0
                                ? ScreenUtil().setSp(40)
                                : ScreenUtil().setSp(32),
                            fontWeight: index == 0
                                ? FontWeight.bold
                                : FontWeight.w100)),
                  ),
                  WidgetUtils.commonSizedBox(0, 20),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        index = 1;
                      });
                    }),
                    child: WidgetUtils.onlyTextBottom(
                        '财富榜',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: index == 1
                                ? ScreenUtil().setSp(40)
                                : ScreenUtil().setSp(32),
                            fontWeight: index == 1
                                ? FontWeight.bold
                                : FontWeight.w100)),
                  ),
                  const Expanded(child: Text('')),
                  WidgetUtils.commonSizedBox(0, 45),
                ],
              ),
            ),



            /// 日榜 周榜 月榜
            WidgetUtils.commonSizedBox(30, 0),
            Container(
              alignment: Alignment.center,
              height: ScreenUtil().setHeight(60),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        showPage = 0;
                      });
                    }),
                    child: WidgetUtils.myContainer(
                        ScreenUtil().setHeight(60),
                        ScreenUtil().setWidth(160),
                        showPage == 0 ? MyColors.riBangBg : MyColors.zhouBangBg,
                        showPage == 0 ? MyColors.riBangBg : MyColors.zhouBangBg,
                        '日榜',
                        ScreenUtil().setSp(30),
                        Colors.white),
                  ),
                  WidgetUtils.commonSizedBox(0, 15),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        showPage = 1;
                      });
                    }),
                    child: WidgetUtils.myContainer(
                        ScreenUtil().setHeight(60),
                        ScreenUtil().setWidth(160),
                        showPage == 1
                            ? MyColors.riBangBg
                            : MyColors.zhouBangBg,
                        showPage == 1 ? MyColors.riBangBg : MyColors.zhouBangBg,
                        '周榜',
                        ScreenUtil().setSp(30),
                        Colors.white),
                  ),
                  WidgetUtils.commonSizedBox(0, 15),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        showPage = 2;
                      });
                    }),
                    child: WidgetUtils.myContainer(
                        ScreenUtil().setHeight(60),
                        ScreenUtil().setWidth(160),
                        showPage == 2 ? MyColors.riBangBg : MyColors.zhouBangBg,
                        showPage == 2 ? MyColors.riBangBg : MyColors.zhouBangBg,
                        '月榜',
                        ScreenUtil().setSp(30),
                        Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(320),
              child:  Row(
                children: [
                  const Expanded(child: Text('')),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 70),
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(55, 55,
                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                        WidgetUtils.showImages(
                            'assets/images/py_two.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        WidgetUtils.onlyTextBottom(
                            '我爱车模',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.bold)),
                        Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(98)),
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setWidth(20),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(15),
                                  ScreenUtil().setWidth(15)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(10))),
                            ],
                          ) /* add child content here */,
                        )
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 4),
                  Transform.translate(offset: Offset(0,-20),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: ScreenUtil().setHeight(260),
                    width: ScreenUtil().setWidth(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(90, 90,
                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                        WidgetUtils.showImages(
                            'assets/images/py_one.png',
                            ScreenUtil().setHeight(231),
                            ScreenUtil().setWidth(228)),
                        WidgetUtils.onlyTextBottom(
                            '我爱车模',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.bold)),
                        Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(155)),
                          width: ScreenUtil().setHeight(75),
                          height: ScreenUtil().setWidth(35),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(20),
                                  ScreenUtil().setWidth(25)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(13))),
                            ],
                          ) /* add child content here */,
                        )
                      ],
                    ),
                  ),),
                  WidgetUtils.commonSizedBox(0, 4),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 70),
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(55, 55,
                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                        WidgetUtils.showImages(
                            'assets/images/py_three.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        WidgetUtils.onlyTextBottom(
                            '我爱车模',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.bold)),
                        Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(98)),
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setWidth(20),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(15),
                                  ScreenUtil().setWidth(15)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(10))),
                            ],
                          ) /* add child content here */,
                        )
                      ],
                    ),
                  ),
                  const Expanded(child: Text('')),
                ],
              ),
            ),

            ///人员信息展示
            index == 0 ? Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(90),
                  left: ScreenUtil().setWidth(60),
                  right: ScreenUtil().setWidth(20)),
              child: Column(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(90),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '4',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(40))),
                        WidgetUtils.commonSizedBox(0, 15),
                        Container(
                          height: ScreenUtil().setHeight(90),
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.CricleImagess(50, 50,
                                  'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20)),
                                width: ScreenUtil().setHeight(70),
                                height: ScreenUtil().setWidth(31),
                                decoration: const BoxDecoration(
                                  //设置Container修饰
                                  image: DecorationImage(
                                    //背景图片修饰
                                    image: AssetImage(
                                        "assets/images/py_tishi.png"),
                                    fit: BoxFit.cover, //覆盖
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/zhibo2.webp',
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setWidth(25)),
                                    WidgetUtils.onlyText(
                                        '在房间',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14))),
                                  ],
                                ) /* add child content here */,
                              ),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.onlyText(
                            '某某主播',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Container(
                    height: ScreenUtil().setHeight(90),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '5',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(40))),
                        WidgetUtils.commonSizedBox(0, 15),
                        Container(
                          height: ScreenUtil().setHeight(90),
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.CricleImagess(50, 50,
                                  'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20)),
                                width: ScreenUtil().setHeight(70),
                                height: ScreenUtil().setWidth(31),
                                decoration: const BoxDecoration(
                                  //设置Container修饰
                                  image: DecorationImage(
                                    //背景图片修饰
                                    image: AssetImage(
                                        "assets/images/py_tishi.png"),
                                    fit: BoxFit.cover, //覆盖
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/zhibo2.webp',
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setWidth(25)),
                                    WidgetUtils.onlyText(
                                        '在房间',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14))),
                                  ],
                                ) /* add child content here */,
                              ),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.onlyText(
                            '某某主播',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                ],
              ),
            )
                :
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(90),
                  left: ScreenUtil().setWidth(60),
                  right: ScreenUtil().setWidth(20)),
              child: Column(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(90),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '4',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(40))),
                        WidgetUtils.commonSizedBox(0, 15),
                        Container(
                          height: ScreenUtil().setHeight(90),
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.CricleImagess(50, 50,
                                  'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20)),
                                width: ScreenUtil().setHeight(70),
                                height: ScreenUtil().setWidth(31),
                                decoration: const BoxDecoration(
                                  //设置Container修饰
                                  image: DecorationImage(
                                    //背景图片修饰
                                    image: AssetImage(
                                        "assets/images/py_tishi.png"),
                                    fit: BoxFit.cover, //覆盖
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/zhibo2.webp',
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setWidth(25)),
                                    WidgetUtils.onlyText(
                                        '在房间',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14))),
                                  ],
                                ) /* add child content here */,
                              ),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.onlyText(
                            '某某主播',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Container(
                    height: ScreenUtil().setHeight(90),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '5',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(40))),
                        WidgetUtils.commonSizedBox(0, 15),
                        Container(
                          height: ScreenUtil().setHeight(90),
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.CricleImagess(50, 50,
                                  'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20)),
                                width: ScreenUtil().setHeight(70),
                                height: ScreenUtil().setWidth(31),
                                decoration: const BoxDecoration(
                                  //设置Container修饰
                                  image: DecorationImage(
                                    //背景图片修饰
                                    image: AssetImage(
                                        "assets/images/py_tishi.png"),
                                    fit: BoxFit.cover, //覆盖
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/zhibo2.webp',
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setWidth(25)),
                                    WidgetUtils.onlyText(
                                        '在房间',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14))),
                                  ],
                                ) /* add child content here */,
                              ),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.onlyText(
                            '某某主播',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ) /* add child content here */,
      ),
    );
  }
}
