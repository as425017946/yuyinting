import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/game/zhuanpan_super_page.dart';
import 'package:yuyinting/pages/game/zhuanpan_xin_page.dart';
import 'package:yuyinting/utils/event_utils.dart';

import '../../bean/balanceBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

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
  var listen, listen2;
  bool isBack = false;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
    doPostWalletList();
    listen = eventBus.on<XiaZhuBack>().listen((event) {
      setState(() {
        if(jinbi.contains('w')){
          // 目的是先把 1w 转换成 10000
          jinbi = (double.parse(jinbi.substring(0,jinbi.length - 1)) * 1000).toString();
          // 减去花费的V豆
          jinbi = '${(double.parse(jinbi) - event.jine)/1000}w';
        }else{
          jinbi = (double.parse(jinbi) - event.jine).toString();
        }
      });
    });

    listen2 = eventBus.on<ResidentBack>().listen((event) {
      setState(() {
        isBack = event.isBack;
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listen2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                if(isBack){
                  return;
                }
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
            child: Column(
              children: [
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
                      Container(
                        height: ScreenUtil().setHeight(45),
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 1, bottom: 1),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.zpBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages(
                                'assets/images/mine_wallet_dd.png',
                                ScreenUtil().setHeight(26),
                                ScreenUtil().setHeight(24)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyTextCenter(
                                jinbi,
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.w600)),
                            WidgetUtils.commonSizedBox(0, 5),
                            Opacity(
                              opacity: 0.8,
                              child: Container(
                                height: ScreenUtil().setHeight(20),
                                width: ScreenUtil().setHeight(1),
                                color: MyColors.home_hx,
                              ),
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                            WidgetUtils.showImages(
                                'assets/images/mine_wallet_zz.png',
                                ScreenUtil().setHeight(26),
                                ScreenUtil().setHeight(24)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyTextCenter(
                                zuanshi,
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.w600)),
                            WidgetUtils.commonSizedBox(0, 5),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                    ],
                  ),
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
                    children: [
                      ZhuanPanXinPage(roomId: widget.roomId,),
                      ZhuanPanSuperPage(roomId: widget.roomId,),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  // 金币 钻石
  String jinbi = '', zuanshi = '';
  /// 钱包明细
  Future<void> doPostWalletList() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(double.parse(bean.data!.goldBean!) > 10000){
              jinbi = '${(double.parse(bean.data!.goldBean!)/10000)}w';
            }else{
              jinbi = bean.data!.goldBean!;
            }
            if(double.parse(bean.data!.diamond!) > 10000){
              zuanshi = '${(double.parse(bean.data!.diamond!)/10000)}w';
            }else{
              zuanshi = bean.data!.diamond!;
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
