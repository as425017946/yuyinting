import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/room/room_manager_page.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 房间公告
class RoomGongGaoPage extends StatefulWidget {
  String roomID;
  RoomGongGaoPage({super.key, required this.roomID});

  @override
  State<RoomGongGaoPage> createState() => _RoomGongGaoPageState();
}

class _RoomGongGaoPageState extends State<RoomGongGaoPage> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller.text = sp.getString('roomNotice').toString() ?? '';
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
                if(MyUtils.checkClick()) {
                  Navigator.pop(context);
                  Future.delayed(const Duration(seconds: 0), () {
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder:
                            (context, animation, secondaryAnimation) {
                          return RoomManagerPage(
                            type: 1, roomID: widget.roomID,);
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
            height: ScreenUtil().setHeight(530),
            width: double.infinity,
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
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(180)),
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter(
                        '房间公告',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCWZ2,
                            fontSize: ScreenUtil().setSp(32))),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        if(MyUtils.checkClick()) {
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
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        height: ScreenUtil().setHeight(300),
                        width: double.infinity,
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 30),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: Colors.black,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(300),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: TextField(
                        controller: controller,
                        maxLength: 300,
                        maxLines: 10,
                        inputFormatters: [
                          // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                        ],
                        style: StyleUtils.loginTextStyle,
                        onChanged: (value) {
                          // eventBus.fire(InfoBack(infos: value));
                        },
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          // labelText: "请输入用户名",
                          // icon: Icon(Icons.people), //前面的图标
                          hintText: '请输入公告信息',
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
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 设置房间信息
  Future<void> doPostEditRoom() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'notice': controller.text.trim().toString(),
    };
    try {
      CommonBean bean = await DataUtils.postEditRoom(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          eventBus.fire(RoomBack(title: '修改了公告', index: controller.text.trim().toString()));
          MyToastUtils.showToastBottom('公告已修改');
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
