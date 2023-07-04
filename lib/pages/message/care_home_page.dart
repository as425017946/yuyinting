import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/message/geren/who_lock_me_page.dart';

import '../../colors/my_colors.dart';
import '../../utils/widget_utils.dart';
import 'be_care_page.dart';
import 'care_page.dart';
/// 关注和被关注整合页面

class CareHomePage extends StatefulWidget {
  const CareHomePage({Key? key}) : super(key: key);

  @override
  State<CareHomePage> createState() => _CareHomePageState();
}

class _CareHomePageState extends State<CareHomePage> {
  int _currentIndex = 0;
  late final PageController _controller ;
  EasyRefreshController easyRefreshController = EasyRefreshController();
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
      backgroundColor: Colors.white,
      body: Column(
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
                    color: Colors.black,
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                  ),
                ),
                const Expanded(child: Text('')),
                /// 关注被关注切换按钮
                SizedBox(
                  height: ScreenUtil().setHeight(80),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: ((){
                          _currentIndex = 0;
                          _controller.jumpToPage(0);
                        }),
                        child: Text(
                          '关注',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontSize:_currentIndex == 0 ? ScreenUtil().setSp(46) : ScreenUtil().setSp(32),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 20),
                      GestureDetector(
                        onTap: ((){
                          _currentIndex = 1;
                          _controller.jumpToPage(1);
                        }),
                        child: Text(
                          '被关注',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontSize: _currentIndex == 1 ? ScreenUtil().setSp(46) : ScreenUtil().setSp(32),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 20),
                      GestureDetector(
                        onTap: ((){
                          _currentIndex = 2;
                          _controller.jumpToPage(2);
                        }),
                        child: Text(
                          '谁看过我',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontSize: _currentIndex == 2 ? ScreenUtil().setSp(46) : ScreenUtil().setSp(32),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ),
                const Expanded(child: Text('')),
                WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(100)),
              ],
            ),
          ),
          _currentIndex != 2 ? WidgetUtils.commonSizedBox(20, 0) : const Text(''),
          ///搜索按钮
          _currentIndex != 2 ? Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            height: ScreenUtil().setHeight(70),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: MyColors.f2,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              //设置四周边框
              border: Border.all(width: 1, color: MyColors.f2),
            ),
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 10),
                WidgetUtils.showImages('assets/images/messages_sousuo.png',
                    ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(child: WidgetUtils.commonTextField(_souSuoName, '请搜索昵称或ID')),
              ],
            ),
          ) : WidgetUtils.commonSizedBox(0, 0),
          WidgetUtils.commonSizedBox(10, 0),
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
                CarePage(),
                BeCarePage(),
                WhoLockMePage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
