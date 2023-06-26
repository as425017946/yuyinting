import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yuyinting/pages/room/room_gongneng.dart';
import 'package:yuyinting/pages/room/room_manager_page.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';

/// 设置房间密码
class RoomPasswordPage extends StatefulWidget {
  int type;
  RoomPasswordPage({super.key,required this.type});

  @override
  State<RoomPasswordPage> createState() => _RoomPasswordPageState();
}

class _RoomPasswordPageState extends State<RoomPasswordPage> {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";

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
                ///0 房间管理进来的  1点击功能进来的
                if(widget.type == 0){
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder:
                            (context, animation, secondaryAnimation) {
                          return RoomManagerPage(type: 1);
                        }));
                  });
                }else{
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder:
                            (context, animation, secondaryAnimation) {
                          return RoomGongNeng(type: 1);
                        }));
                  });
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
            height: ScreenUtil().setHeight(350),
            width: double.infinity,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc3.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(15, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(180)),
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter(
                        '房间设置密码',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCWZ2,
                            fontSize: ScreenUtil().setSp(32))),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        Navigator.pop(context);
                      }),
                      child: Container(
                        width: ScreenUtil().setWidth(180),
                        padding:
                        EdgeInsets.only(right: ScreenUtil().setHeight(40)),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '保存',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ3,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: ScreenUtil().setHeight(150),
                  width: double.infinity,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: PinCodeTextField(
                    length: 4,
                    inputFormatters: [
                      // 表示只能输入字母大写小写都可以
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    // animationDuration: const Duration(milliseconds: 300),
                    controller: textEditingController,
                    onChanged: (value) {
                      LogE('返回数据$value');
                      setState(() {
                        currentText = value;
                      });
                    },
                    textStyle: StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(38)),
                    appContext: context,
                    keyboardType: TextInputType.number,
                    autoFocus: true,
                    // enableActiveFill: true,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 40,
                      fieldWidth: 40,
                      activeFillColor: Colors.transparent, //填充背景色
                      activeColor: MyColors.roomPassXian, //下划线颜色
                      inactiveFillColor: MyColors.roomPassXian,
                      inactiveColor: MyColors.roomPassXian,
                      selectedColor: MyColors.roomPassXian,
                      selectedFillColor: MyColors.roomPassXian,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
