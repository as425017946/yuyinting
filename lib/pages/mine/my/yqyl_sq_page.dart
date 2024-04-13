import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/regex_formatter.dart';
import '../../../utils/widget_utils.dart';
import '../../message/chat_page.dart';

/// 邀请有礼快速申请
class YQYLSQPage extends StatefulWidget {
  String kefuUid;
  String kefUavatar;

  YQYLSQPage({super.key, required this.kefuUid, required this.kefUavatar});

  @override
  State<YQYLSQPage> createState() => _YQYLSQPageState();
}

class _YQYLSQPageState extends State<YQYLSQPage> {
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerWX = TextEditingController();
  TextEditingController controllerdesc = TextEditingController();

  bool isGet = false;
  int dlsq = 0;
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('邀请有礼', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      body: Stack(
        children: [
          WidgetUtils.showImagesFill('assets/images/mine_yq_bg2.jpg',
              double.infinity, double.infinity),
          Column(
            children: [
              WidgetUtils.commonSizedBox(130.h, 0),
              Container(
                height: 120.h,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 80.h, left: 60.h),
                child: WidgetUtils.onlyText(
                    '',
                    TextStyle(
                        fontSize: ScreenUtil().setSp(55),
                        color: MyColors.yzZi1,
                        fontFamily: 'YOUSHEBIAOTIHEI')),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 60.h),
                child: WidgetUtils.onlyTextCenter(
                    '请填写申请资料',
                    TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: MyColors.yzZi1,
                        fontFamily: 'YOUSHEBIAOTIHEI')),
              ),
              WidgetUtils.commonSizedBox(40.h, 10.h),
              Container(
                height: 60.h,
                color: Colors.transparent,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 60.h, right: 0.h),
                child: Row(
                  children: [
                    WidgetUtils.onlyText(
                        '手 机 号： ',
                        StyleUtils.getCommonTextStyle(
                          color: MyColors.yzZi1,
                          fontSize: 30.sp,
                        )),
                    Container(
                      height: ScreenUtil().setHeight(60),
                      width: ScreenUtil().setHeight(260),
                      padding: const EdgeInsets.all(5),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.dailiTime,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: TextField(
                        controller: controllerPhone,
                        inputFormatters: [
                          // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                        ],
                        style: StyleUtils.loginTextStyle,
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          // labelText: "请输入用户名",
                          // icon: Icon(Icons.people), //前面的图标
                          hintText: '请输入手机号',
                          hintStyle: StyleUtils.loginHintTextStyle,

                          contentPadding:
                              const EdgeInsets.only(top: 0, bottom: 0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                        ),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 10.h),
                    WidgetUtils.onlyText(
                        '(必填)',
                        StyleUtils.getCommonTextStyle(
                          color: MyColors.yzZi2,
                          fontSize: 20.sp,
                        )),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(20.h, 10.h),
              Container(
                height: 60.h,
                color: Colors.transparent,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 60.h, right: 0.h),
                child: Row(
                  children: [
                    WidgetUtils.onlyText(
                        '微信/QQ：',
                        StyleUtils.getCommonTextStyle(
                          color: MyColors.yzZi1,
                          fontSize: 30.sp,
                        )),
                    Container(
                      height: ScreenUtil().setHeight(60),
                      width: ScreenUtil().setHeight(260),
                      padding: const EdgeInsets.all(5),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.dailiTime,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: TextField(
                        controller: controllerWX,
                        inputFormatters: [
                          // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                        ],
                        style: StyleUtils.loginTextStyle,
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          // labelText: "请输入用户名",
                          // icon: Icon(Icons.people), //前面的图标
                          hintText: '请输入微信或QQ号码',
                          hintStyle: StyleUtils.loginHintTextStyle,

                          contentPadding:
                              const EdgeInsets.only(top: 0, bottom: 0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                        ),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 10.h),
                    WidgetUtils.onlyText(
                        '(二选一必填)',
                        StyleUtils.getCommonTextStyle(
                          color: MyColors.yzZi2,
                          fontSize: 20.sp,
                        )),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(20.h, 10.h),
              Container(
                height: 180.h,
                color: Colors.transparent,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 60.h, right: 0.h),
                child: Row(
                  children: [
                    WidgetUtils.onlyText(
                        '选       填：',
                        StyleUtils.getCommonTextStyle(
                          color: MyColors.yzZi1,
                          fontSize: 30.sp,
                        )),
                    Container(
                      height: ScreenUtil().setHeight(240),
                      width: ScreenUtil().setHeight(400),
                      padding: const EdgeInsets.all(5),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.dailiTime,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: TextField(
                        controller: controllerdesc,
                        maxLength: 150,
                        maxLines: 20,
                        inputFormatters: [
                          // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                        ],
                        style: StyleUtils.loginTextStyle,
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          // labelText: "请输入用户名",
                          // icon: Icon(Icons.people), //前面的图标
                          hintText: '请输入备注信息',
                          hintStyle: StyleUtils.loginHintTextStyle,

                          contentPadding:
                              const EdgeInsets.only(top: 0, bottom: 0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity.h,
                color: Colors.transparent,
                child: Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          MyUtils.goTransparentRFPage(
                              context,
                              ChatPage(
                                nickName: '小柴客服',
                                otherUid: widget.kefuUid,
                                otherImg: widget.kefUavatar,
                              ));
                        }
                      }),
                      child: Container(
                        color: Colors.transparent,
                        child: WidgetUtils.showImages(
                            'assets/images/mine_yq_kf.png', 60.h, 220.h),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 30.h),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          doPostYqApply();
                        }
                      }),
                      child: Container(
                        color: Colors.transparent,
                        child: WidgetUtils.showImages(
                            'assets/images/mine_yq_tj.png', 60.h, 220.h),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(120.h, 0),
            ],
          )
        ],
      ),
    );
  }

  /// 提交申请
  Future<void> doPostYqApply() async {
    if (controllerPhone.text.trim().isEmpty) {
      MyToastUtils.showToastBottom('请输入手机号');
      return;
    }

    if (!MyUtils.chinaPhoneNumber(controllerPhone.text.trim())) {
      MyToastUtils.showToastBottom('输入的手机号码格式错误');
      return;
    }

    if (controllerWX.text.trim().isEmpty) {
      MyToastUtils.showToastBottom('请输入微信或QQ号码');
      return;
    }

    Map<String, dynamic> params = <String, dynamic>{
      'phone': controllerPhone.text.trim().toString(),
      'wx': controllerWX.text.trim().toString(),
      'desc': controllerdesc.text.trim().toString()
    };
    try {
      CommonBean bean = await DataUtils.postYqApply(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          MyToastUtils.showToastBottom('提交成功，请耐心等待审核~');
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
