import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../bean/Common_bean.dart';
import '../../bean/joinRoomBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../mine/my/edit_head_page.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';

/// 填写个人信息
class EditInfoPage extends StatefulWidget {
  const EditInfoPage({Key? key}) : super(key: key);

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  TextEditingController controller = TextEditingController();
  var sex = 0;
  String avatar = '', avatarID = '', avatarID2 = '', nickName = '';
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      avatar = sp.getString('user_headimg').toString();
      avatarID = sp.getString('user_headimg_id').toString();
      avatarID2 = sp.getString('user_headimg_id').toString();
      controller.text = sp.getString('nickname').toString();
      nickName = sp.getString('nickname').toString();
    });
    listen = eventBus.on<FileBack>().listen((event) {
      setState(() {
        avatarID2 = event.id;
        avatar = event.info;
        sp.setString("user_headimg_id", event.id);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.black45,
      body: WillPopScope(
        //不能点击返回消失页面
        onWillPop: () async {
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: Column(
            children: [
              WidgetUtils.commonSizedBox(ScreenUtil().setHeight(450), 0),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image: AssetImage("assets/images/login_ziliao_bg.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(15, 0),
                      WidgetUtils.onlyTextCenter(
                          '填写个人信息',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(36),
                              fontWeight: FontWeight.w600)),
                      WidgetUtils.onlyTextCenter(
                          '更容易遇到合拍的小伙伴哦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(21))),
                      WidgetUtils.commonSizedBox(50, 0),
                      GestureDetector(
                        onTap: (() {
                          MyUtils.goTransparentPage(
                              context, const EditHeadPage());
                        }),
                        child: SizedBox(
                          height: ScreenUtil().setHeight(130),
                          width: ScreenUtil().setHeight(130),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              WidgetUtils.CircleImageNet(ScreenUtil().setHeight(130), ScreenUtil().setHeight(130), ScreenUtil().setHeight(65), avatar),
                              WidgetUtils.showImages(
                                  'assets/images/login_paizhao.png',
                                  ScreenUtil().setHeight(40),
                                  ScreenUtil().setHeight(40)),
                            ],
                          ),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(40, 0),
                      Container(
                        height: ScreenUtil().setHeight(80),
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.f2,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(17.0)),
                        ),
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            Expanded(
                                child: WidgetUtils.commonTextField(
                                    controller, '请输入昵称')),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  controller.text = '';
                                });
                              }),
                              child: WidgetUtils.showImages(
                                  'assets/images/login_colse.png',
                                  ScreenUtil().setHeight(24),
                                  ScreenUtil().setHeight(24)),
                            ),
                            WidgetUtils.commonSizedBox(0, 20),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(20, 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  sex = 1;
                                });
                              }),
                              child: Container(
                                height: ScreenUtil().setHeight(80),
                                width: double.infinity,
                                margin: const EdgeInsets.only(left: 40),
                                //边框设置
                                decoration: BoxDecoration(
                                  //背景
                                  color: sex == 1
                                      ? MyColors.loginBlue
                                      : MyColors.loginBlue2,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(17.0)),
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages(
                                        'assets/images/nan.png',
                                        ScreenUtil().setHeight(26),
                                        ScreenUtil().setHeight(26)),
                                    WidgetUtils.commonSizedBox(0, 10),
                                    WidgetUtils.onlyTextCenter(
                                        '男生',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(33))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  sex = 2;
                                });
                              }),
                              child: Container(
                                height: ScreenUtil().setHeight(80),
                                width: double.infinity,
                                margin: const EdgeInsets.only(right: 40),
                                //边框设置
                                decoration: BoxDecoration(
                                  //背景
                                  color: sex == 2
                                      ? MyColors.loginPink
                                      : MyColors.loginPink2,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(17.0)),
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages(
                                        'assets/images/nv.png',
                                        ScreenUtil().setHeight(26),
                                        ScreenUtil().setHeight(26)),
                                    WidgetUtils.commonSizedBox(0, 10),
                                    WidgetUtils.onlyTextCenter(
                                        '女生',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(33))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 10),
                      WidgetUtils.onlyTextCenter(
                          '性别后续不可修改',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(29))),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: (() {
                          doSaveInfo();
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          width: double.infinity,
                          alignment: Alignment.center,
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: MyColors.walletWZBlue,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          ),
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          child: Text(
                            '去听好声音',
                            style: StyleUtils.getCommonTextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(33)),
                          ),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(20, 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 首次填写个人信息
  Future<void> doSaveInfo() async {
    String userNick = controller.text.trim();
    if (userNick.isEmpty) {
      MyToastUtils.showToastBottom("请输入昵称");
      return;
    }
    if (sex == 0) {
      MyToastUtils.showToastBottom("请选择性别");
      return;
    }
    Map<String, dynamic> params = <String, dynamic>{
      'avatar': sp.getString('user_headimg_id').toString(),
      'nickname': userNick,
      'gender': sex,
    };
    try {
      Loading.show("提交中...");
      CommonBean commonBean = await DataUtils.postIsFirst(params);
      switch (commonBean.code) {
        case MyHttpConfig.successCode:
          sp.setBool("isFirst", false);
          sp.setInt("user_gender", sex);
          LogE('更换值${sp.getBool('isFirst')}');
          if(avatarID != avatarID2 || nickName != controller.text.trim().toString()) {
            MyToastUtils.showToastBottom('资料提交成功，请耐心等待审核');
          }
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          //判断有无代理房间
          if(sp.getString('daili_roomid').toString() != 'null' && sp.getString('daili_roomid').toString().isNotEmpty){
            //有房间直接进入
            doPostBeforeJoin(sp.getString('daili_roomid').toString(),'');
          }
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(commonBean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID, String anchorUid) async {
    //判断房间id是否为空的
    if(sp.getString('roomID') == null || sp.getString('').toString().isEmpty){
    }else{
      // 不是空的，并且不是之前进入的房间
      if(sp.getString('roomID').toString() != roomID){
        sp.setString('roomID', roomID);
        eventBus.fire(SubmitButtonBack(title: '加入其他房间'));
      }
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      Loading.show();
      joinRoomBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(roomID, '', anchorUid, bean.data!.rtc!);
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
        // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomTSMiMaPage(
                  roomID: roomID,
                  roomToken: bean.data!.rtc!,
                  anchorUid: anchorUid));
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
  Future<void> doPostRoomJoin(
      roomID, password, String anchorUid, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password,
      'anchor_uid': anchorUid
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
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
