import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/room/room_manager_page.dart';
import 'package:yuyinting/utils/event_utils.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 房间名称
class RoomName extends StatefulWidget {
  const RoomName({super.key});

  @override
  State<RoomName> createState() => _RoomNameState();
}

class _RoomNameState extends State<RoomName> {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  int num = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      textEditingController.text = sp.getString('roomName').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
                MyUtils.goTransparentPageCom(context, RoomManagerPage(type: 1, roomID: sp.getString('roomID').toString()));
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: 240.h,
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
                        '房间名称',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCWZ2,
                            fontSize: ScreenUtil().setSp(32))),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        if(textEditingController.text.trim().toString().isEmpty){
                          MyToastUtils.showToastBottom('请输入房间名称');
                        }else{
                          doPostEditRoom();
                        }
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
                  height: ScreenUtil().setHeight(80),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 20.h, right: 20.h),
                  margin: EdgeInsets.all(40.h),
                  //边框设置
                  decoration: const BoxDecoration(
                    //背景
                    color: Colors.white10,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: TextField(
                        controller: textEditingController,
                        autofocus: true,
                        inputFormatters: [
                          RegexFormatter(regex: MyUtils.regexFirstNotNull),
                          //设置只能输入12位
                          LengthLimitingTextInputFormatter(12),
                        ],
                        style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 28.sp),
                        onChanged: (value) {
                          setState(() {
                            num = value.length;
                          });
                          // eventBus.fire(InfoBack(infos: value));
                        },
                        decoration: InputDecoration(
                          hintText: '请输入房间名称',
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
                      )),
                      WidgetUtils.onlyText('$num/12', StyleUtils.getCommonTextStyle(color: Colors.white,fontSize: 21.sp))
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 修改房间名称
  Future<void> doPostEditRoom() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': sp.getString('roomID'),
      'room_name': textEditingController.text.trim().toString(),
    };
    try {
      CommonBean bean = await DataUtils.postEditRoom(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('房间名称修改成功');
          eventBus.fire(SubmitButtonBack(title: '修改房间名称'));
          sp.setString('roomName', textEditingController.text.trim().toString());
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
