import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/room/room_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/Common_bean.dart';
import '../../bean/joinRoomBean.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';

/// 进入房间前输入密码
class RoomTSMiMaPage extends StatefulWidget {
  String roomID;
  String roomToken;
  String anchorUid;
  RoomTSMiMaPage({super.key, required this.roomID, required this.roomToken, required this.anchorUid});

  @override
  State<RoomTSMiMaPage> createState() => _RoomTSMiMaPageState();
}

class _RoomTSMiMaPageState extends State<RoomTSMiMaPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false, // 解决键盘顶起页面
        body: Column(
          children: [
            GestureDetector(
              onTap: (() {
                setState(() {
                  sp.setBool('joinRoom',false);
                });
                if (MyUtils.checkClick()) {
                  Navigator.pop(context);
                }
              }),
              child: Container(
                height: 300.h,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
            Container(
              width: ScreenUtil().setHeight(506),
              height: ScreenUtil().setHeight(400),
              decoration: const BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage("assets/images/room_mima_bg.png"),
                  fit: BoxFit.fill, //覆盖
                ),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(120, 0),
                  WidgetUtils.onlyTextCenter(
                      '请输入房间密码',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black87,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600)),
                  WidgetUtils.commonSizedBox(30, 0),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      left: ScreenUtil().setHeight(80),
                      right: ScreenUtil().setHeight(80),
                    ),
                    child: PinCodeTextField(
                      length: 4,
                      inputFormatters: [
                        // 表示只能输入字母大写小写都可以
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      // animationDuration: const Duration(milliseconds: 300),
                      controller: textEditingController,
                      onChanged: (value) {
                        // LogE('返回数据$value');
                        if (value.length == 4) {
                          doPostCheckPwd();
                        }
                      },
                      textStyle: StyleUtils.getCommonTextStyle(
                          color: MyColors.btn_a, fontSize: 38.sp),
                      appContext: context,
                      keyboardType: TextInputType.number,
                      autoFocus: true,
                      // enableActiveFill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(2),
                        fieldHeight: 70.h,
                        fieldWidth: 55.h,
                        activeFillColor: Colors.transparent,
                        //填充背景色
                        activeColor: MyColors.btn_a,
                        //下划线颜色
                        inactiveFillColor: Colors.white,
                        inactiveColor: Colors.white,
                        selectedColor: Colors.white,
                        selectedFillColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
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
          ],
        ));
  }

  /// 校验密码
  Future<void> doPostCheckPwd() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'password': textEditingController.text.trim()
    };
    try {
      Loading.show("校验中...");
      joinRoomBean bean = await DataUtils.postCheckPwd(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(widget.roomID, textEditingController.text.trim(),bean.data!.rtc!);
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom',false);
          });
          setState(() {
            textEditingController.text = '';
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom',false);
      });
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间
  Future<void> doPostRoomJoin(roomID, password,roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password,
      'anchor_uid': widget.anchorUid
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
              context,
              RoomPage(
                roomId: roomID,
                beforeId: '',
                roomToken: roomToken,
              ));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom',false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom',false);
      });
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
