import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yuyinting/pages/room/room_page.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/Common_bean.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';

/// 进入房间前输入密码
class RoomTSMiMaPage extends StatefulWidget {
  String roomID;
  RoomTSMiMaPage({super.key, required this.roomID});

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
              width: ScreenUtil().setHeight(506),
              height: ScreenUtil().setHeight(262),
              decoration: const BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage("assets/images/room_fangmm.png"),
                  fit: BoxFit.fill, //覆盖
                ),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(20, 0),
                  WidgetUtils.onlyTextCenter(
                      '请输入房间密码',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(29))),
                  WidgetUtils.commonSizedBox(50, 0),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: ScreenUtil().setHeight(80), right: ScreenUtil().setHeight(80),),
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
                        if(value.length == 4){
                          doPostCheckPwd();
                        }
                      },
                      textStyle: StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(38)),
                      appContext: context,
                      keyboardType: TextInputType.number,
                      autoFocus: true,
                      // enableActiveFill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(2),
                        fieldHeight: ScreenUtil().setHeight(64),
                        fieldWidth: ScreenUtil().setHeight(43),
                        activeFillColor: Colors.transparent,
                        //填充背景色
                        activeColor: Colors.white,
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
                  Navigator.pop(context);
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
      CommonBean bean = await DataUtils.postCheckPwd(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(widget.roomID,textEditingController.text.trim());
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

  /// 加入房间
  Future<void> doPostRoomJoin(roomID, password) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          Navigator.pop(context);
        // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(context, RoomPage(roomId: roomID,));
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

}
