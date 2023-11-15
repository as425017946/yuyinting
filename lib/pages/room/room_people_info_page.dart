import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/room/room_liwu_page.dart';
import 'package:yuyinting/pages/room/room_messages_more_page.dart';
import 'package:yuyinting/pages/room/room_send_info_page.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../bean/Common_bean.dart';
import '../../bean/roomInfoBean.dart';
import '../../bean/roomInfoUserManagerBean.dart';
import '../../bean/roomUserInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';

/// 厅内人员信息详情
class RoomPeopleInfoPage extends StatefulWidget {
  String uid;
  String index;
  String roomID;
  String isClose;
  List<MikeList> listM;
  RoomPeopleInfoPage({super.key, required this.uid, required this.index, required this.roomID, required this.isClose, required this.listM});

  @override
  State<RoomPeopleInfoPage> createState() => _RoomPeopleInfoPageState();
}

class _RoomPeopleInfoPageState extends State<RoomPeopleInfoPage> {
  // 显示隐藏 禁言拉黑使用
  bool jinyan = false;
  //显示隐藏设置为管理使用
  bool ren = false;
  int sex = 0;
  String userNumber='', headImg = '', nickName = '', city = '', description = '', status = '0', is_admin = '0', is_forbation = '', is_black = '';
  List<String> list_p = [];
  String zhuangtai = '闭麦';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRoomUserInfo();
    doPostRoomUserInfoManager();
    LogE('身份${sp.getString('role').toString()}');
    if(widget.isClose == '0'){
      zhuangtai = '闭麦';
    }else{
      zhuangtai = '开麦';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: ((){
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          SizedBox(
            height: sp.getString('role').toString() == 'user' ? ScreenUtil().setHeight(450) : ScreenUtil().setHeight(530),
            width: double.infinity,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: sp.getString('role').toString() == 'user' ? ScreenUtil().setHeight(390) : ScreenUtil().setHeight(470),
                  width: double.infinity,
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
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
                      WidgetUtils.commonSizedBox(10, 0),
                      /// @某人
                      sp.getString('role').toString() == 'leader' ? Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: ((){
                              MyUtils.goTransparentPage(
                                  context, RoomSendInfoPage(info: nickName,));
                              Navigator.pop(context);
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/room_@ta.png',
                                ScreenUtil().setHeight(22),
                                ScreenUtil().setHeight(48)),
                          ),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                ren = !ren;
                                jinyan = false;
                              });
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/room_head.png',
                                ScreenUtil().setHeight(33),
                                ScreenUtil().setHeight(33)),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                jinyan = !jinyan;
                                ren = false;
                              });
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/room_setting.png',
                                ScreenUtil().setHeight(33),
                                ScreenUtil().setHeight(33)),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      )  : sp.getString('role').toString() == 'adminer' ? Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: ((){
                              MyUtils.goTransparentPage(
                                  context, RoomSendInfoPage(info: nickName,));
                              Navigator.pop(context);
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/room_@ta.png',
                                ScreenUtil().setHeight(22),
                                ScreenUtil().setHeight(48)),
                          ),
                          const Expanded(child: Text('')),
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                jinyan = !jinyan;
                              });
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/room_setting.png',
                                ScreenUtil().setHeight(33),
                                ScreenUtil().setHeight(33)),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ) : Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: ((){
                              MyUtils.goTransparentPage(
                                  context, RoomSendInfoPage(info: nickName,));
                              Navigator.pop(context);
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/room_@ta.png',
                                ScreenUtil().setHeight(22),
                                ScreenUtil().setHeight(48)),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(25, 0),
                      /// 昵称 性别
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.onlyText(nickName, StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.showImages(sex == 1 ? 'assets/images/room_nan.png' : 'assets/images/room_nv.png', ScreenUtil().setHeight(31), ScreenUtil().setHeight(29)),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      /// id 地区
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.showImages('assets/images/room_id.png', ScreenUtil().setHeight(26), ScreenUtil().setHeight(18)),
                          WidgetUtils.commonSizedBox(0, 2),
                          WidgetUtils.onlyText(userNumber, StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(0, 5),
                          GestureDetector(
                            onTap: ((){
                              Clipboard.setData(ClipboardData(
                                text: userNumber,
                              ));
                              MyToastUtils.showToastBottom('已成功复制到剪切板');
                            }),
                              child: WidgetUtils.showImages('assets/images/room_fuzhu.png', ScreenUtil().setHeight(18), ScreenUtil().setHeight(18))),
                          WidgetUtils.commonSizedBox(0, 20),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.onlyText(city, StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(25))),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      /// 个性签名
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.showImages('assets/images/room_cc.png', ScreenUtil().setHeight(26), ScreenUtil().setHeight(21)),
                          WidgetUtils.commonSizedBox(0, 2),
                          WidgetUtils.onlyText(description, StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(24))),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(30, 0),
                      /// 上麦下麦
                      sp.getString('role').toString() != 'user' ? Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.6,
                                child: Row(
                                  children: [
                                    Container(
                                      height: ScreenUtil().setHeight(60),
                                      width: ScreenUtil().setHeight(110),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomMaiLiao2,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: ((){
                                  eventBus.fire(RoomBack(title: '下麦', index: widget.index));
                                }),
                                child: WidgetUtils.onlyTextCenter(
                                    '下麦',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ1,
                                        fontSize: ScreenUtil().setSp(24))),
                              ),
                            ],
                          ),
                          const Expanded(child: Text('')),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.6,
                                child: Row(
                                  children: [
                                    Container(
                                      height: ScreenUtil().setHeight(60),
                                      width: ScreenUtil().setHeight(110),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomMaiLiao2,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: ((){
                                  doPostSetClose(widget.index);
                                }),
                                child: WidgetUtils.onlyTextCenter(
                                    zhuangtai,
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ1,
                                        fontSize: ScreenUtil().setSp(24))),
                              ),
                            ],
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ) : const Text(''),
                      const Expanded(child: Text('')),
                      /// 关注送礼
                      Row(
                        children: [
                         Expanded(child:  GestureDetector(
                           onTap: ((){
                             doPostFollow();
                           }),
                           child: WidgetUtils.onlyTextCenter(
                               status == '0' ? '关注' : '已关注',
                               StyleUtils.getCommonTextStyle(
                                   color: MyColors.roomTCYellow,
                                   fontSize: ScreenUtil().setSp(28))),
                         )),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          Expanded(child:  GestureDetector(
                            onTap: ((){
                              Navigator.pop(context);
                              MyUtils.goTransparentPage(context, RoomLiWuPage(listM: widget.listM, uid: widget.uid,));
                            }),
                            child: WidgetUtils.onlyTextCenter(
                                '送礼物',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWhitw,
                                    fontSize: ScreenUtil().setSp(28))),
                          )),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          Expanded(child:  GestureDetector(
                            onTap: ((){
                              MyUtils.goTransparentPageCom(
                                  context,
                                  RoomMessagesMorePage(otherUid: widget.uid, otherImg: headImg, nickName: nickName,));
                            }),
                            child: WidgetUtils.onlyTextCenter(
                                '私聊',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWhitw,
                                    fontSize: ScreenUtil().setSp(28))),
                          )),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                /// 禁言使用
                jinyan
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Opacity(
                          opacity: 0.55,
                          child: Container(
                            height: ScreenUtil().setHeight(104),
                            width: ScreenUtil().setHeight(117),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.roomTCBlack,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
                jinyan
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Container(
                          height: ScreenUtil().setHeight(104),
                          width: ScreenUtil().setHeight(117),
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Expanded(
                                    child: GestureDetector(
                                      onTap: ((){
                                        if(is_forbation == '1'){
                                          doPostSetRoomForbation('0');
                                        }else{
                                          doPostSetRoomForbation('1');
                                        }
                                      }),
                                      child: WidgetUtils.onlyTextCenter(
                                          is_forbation == '0' ? '禁言' : '解除禁言',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomTCWZ1,
                                              fontSize: ScreenUtil().setSp(21))),
                                    )),
                              Container(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(1),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setHeight(10)),
                                color: MyColors.roomTCWZ1,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                    onTap: ((){
                                      if(is_black == '1'){
                                        doPostSetRoomBlack('0');
                                      }else{
                                        doPostSetRoomBlack('1');
                                      }
                                    }),
                                    child: WidgetUtils.onlyTextCenter(
                                        is_black == '0' ? '拉黑' : '解除拉黑',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomTCWZ1,
                                            fontSize: ScreenUtil().setSp(21))),
                                  )),
                            ],
                          ),
                        ),
                      )
                    : const Text(''),

                /// 人员设置使用
                ren
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Opacity(
                          opacity: 0.55,
                          child: Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setHeight(142),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.roomTCBlack,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
                ren
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Container(
                          height: ScreenUtil().setHeight(50),
                          width: ScreenUtil().setHeight(142),
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: ((){
                              if(is_admin == '1'){
                                doPostSetRoomAdmin('0');
                              }else{
                                doPostSetRoomAdmin('1');
                              }
                            }),
                            child: WidgetUtils.onlyTextCenter(
                                is_admin == '0' ? '设置为管理' : '取消管理',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ1,
                                    fontSize: ScreenUtil().setSp(21))),
                          ),
                        ),
                      )
                    : const Text(''),

                WidgetUtils.CircleHeadImage(80, 80,
                    headImg)
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 查看用户
  Future<void> doPostRoomUserInfo() async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid
    };
    try {
      roomUserInfoBean bean = await DataUtils.postRoomUserInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list_p.clear();
          setState(() {
              headImg = bean.data!.avatar!;
              nickName = bean.data!.nickname!;
              userNumber = bean.data!.number.toString();
              city = bean.data!.city!;
              description = bean.data!.description!;
              sex = bean.data!.gender as int;
              status = bean.data!.followStatus!;
          });
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
  /// 是否为管理、黑名单、禁言
  Future<void> doPostRoomUserInfoManager() async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'room_id': widget.roomID
    };
    try {
      roomInfoUserManagerBean bean = await DataUtils.postRoomUserInfoManager(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            is_admin = bean.data!.isAdmin.toString();
            is_forbation = bean.data!.isForbation.toString();
            is_black = bean.data!.isBlack.toString();
          });
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

  /// 取消关注
  Future<void> doPostFollow() async {
    String type = '';
    if(status == '1'){
      type = '0';
    }else{
      type = '1';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status': type,
      'follow_id': widget.uid,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(status == '1'){
              status = '0';
            }else{
              status = '1';
            }
          });
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
  /// 设置/取消黑名单
  Future<void> doPostSetRoomBlack(String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'status': status,
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postSetRoomBlack(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("设置成功");
          setState(() {
            is_black = status;
          });
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
  /// 设置/取消房间用户禁言
  Future<void> doPostSetRoomForbation(String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'status': status,
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postSetRoomForbation(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("设置成功");
          setState(() {
            is_forbation = status;
          });
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
  /// 设置/取消管理员
  Future<void> doPostSetRoomAdmin(String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'status': status,
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postSetRoomAdmin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("设置成功");
          setState(() {
            is_admin = status;
          });
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

  /// 闭麦/开麦
  Future<void> doPostSetClose(String serial_number) async {
    String status = '';
    if(zhuangtai == '闭麦'){
      status = 'no';
    }else{
      status = 'yes';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'serial_number': int.parse(serial_number) + 1,
      'uid': sp.getString('user_id').toString(),
      'status': status
    };
    try {
      CommonBean bean = await DataUtils.postSetClose(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if(zhuangtai == '闭麦'){
            eventBus.fire(RoomBack(title: '闭麦', index: serial_number));
            setState(() {
              zhuangtai = '开麦';
            });
            MyToastUtils.showToastBottom('已闭麦');
          }else{
            setState(() {
              eventBus.fire(RoomBack(title: '开麦', index: serial_number));
              zhuangtai = '闭麦';
            });
            MyToastUtils.showToastBottom('已开麦');
          }
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
