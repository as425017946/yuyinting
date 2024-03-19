import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';

///打招呼弹窗
class TrendsHiPage extends StatefulWidget {
  String imgUrl;
  String uid;
  int index;

  TrendsHiPage(
      {Key? key, required this.imgUrl, required this.uid, required this.index})
      : super(key: key);

  @override
  State<TrendsHiPage> createState() => _TrendsHiPageState();
}

class _TrendsHiPageState extends State<TrendsHiPage> {
  var gz = true;
  bool isClick = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.black54,
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: (20 * 2).w),
                height: ScreenUtil().setWidth(600 * 1.3),
                width: ScreenUtil().setWidth(520 * 1.3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular((10 * 2).w)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text('')),
                        GestureDetector(
                          onTap: (() {
                            ///关闭当前页面
                            Navigator.pop(context);
                          }),
                          child: Container(
                            height: (100 * 1.3).w,
                            width: (100 * 1.3).w,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: WidgetUtils.showImages(
                                'assets/images/close.png',
                                (15 * 2).w,
                                (15 * 2).w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: (40 * 2).w,
                    ),
                    Text(
                      '给TA别致打招呼',
                      style: TextStyle(
                          fontSize: (18 * 2).sp,
                          color: MyColors.black_3,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: (10 * 2).w,
                    ),
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.only(left: (20 * 2).w, right: (20 * 2).w),
                      height: ScreenUtil().setWidth(150 * 1.3),
                      padding:
                          EdgeInsets.only(left: (10 * 2).w, right: (10 * 2).w),
                      alignment: Alignment.center,
                      //边框设置
                      decoration: BoxDecoration(
                        //背景
                        color: MyColors.f2,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                            BorderRadius.all(Radius.circular((20.0 * 2).w)),
                      ),
                      child: WidgetUtils.onlyText(
                          "遇见你真好，我们交个朋友吧！", StyleUtils.textStyleG3),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          (20 * 2).w, (20 * 2).w, (20 * 2).w, 0),
                      height: (80 * 1.3).w,
                      alignment: Alignment.center,
                      width: double.infinity,
                      //边框设置
                      decoration: BoxDecoration(
                        //背景
                        color: MyColors.homeTopBG,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                            BorderRadius.all(Radius.circular((40 * 1.3).w)),
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: (90 * 1.3).w,
                        splashColor: MyColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular((25 * 2).w)),
                        ),
                        onPressed: (() {
                          if (MyUtils.checkClick() && isClick == false) {
                            setState(() {
                              isClick = true;
                            });
                            if (gz) {
                              doPostFollow();
                            }
                            Navigator.pop(context);
                          }
                        }),
                        child: Text(
                          '发送',
                          style: StyleUtils.buttonTextStyle,
                        ),
                      ),
                    ),
                    WidgetUtils.commonSizedBox((10 * 2).w, 0),
                    GestureDetector(
                      // onTap: (() {
                      //   setState(() {
                      //     gz = !gz;
                      //   });
                      // }),
                      child: Row(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.showImages(
                              gz == false
                                  ? 'assets/images/trends_r1.png'
                                  : 'assets/images/trends_r2.png',
                              (15 * 2).w,
                              (15 * 2).w),
                          WidgetUtils.commonSizedBox(0, (10 * 2).w),
                          Text(
                            '关注TA，Ta的最新动态怎能错过~',
                            style: TextStyle(
                              fontSize: (13 * 2).sp,
                              color: MyColors.g9,
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              WidgetUtils.CircleHeadImage((80 * 2).w, (80 * 2).w, widget.imgUrl)
            ],
          ),
        ),
      ),
    );
  }

  /// 打招呼
  Future<void> doPostHi() async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
    };
    try {
      CommonBean bean = await DataUtils.postHi(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          LogE('打招呼成功！${widget.uid}');
          isClick = false;
          eventBus.fire(HiBack(isBack: true, index: widget.uid));
          break;
        case MyHttpConfig.errorHiCode:
          eventBus.fire(HiBack(isBack: true, index: widget.uid));
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

  /// 关注
  Future<void> doPostFollow() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status': '1',
      'follow_id': widget.uid,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostHi();
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
