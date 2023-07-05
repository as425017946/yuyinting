import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
///推荐页面
class TuijianPage extends StatefulWidget {
  const TuijianPage({Key? key}) : super(key: key);

  @override
  State<TuijianPage> createState() => _TuijianPageState();
}

class _TuijianPageState extends State<TuijianPage> {
  final TextEditingController _souSuoName = TextEditingController();

  ///大厅使用
  List<Map> imgList = [
    {"url": "https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500"},
    {"url": "https://lmg.jj20.com/up/allimg/4k/s/02/21092423014IX6-0-lp.jpg"},
    {"url": "https://img0.baidu.com/it/u=2252164664,3334752698&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500"},
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.homeBG,
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(80),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            color: MyColors.homeTopBG,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: ScreenUtil().setHeight(50),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.homeSoucuoBG,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                //设置四周边框
                border: Border.all(width: 1, color: MyColors.homeSoucuoBG),
              ),
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.showImages('assets/images/sousuo.png',
                      ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(child: WidgetUtils.commonTextField(_souSuoName, '搜索ID昵称房间名')),
                ],
              ),
            ),
          ),
          Transform.translate(offset: Offset(0,-1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(      //渐变位置
                            begin: Alignment.topCenter, //右上
                            end: Alignment.bottomCenter, //左下
                            stops: [0.0, 1.0],         //[渐变起始点, 渐变结束点]
                            //渐变颜色[始点颜色, 结束颜色]
                            colors: [Color.fromRGBO(91, 70, 185, 1), Color.fromRGBO(255, 255, 255, 1)]
                        )
                    ),
                    child: Column(
                      children: [
                        ///轮播图
                        Container(
                          height:ScreenUtil().setHeight(140),
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Swiper(
                            itemBuilder: (BuildContext context,int index){
                              // 配置图片地址
                              return FadeInImage.assetNetwork(
                                placeholder: 'assets/images/img_placeholder.png',
                                image: imgList[index]["url"],
                                fit: BoxFit.fill,
                              );
                            },
                            // 配置图片数量
                            itemCount: imgList.length ,
                            // 无限循环
                            loop: true,
                            // 自动轮播
                            autoplay: true,
                            duration: 2000,
                            onIndexChanged: (index){
                              LogE('用户拖动或者自动播放引起下标改变调用');
                            },
                            onTap: (index){
                              LogE('用户点击引起下标改变调用');
                            },
                          ),
                        ),
                        ///热门推荐
                        WidgetUtils.commonSizedBox(10, 0),
                        WidgetUtils.onlyText('热门推荐', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600)),
                        WidgetUtils.commonSizedBox(10, 0),
                        SizedBox(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(350),
                          child: Row(
                            children: [
                              ///热门推荐第一个大的轮播图
                              Container(
                                height:ScreenUtil().setHeight(350),
                                width: ScreenUtil().setWidth(450),
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Swiper(
                                  itemBuilder: (BuildContext context,int index){
                                    // 配置图片地址
                                    return FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/img_placeholder.png',
                                      image: imgList[index]["url"],
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  // 配置图片数量
                                  itemCount: imgList.length ,
                                  // 无限循环
                                  loop: true,
                                  // 自动轮播
                                  autoplay: true,
                                  duration: 1500,
                                ),
                              ),
                              WidgetUtils.commonSizedBox(0, 10),
                              Expanded(child: Column(
                                children: [
                                  ///热门推荐 小的轮播图1
                                  Expanded(child: Container(
                                    height: ScreenUtil().setHeight(170),
                                    //超出部分，可裁剪
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Swiper(
                                      itemBuilder: (BuildContext context,int index){
                                        // 配置图片地址
                                        return FadeInImage.assetNetwork(
                                          placeholder: 'assets/images/img_placeholder.png',
                                          image: imgList[index]["url"],
                                          fit: BoxFit.fill,
                                        );
                                      },
                                      // 配置图片数量
                                      itemCount: imgList.length ,
                                      // 无限循环
                                      loop: true,
                                      // 自动轮播
                                      autoplay: true,
                                      duration: 1000,
                                    ),
                                  )),
                                  WidgetUtils.commonSizedBox(10, 0),
                                  ///热门推荐 小的轮播图2
                                  Expanded(child: Container(
                                    height: ScreenUtil().setHeight(170),
                                    //超出部分，可裁剪
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Swiper(
                                      itemBuilder: (BuildContext context,int index){
                                        // 配置图片地址
                                        return FadeInImage.assetNetwork(
                                          placeholder: 'assets/images/img_placeholder.png',
                                          image: imgList[index]["url"],
                                          fit: BoxFit.fill,
                                        );
                                      },
                                      // 配置图片数量
                                      itemCount: imgList.length ,
                                      // 无限循环
                                      loop: true,
                                      // 自动轮播
                                      autoplay: true,
                                      duration: 1000,
                                    ),
                                  )),
                                ],
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  ///推荐主播
                  WidgetUtils.commonSizedBox(20, 0),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: WidgetUtils.onlyText('推荐主播', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600)),
                  ),
                  WidgetUtils.commonSizedBox(20, 0),
                  GestureDetector(
                    onTap: ((){
                      MyToastUtils.showToastBottom('点击了');
                    }),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      width: double.infinity,
                      height: ScreenUtil().setHeight(80),
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(80),
                            height: ScreenUtil().setHeight(80),
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.CircleHeadImage(40, 40, 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                                WidgetUtils.showImages( 'assets/images/zhibozhong.webp', 80, 80),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      WidgetUtils.onlyText('亦亦12121', StyleUtils.getCommonTextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      Stack(
                                        children: [
                                          WidgetUtils.showImages('assets/images/avk.png', 15, 45),
                                          Container(
                                            padding: const EdgeInsets.only(right: 7),
                                            width: 45,
                                            height: 15,
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '21',
                                              style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'a...',
                                    textAlign: TextAlign.left,
                                    style: StyleUtils.getCommonTextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                          WidgetUtils.showImages('assets/images/Hi.png', 25, 60),
                          WidgetUtils.commonSizedBox(0, 20),

                        ],
                      ),
                    ),
                  ),
                  WidgetUtils.myLine(indent: 20,endIndent: 20),
                  GestureDetector(
                    onTap: ((){
                      MyToastUtils.showToastBottom('点击了');
                    }),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      width: double.infinity,
                      height: ScreenUtil().setHeight(80),
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(80),
                            height: ScreenUtil().setHeight(80),
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.CircleHeadImage(40, 40, 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                                WidgetUtils.showImages( 'assets/images/zhibozhong.webp', 80, 80),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      WidgetUtils.onlyText('亦亦12121', StyleUtils.getCommonTextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      Stack(
                                        children: [
                                          WidgetUtils.showImages('assets/images/avk.png', 15, 45),
                                          Container(
                                            padding: const EdgeInsets.only(right: 7),
                                            width: 45,
                                            height: 15,
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '21',
                                              style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'a...',
                                    textAlign: TextAlign.left,
                                    style: StyleUtils.getCommonTextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                          WidgetUtils.showImages('assets/images/Hi.png', 25, 60),
                          WidgetUtils.commonSizedBox(0, 20),

                        ],
                      ),
                    ),
                  ),
                  WidgetUtils.myLine(indent: 20,endIndent: 20),
                  GestureDetector(
                    onTap: ((){
                      MyToastUtils.showToastBottom('点击了');
                    }),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      width: double.infinity,
                      height: ScreenUtil().setHeight(80),
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(80),
                            height: ScreenUtil().setHeight(80),
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.CircleHeadImage(40, 40, 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                                WidgetUtils.showImages( 'assets/images/zhibozhong.webp', 80, 80),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      WidgetUtils.onlyText('亦亦12121', StyleUtils.getCommonTextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      Stack(
                                        children: [
                                          WidgetUtils.showImages('assets/images/avk.png', 15, 45),
                                          Container(
                                            padding: const EdgeInsets.only(right: 7),
                                            width: 45,
                                            height: 15,
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '21',
                                              style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'a...',
                                    textAlign: TextAlign.left,
                                    style: StyleUtils.getCommonTextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                          WidgetUtils.showImages('assets/images/Hi.png', 25, 60),
                          WidgetUtils.commonSizedBox(0, 20),

                        ],
                      ),
                    ),
                  ),
                  WidgetUtils.myLine(indent: 20,endIndent: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
