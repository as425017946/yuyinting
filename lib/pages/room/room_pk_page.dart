import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
///房间pk使用

class RoomPKPage extends StatefulWidget {
  String roomID;
  RoomPKPage({super.key,required this.roomID,});

  @override
  State<RoomPKPage> createState() => _RoomPKPageState();
}

class _RoomPKPageState extends State<RoomPKPage> {
  final TextEditingController _souSuoName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
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
            height: 450.h,
            width: double.infinity,
            padding: EdgeInsets.only(left: 20.w,right: 20.w),
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc2.png"),
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
                WidgetUtils.commonSizedBox(50.h, 0),
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
                    borderRadius:
                    const BorderRadius.all(Radius.circular(25.0)),
                    //设置四周边框
                    border: Border.all(width: 1, color: MyColors.home_hx),
                  ),
                  child: TextField(
                    controller: _souSuoName,
                    inputFormatters: [
                      RegexFormatter(regex: MyUtils.regexFirstNotNull),
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
                          // doForgetPassword();
                        }),
                        child: Container(
                          height: 70.h,
                          width: 200.w,
                          alignment: Alignment.center,
                          //边框设置
                          decoration: BoxDecoration(
                            //背景
                            color: MyColors.d8,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(30.h)),
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
                          // doForgetPassword();
                        }),
                        child: Container(
                          height: 70.h,
                          width: 400.w,
                          alignment: Alignment.center,
                          //边框设置
                          decoration: BoxDecoration(
                            //背景
                            color: MyColors.homeTopBG,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(30.h)),
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
    );
  }
}
