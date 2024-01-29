import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/game/zhuanpan_super_page.dart';
import 'package:yuyinting/pages/game/zhuanpan_xin_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../bean/balanceBean.dart';
import '../../config/my_config.dart';
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
  var listen, listen2;
  bool isBack = false;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
    doPostBalance();
    listen = eventBus.on<XiaZhuBack>().listen((event) {
      setState(() {
        //cur_type 1金豆 2钻石 3蘑菇
        if(event.type == 1){
          if(double.parse(jinbi) > 10000){
            // 减去花费的V豆
            jinbi = '${(double.parse(jinbi) - event.jine)}';
            if(double.parse(jinbi) > 10000){
              //保留2位小数
              jinbi2 = '${(double.parse(jinbi) / 10000)}';
              if(jinbi2.split('.')[1].length >=2){
                jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1].substring(0,2)}w';
              }else{
                jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1]}w';
              }
            }else{
              jinbi2 = jinbi;
            }

          }else{
            jinbi = (double.parse(jinbi) - event.jine).toString();
            jinbi2 = jinbi;
          }
          sp.setString('zp_jinbi', jinbi);
        }else if(event.type == 2){
          if(double.parse(zuanshi) > 10000){
            // 减去花费的V豆
            zuanshi = '${(double.parse(zuanshi) - event.jine)}';
            if(double.parse(zuanshi) > 10000){
              zuanshi2 = '${(double.parse(zuanshi) / 10000)}';
              if(zuanshi2.split('.')[1].length >=2){
                zuanshi2 = '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1].substring(0,2)}w';
              }else{
                zuanshi2 = '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1]}w';
              }
            }else{
              zuanshi2 = zuanshi;
            }
          }else{
            zuanshi = (double.parse(zuanshi) - event.jine).toString();
            zuanshi2 = zuanshi;
          }
        }
      });
    });

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
    listen.cancel();
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
                        GestureDetector(
                          onTap: ((){
                            MyUtils.goTransparentPageCom(context, DouPayPage(shuliang: jinbi,));
                          }),
                          child: Container(
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
                                    jinbi2,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(23),
                                        fontWeight: FontWeight.w600)),
                                WidgetUtils.commonSizedBox(0, 5.w),
                                Image(
                                  image: const AssetImage(
                                      'assets/images/wallet_more.png'),
                                  width: 15.h,
                                  height: 15.h,
                                ),
                                WidgetUtils.commonSizedBox(0, 5),
                                // 钻石处先隐藏
                                // Opacity(
                                //   opacity: 0.8,
                                //   child: Container(
                                //     height: ScreenUtil().setHeight(20),
                                //     width: ScreenUtil().setHeight(1),
                                //     color: MyColors.home_hx,
                                //   ),
                                // ),
                                // WidgetUtils.commonSizedBox(0, 10),
                                // WidgetUtils.showImages(
                                //     'assets/images/mine_wallet_zz.png',
                                //     ScreenUtil().setHeight(26),
                                //     ScreenUtil().setHeight(24)),
                                // WidgetUtils.commonSizedBox(0, 5),
                                // WidgetUtils.onlyTextCenter(
                                //     zuanshi2,
                                //     StyleUtils.getCommonTextStyle(
                                //         color: Colors.white,
                                //         fontSize: ScreenUtil().setSp(23),
                                //         fontWeight: FontWeight.w600)),
                                // WidgetUtils.commonSizedBox(0, 5),
                              ],
                            ),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),
                      ],
                    ),
                  ),
                  Expanded(
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  // 金币 钻石
  String jinbi = '', jinbi2 = '', zuanshi = '', zuanshi2 = '';
  /// 钱包余额
  Future<void> doPostBalance() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            jinbi = bean.data!.goldBean!;
            sp.setString('zp_jinbi', jinbi);
            if(double.parse(bean.data!.goldBean!) > 10000){
              jinbi2 = '${(double.parse(bean.data!.goldBean!) / 10000)}';
              if(jinbi2.split('.')[1].length >=2){
                jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1].substring(0,2)}w';
              }else{
                jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1]}w';
              }
            }else{
              jinbi2 = bean.data!.goldBean!;
            }
            zuanshi = bean.data!.diamond!;
            if(double.parse(bean.data!.diamond!) > 10000){
              zuanshi2 = '${(double.parse(bean.data!.diamond!) / 10000)}';
              if(zuanshi2.split('.')[1].length >=2){
                zuanshi2 = '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1].substring(0,2)}w';
              }else{
                zuanshi2 = '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1]}w';
              }
            }else{
              zuanshi2 = bean.data!.diamond!;
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
