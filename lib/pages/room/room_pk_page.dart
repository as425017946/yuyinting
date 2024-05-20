import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

///房间pk使用

class RoomPKPage extends StatefulWidget {
  String roomID;

  RoomPKPage({
    super.key,
    required this.roomID,
  });

  @override
  State<RoomPKPage> createState() => _RoomPKPageState();
}

class _RoomPKPageState extends State<RoomPKPage> {
  final TextEditingController _souSuoName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    Navigator.pop(context);
                  }
                }),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: 850.h,
              width: double.infinity,
              padding: EdgeInsets.only(left: 40.w, right: 40.w),
              decoration: const BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage("assets/images/room_tc1.png"),
                  fit: BoxFit.fill, //覆盖
                ),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(15, 0),
                  WidgetUtils.onlyTextCenter(
                      '房内PK',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(32))),
                  WidgetUtils.showImages('assets/images/room_pk_mm_bg.png', 450.h, 610.w),
                  WidgetUtils.onlyText(
                      '请设置本次时长：',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(26))),
                  WidgetUtils.commonSizedBox(30.h, 0),
                  Container(
                    padding: EdgeInsets.only(left: 20.w),
                    height: 70.h,
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: MyColors.home_hx,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                      //设置四周边框
                      border: Border.all(width: 1, color: MyColors.home_hx),
                    ),
                    child: TextField(
                      controller: _souSuoName,
                      inputFormatters: [
                        // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: StyleUtils.loginTextStyle,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        // labelText: "请输入用户名",
                        // icon: Icon(Icons.people), //前面的图标
                        hintText: '请输入本次时长(1-60分钟)',
                        hintStyle: StyleUtils.loginHintTextStyle,
                        contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
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
                  WidgetUtils.commonSizedBox(70.h, 0),
                  SizedBox(
                    height: 70.h,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (() {
                            if (MyUtils.checkClick()) {
                              Navigator.pop(context);
                            }
                          }),
                          child: Container(
                            height: 70.h,
                            width: 280.w,
                            alignment: Alignment.center,
                            //边框设置
                            decoration: BoxDecoration(
                              //背景
                              color: MyColors.d8,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.h)),
                            ),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                color: MyColors.g2,
                                fontSize: 26.sp,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: (() {
                            if (MyUtils.checkClick()) {
                              if (_souSuoName.text.trim().isEmpty) {
                                MyToastUtils.showToastBottom('请输入本次时长~');
                                return;
                              }
                              if (_souSuoName.text.trim().contains('.')) {
                                MyToastUtils.showToastBottom('请输入本次时长~');
                                return;
                              }
                              if (int.parse(_souSuoName.text.trim().toString()) < 1) {
                                MyToastUtils.showToastBottom('输入时长最少为1分钟');
                                return;
                              }
                              if (int.parse(_souSuoName.text.trim().toString()) > 60) {
                                MyToastUtils.showToastBottom('输入时长最多为60分钟');
                                return;
                              }
                              doPostStartPk();
                            }
                          }),
                          child: Container(
                            height: 70.h,
                            width: 280.w,
                            alignment: Alignment.center,
                            //边框设置
                            decoration: const BoxDecoration(
                              //设置Container修饰
                              image: DecorationImage(
                                //背景图片修饰
                                image: AssetImage("assets/images/room_pk_mm_qr.png"),
                                fit: BoxFit.fill, //覆盖
                              ),
                            ),
                            child: Text(
                              '立即开始PK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 开启pk
  Future<void> doPostStartPk() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'seconds': _souSuoName.text.trim().toString(),
    };
    try {
      CommonBean bean = await DataUtils.postStartPk(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
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
    } catch (e) {}
  }
}
