import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/room_manager_page.dart';
import 'package:yuyinting/pages/room/room_password_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 房间内功能
class RoomGongNeng extends StatefulWidget {
  int type;
  RoomGongNeng({super.key, required this.type});

  @override
  State<RoomGongNeng> createState() => _RoomGongNengState();
}

class _RoomGongNengState extends State<RoomGongNeng> {
  var mima = false;
  var laobanwei = true;
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
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          widget.type == 1 ? Container(
            height: ScreenUtil().setHeight(450),
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
                WidgetUtils.onlyTextCenter(
                    '功能',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(32))),
                WidgetUtils.commonSizedBox(30, 0),
                /// 展示的功能
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: ((){

                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_shouye.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setHeight(70),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('首页展示', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        Navigator.pop(context);
                        Future.delayed(const Duration(seconds: 0), () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return RoomPasswordPage(type: 1,);
                              }));
                        });
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_mima.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                              Opacity(
                                opacity: mima == false ? 0 : 1,
                                child: Container(
                                  height: ScreenUtil().setHeight(25),
                                  width: ScreenUtil().setHeight(70),
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.roomBlue,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                                ),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('房间密码', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        eventBus.fire(SubmitButtonBack(title: '清除公屏'));
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_qingchu.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('清除公屏', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        eventBus.fire(SubmitButtonBack(title: '清除魅力'));
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_meili.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('清除魅力', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        eventBus.fire(SubmitButtonBack(title: '老板位'));
                        Navigator.pop(context);
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_laoban.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                              Opacity(
                                opacity: laobanwei== false ? 0 : 1,
                                child: Container(
                                  height: ScreenUtil().setHeight(25),
                                  width: ScreenUtil().setHeight(70),
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.roomBlue,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                                ),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('老板位', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                ),
                WidgetUtils.commonSizedBox(30, 20),
                /// 第二排
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: ((){
                        eventBus.fire(SubmitButtonBack(title: '动效'));
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_dongxiao.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setHeight(70),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('动效', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        eventBus.fire(SubmitButtonBack(title: '房间声音'));
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_shengyin.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setHeight(70),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('房间声音', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        Navigator.pop(context);
                        Future.delayed(const Duration(seconds: 0), () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return RoomManagerPage(type: 1);
                              }));
                        });
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_shezhi.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('房间设置', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    Opacity(opacity: 0,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            WidgetUtils.showImages('assets/images/room_shouye.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
                            Container(
                              height: ScreenUtil().setHeight(25),
                              width: ScreenUtil().setHeight(70),
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.roomBlue,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                            )
                          ],
                        ),
                        WidgetUtils.commonSizedBox(5, 0),
                        WidgetUtils.onlyTextCenter('首页展示', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                      ],
                    ),),
                    const Expanded(child: Text('')),
                    Opacity(opacity: 0,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_shouye.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setHeight(70),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('首页展示', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                )
              ],
            ),
          )
              :
          Container(
            height: ScreenUtil().setHeight(300),
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
                WidgetUtils.onlyTextCenter(
                    '功能',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(32))),
                WidgetUtils.commonSizedBox(40, 0),
                /// 展示的功能
                /// 第二排
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: ((){
                          eventBus.fire(SubmitButtonBack(title: '动效'));
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_dongxiao.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setHeight(70),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('动效', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        eventBus.fire(SubmitButtonBack(title: '房间声音'));
                      }),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_shengyin.png', ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setHeight(70),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('房间声音', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    Opacity(opacity: 0,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            WidgetUtils.showImages('assets/images/room_shezhi.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
                          ],
                        ),
                        WidgetUtils.commonSizedBox(5, 0),
                        WidgetUtils.onlyTextCenter('房间设置', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                      ],
                    ),),
                    const Expanded(child: Text('')),
                    Opacity(opacity: 0,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_shouye.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setHeight(70),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('首页展示', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),),
                    const Expanded(child: Text('')),
                    Opacity(opacity: 0,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              WidgetUtils.showImages('assets/images/room_shouye.png', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setHeight(70),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter('已开启', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18))),
                              )
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          WidgetUtils.onlyTextCenter('首页展示', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(18))),
                        ],
                      ),),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
