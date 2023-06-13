import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';

class TrendsMorePage extends StatefulWidget {
  const TrendsMorePage({Key? key}) : super(key: key);

  @override
  State<TrendsMorePage> createState() => _TrendsMorePageState();
}

class _TrendsMorePageState extends State<TrendsMorePage> {
  var appBar;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('动态详情', true, context, false,0);
  }

  Widget _itemsTuijian(BuildContext context, int i) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(10, 0),
        Container(
          height: ScreenUtil().setHeight(100),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  WidgetUtils.CircleHeadImage(50, 50,
                      'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                  Container(
                    height: ScreenUtil().setHeight(25),
                    width: ScreenUtil().setWidth(30),
                    alignment: Alignment.center,
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: i % 2 == 0 ? MyColors.dtPink : MyColors.dtBlue,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: WidgetUtils.showImages(
                        i % 2 == 0
                            ? 'assets/images/nv.png'
                            : 'assets/images/nan.png',
                        10,
                        10),
                  ),
                ],
              ),
              WidgetUtils.commonSizedBox(0, 10),
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '张三',
                        style: StyleUtils.getCommonTextStyle(
                            color: MyColors.g6,
                            fontSize: ScreenUtil().setSp(36),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '张三张三',
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(30),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 60),
            Expanded(
                child: Text(
              '20223-05-25 · IP属地：唐山',
              style: StyleUtils.getCommonTextStyle(
                  color: MyColors.g9,
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(10, 0),
                      Container(
                        height: ScreenUtil().setHeight(100),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.CircleHeadImage(50, 50,
                                'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                            WidgetUtils.commonSizedBox(0, 10),
                            Column(
                              children: [
                                const Expanded(child: Text('')),
                                SizedBox(
                                  width: ScreenUtil().setWidth(130),
                                  child: Text(
                                    '张三',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(36),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                  alignment: Alignment.center,
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.dtPink,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/nv.png', 10, 10),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          '21·天秤',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 11)),
                                    ],
                                  ),
                                ),
                                const Expanded(child: Text('')),
                              ],
                            ),
                            const Expanded(child: Text('')),
                            WidgetUtils.showImages(
                                'assets/images/trends_hi.png', 124, 59),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(5, 0),
                      WidgetUtils.onlyText(
                          '哈哈哈哈哈哈',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(32),
                              fontWeight: FontWeight.bold)),
                      WidgetUtils.commonSizedBox(5, 0),
                      Row(
                        children: [
                          WidgetUtils.CircleImageNet(150, 150, 10,
                              'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                          const Expanded(child: Text('')),
                          WidgetUtils.CircleImageNet(150, 150, 10,
                              'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      Row(
                        children: [
                          WidgetUtils.onlyText(
                              '刚刚·IP属地：唐山',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.bold)),
                          const Expanded(child: Text('')),
                          WidgetUtils.showImages(
                              'assets/images/trends_zan1.png', 18, 18),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText(
                              '抢首赞',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.bold)),
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.showImages(
                              'assets/images/trends_message.png', 18, 18),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText(
                              '评论',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ),

                ///内容信息
                WidgetUtils.commonSizedBox(20, 0),
                WidgetUtils.myLine(thickness: 10),
                WidgetUtils.commonSizedBox(20, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.onlyText(
                        '评论 10',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(32),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 20, right: 20,bottom: 110),
                  itemBuilder: _itemsTuijian,
                  itemCount: 5,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ScreenUtil().setHeight(110),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 0.5,//宽度
                    color: MyColors.f2, //边框颜色
                  ),
                ),
              ),
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(70),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.f2,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: WidgetUtils.commonTextField(controller, '对 Ta 说点什么吧~'),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.showImages('assets/images/trends_biaoqing.png', 25, 25),
                  WidgetUtils.commonSizedBox(0, 10),
                  Container(
                    height: ScreenUtil().setHeight(70),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.homeTopBG,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius:
                      BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: WidgetUtils.onlyText('发送', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36))),
                  ),
                  WidgetUtils.commonSizedBox(0, 20),                  
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
