import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/loading.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/myFenRunBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/my_toast_utils.dart';
import 'fenrun_ts_page.dart';

/// 我的推广
class TuiguangPage extends StatefulWidget {
  const TuiguangPage({Key? key}) : super(key: key);

  @override
  State<TuiguangPage> createState() => _TuiguangPageState();
}

class _TuiguangPageState extends State<TuiguangPage> {
  /// 推广总人数，今日推广人数，今日游戏参与额，今日中奖礼物额，今日直刷礼物额，今日实际分润额，分润比例，历史分润V豆，历史分润钻石，可领取V豆，可领取钻石
  String allPeople = '',
      dayPeople = '',
      dayGameMoney = '',
      dayZjMoney = '',
      dayZSMoney = '',
      daySjMoney = '',
      fenRunBL = '',
      lsVMoney = '',
      lsZSMoney = '',
      lqVMoney = '',
      lqZSMoney = '';
  // 是否显示领取按钮
  bool isShow = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      doPostMyPromotion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(40.h, 10),
        // Row(
        //   children: [
        //     const Expanded(child: Text('')),
        //     WidgetUtils.onlyText('2023-06-12', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(33))),
        //     WidgetUtils.commonSizedBox(0, 10),
        //     WidgetUtils.onlyText('至', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(33))),
        //     WidgetUtils.commonSizedBox(0, 10),
        //     WidgetUtils.onlyText('2023-06-12', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(33))),
        //     const Expanded(child: Text('')),
        //   ],
        // ),
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(485),
          margin: EdgeInsets.all(20.h),
          //边框设置
          decoration: const BoxDecoration(
            //背景
            color: MyColors.dailiBlue,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            children: [
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '推广总人数',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '今日推广人数',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          allPeople,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          dayPeople,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '今日游戏参与额',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '今日中奖礼物额',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          dayGameMoney,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          dayZjMoney,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          '今日直刷礼物额',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28)))),
                  Expanded(
                      child: GestureDetector(
                    onTap: (() {
                      MyUtils.goTransparentPageCom(
                          context, const FenRunTSPage());
                    }),
                    child: Row(
                      children: [
                        const Spacer(),
                        WidgetUtils.onlyTextCenter(
                            '今日实时分润',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                        WidgetUtils.commonSizedBox(0, 5.h),
                        WidgetUtils.showImages(
                            'assets/images/daili_wenti.png', 30.h, 30.h),
                        const Spacer(),
                      ],
                    ),
                  )),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          dayZSMoney,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                  Expanded(
                      child: WidgetUtils.onlyTextCenter(
                          daySjMoney,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600))),
                ],
              ),
              WidgetUtils.commonSizedBox(30, 10),
              WidgetUtils.onlyTextCenter(
                  '分润比例：$fenRunBL%',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g9, fontSize: ScreenUtil().setSp(21)))
            ],
          ),
        ),

        ///历史总分润
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20.h),
            Expanded(
              child: Container(
                height: 220.h,
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: MyColors.dailiPink,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter(
                        '历史总V币分润',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28))),
                    WidgetUtils.commonSizedBox(15.h, 0),
                    WidgetUtils.onlyTextCenter(
                         lsVMoney,
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(33),
                            fontWeight: FontWeight.w600)),
                    WidgetUtils.commonSizedBox(15.h, 0),
                    WidgetUtils.onlyTextCenter(
                        '历史总钻石分润',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28))),
                    WidgetUtils.commonSizedBox(15.h, 0),
                    WidgetUtils.onlyTextCenter(
                        lsZSMoney,
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(33),
                            fontWeight: FontWeight.w600)),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(0, 20.h),
            Expanded(
              child: Container(
                height: 220.h,
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: MyColors.dailiPurple,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter(
                        '可领取V币',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28))),
                    WidgetUtils.commonSizedBox(15, 10),
                    WidgetUtils.onlyTextCenter(
                        lqVMoney,
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(33),
                            fontWeight: FontWeight.w600)),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(0, 20.h),
            Expanded(
              child: Container(
                height: 220.h,
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: MyColors.dailiPurple,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter(
                        '可领取钻石',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28))),
                    WidgetUtils.commonSizedBox(15, 10),
                    WidgetUtils.onlyTextCenter(
                        lqZSMoney,
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(33),
                            fontWeight: FontWeight.w600)),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(0, 20.h),
          ],
        ),
        WidgetUtils.commonSizedBox(50, 20),

        /// 立即推广按钮
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (() {
                    Navigator.pushNamed(context, 'ShareTuiguangPage');
                  }),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(70),
                      double.infinity,
                      MyColors.homeTopBG,
                      MyColors.homeTopBG,
                      '立即推广',
                      ScreenUtil().setSp(28),
                      Colors.white),
                ),
              ),
              isShow ? WidgetUtils.commonSizedBox(0, 20) : const Text(''),
              isShow ? Expanded(
                child: GestureDetector(
                  onTap: (() {
                    doPostRoomUserInfo(1);
                  }),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(70),
                      double.infinity,
                      MyColors.homeTopBG,
                      MyColors.homeTopBG,
                      '领取V币',
                      ScreenUtil().setSp(28),
                      Colors.white),
                ),
              ) : const Text(''),
              isShow ? WidgetUtils.commonSizedBox(0, 20) : const Text(''),
              isShow ? Expanded(
                child: GestureDetector(
                  onTap: (() {
                    doPostRoomUserInfo(2);
                  }),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(70),
                      double.infinity,
                      MyColors.homeTopBG,
                      MyColors.homeTopBG,
                      '领取钻石',
                      ScreenUtil().setSp(28),
                      Colors.white),
                ),
              ) : const Text(''),
            ],
          ),
        )
      ],
    );
  }

  /// 我的推广
  Future<void> doPostMyPromotion() async {
    Loading.show();
    try {
      myFenRunBean bean = await DataUtils.postMyPromotion();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            allPeople = bean.data!.allPromotionNum.toString();
            dayPeople = bean.data!.promotionNum.toString();
            dayGameMoney = bean.data!.game!;
            dayZjMoney = bean.data!.win!;
            dayZSMoney = bean.data!.direct!;
            daySjMoney = bean.data!.rebate!;
            fenRunBL = bean.data!.proportion!;
            lsVMoney = bean.data!.allRebateGb!;
            lsZSMoney = bean.data!.allRebateD!;
            lqVMoney = bean.data!.canRebateGb!;
            lqZSMoney = bean.data!.canRebateD!;
            if(bean.data!.getSwtich == 1){
              isShow = true;
            }else{
              isShow = false;
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
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 领取分润
  Future<void> doPostRoomUserInfo(int type) async {
    LogE('领取分润 用户token ${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'amount': type == 1 ? lqVMoney : lqZSMoney,
      'cur_type': type == 1 ? '1' : '2',
    };
    try {
      CommonBean bean = await DataUtils.postExtractRebate(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(type == 1){
              lqVMoney = '0';
            }else{
              lqZSMoney = '0';
            }
          });
          MyToastUtils.showToastBottom('领取成功！');
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
