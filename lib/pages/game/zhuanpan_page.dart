import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/game/zhuanpan_super_page.dart';
import 'package:yuyinting/pages/game/zhuanpan_xin_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import '../../bean/balanceBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../mine/qianbao/dou_pay_page.dart';

/// 转盘主页
class ZhuanPanPage extends StatefulWidget {
  String roomId;
  ZhuanPanPage({super.key, required this.roomId});

  @override
  State<ZhuanPanPage> createState() => _ZhuanPanPageState();
}

class _ZhuanPanPageState extends State<ZhuanPanPage> {
  int isCheck = 1;
  int _currentIndex = 0;
  late final PageController _controller;
  var  listen2;
  bool isBack = false;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
    listen2 = eventBus.on<GameBack>().listen((event) {
      setState(() {
        isBack = event.isBack;
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          if (isBack) {
            // 阻止返回操作
            return false;
          }
          return true; // 允许正常的返回操作
        },
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (() {
                  if(isBack){
                    return;
                  }
                  eventBus.fire(SubmitButtonBack(title: '转盘关闭'));
                  Navigator.pop(context);
                }),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(950),
              width: double.infinity,
              decoration: BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage(_currentIndex == 0 ? "assets/images/zhuanpan_tow_bg.png" : "assets/images/zhuanpan_one_bg.png"),
                  fit: BoxFit.fill, //覆盖
                ),
              ),
              child: Stack(
                children: [
                  // 页面信息
                  Container(
                    height: 950.h,
                    color: Colors.transparent,
                    child: PageView(
                      reverse: false,
                      physics: isBack ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          // 更新当前的索引值
                          _currentIndex = index;
                        });
                      },
                      children: [
                        ZhuanPanXinPage(roomId: widget.roomId,),
                        ZhuanPanSuperPage(roomId: widget.roomId,),
                      ],
                    ),
                  ),
                  // 头部信息
                  Container(
                    height: ScreenUtil().setHeight(61),
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 10),
                        Container(
                          height: ScreenUtil().setHeight(61),
                          width: ScreenUtil().setHeight(260),
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: MyColors.zpBG,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: _currentIndex == 0
                                      ? GestureDetector(
                                    onTap: (() {
                                      if(isBack){
                                        return;
                                      }
                                      setState(() {
                                        _currentIndex = 0;
                                        _controller.animateToPage(0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    }),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            MyColors.zpBGJ1,
                                            MyColors.zpBGJ2,
                                          ],
                                        ),
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '心动转盘',
                                          style: TextStyle(
                                              color: MyColors.zpWZ1,
                                              fontSize:
                                              ScreenUtil().setSp(22),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  )
                                      : GestureDetector(
                                    onTap: (() {
                                      if(isBack){
                                        return;
                                      }
                                      setState(() {
                                        _currentIndex = 0;
                                        _controller.animateToPage(0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    }),
                                    child: Center(
                                      child: Text(
                                        '心动转盘',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            ScreenUtil().setSp(22),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  child: _currentIndex == 1
                                      ? GestureDetector(
                                    onTap: (() {
                                      if(isBack){
                                        return;
                                      }
                                      setState(() {
                                        _currentIndex = 1;
                                        _controller.animateToPage(1,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    }),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            MyColors.zpBGJ1,
                                            MyColors.zpBGJ2,
                                          ],
                                        ),
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '超级转盘',
                                          style: TextStyle(
                                              color: MyColors.zpWZ1,
                                              fontSize:
                                              ScreenUtil().setSp(22),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  )
                                      : GestureDetector(
                                    onTap: (() {
                                      if(isBack){
                                        return;
                                      }
                                      setState(() {
                                        _currentIndex = 1;
                                        _controller.animateToPage(1,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                      });
                                    }),
                                    child: Center(
                                      child: Text(
                                        '超级转盘',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            ScreenUtil().setSp(22),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const Spacer(),
                        WidgetUtils.commonSizedBox(0, 10),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
