import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/message/geren/ziliao_page.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/widget_utils.dart';
import 'dongtai_page.dart';

/// 个人主页
class PeopleInfoPage extends StatefulWidget {
  const PeopleInfoPage({Key? key}) : super(key: key);

  @override
  State<PeopleInfoPage> createState() => _PeopleInfoPageState();
}

class _PeopleInfoPageState extends State<PeopleInfoPage> {
  int _currentIndex = 0;
  late final PageController _controller ;
  final TextEditingController _souSuoName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/people_bg.jpg"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(35, 0),
                ///头部信息
                Container(
                  height: ScreenUtil().setHeight(60),
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(50),
                        padding: const EdgeInsets.only(left: 15),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: (() {
                            Navigator.of(context).pop();
                          }),
                        ),
                      ),
                      const Expanded(child: Text('')),
                      Container(
                        width: ScreenUtil().setWidth(50),
                        margin: const EdgeInsets.only(right: 15),
                        child: WidgetUtils.showImages('assets/images/dian_white.png', 15, 45),
                      ),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(10, 0),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 0),
                  height: ScreenUtil().setHeight(150),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(130), ScreenUtil().setWidth(130), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                      WidgetUtils.commonSizedBox(0, 10),
                      ///昵称等信息
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text('')),
                            WidgetUtils.onlyText('昵称', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(40), fontWeight: FontWeight.bold)),
                            WidgetUtils.commonSizedBox(5, 0),
                            Row(
                              children: [
                                Container(
                                  height: ScreenUtil().setHeight(25),
                                  width: ScreenUtil().setWidth(50),
                                  alignment: Alignment.center,
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.dtPink ,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: WidgetUtils.showImages(
                                      'assets/images/nv.png',
                                      12,
                                      12),
                                ),
                              ],
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            Container(
                              height: ScreenUtil().setHeight(38),
                              width: ScreenUtil().setWidth(208),
                              padding: const EdgeInsets.only(left: 8),
                              alignment: Alignment.center,
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.peopleBlue ,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Row(
                                children: [
                                  WidgetUtils.onlyText('ID:12345678', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(26))),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.showImages('assets/images/people_fuzhi.png', ScreenUtil().setHeight(22), ScreenUtil().setWidth(22)),
                                ],
                              ),
                            ),
                            const Expanded(child: Text('')),
                          ],
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(68),
                        width: ScreenUtil().setWidth(151),
                        padding: const EdgeInsets.only(left: 8),
                        alignment: Alignment.center,
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: Colors.white ,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            WidgetUtils.showImages('assets/images/zhibozhong2.webp', ScreenUtil().setHeight(22), ScreenUtil().setWidth(22)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyText('踩房间', StyleUtils.getCommonTextStyle(color: MyColors.careBlue, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(30))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(10, 0),
                /// 音频
                Row(
                  children: [
                    Container(
                      height: ScreenUtil().setHeight(50),
                      width: ScreenUtil().setWidth(220),
                      margin: EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.only(left: 8),
                      alignment: Alignment.topLeft,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.peopleYellow ,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Row(
                        children: [
                          WidgetUtils.showImages('assets/images/people_bofang.png', ScreenUtil().setHeight(35), ScreenUtil().setWidth(35)),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText('晴天少女', StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
                WidgetUtils.commonSizedBox(15, 0),
                Expanded(
                  child: Container(
                    height: double.infinity,
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
                        Row(
                          children: [
                            Container(
                                alignment: Alignment.bottomLeft,
                                height: ScreenUtil().setHeight(80),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: ((){
                                        setState(() {
                                          _currentIndex = 0;
                                          _controller.jumpToPage(0);
                                        });
                                      }),
                                      child: Text(
                                        '资料',
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: _currentIndex == 0 ? Colors.black : MyColors.g6,
                                            fontSize:_currentIndex == 0 ? ScreenUtil().setSp(48) : ScreenUtil().setSp(36),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    WidgetUtils.commonSizedBox(0, 20),
                                    GestureDetector(
                                      onTap: ((){
                                        setState(() {
                                          _currentIndex = 1;
                                          _controller.jumpToPage(1);
                                        });
                                      }),
                                      child: Text(
                                        '动态',
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: _currentIndex == 1 ? Colors.black : MyColors.g6,
                                            fontSize: _currentIndex == 1 ? ScreenUtil().setSp(48) : ScreenUtil().setSp(36),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                        Expanded(
                          child: PageView(
                            controller: _controller,
                            onPageChanged: (index) {
                              setState(() {
                                // 更新当前的索引值
                                _currentIndex = index;
                              });
                            },
                            children: const [
                              ZiliaoPage(),
                              DongtaiPage(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ScreenUtil().setHeight(120),
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(      //渐变位置
                      begin: Alignment.topCenter, //右上
                      end: Alignment.bottomCenter, //左下
                      stops: [0.0, 1.0],         //[渐变起始点, 渐变结束点]
                      //渐变颜色[始点颜色, 结束颜色]
                      colors: [Color.fromRGBO(255, 255, 255, 0), Color.fromRGBO(255, 255, 255, 1)]
                  )
              ),
              child: Row(
                children: [
                  WidgetUtils.PeopleButton('assets/images/people_hongbao.png', '发红包', MyColors.peopleRed),
                  const Expanded(child: Text('')),
                  WidgetUtils.PeopleButton('assets/images/people_jia.png', '加关注', MyColors.peopleYellow),
                  const Expanded(child: Text('')),
                  WidgetUtils.PeopleButton('assets/images/people_sixin.png', '私信', MyColors.peopleBlue2),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
