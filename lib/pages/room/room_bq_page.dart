import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/room/room_send_info_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../main.dart';
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
      'name': 'GO',
      "url1": "assets/images/cy/GO.png",
      "url2": "assets/images/cy/GO.gif",
    },
    {
      'name': 'NONO',
      "url1": "assets/images/cy/NONO.png",
      "url2": "assets/images/cy/NONO.gif",
    },
    {
      'name': 'OK',
      "url1": "assets/images/cy/OK.png",
      "url2": "assets/images/cy/OK.gif",
    },
    {
      'name': '一起睡',
      "url1": "assets/images/cy/一起睡.png",
      "url2": "assets/images/cy/一起睡.gif",
    },
    {
      'name': '不是吧',
      "url1": "assets/images/cy/不是吧.png",
      "url2": "assets/images/cy/不是吧.gif",
    },
    {
      'name': '不活啦',
      "url1": "assets/images/cy/不活啦.png",
      "url2": "assets/images/cy/不活啦.gif",
    },
    {
      'name': '不知道鸭',
      "url1": "assets/images/cy/不知道鸭.png",
      "url2": "assets/images/cy/不知道鸭.gif",
    },
    {
      'name': '什么事',
      "url1": "assets/images/cy/什么事.png",
      "url2": "assets/images/cy/什么事.gif",
    },
    {
      'name': '加油哦',
      "url1": "assets/images/cy/加油哦.png",
      "url2": "assets/images/cy/加油哦.gif",
    },
    {
      'name': '吃狗粮',
      "url1": "assets/images/cy/吃狗粮.png",
      "url2": "assets/images/cy/吃狗粮.gif",
    },
    {
      'name': '吃瓜',
      "url1": "assets/images/cy/吃瓜.png",
      "url2": "assets/images/cy/吃瓜.gif",
    },
    {
      'name': '吐血',
      "url1": "assets/images/cy/吐血.png",
      "url2": "assets/images/cy/吐血.gif",
    },
    {
      'name': '吹刘海',
      "url1": "assets/images/cy/吹刘海.png",
      "url2": "assets/images/cy/吹刘海.gif",
    },
    {
      'name': '哈哈哈哈',
      "url1": "assets/images/cy/哈哈哈哈.png",
      "url2": "assets/images/cy/哈哈哈哈.gif",
    },
    {
      'name': '哦',
      "url1": "assets/images/cy/哦.png",
      "url2": "assets/images/cy/哦.gif",
    },
    {
      'name': '哼',
      "url1": "assets/images/cy/哼.png",
      "url2": "assets/images/cy/哼.gif",
    },
    {
      'name': '嗯嗯',
      "url1": "assets/images/cy/嗯嗯.png",
      "url2": "assets/images/cy/嗯嗯.gif",
    },
    {
      'name': '嘚瑟',
      "url1": "assets/images/cy/嘚瑟.png",
      "url2": "assets/images/cy/嘚瑟.gif",
    },
    {
      'name': '在吗',
      "url1": "assets/images/cy/在吗.png",
      "url2": "assets/images/cy/在吗.gif",
    },
    {
      'name': '大佬喝阔乐',
      "url1": "assets/images/cy/大佬喝阔乐.png",
      "url2": "assets/images/cy/大佬喝阔乐.gif",
    },
    {
      'name': '心里苦',
      "url1": "assets/images/cy/心里苦.png",
      "url2": "assets/images/cy/心里苦.gif",
    },
    {
      'name': '我好美',
      "url1": "assets/images/cy/我好美.png",
      "url2": "assets/images/cy/我好美.gif",
    },
    {
      'name': '我郁闷',
      "url1": "assets/images/cy/我郁闷.png",
      "url2": "assets/images/cy/我郁闷.gif",
    },
    {
      'name': '扎心了',
      "url1": "assets/images/cy/扎心了.png",
      "url2": "assets/images/cy/扎心了.gif",
    },
    {
      'name': '抱大腿',
      "url1": "assets/images/cy/抱大腿.png",
      "url2": "assets/images/cy/抱大腿.gif",
    },
    {
      'name': '拍你屁屁',
      "url1": "assets/images/cy/拍你屁屁.png",
      "url2": "assets/images/cy/拍你屁屁.gif",
    },
    {
      'name': '拒绝狗粮',
      "url1": "assets/images/cy/拒绝狗粮.png",
      "url2": "assets/images/cy/拒绝狗粮.gif",
    },
    {
      'name': '拜拜',
      "url1": "assets/images/cy/拜拜.png",
      "url2": "assets/images/cy/拜拜.gif",
    },
    {
      'name': '揪揪',
      "url1": "assets/images/cy/揪揪.png",
      "url2": "assets/images/cy/揪揪.gif",
    },
    {
      'name': '撒花',
      "url1": "assets/images/cy/撒花.png",
      "url2": "assets/images/cy/撒花.gif",
    },
    {
      'name': '晚安',
      "url1": "assets/images/cy/晚安.png",
      "url2": "assets/images/cy/晚安.gif",
    },
    {
      'name': '暗中观察',
      "url1": "assets/images/cy/暗中观察.png",
      "url2": "assets/images/cy/暗中观察.gif",
    },
    {
      'name': '来呀~',
      "url1": "assets/images/cy/来呀~.png",
      "url2": "assets/images/cy/来呀~.gif",
    },
    {
      'name': '棒棒哒',
      "url1": "assets/images/cy/棒棒哒.png",
      "url2": "assets/images/cy/棒棒哒.gif",
    },
    {
      'name': '滚粗去',
      "url1": "assets/images/cy/滚粗去.png",
      "url2": "assets/images/cy/滚粗去.gif",
    },
    {
      'name': '爱你呦',
      "url1": "assets/images/cy/爱你呦.png",
      "url2": "assets/images/cy/爱你呦.gif",
    },
    {
      'name': '爱心飞吻',
      "url1": "assets/images/cy/爱心飞吻.png",
      "url2": "assets/images/cy/爱心飞吻.gif",
    },
    {
      'name': '猛灌可乐',
      "url1": "assets/images/cy/猛灌可乐.png",
      "url2": "assets/images/cy/猛灌可乐.gif",
    },
    {
      'name': '要你何用',
      "url1": "assets/images/cy/要你何用.png",
      "url2": "assets/images/cy/要你何用.gif",
    },
    {
      'name': '请收下',
      "url1": "assets/images/cy/请收下.png",
      "url2": "assets/images/cy/请收下.gif",
    },
    {
      'name': '谢谢老板',
      "url1": "assets/images/cy/谢谢老板.png",
      "url2": "assets/images/cy/谢谢老板.gif",
    },
    {
      'name': '赚钱中',
      "url1": "assets/images/cy/赚钱中.png",
      "url2": "assets/images/cy/赚钱中.gif",
    },
    {
      'name': '走你',
      "url1": "assets/images/cy/走你.png",
      "url2": "assets/images/cy/走你.gif",
    },
    {
      'name': '难受',
      "url1": "assets/images/cy/难受.png",
      "url2": "assets/images/cy/难受.gif",
    },
    {
      'name': '鸭梨山大',
      "url1": "assets/images/cy/鸭梨山大.png",
      "url2": "assets/images/cy/鸭梨山大.gif",
    },
  ];

  List<Map> list4 = [
    {
      'name': '886',
      "url1": "assets/images/gz/886.png",
      "url2": "assets/images/gz/886.gif",
    },
    {
      'name': 'NO',
      "url1": "assets/images/gz/NO.png",
      "url2": "assets/images/gz/NO.gif",
    },
    {
      'name': 'thankyou',
      "url1": "assets/images/gz/thankyou.png",
      "url2": "assets/images/gz/thankyou.gif",
    },
    {
      'name': 'yeach',
      "url1": "assets/images/gz/yeach.png",
      "url2": "assets/images/gz/yeach.gif",
    },
    {
      'name': 'YOYOYO',
      "url1": "assets/images/gz/YOYOYO.png",
      "url2": "assets/images/gz/YOYOYO.gif",
    },
    {
      'name': '你最棒',
      "url1": "assets/images/gz/你最棒.png",
      "url2": "assets/images/gz/你最棒.gif",
    },
    {
      'name': '你礼貌吗',
      "url1": "assets/images/gz/你礼貌吗.png",
      "url2": "assets/images/gz/你礼貌吗.gif",
    },
    {
      'name': '冲冲冲',
      "url1": "assets/images/gz/冲冲冲.png",
      "url2": "assets/images/gz/冲冲冲.gif",
    },
    {
      'name': '冲呀',
      "url1": "assets/images/gz/冲呀.png",
      "url2": "assets/images/gz/冲呀.gif",
    },
    {
      'name': '哈哈哈哈',
      "url1": "assets/images/gz/哈哈哈哈.png",
      "url2": "assets/images/gz/哈哈哈哈.gif",
    },
    {
      'name': '喜报',
      "url1": "assets/images/gz/喜报.png",
      "url2": "assets/images/gz/喜报.gif",
    },
    {
      'name': '喝红酒',
      "url1": "assets/images/gz/喝红酒.png",
      "url2": "assets/images/gz/喝红酒.gif",
    },
    {
      'name': '坐莲',
      "url1": "assets/images/gz/坐莲.png",
      "url2": "assets/images/gz/坐莲.gif",
    },
    {
      'name': '好的',
      "url1": "assets/images/gz/好的.png",
      "url2": "assets/images/gz/好的.gif",
    },
    {
      'name': '帅气',
      "url1": "assets/images/gz/帅气.png",
      "url2": "assets/images/gz/帅气.gif",
    },
    {
      'name': '感动',
      "url1": "assets/images/gz/感动.png",
      "url2": "assets/images/gz/感动.gif",
    },
    {
      'name': '我很快乐',
      "url1": "assets/images/gz/我很快乐.png",
      "url2": "assets/images/gz/我很快乐.gif",
    },
    {
      'name': '我想静静',
      "url1": "assets/images/gz/我想静静.png",
      "url2": "assets/images/gz/我想静静.gif",
    },
    {
      'name': '打篮球',
      "url1": "assets/images/gz/打篮球.png",
      "url2": "assets/images/gz/打篮球.gif",
    },
    {
      'name': '收到',
      "url1": "assets/images/gz/收到.png",
      "url2": "assets/images/gz/收到.gif",
    },
    {
      'name': '无语',
      "url1": "assets/images/gz/无语.png",
      "url2": "assets/images/gz/无语.gif",
    },
    {
      'name': '求求你',
      "url1": "assets/images/gz/求求你.png",
      "url2": "assets/images/gz/求求你.gif",
    },
    {
      'name': '滚来滚去',
      "url1": "assets/images/gz/滚来滚去.png",
      "url2": "assets/images/gz/滚来滚去.gif",
    },
    {
      'name': '点头',
      "url1": "assets/images/gz/点头.png",
      "url2": "assets/images/gz/点头.gif",
    },
    {
      'name': '点赞',
      "url1": "assets/images/gz/点赞.png",
      "url2": "assets/images/gz/点赞.gif",
    },
    {
      'name': '爱心',
      "url1": "assets/images/gz/爱心.png",
      "url2": "assets/images/gz/爱心.gif",
    },
    {
      'name': '瞅你咋地',
      "url1": "assets/images/gz/瞅你咋地.png",
      "url2": "assets/images/gz/瞅你咋地.gif",
    },
    {
      'name': '答应',
      "url1": "assets/images/gz/答应.png",
      "url2": "assets/images/gz/答应.gif",
    },
    {
      'name': '表示同意',
      "url1": "assets/images/gz/表示同意.png",
      "url2": "assets/images/gz/表示同意.gif",
    },
    {
      'name': '辛苦了',
      "url1": "assets/images/gz/辛苦了.png",
      "url2": "assets/images/gz/辛苦了.gif",
    },
    {
      'name': '阿巴阿巴',
      "url1": "assets/images/gz/阿巴阿巴.png",
      "url2": "assets/images/gz/阿巴阿巴.gif",
    },
    {
      'name': '难受',
      "url1": "assets/images/gz/难受.png",
      "url2": "assets/images/gz/难受.gif",
    },
    {
      'name': '震惊',
      "url1": "assets/images/gz/震惊.png",
      "url2": "assets/images/gz/震惊.gif",
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LogE('贵族等级 ${int.parse(sp.getString('nobleID').toString()) == 0 }');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick()) {
                Navigator.pop(context);
              }
            }),
            child: Container(
              color: Colors.transparent,
            ),
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
                                  color:
                                      typeB == 0 ? MyColors.d8 : Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
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
                                  color:
                                      typeB == 1 ? MyColors.d8 : Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
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
                                  color:
                                      typeB == 2 ? MyColors.d8 : Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                              ),
                              WidgetUtils.showImages(
                                  'assets/images/cy/嘚瑟.png', 40.h, 40.h)
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 20.w),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              typeB = 3;
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
                                  color:
                                      typeB == 3 ? MyColors.d8 : Colors.white,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                              ),
                              WidgetUtils.showImages(
                                  'assets/images/gz/zuolian.png', 40.h, 40.h)
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                            MyUtils.goTransparentPage(
                                context,
                                RoomSendInfoPage(
                                  info: '',
                                ));
                          }),
                          child: WidgetUtils.showImages(
                              'assets/images/chat_jianpan.png',
                              ScreenUtil().setHeight(50),
                              ScreenUtil().setHeight(50)),
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
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
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
                                            info:
                                                '${shuiguoji[a]}、${shuiguoji[b]}、${shuiguoji[c]},${shuiguoji2[a]}、${shuiguoji2[b]}、${shuiguoji2[c]}'));
                                      } else if (i == 2) {
                                        // 生成0-9的随机数
                                        var a = Random().nextInt(10);
                                        eventBus.fire(SendRoomImgBack(
                                            info:
                                                '${shuiguoji[a]},${shuiguoji2[a]}'));
                                      } else if (i == 3) {
                                        // 生成0-2的随机数
                                        var a = Random().nextInt(3);
                                        eventBus.fire(SendRoomImgBack(
                                            info:
                                                '${jiandao[a]},${jiandao2[a]}'));
                                      } else if (i == 4) {
                                        // 生成0-5的随机数
                                        var a = Random().nextInt(6);
                                        eventBus.fire(SendRoomImgBack(
                                            info:
                                                '${shaizi[a]},${shaizi2[a]}'));
                                      } else {
                                        eventBus.fire(
                                            SendRoomImgBack(info: list1[i]));
                                      }
                                      Navigator.pop(context);
                                    }
                                  }),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 15.h),
                                    child: WidgetUtils.showImages(
                                        list1[i], 60.h, 60.h),
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
                                      onTap: (() {
                                        eventBus.fire(SendRoomImgBack(
                                            info: list2[i]['url2']));
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
                            : typeB == 2
                                ? Wrap(
                                    spacing: 15.h,
                                    runSpacing: 20.h,
                                    children: [
                                      for (int i = 0; i < list3.length; i++)
                                        GestureDetector(
                                          onTap: (() {
                                            eventBus.fire(SendRoomImgBack(
                                                info: list3[i]['url2']));
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
                                                    list3[i]['url1'],
                                                    90.h,
                                                    111.h),
                                                WidgetUtils.onlyTextCenter(
                                                    list3[i]['name'],
                                                    StyleUtils
                                                        .getCommonTextStyle(
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
                                      for (int i = 0; i < list4.length; i++)
                                        GestureDetector(
                                          onTap: (() {
                                            eventBus.fire(SendRoomImgBack(
                                                info: list4[i]['url2']));
                                            Navigator.pop(context);
                                          }),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                height: 120.h,
                                                width: 100.h,
                                                margin: EdgeInsets.only(left: 8.h),
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    WidgetUtils.showImages(
                                                        list4[i]['url1'],
                                                        90.h,
                                                        111.h),
                                                    WidgetUtils.onlyTextCenter(
                                                        list4[i]['name'],
                                                        StyleUtils
                                                            .getCommonTextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.sp))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        )
                                    ],
                                  ),
                  ),
                ),
                (typeB == 3 && int.parse(sp.getString('nobleID').toString()) < 2 )? Container(
                  margin: EdgeInsets.only(top: 130.h),
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Spacer(),
                      WidgetUtils.showImages('assets/images/gz/bq_suo.png', 50.h, 50.h),
                      WidgetUtils.commonSizedBox(10.h, 0),
                      WidgetUtils.onlyTextCenter(
                          '达成上仙及以上贵族等级解锁',
                          StyleUtils
                              .getCommonTextStyle(
                              color: Colors.white,
                              fontSize: 26.sp)),
                      const Spacer(),
                    ],
                  ),
                ) : const Text('')
              ],
            ),
          )
        ],
      ),
    );
  }
}
