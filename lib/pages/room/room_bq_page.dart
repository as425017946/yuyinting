import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/room/room_send_info_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
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
  // 水果机使用
  List<String> shuiguoji = [
    'assets/svga/0.svga',
    'assets/svga/1.svga',
    'assets/svga/2.svga',
    'assets/svga/3.svga',
    'assets/svga/4.svga',
    'assets/svga/5.svga',
    'assets/svga/6.svga',
    'assets/svga/7.svga',
    'assets/svga/8.svga',
    'assets/svga/9.svga',
    'assets/svga/10.svga',
    'assets/svga/11.svga',
    'assets/svga/12.svga',
    'assets/svga/13.svga',
  ];
  List<String> shuiguoji2 = [
    'assets/images/hd/j_0.png',
    'assets/images/hd/j_1.png',
    'assets/images/hd/j_2.png',
    'assets/images/hd/j_3.png',
    'assets/images/hd/j_4.png',
    'assets/images/hd/j_5.png',
    'assets/images/hd/j_6.png',
    'assets/images/hd/j_7.png',
    'assets/images/hd/j_8.png',
    'assets/images/hd/j_9.png',
    'assets/images/hd/j_10.png',
    'assets/images/hd/j_11.png',
    'assets/images/hd/j_12.png',
    'assets/images/hd/j_13.png',
  ];
  // 见到石头布
  List<String> jiandao = [
    'assets/svga/vc_emo_paper.svga',
    'assets/svga/vc_emo_rock.svga',
    'assets/svga/vc_emo_scissors.svga',
  ];
  List<String> jiandao2 = [
    'assets/images/hd/s_b.png',
    'assets/images/hd/s_q.png',
    'assets/images/hd/s_j.png',
  ];
  // 筛子
  List<String> shaizi = [
    'assets/svga/vc_emo_dice_1.svga',
    'assets/svga/vc_emo_dice_2.svga',
    'assets/svga/vc_emo_dice_3.svga',
    'assets/svga/vc_emo_dice_4.svga',
    'assets/svga/vc_emo_dice_5.svga',
    'assets/svga/vc_emo_dice_6.svga',
  ];
  List<String> shaizi2 = [
    'assets/images/hd/sz_11.png',
    'assets/images/hd/sz_22.png',
    'assets/images/hd/sz_33.png',
    'assets/images/hd/sz_44.png',
    'assets/images/hd/sz_55.png',
    'assets/images/hd/sz_66.png',
  ];

  List<String> list1 = [
    'assets/images/pt/22.png',
    'assets/images/pt/24.png',
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
      'name': '眨眼',
      "url1": "assets/images/cs/cs_1.png",
      "url2": "assets/images/cs/cs_1.gif",
    },
    {
      'name': '爱心泛滥',
      "url1": "assets/images/cs/cs_2.png",
      "url2": "assets/images/cs/cs_2.gif",
    },
    {
      'name': '拜拜',
      "url1": "assets/images/cs/cs_3.png",
      "url2": "assets/images/cs/cs_3.gif",
    },
    {
      'name': '不要啊',
      "url1": "assets/images/cs/cs_4.png",
      "url2": "assets/images/cs/cs_4.gif",
    },
    {
      'name': '超爱你',
      "url1": "assets/images/cs/cs_5.png",
      "url2": "assets/images/cs/cs_5.gif",
    },
    {
      'name': '嘚瑟',
      "url1": "assets/images/cs/cs_6.png",
      "url2": "assets/images/cs/cs_6.gif",
    },
    {
      'name': '点赞',
      "url1": "assets/images/cs/cs_7.png",
      "url2": "assets/images/cs/cs_7.gif",
    },
    {
      'name': '飞向你',
      "url1": "assets/images/cs/cs_8.png",
      "url2": "assets/images/cs/cs_8.gif",
    },
    {
      'name': '害羞',
      "url1": "assets/images/cs/cs_9.png",
      "url2": "assets/images/cs/cs_9.gif",
    },
    {
      'name': '狡诈',
      "url1": "assets/images/cs/cs_10.png",
      "url2": "assets/images/cs/cs_10.gif",
    },
    {
      'name': '来睡觉',
      "url1": "assets/images/cs/cs_11.png",
      "url2": "assets/images/cs/cs_11.gif",
    },
    {
      'name': '亲亲',
      "url1": "assets/images/cs/cs_12.png",
      "url2": "assets/images/cs/cs_12.gif",
    },
    {
      'name': '求你了',
      "url1": "assets/images/cs/cs_13.png",
      "url2": "assets/images/cs/cs_13.gif",
    },
    {
      'name': '失落淋雨',
      "url1": "assets/images/cs/cs_14.png",
      "url2": "assets/images/cs/cs_14.gif",
    },
    {
      'name': '收情书',
      "url1": "assets/images/cs/cs_15.png",
      "url2": "assets/images/cs/cs_15.gif",
    },
    {
      'name': '帅气的我',
      "url1": "assets/images/cs/cs_16.png",
      "url2": "assets/images/cs/cs_16.gif",
    },
    {
      'name': '送花',
      "url1": "assets/images/cs/cs_17.png",
      "url2": "assets/images/cs/cs_17.gif",
    },
    {
      'name': '太棒了',
      "url1": "assets/images/cs/cs_18.png",
      "url2": "assets/images/cs/cs_18.gif",
    },
    {
      'name': '心里阴影',
      "url1": "assets/images/cs/cs_19.png",
      "url2": "assets/images/cs/cs_19.gif",
    },
    {
      'name': '星星眼',
      "url1": "assets/images/cs/cs_20.png",
      "url2": "assets/images/cs/cs_20.gif",
    },
    {
      'name': '疑问',
      "url1": "assets/images/cs/cs_21.png",
      "url2": "assets/images/cs/cs_21.gif",
    },
    {
      'name': '应援',
      "url1": "assets/images/cs/cs_22.png",
      "url2": "assets/images/cs/cs_22.gif",
    },
    {
      'name': '原来如此',
      "url1": "assets/images/cs/cs_23.png",
      "url2": "assets/images/cs/cs_23.gif",
    },
    {
      'name': '震惊',
      "url1": "assets/images/cs/cs_24.png",
      "url2": "assets/images/cs/cs_24.gif",
    },
    {
      'name': '装死',
      "url1": "assets/images/cs/cs_25.png",
      "url2": "assets/images/cs/cs_25.gif",
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
              if(MyUtils.checkClick()) {
                Navigator.pop(context);
              }
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
                                  'assets/images/pt/1.png', 40.h, 40.h)
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 20.w),
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
                                  'assets/images/cs/cs_first.png', 40.h, 40.h)
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 20.w),
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
                                  'assets/images/cy/cy_first.png', 40.h, 40.h)
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: ((){
                            Navigator.pop(context);
                            MyUtils.goTransparentPage(context, RoomSendInfoPage(info: '',));
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
                          GestureDetector(
                            onTap: ((){
                              if(MyUtils.checkClick()) {
                                // 通知厅内我发表情了
                                // 这里需要判断0是爆灯1是水果机2是剪刀石头布3是筛子
                                if (i == 0) {
                                  eventBus.fire(
                                      SubmitButtonBack(title: '爆灯'));
                                } else if (i == 1) {
                                  // 生成0-13的随机数
                                  var a = Random().nextInt(14);
                                  var b = Random().nextInt(14);
                                  var c = Random().nextInt(14);
                                  eventBus.fire(SendRoomImgBack(
                                      info: '${shuiguoji[a]}、${shuiguoji[b]}、${shuiguoji[c]},${shuiguoji2[a]}、${shuiguoji2[b]}、${shuiguoji2[c]}'));
                                } else if (i == 2) {
                                  // 生成0-9的随机数
                                  var a = Random().nextInt(10);
                                  eventBus.fire(SendRoomImgBack(
                                      info: '${shuiguoji[a]},${shuiguoji2[a]}'));
                                } else if (i == 3) {
                                  // 生成0-2的随机数
                                  var a = Random().nextInt(3);
                                  eventBus.fire(SendRoomImgBack(
                                      info: '${jiandao[a]},${jiandao2[a]}'));
                                } else if (i == 4) {
                                  // 生成0-5的随机数
                                  var a = Random().nextInt(6);
                                  eventBus.fire(SendRoomImgBack(
                                      info: '${shaizi[a]},${shaizi2[a]}'));
                                } else {
                                  eventBus.fire(
                                      SendRoomImgBack(info: list1[i]));
                                }
                                Navigator.pop(context);
                              }
                            }),
                            child: Container(
                              margin: EdgeInsets.only(left: 15.h),
                              child:
                              WidgetUtils.showImages(list1[i], 60.h, 60.h),
                            ),
                          )
                      ],
                    )
                        : typeB == 1
                        ? Wrap(
                      spacing: 15.h,
                      runSpacing: 20.h,
                      children: [
                        for (int i = 0; i < list2.length; i++)
                          GestureDetector(
                            onTap: ((){
                              eventBus.fire(SendRoomImgBack(info: list2[i]['url2']));
                              Navigator.pop(context);
                            }),
                            child: Container(
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
                            ),
                          )
                      ],
                    )
                        : Wrap(
                      spacing: 15.h,
                      runSpacing: 20.h,
                      children: [
                        for (int i = 0; i < list3.length; i++)
                          GestureDetector(
                            onTap: ((){
                              eventBus.fire(SendRoomImgBack(info: list3[i]['url2']));
                              Navigator.pop(context);
                            }),
                            child: Container(
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
