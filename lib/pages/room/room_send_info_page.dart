import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/room_bq_page.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

class RoomSendInfoPage extends StatefulWidget {
  const RoomSendInfoPage({super.key});

  @override
  State<RoomSendInfoPage> createState() => _RoomSendInfoPageState();
}

class _RoomSendInfoPageState extends State<RoomSendInfoPage> {
  TextEditingController controller = TextEditingController();
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
            }),
            child: Container(
              color: Colors.transparent,
            ),
          )),
          Container(
            height: 80.h,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20.h),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(60),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.f2,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: TextField(
                      autofocus: true,
                      textInputAction: TextInputAction.send,
                      // 设置为发送按钮
                      controller: controller,
                      inputFormatters: [
                        RegexFormatter(regex: MyUtils.regexFirstNotNull),
                      ],
                      style: StyleUtils.loginTextStyle,
                      onSubmitted: (value) {
                        setState(() {
                          Navigator.pop(context);
                        });
                        // MyUtils.sendMessage(widget.otherUid, value);
                        // doPostSendUserMsg(value);
                      },
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        // labelText: "请输入用户名",
                        // icon: Icon(Icons.people), //前面的图标
                        hintText: '请输入文字信息',
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
                ),
                WidgetUtils.commonSizedBox(0, 20.h),
                GestureDetector(
                  onTap: ((){
                    Navigator.pop(context);
                    MyUtils.goTransparentPage(context, const RoomBQPage());
                  }),
                  child: WidgetUtils.showImages('assets/images/trends_biaoqing.png', 50.h, 50.h),
                ),
                WidgetUtils.commonSizedBox(0, 20.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
