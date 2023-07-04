import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/widget_utils.dart';
import 'my_dongtai_page.dart';
import 'my_ziliao_page.dart';

/// 个人主页
class MyInfoPage extends StatefulWidget {
  const MyInfoPage({Key? key}) : super(key: key);

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
                    width: ScreenUtil().setWidth(100),
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
                  GestureDetector(
                    onTap: ((){
                      Navigator.pushNamed(context, 'EditMyInfoPage');
                    }),
                    child: Container(
                      width: ScreenUtil().setWidth(100),
                      child: WidgetUtils.showImages('assets/images/mine_edit.png', ScreenUtil().setHeight(33), ScreenUtil().setHeight(33)),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
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
                  WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(140), ScreenUtil().setWidth(140), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                  WidgetUtils.commonSizedBox(0, 10),
                  ///昵称等信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText('昵称', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(38), fontWeight: FontWeight.bold)),
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
                              WidgetUtils.onlyText('ID:12345678', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(26))),
                              WidgetUtils.commonSizedBox(0, 5),
                              WidgetUtils.showImages('assets/images/people_fuzhi.png', ScreenUtil().setHeight(22), ScreenUtil().setWidth(22)),
                            ],
                          ),
                        ),
                        const Expanded(child: Text('')),
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
                  width: ScreenUtil().setWidth(180),
                  margin: const EdgeInsets.only(left: 20),
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
                                        fontSize:ScreenUtil().setSp(36) ,
                                        fontWeight: _currentIndex == 0 ? FontWeight.bold : FontWeight.normal),
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
                                        fontSize:ScreenUtil().setSp(36) ,
                                        fontWeight: _currentIndex == 1 ? FontWeight.bold : FontWeight.normal),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    Expanded(
                      child: PageView(
                        reverse: false,
                        controller: _controller,
                        onPageChanged: (index) {
                          setState(() {
                            // 更新当前的索引值
                            _currentIndex = index;
                          });
                        },
                        children: const [
                          MyZiliaoPage(),
                          MyDongtaiPage(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
