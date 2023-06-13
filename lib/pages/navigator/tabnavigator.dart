import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/message/message_page.dart';
import 'package:yuyinting/pages/trends/trends_page.dart';
import '../../colors/my_colors.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../home/home_page.dart';
import '../mine/mine_page.dart';

class Tab_Navigator extends StatefulWidget {
  const Tab_Navigator({Key? key}) : super(key: key);

  @override
  State<Tab_Navigator> createState() => _Tab_NavigatorState();
}

class _Tab_NavigatorState extends State<Tab_Navigator> {
  final _defaultColor = MyColors.btn_d;
  final _activetColor = MyColors.btn_a;
  int _currentIndex = 0;
  //定义个变量，检测两次点击返回键的时间，如果在1秒内点击两次就退出
  DateTime? lastPopTime = null;

  late final PageController _controller ;

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
    return WillPopScope(
      onWillPop: () async  {
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime!) > Duration(seconds: 1)) {
          lastPopTime = DateTime.now();

          MyToastUtils.showToastBottom("再按一次退出");
          return Future.value(false);
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(), //禁止左右滑动
          onPageChanged: (index) {
            setState(() {
              // 更新当前的索引值
              _currentIndex = index;
            });
          },
          children: const [
            HomePage(),
            TrendsPage(),
            MessagePage(),
            MinePage()
          ],
        ),
        bottomNavigationBar:BottomNavigationBar(
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: _currentIndex,
            onTap: (index){
              _controller.jumpToPage(index);
              setState((){
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              _bottomNavigationBarItem('首页','assets/images/ic_bottom_menu1.png',0),
              _bottomNavigationBarItem('动态','assets/images/ic_bottom_menu2.png',1),
              _bottomNavigationBarItem('消息','assets/images/ic_bottom_menu3.png',2),
              _bottomNavigationBarItem('我的','assets/images/ic_bottom_menu3.png',3),
            ]
        ),
      ),
    );
  }
  /// 自定义底部信息
  _bottomNavigationBarItem(String title,String imgUrl,int i){
    return BottomNavigationBarItem(
      label: title,
      icon: Image.asset(i == 0 ? "assets/images/ic_bottom_menu1.png" : i == 1 ? "assets/images/ic_bottom_menu2.png" : i == 2 ? "assets/images/ic_bottom_menu3.png" : "assets/images/ic_bottom_menu4.png",fit: BoxFit.fill,width: 25,height: 25,),
      activeIcon: Image.asset(i == 0 ? "assets/images/ic_bottom_menu11.png" : i == 1 ? "assets/images/ic_bottom_menu22.png" : i == 2 ? "assets/images/ic_bottom_menu33.png" : "assets/images/ic_bottom_menu44.png", width: 25,height: 25,),
    );
  }
}
