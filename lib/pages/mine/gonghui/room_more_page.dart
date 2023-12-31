import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/ghRoomBean.dart';
import '../../../bean/myGhBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../room/room_page.dart';
import '../../room/room_ts_mima_page.dart';
/// 房间列表
class RoomMorePage extends StatefulWidget {
  const RoomMorePage({Key? key}) : super(key: key);

  @override
  State<RoomMorePage> createState() => _RoomMorePageState();
}

class _RoomMorePageState extends State<RoomMorePage> {
  var appBar;
  var length = 1;
  List<ListR> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会房间', true, context, false, 0);
    doPostSearchGuildRoom();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _itemPeople(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        //点击进入房间
        if (MyUtils.checkClick()) {
          doPostBeforeJoin(list[i].id.toString());
        }
      }),
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          children: [
            WidgetUtils.CircleImageNet(ScreenUtil().setHeight(110), ScreenUtil().setHeight(110), 10, list[i].coverImg!),
            WidgetUtils.commonSizedBox(10, 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetUtils.onlyText(list[i].roomName!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.w600)),
                WidgetUtils.onlyText('ID：${list[i].roomNumber.toString()}', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(26), fontWeight: FontWeight.w600))
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: length > 0 ? ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        itemBuilder: _itemPeople,
        itemCount: list.length,
      )
          :
      Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: [
            const Expanded(child: Text('')),
            WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
            WidgetUtils.commonSizedBox(10, 0),
            WidgetUtils.onlyTextCenter('暂无公会房间', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
            const Expanded(child: Text('')),
          ],
        ),
      ),
    );
  }


  /// 我的公会
  Future<void> doPostSearchGuildRoom() async {
    Loading.show(MyConfig.successTitle);
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'guild_id': sp.getString('guild_id'),
        'keyword': ''
      };
      ghRoomBean bean = await DataUtils.postSearchGuildRoom(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            if(bean.data!.list!.isNotEmpty){
              list = bean.data!.list!;
              length = list.length;
            }else{
              length = 0;
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

