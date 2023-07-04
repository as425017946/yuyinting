import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/trends/trends_hi_page.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

///动态
class TrendsPage extends StatefulWidget {
  const TrendsPage({Key? key}) : super(key: key);

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  int index = 0;
  int length = 0;


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
                WidgetUtils.commonSizedBox(0, 10),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    SizedBox(
                      width: ScreenUtil().setWidth(130),
                      child: Text(
                        '张三',
                        style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                      alignment: Alignment.center,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.dtPink,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.showImages('assets/images/nv.png', 10, 10),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText('21·天秤', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 11)),
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
          WidgetUtils.onlyText('哈哈哈哈哈哈', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32),)),
          WidgetUtils.commonSizedBox(5, 0),
          Row(
            children: [
              WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
              const Expanded(child: Text('')),
              WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 0),
          Row(
            children: [
              WidgetUtils.onlyText('刚刚·IP属地：唐山', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(24), )),
              const Expanded(child: Text('')),
              WidgetUtils.showImages('assets/images/trends_zan1.png', 18, 18),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText('抢首赞', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(24), )),
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.showImages('assets/images/trends_message.png', 18, 18),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText('评论', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(24), )),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.myLine()
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(35, 0),
          ///头部信息
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            height: ScreenUtil().setHeight(60),
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      index = 0;
                    });
                  }),
                  child: WidgetUtils.onlyTextBottom(
                      '关注',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: index == 0
                              ? ScreenUtil().setSp(46)
                              : ScreenUtil().setSp(32),
                          fontWeight: FontWeight.bold)),
                ),
                WidgetUtils.commonSizedBox(0, 5),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      index = 1;
                    });
                  }),
                  child: WidgetUtils.onlyTextBottom(
                      '推荐',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: index == 1
                              ? ScreenUtil().setSp(46)
                              : ScreenUtil().setSp(32),
                          fontWeight: FontWeight.bold)),
                ),
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: ((){
                    Navigator.pushNamed(context, 'TrendsSendPage');
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(60),
                    width: ScreenUtil().setWidth(174),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        WidgetUtils.showImages('assets/images/trends_fabu_btn.png', ScreenUtil().setHeight(60), ScreenUtil().setWidth(174)),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages('assets/images/trends_xiangji.webp', 30, 30),
                            WidgetUtils.onlyText('发动态', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold)),
                            const Expanded(child: Text('')),

                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          ///内容展示
          index == 0 ? SingleChildScrollView(
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
                     child:  SizedBox(
                       child: Column(
                         children: [
                           WidgetUtils.commonSizedBox(10, 0),
                           Container(
                             height: ScreenUtil().setHeight(100),
                             alignment: Alignment.centerLeft,
                             child: Row(
                               children: [
                                 WidgetUtils.CircleHeadImage(40, 40, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                                 WidgetUtils.commonSizedBox(0, 10),
                                 Column(
                                   children: [
                                     const Expanded(child: Text('')),
                                     SizedBox(
                                       width: ScreenUtil().setWidth(130),
                                       child: Text(
                                         '张三',
                                         style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold),
                                       ),
                                     ),
                                     Container(
                                       padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                       alignment: Alignment.center,
                                       //边框设置
                                       decoration: const BoxDecoration(
                                         //背景
                                         color: MyColors.dtPink,
                                         //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                       ),
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           WidgetUtils.showImages('assets/images/nv.png', 10, 10),
                                           WidgetUtils.commonSizedBox(0, 5),
                                           WidgetUtils.onlyText('21·天秤', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 11)),
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
                           WidgetUtils.onlyText('哈哈哈哈哈哈', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32),)),
                           WidgetUtils.commonSizedBox(5, 0),
                           Row(
                             children: [
                               WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                               const Expanded(child: Text('')),
                               WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                             ],
                           ),
                           WidgetUtils.commonSizedBox(10, 0),
                           Row(
                             children: [
                               WidgetUtils.onlyText('刚刚·IP属地：唐山', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(24), )),
                               const Expanded(child: Text('')),
                               WidgetUtils.showImages('assets/images/trends_zan1.png', 18, 18),
                               WidgetUtils.commonSizedBox(0, 5),
                               WidgetUtils.onlyText('抢首赞', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(24), )),
                               WidgetUtils.commonSizedBox(0, 20),
                               WidgetUtils.showImages('assets/images/trends_message.png', 18, 18),
                               WidgetUtils.commonSizedBox(0, 5),
                               WidgetUtils.onlyText('评论', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(24), )),
                             ],
                           ),
                           WidgetUtils.commonSizedBox(10, 0),
                           WidgetUtils.myLine()
                         ],
                       ),
                     ),
                   )
                  ],
                ) : Column(
                  children: [
                    WidgetUtils.commonSizedBox(20, 0),
                    Container(
                      height: ScreenUtil().setHeight(100),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          WidgetUtils.CircleHeadImage(50, 50, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                          WidgetUtils.commonSizedBox(0, 10),
                          Column(
                            children: [
                              const Expanded(child: Text('')),
                              SizedBox(
                                width: ScreenUtil().setWidth(130),
                                child: Text(
                                  '张三',
                                  style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                alignment: Alignment.center,
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.dtPink,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.showImages('assets/images/nv.png', 10, 10),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText('21·天秤', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 11)),
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
                    WidgetUtils.onlyText('哈哈哈哈哈哈', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.bold)),
                    WidgetUtils.commonSizedBox(5, 0),
                    Row(
                      children: [
                        WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                        const Expanded(child: Text('')),
                        WidgetUtils.CircleImageNet(150, 150, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        WidgetUtils.onlyText('刚刚·IP属地：唐山', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold)),
                        const Expanded(child: Text('')),
                        WidgetUtils.showImages('assets/images/trends_zan1.png', 18, 18),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyText('抢首赞', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold)),
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.showImages('assets/images/trends_message.png', 18, 18),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyText('评论', StyleUtils.getCommonTextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                )
              ],
            )
          )
              :
          index == 1 ? WidgetUtils.commonSizedBox(20, 0) : const Text(''),
          ///轮播图
          index == 1 ? Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            height:ScreenUtil().setHeight(140),
            //超出部分，可裁剪
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Swiper(
              itemBuilder: (BuildContext context,int index){
                // 配置图片地址
                return Image.network(imgList[index]["url"],fit: BoxFit.fill,);
              },
              // 配置图片数量
              itemCount: imgList.length ,
              // 无限循环
              loop: true,
              // 自动轮播
              autoplay: true,
              duration: 5,
            ),
          ) : const Text(''),
          index == 1 ? Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemBuilder: _itemsTuijian,
                itemCount: 5,
              )
          ) : const Text(''),
        ],
      ),
    );
  }
}
