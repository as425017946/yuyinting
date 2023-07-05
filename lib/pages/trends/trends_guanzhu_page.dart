import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 动态-关注页面
class TrendsGuanZhuPage extends StatefulWidget {
  const TrendsGuanZhuPage({super.key});

  @override
  State<TrendsGuanZhuPage> createState() => _TrendsGuanZhuPageState();
}

class _TrendsGuanZhuPageState extends State<TrendsGuanZhuPage> {
  int index = 0;
  int length = 1;
  double x = 0 , y = 0;

  List<Map> imgList = [
    {"url": "https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500"},
    {"url": "https://lmg.jj20.com/up/allimg/4k/s/02/21092423014IX6-0-lp.jpg"},
    {"url": "https://img0.baidu.com/it/u=2252164664,3334752698&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500"},
  ];

  Widget _itemsTuijian(BuildContext context, int i){
    return
      Column(
        children: [
          WidgetUtils.commonSizedBox(10, 0),
          Container(
            height: ScreenUtil().setHeight(100),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                WidgetUtils.CircleHeadImage(40, 40, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                WidgetUtils.commonSizedBox(0, 8),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    Container(
                      width: ScreenUtil().setWidth(130),
                      padding: EdgeInsets.only(left: ScreenUtil().setHeight(8)),
                      child: Text(
                        '张三',
                        style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(25),
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      margin: const EdgeInsets.only(top: 2),
                      alignment: Alignment.center,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.dtPink,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.showImages('assets/images/nv.png', 10, 10),
                          WidgetUtils.commonSizedBox(0, 5),
                          Column(
                            children: [
                              WidgetUtils.onlyText('21·天秤', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
                const Expanded(child: Text('')),
                WidgetUtils.showImages('assets/images/trends_hi.png', 124, 59),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(5, 0),
          WidgetUtils.onlyText('哈哈哈哈哈哈', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28),)),
          WidgetUtils.commonSizedBox(10, 0),
          Row(
            children: [
              WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
              const Expanded(child: Text('')),
              WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
            ],
          ),
          WidgetUtils.commonSizedBox(20, 0),
          Row(
            children: [
              WidgetUtils.onlyText('刚刚·来自：唐山', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
              const Expanded(child: Text('')),
              WidgetUtils.showImages('assets/images/trends_zan1.png', 18, 18),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText('抢首赞', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.showImages('assets/images/trends_message.png', 18, 18),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText('评论', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.myLine()
        ],
      );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: ((details){
        final tapPosition = details.globalPosition;
        setState(() {
          x = tapPosition.dx;
          y = tapPosition.dy;
        });
      }),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child:Column(
                  children: [
                    length == 0 ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetUtils.commonSizedBox(50, 0),
                        WidgetUtils.showImages('assets/images/trends_no.jpg', ScreenUtil().setHeight(242), ScreenUtil().setWidth(221)),
                        WidgetUtils.onlyTextBottom(
                            '您还没有关注的人',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.homeNoHave,
                                fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(10, 0),
                        WidgetUtils.myLine(),
                        GestureDetector(
                          onTap: ((){
                            Navigator.pushNamed(context, 'TrendsMorePage');
                          }),
                          child:  Column(
                            children: [
                              WidgetUtils.commonSizedBox(10, 0),
                              Container(
                                height: ScreenUtil().setHeight(100),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    WidgetUtils.CircleHeadImage(40, 40, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                                    WidgetUtils.commonSizedBox(0, 8),
                                    Column(
                                      children: [
                                        const Expanded(child: Text('')),
                                        Container(
                                          width: ScreenUtil().setWidth(130),
                                          padding: EdgeInsets.only(left: ScreenUtil().setHeight(8)),
                                          child: Text(
                                            '张三',
                                            style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          height: ScreenUtil().setHeight(25),
                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                          margin: const EdgeInsets.only(top: 2),
                                          alignment: Alignment.center,
                                          //边框设置
                                          decoration: const BoxDecoration(
                                            //背景
                                            color: MyColors.dtPink,
                                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              WidgetUtils.showImages('assets/images/nv.png', 10, 10),
                                              WidgetUtils.commonSizedBox(0, 5),
                                              Column(
                                                children: [
                                                  WidgetUtils.onlyText('21·天秤', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const Expanded(child: Text('')),
                                      ],
                                    ),
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages('assets/images/trends_hi.png', 124, 59),
                                  ],
                                ),
                              ),
                              WidgetUtils.commonSizedBox(5, 0),
                              WidgetUtils.onlyText('哈哈哈哈哈哈', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28),)),
                              WidgetUtils.commonSizedBox(10, 0),
                              Row(
                                children: [
                                  WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                                  const Expanded(child: Text('')),
                                  WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                                ],
                              ),
                              WidgetUtils.commonSizedBox(20, 0),
                              Row(
                                children: [
                                  WidgetUtils.onlyText('刚刚·来自：唐山', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages('assets/images/trends_zan1.png', 18, 18),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.onlyText('抢首赞', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
                                  WidgetUtils.commonSizedBox(0, 20),
                                  WidgetUtils.showImages('assets/images/trends_message.png', 18, 18),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.onlyText('评论', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
                                ],
                              ),
                              WidgetUtils.commonSizedBox(10, 0),
                              WidgetUtils.myLine()
                            ],
                          ),
                        )
                      ],
                    ) : Column(
                      children: [
                        WidgetUtils.commonSizedBox(10, 0),
                        Container(
                          height: ScreenUtil().setHeight(100),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              WidgetUtils.CircleHeadImage(40, 40, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                              WidgetUtils.commonSizedBox(0, 8),
                              Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setWidth(130),
                                    padding: EdgeInsets.only(left: ScreenUtil().setHeight(8)),
                                    child: Text(
                                      '张三',
                                      style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    height: ScreenUtil().setHeight(25),
                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                    margin: const EdgeInsets.only(top: 2),
                                    alignment: Alignment.center,
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.dtPink,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        WidgetUtils.showImages('assets/images/nv.png', 10, 10),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        Column(
                                          children: [
                                            WidgetUtils.onlyText('21·天秤', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                              const Expanded(child: Text('')),
                              WidgetUtils.showImages('assets/images/trends_hi.png', 124, 59),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(5, 0),
                        WidgetUtils.onlyText('哈哈哈哈哈哈', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(28),)),
                        WidgetUtils.commonSizedBox(10, 0),
                        Row(
                          children: [
                            WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                            const Expanded(child: Text('')),
                            WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                          ],
                        ),
                        WidgetUtils.commonSizedBox(20, 0),
                        Row(
                          children: [
                            WidgetUtils.onlyText('刚刚·来自：唐山', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
                            const Expanded(child: Text('')),
                            WidgetUtils.showImages('assets/images/trends_zan1.png', 18, 18),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyText('抢首赞', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
                            WidgetUtils.commonSizedBox(0, 20),
                            WidgetUtils.showImages('assets/images/trends_message.png', 18, 18),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyText('评论', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(21), )),
                          ],
                        ),
                        WidgetUtils.commonSizedBox(10, 0),
                        WidgetUtils.myLine()
                      ],
                    )
                  ],
                )
            ),
            ///点赞显示样式
            // Positioned(
            //   left: x-ScreenUtil().setHeight(100),
            //   top: y-ScreenUtil().setHeight(100),
            //   height: ScreenUtil().setHeight(200),
            //   width: ScreenUtil().setHeight(200),
            //   child: const SVGASimpleImage(
            //       assetsName: 'assets/svga/dianzan_2.svga'),
            // )
          ],
        ),
      ),
    );
  }
}
