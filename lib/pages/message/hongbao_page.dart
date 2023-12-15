import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../bean/balanceBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';

/// 发红包页面
class HongBaoPage extends StatefulWidget {
  String uid;
  HongBaoPage({super.key,  required this.uid});

  @override
  State<HongBaoPage> createState() => _HongBaoPageState();
}

class _HongBaoPageState extends State<HongBaoPage> {
  TextEditingController controllerDou = TextEditingController();
  // 0钻石 1V豆
  int type = 0;
  // 是否显示全的
  bool isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
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
            height: isShow ? 700.h : 800.h,
            width: double.infinity,
            padding: EdgeInsets.only(left: 20.h, right: 20.h),
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/fahongbao.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(320.h, 0),
                Row(
                  children: [
                    // WidgetUtils.commonSizedBox(0, 30.h),
                    // Opacity(
                    //     opacity: 0,
                    //     child: WidgetUtils.onlyText(
                    //         '充值',
                    //         StyleUtils.getCommonTextStyle(
                    //             color: MyColors.peopleRed, fontSize: 25.sp))),
                    const Spacer(),
                    WidgetUtils.onlyText(
                        '发红包',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    // WidgetUtils.onlyText(
                    //     '充值',
                    //     StyleUtils.getCommonTextStyle(
                    //         color: MyColors.peopleRed, fontSize: 25.sp)),
                    // WidgetUtils.commonSizedBox(0, 30.h),
                  ],
                ),
                isShow ? WidgetUtils.commonSizedBox(20.h, 0) : WidgetUtils.commonSizedBox(0.h, 0),
                isShow ? WidgetUtils.onlyText(
                    '选择红包类型:',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: 28.sp, fontWeight: FontWeight.w300)) : const Text(''),
                isShow ? WidgetUtils.commonSizedBox(50.h, 0) : const Text(''),
                isShow ? Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: ((){
                        setState(() {
                          type = 0;
                        });
                      }),
                      child: Container(
                        height: 75.h,
                        width: 190.h,
                        decoration: BoxDecoration(
                          //背景
                          color: type == 0 ? MyColors.walletMingxi : Colors.white,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(42.h)),
                          //设置四周边框
                          border: Border.all(width: 1, color: MyColors.walletMingxi),
                        ),
                        child: Row(
                          children: [
                            const Spacer(),
                            WidgetUtils.showImages('assets/images/mine_wallet_zz.png', 51.h, 49.h),
                            WidgetUtils.commonSizedBox(0, 10.h),
                            WidgetUtils.onlyText(
                                '发钻石',
                                StyleUtils.getCommonTextStyle(
                                    color: type != 0 ?  MyColors.walletMingxi : Colors.white, fontSize: 32.sp, fontWeight: FontWeight.w300)),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 40.h),
                    GestureDetector(
                      onTap: ((){
                        setState(() {
                          type = 1;
                        });
                      }),
                      child: Container(
                        height: 75.h,
                        width: 190.h,
                        decoration: BoxDecoration(
                          //背景
                          color: type == 1 ?  MyColors.walletMingxi : Colors.white,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(42.h)),
                          //设置四周边框
                          border: Border.all(width: 1, color: MyColors.walletMingxi),
                        ),
                        child: Row(
                          children: [
                            const Spacer(),
                            WidgetUtils.showImages('assets/images/mine_wallet_dd.png', 51.h, 49.h),
                            WidgetUtils.commonSizedBox(0, 10.h),
                            WidgetUtils.onlyText(
                                '发V豆',
                                StyleUtils.getCommonTextStyle(
                                    color: type != 1 ?  MyColors.walletMingxi : Colors.white, fontSize: 32.sp, fontWeight: FontWeight.w300)),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ) : const Text(''),
                isShow ? WidgetUtils.commonSizedBox(80.h, 0) :  WidgetUtils.commonSizedBox(0, 0),
                // 输入红包个数
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    //背景
                    color: MyColors.dailiBaobiao,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(Radius.circular(20.h)),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0.h, 20.h),
                      WidgetUtils.onlyText(
                          '输入V豆数量',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black87, fontSize: 32.sp, fontWeight: FontWeight.w500)),
                      Expanded(
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: WidgetUtils.commonTextFieldNumberHB(
                              controller: controllerDou,
                              hintText: '请在此输入'),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0.h, 10.h),
                      WidgetUtils.onlyText(
                          '个',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black87, fontSize: 32.sp, fontWeight: FontWeight.w500)),
                      WidgetUtils.commonSizedBox(0.h, 20.h),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(30.h, 0),
                // 余额
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0.h, 20.h),
                    WidgetUtils.onlyText(
                        '余额',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white70, fontSize: 28.sp, fontWeight: FontWeight.w300)),
                    WidgetUtils.commonSizedBox(0.h, 5.h),
                    Transform.translate(offset: Offset(0,2.h), child: WidgetUtils.onlyText(
                        jinbi,
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.w600)),)
                  ],
                ),
                WidgetUtils.commonSizedBox(60.h, 0),
                GestureDetector(
                  onTap: ((){
                    if(controllerDou.text.isEmpty){
                      MyToastUtils.showToastBottom('请输入要发送的V豆数量');
                    }else{
                      doPostSendRedPacket(controllerDou.text);
                    }
                  }),
                  child: Container(
                    height: 90.h,
                    width: 360.h,
                    decoration: BoxDecoration(
                      //背景
                      color: MyColors.peopleYellow,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(50.h)),
                    ),
                    child: WidgetUtils.onlyTextCenter(
                        '发红包',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black87, fontSize: 38.sp, fontWeight: FontWeight.w300)),
                  ),
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 金币 钻石
  String jinbi = '', zuanshi = '';
  /// 钱包余额
  Future<void> doPostBalance() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            jinbi = bean.data!.goldBean!;
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

  /// 发红包
  Future<void> doPostSendRedPacket(String shuliang) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'amount': shuliang,
      'amount_type': '1',
    };
    try {
      CommonBean bean = await DataUtils.postSendRedPacket(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          eventBus.fire(HongBaoBack(info: shuliang));
          setState(() {
            jinbi = (double.parse(jinbi) - double.parse(shuliang)).toString();
          });
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
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
