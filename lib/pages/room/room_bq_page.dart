import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/room/room_send_info_page.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../utils/my_utils.dart';

class RoomBQPage extends StatefulWidget {
  const RoomBQPage({super.key});

  @override
  State<RoomBQPage> createState() => _APageState();
}

class _APageState extends State<RoomBQPage> {
  int typeB = 0;
  List<String> list1 = [
    'assets/images/pt/22.png',
    'assets/images/pt/23.png',
    'assets/images/pt/20.png',
    'assets/images/pt/21.png',
    'assets/images/pt/1.png',
    'assets/images/pt/2.png',
    'assets/images/pt/3.png',
    'assets/images/pt/4.png',
    'assets/images/pt/5.png',
    'assets/images/pt/6.png',
    'assets/images/pt/7.png',
    'assets/images/pt/8.png',
    'assets/images/pt/9.png',
    'assets/images/pt/10.png',
    'assets/images/pt/11.png',
    'assets/images/pt/12.png',
    'assets/images/pt/13.png',
    'assets/images/pt/14.png',
    'assets/images/pt/15.png',
    'assets/images/pt/16.png',
    'assets/images/pt/17.png',
    'assets/images/pt/18.png',
    'assets/images/pt/19.png',
  ];
  List<Map> list2 = [
    {
      'name': '88',
      "url1": "assets/images/cs/cs_1.png",
      "url2": "assets/images/cs/cs_1.gif",
    },
    {
      'name': '打屁股',
      "url1": "assets/images/cs/cs_2.png",
      "url2": "assets/images/cs/cs_2.gif",
    },
    {
      'name': '好棒好棒',
      "url1": "assets/images/cs/cs_3.png",
      "url2": "assets/images/cs/cs_3.gif",
    },
    {
      'name': '加油',
      "url1": "assets/images/cs/cs_4.png",
      "url2": "assets/images/cs/cs_4.gif",
    },
    {
      'name': '可爱',
      "url1": "assets/images/cs/cs_5.png",
      "url2": "assets/images/cs/cs_5.gif",
    },
    {
      'name': '联系我',
      "url1": "assets/images/cs/cs_6.png",
      "url2": "assets/images/cs/cs_6.gif",
    },
    {
      'name': '恋爱脑',
      "url1": "assets/images/cs/cs_7.png",
      "url2": "assets/images/cs/cs_7.gif",
    },
    {
      'name': '你最棒',
      "url1": "assets/images/cs/cs_8.png",
      "url2": "assets/images/cs/cs_8.gif",
    },
    {
      'name': '破坏一切',
      "url1": "assets/images/cs/cs_9.png",
      "url2": "assets/images/cs/cs_9.gif",
    },
    {
      'name': '气到着火',
      "url1": "assets/images/cs/cs_10.png",
      "url2": "assets/images/cs/cs_10.gif",
    },
    {
      'name': '庆祝',
      "url1": "assets/images/cs/cs_11.png",
      "url2": "assets/images/cs/cs_11.gif",
    },
    {
      'name': '蹂躏你',
      "url1": "assets/images/cs/cs_12.png",
      "url2": "assets/images/cs/cs_12.gif",
    },
    {
      'name': '睡觉中',
      "url1": "assets/images/cs/cs_13.png",
      "url2": "assets/images/cs/cs_13.gif",
    },
    {
      'name': '送你小花',
      "url1": "assets/images/cs/cs_14.png",
      "url2": "assets/images/cs/cs_14.gif",
    },
    {
      'name': '体重超标',
      "url1": "assets/images/cs/cs_15.png",
      "url2": "assets/images/cs/cs_15.gif",
    },
    {
      'name': '土豪求包',
      "url1": "assets/images/cs/cs_16.png",
      "url2": "assets/images/cs/cs_16.gif",
    },
    {
      'name': '哇哇哇',
      "url1": "assets/images/cs/cs_17.png",
      "url2": "assets/images/cs/cs_17.gif",
    },
    {
      'name': '我倒',
      "url1": "assets/images/cs/cs_18.png",
      "url2": "assets/images/cs/cs_18.gif",
    },
    {
      'name': '我动心了',
      "url1": "assets/images/cs/cs_19.png",
      "url2": "assets/images/cs/cs_19.gif",
    },
    {
      'name': '吓我一跳',
      "url1": "assets/images/cs/cs_20.png",
      "url2": "assets/images/cs/cs_20.gif",
    },
    {
      'name': '小拳捶胸',
      "url1": "assets/images/cs/cs_21.png",
      "url2": "assets/images/cs/cs_21.gif",
    },
    {
      'name': '心被击中',
      "url1": "assets/images/cs/cs_22.png",
      "url2": "assets/images/cs/cs_22.gif",
    },
    {
      'name': '心跳加速',
      "url1": "assets/images/cs/cs_23.png",
      "url2": "assets/images/cs/cs_23.gif",
    },
    {
      'name': '悠哉',
      "url1": "assets/images/cs/cs_24.png",
      "url2": "assets/images/cs/cs_24.gif",
    },
  ];
  List<Map> list3 = [
    {
      'name': '开心',
      "url1": "assets/images/cy/cy_1.png",
      "url2": "assets/images/cy/cy_1.gif",
    },
    {
      'name': '我哭',
      "url1": "assets/images/cy/cy_2.png",
      "url2": "assets/images/cy/cy_2.gif",
    },
    {
      'name': 'OK',
      "url1": "assets/images/cy/cy_3.png",
      "url2": "assets/images/cy/cy_3.gif",
    },
    {
      'name': '泪目',
      "url1": "assets/images/cy/cy_4.png",
      "url2": "assets/images/cy/cy_4.gif",
    },
    {
      'name': 'cpdd',
      "url1": "assets/images/cy/cy_5.png",
      "url2": "assets/images/cy/cy_5.gif",
    },
    {
      'name': '笑哭',
      "url1": "assets/images/cy/cy_6.png",
      "url2": "assets/images/cy/cy_6.gif",
    },
    {
      'name': '困了',
      "url1": "assets/images/cy/cy_7.png",
      "url2": "assets/images/cy/cy_7.gif",
    },
    {
      'name': '无语',
      "url1": "assets/images/cy/cy_8.png",
      "url2": "assets/images/cy/cy_8.gif",
    },
    {
      'name': '听音乐',
      "url1": "assets/images/cy/cy_9.png",
      "url2": "assets/images/cy/cy_9.gif",
    },
    {
      'name': '思索',
      "url1": "assets/images/cy/cy_10.png",
      "url2": "assets/images/cy/cy_10.gif",
    },
    {
      'name': '打游戏',
      "url1": "assets/images/cy/cy_11.png",
      "url2": "assets/images/cy/cy_11.gif",
    },
    {
      'name': '可爱',
      "url1": "assets/images/cy/cy_12.png",
      "url2": "assets/images/cy/cy_12.gif",
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(child: GestureDetector(
            onTap: ((){
              Navigator.pop(context);
            }),
            child: Container(color: Colors.transparent,),
          )),
          Container(
            height: 500.h,
            width: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    WidgetUtils.commonSizedBox(20.h, 0),
                    Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20.h),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              typeB = 0;
                            });
                          }),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50.h,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  //背景
                                  color: typeB == 0 ? MyColors.d8 : Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              WidgetUtils.showImages(
                                  'assets/images/pt/1.png', 30.h, 30.h)
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10.w),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              typeB = 1;
                            });
                          }),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50.h,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  //背景
                                  color: typeB == 1 ? MyColors.d8 : Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              WidgetUtils.showImagesFill(
                                  'assets/images/cs/cs_first.png', 35.h, 35.h)
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10.w),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              typeB = 2;
                            });
                          }),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50.h,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  //背景
                                  color: typeB == 2 ? MyColors.d8 : Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              WidgetUtils.showImages(
                                  'assets/images/cy/cy_first.png', 30.h, 30.h)
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: ((){
                            Navigator.pop(context);
                            MyUtils.goTransparentPage(context, const RoomSendInfoPage());
                          }),
                          child: WidgetUtils.showImages('assets/images/chat_jianpan.png', ScreenUtil().setHeight(50), ScreenUtil().setHeight(50)),
                        ),
                        WidgetUtils.commonSizedBox(0, 20.h),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10.h, 0),
                    WidgetUtils.bgLine(1.h),
                    WidgetUtils.commonSizedBox(10.h, 0),
                    Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20.h),
                        WidgetUtils.onlyText(
                            '所有表情',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g9, fontSize: 20.sp))
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10.h, 0),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 130.h),
                  child: SingleChildScrollView(
                    child: typeB == 0
                        ? Wrap(
                      spacing: 10.h,
                      runSpacing: 20.h,
                      children: [
                        for (int i = 0; i < list1.length; i++)
                          Container(
                            margin: EdgeInsets.only(left: 15.h),
                            child:
                            WidgetUtils.showImages(list1[i], 60.h, 60.h),
                          )
                      ],
                    )
                        : typeB == 1
                        ? Wrap(
                      spacing: 15.h,
                      runSpacing: 20.h,
                      children: [
                        for (int i = 0; i < list2.length; i++)
                          Container(
                            height: 120.h,
                            width: 100.h,
                            margin: EdgeInsets.only(left: 8.h),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                WidgetUtils.showImages(
                                    list2[i]['url1'], 90.h, 111.h),
                                WidgetUtils.onlyTextCenter(
                                    list2[i]['name'],
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 18.sp))
                              ],
                            ),
                          )
                      ],
                    )
                        : Wrap(
                      spacing: 15.h,
                      runSpacing: 20.h,
                      children: [
                        for (int i = 0; i < list3.length; i++)
                          Container(
                            height: 120.h,
                            width: 100.h,
                            margin: EdgeInsets.only(left: 8.h),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                WidgetUtils.showImages(
                                    list3[i]['url1'], 90.h, 111.h),
                                WidgetUtils.onlyTextCenter(
                                    list3[i]['name'],
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 18.sp))
                              ],
                            ),
                          )
                      ],
                    ),
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
