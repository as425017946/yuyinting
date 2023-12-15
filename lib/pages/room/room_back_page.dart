import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/room/room_page.dart';
import 'package:yuyinting/pages/room/room_ts_mima_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../bean/Common_bean.dart';
import '../../bean/tjRoomListBean.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';

/// 退出房间
class RoomBackPage extends StatefulWidget {
  const RoomBackPage({super.key});

  @override
  State<RoomBackPage> createState() => _RoomBackPageState();
}

class _RoomBackPageState extends State<RoomBackPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostTJRoomList();
  }

  Widget roomHouse(BuildContext context, int i){
    return Column(children: [
      GestureDetector(
        onTap: (() {
          eventBus.fire(SubmitButtonBack(title: '关闭房间'));
          // 点击的是不是当前房间，如果是关闭弹窗，不是跳转房间
          if(sp.getString('roomID').toString() == list[i].id.toString()){
            Navigator.pop(context);
          }else{
            doPostBeforeJoin(list[i].id.toString());
          }
        }),
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            children: [
              WidgetUtils.CircleImageNet(200.h, 200.h, 20, list[i].coverImg!),
              Positioned(
                  bottom: 10.h,
                  left: 10.h,
                  child: SizedBox(
                    width: 190.h,
                    child: Text(
                      list[i].roomName!,
                      style:
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: 30.sp),
                    ),
                  ))
            ],
          ),
        ),
      ),
      WidgetUtils.commonSizedBox(20.h, 0),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: (() {
          eventBus.fire(SubmitButtonBack(title: '关闭房间'));
          Navigator.pop(context);
        }),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 240.h,
              color: Colors.transparent,
            ),
            Expanded(
                child: Container(
              height: double.infinity,
              color: Colors.black54,
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(35, 0),
                  Row(
                    children: [
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: (() {
                          eventBus.fire(SubmitButtonBack(title: '退出房间'));
                          Navigator.pop(context);
                        }),
                        child: Column(
                          children: [
                            WidgetUtils.showImages(
                                'assets/images/room_exit.png',
                                ScreenUtil().setHeight(60),
                                ScreenUtil().setHeight(60)),
                            WidgetUtils.onlyTextCenter(
                                '退出房间',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ3,
                                    fontSize: ScreenUtil().setSp(24))),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 50),
                      GestureDetector(
                        onTap: (() {
                          eventBus.fire(SubmitButtonBack(title: '收起房间'));
                          Navigator.pop(context);
                        }),
                        child: Column(
                          children: [
                            WidgetUtils.showImages(
                                'assets/images/room_shouqi.png',
                                ScreenUtil().setHeight(60),
                                ScreenUtil().setHeight(60)),
                            WidgetUtils.onlyTextCenter(
                                '收起房间',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ3,
                                    fontSize: ScreenUtil().setSp(24))),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 40),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(40, 0),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                      itemBuilder: roomHouse,
                      itemCount: list.length,
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  List<Data> list = [];

  /// 派对前5名排行
  Future<void> doPostTJRoomList() async {
    LogE('token == ${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'page': '1',
      'pageSize': MyConfig.pageSize,
      'type': '1'
    };
    try {
      // Loading.show();
      tjRoomListBean bean = await DataUtils.postTJRoomList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (bean.data!.isNotEmpty) {
              list.clear();
              list = bean.data!;
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
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(roomID, '');
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
        // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomTSMiMaPage(
                roomID: roomID,
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
        // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
              context,
              RoomPage(
                roomId: roomID,
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
