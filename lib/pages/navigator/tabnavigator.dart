import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:yuyinting/pages/message/message_page.dart';
import 'package:yuyinting/pages/trends/trends_page.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import '../../colors/my_colors.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';
import '../gongping/gp_show_one_page.dart';
import '../home/home_page.dart';
import '../mine/mine_page.dart';

class Tab_Navigator extends StatefulWidget {
  const Tab_Navigator({Key? key}) : super(key: key);

  @override
  State<Tab_Navigator> createState() => _Tab_NavigatorState();
}

class _Tab_NavigatorState extends State<Tab_Navigator>
    with TickerProviderStateMixin {
  final _defaultColor = MyColors.btn_d;
  final _activetColor = MyColors.btn_a;
  int _currentIndex = 0;

  //定义个变量，检测两次点击返回键的时间，如果在1秒内点击两次就退出
  DateTime? lastPopTime = null;

  late final PageController _controller;

  // 是否开始拖拽
  bool isDragNow = false;

  // 是否将要删除
  bool isRemove = false;

  // 是否有进入房间返回出来
  bool isJoinRoom = true;

  /// 会重复播放的控制器
  late AnimationController _repeatController;

  /// 线性动画
  late Animation<double> _animation;



  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );

    /// 动画持续时间是 3秒，此处的this指 TickerProviderStateMixin
    _repeatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(); // 设置动画重复播放

    // 创建一个从0到360弧度的补间动画 v * 2 * π
    _animation = Tween<double>(begin: 0, end: 1).animate(_repeatController);


    // MyUtils.goTransparentPageCom(context, GPShowOnePage());

    MyUtils.initSDK();
    MyUtils.addChatListener();
    MyUtils.signIn();
  }

  @override
  void dispose() {
    _repeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
      child: Stack(
        children: [
          Scaffold(
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
            bottomNavigationBar: BottomNavigationBar(
                selectedFontSize: 12,
                unselectedFontSize: 12,
                currentIndex: _currentIndex,
                onTap: (index) {
                  _controller.jumpToPage(index);
                  setState(() {
                    _currentIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  _bottomNavigationBarItem(
                      '首页', 'assets/images/ic_bottom_menu1.png', 0),
                  _bottomNavigationBarItem(
                      '动态', 'assets/images/ic_bottom_menu2.png', 1),
                  _bottomNavigationBarItem(
                      '消息', 'assets/images/ic_bottom_menu3.png', 2),
                  _bottomNavigationBarItem(
                      '我的', 'assets/images/ic_bottom_menu3.png', 3),
                ]),
          ),

          /// 房间图标转动
          isJoinRoom
              ? Positioned(
                  bottom: 200,
                  right: 20,
                  child: RotationTransition(
                    turns: _animation,
                    child: Draggable(
                        data: '1',
                        //当拖动对象开始被拖动时调用
                        onDragStarted: () {
                          setState(() {
                            isDragNow = true;
                          });
                        },
                        //当拖动对象被放下时调用
                        onDragEnd: (va) {
                          setState(() {
                            isDragNow = false;
                          });
                        },
                        //当draggable 被放置并被【DragTarget】 接受时调用
                        onDragCompleted: () {},
                        //当draggable 被放置但未被【DragTarget】 接受时调用
                        onDraggableCanceled: (velocity, offset) {},

                        //拖动显示
                        feedback: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3)),
                          child: WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(90),
                              ScreenUtil().setHeight(90),
                              'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg'),
                        ),
                        //拖动占位
                        childWhenDragging: Opacity(
                          opacity: 0,
                          child: WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(90),
                              ScreenUtil().setHeight(90),
                              'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg'),
                        ),
                        child: WidgetUtils.CircleHeadImage(
                            ScreenUtil().setHeight(90),
                            ScreenUtil().setHeight(90),
                            'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg')),
                  ),
                )
              : const Text(''),
          Column(
            children: [
              const Expanded(child: Text('')),
              isDragNow
                  ? DragTarget(
                      // 调用以构建此小部件的内容
                      builder: (BuildContext context,
                          List<String?> candidateData,
                          List<dynamic> rejectedData) {
                        return Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(80),
                          decoration: BoxDecoration(
                            //背景
                            color: isRemove ? Colors.red[500] : Colors.red[200],
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                size: 20,
                                color: isRemove ? Colors.white : Colors.white70,
                              ),
                              WidgetUtils.commonSizedBox(0, 5),
                              WidgetUtils.onlyTextCenter(
                                  isRemove ? '松手即可退出房间' : '拖到这里退出房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: isRemove
                                          ? Colors.white
                                          : Colors.white70,
                                      fontSize: ScreenUtil().setSp(21)))
                            ],
                          ),
                        );
                      },
                      // 调用以确定此小部件是否有兴趣接受给定的被拖动到这个拖动目标上的数据片段
                      onWillAccept: (data) {
                        setState(() {
                          isRemove = true;
                          isJoinRoom = true;
                        });
                        return true;
                      },
                      // 当一条可接受的数据被拖放到这个拖动目标上时调用
                      onAccept: (data) {
                        setState(() {
                          isRemove = false;
                          isJoinRoom = false;
                        });
                      },
                      // 当一条可接受的数据被拖放离开这个拖动目标上时调用
                      onLeave: (data) {
                        setState(() {
                          isRemove = false;
                          isJoinRoom = true;
                        });
                      },
                    )
                  : const Text('')
            ],
          )
        ],
      ),
    );
  }

  /// 自定义底部信息
  _bottomNavigationBarItem(String title, String imgUrl, int i) {
    return BottomNavigationBarItem(
      label: title,
      icon: Image.asset(
        i == 0
            ? "assets/images/ic_bottom_menu1.png"
            : i == 1
                ? "assets/images/ic_bottom_menu2.png"
                : i == 2
                    ? "assets/images/ic_bottom_menu3.png"
                    : "assets/images/ic_bottom_menu4.png",
        fit: BoxFit.fill,
        width: 25,
        height: 25,
      ),
      activeIcon: Image.asset(
        i == 0
            ? "assets/images/ic_bottom_menu11.png"
            : i == 1
                ? "assets/images/ic_bottom_menu22.png"
                : i == 2
                    ? "assets/images/ic_bottom_menu33.png"
                    : "assets/images/ic_bottom_menu44.png",
        width: 25,
        height: 25,
      ),
    );
  }
}
