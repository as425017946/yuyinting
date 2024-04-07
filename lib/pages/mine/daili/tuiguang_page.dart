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

class _TuiguangPageState extends State<TuiguangPage> with YQYLItem {
  /// 推广总人数，今日推广人数，今日游戏参与额，今日中奖礼物额，今日直刷礼物额，今日实际分润额，分润比例，历史分润金豆，历史分润钻石，可领取金豆，可领取钻石
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
      lqZSMoney = '',
      jdFenRun = '',
      yxFenRun = '';

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

  Widget _bottomItem(String title, String content, Color bg) {
    return Expanded(
      child: Container(
        height: 173.w,
        margin: EdgeInsets.all(31.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.all(Radius.circular(23.w)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetUtils.onlyTextCenter(
              title,
              StyleUtils.getCommonTextStyle(
                color: Colors.black,
                fontSize: 28.sp,
              ),
            ),
            SizedBox(height: 15.w),
            WidgetUtils.onlyTextCenter(
              content,
              StyleUtils.getCommonTextStyle(
                color: Colors.black,
                fontSize: 33.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String title, void Function() action) {
    return Expanded(
      child: GestureDetector(
        onTap: action,
        child: Container(
          height: 83.w,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MyColors.homeTopBG,
            borderRadius: BorderRadius.all(Radius.circular(83.w / 2)),
            border: Border.all(width: 1, color: MyColors.homeTopBG),
          ),
          child: Text(
            title,
            style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 33.sp),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(height: 31.w),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 31.w),
          padding: EdgeInsets.only(bottom: 22.w),
          decoration: BoxDecoration(
            color: MyColors.dailiBlue,
            borderRadius: BorderRadius.all(Radius.circular(21.w)),
          ),
          child: Column(
            children: [
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 328.0 / 122,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 35.w),
                children: [
                  gridItem('推广总人数', allPeople),
                  gridItem('今日推广人数', dayPeople),
                  gridItem('今日礼物打赏额', dayZSMoney),
                  gridItem('今日实时分润', daySjMoney, child: GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          MyUtils.goTransparentPageCom(context, const FenRunTSPage());
                        }
                      }),
                      child: WidgetUtils.showImages('assets/images/daili_wenti.png', 30.w, 30.w),
                    ),
                  ),
                ],
              ),
              WidgetUtils.onlyTextCenter(
                '拉新股份：$jdFenRun',
                StyleUtils.getCommonTextStyle(
                  color: MyColors.g9,
                  fontSize: 21.sp,
                ),
              ),
            ],
          ),
        ),
        ///历史总分润
        Row(
          children: [
            _bottomItem('历史总金币分润', lsVMoney, MyColors.dailiPink),
            _bottomItem('可领取金币', lqVMoney, MyColors.dailiPurple),
          ],
        ),

        /// 立即推广按钮
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            alignment: Alignment.center,
            child: Row(
              children: [
                _btn('立即推广', () { 
                  if (MyUtils.checkClick()) {
                    Navigator.pushNamed(context, 'ShareTuiguangPage');
                  }
                }),
                if (isShow) _btn('领取金币', () {
                  if (MyUtils.checkClick()) {
                    doPostRoomUserInfo(1);
                  }
                })
              ],
            ),
          ),
        ),
        /*
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      Navigator.pushNamed(context, 'ShareTuiguangPage');
                    }
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
              isShow
                  ? Expanded(
                      child: GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            doPostRoomUserInfo(1);
                          }
                        }),
                        child: WidgetUtils.myContainer(
                            ScreenUtil().setHeight(70),
                            double.infinity,
                            MyColors.homeTopBG,
                            MyColors.homeTopBG,
                            '领取金币',
                            ScreenUtil().setSp(28),
                            Colors.white),
                      ),
                    )
                  : const Text(''),
              isShow ? WidgetUtils.commonSizedBox(0, 20) : const Text(''),
              isShow
                  ? Expanded(
                      child: GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            doPostRoomUserInfo(2);
                          }
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
                    )
                  : const Text(''),
            ],
          ),
        )
        */
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
            jdFenRun = bean.data!.directRatio!;
            yxFenRun = bean.data!.gameRatio!;
            if (bean.data!.getSwtich == 1) {
              isShow = true;
            } else {
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
            if (type == 1) {
              lqVMoney = '0';
            } else {
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}

mixin YQYLItem {
  Widget gridItem(String title, String content, { Widget? child}) { // 328 x 122 35 16
    Widget top = WidgetUtils.onlyTextCenter(
          title,
          StyleUtils.getCommonTextStyle(
            color: Colors.black,
            fontSize: 28.sp,
          ),
        );
    if (child != null) {
      top = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          top,
          SizedBox(width: 5.w),
          child,
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        top,
        SizedBox(height: 22.w),
        WidgetUtils.onlyTextCenter(
          content,
          StyleUtils.getCommonTextStyle(
            color: Colors.black,
            fontSize: 25.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}