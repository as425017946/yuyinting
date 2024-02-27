import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/ghRoomBean.dart';
import '../../../bean/hzRoomBean.dart';
import '../../../bean/joinRoomBean.dart';
import '../../../bean/myGhBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../room/room_page.dart';
import '../../room/room_ts_mima_page.dart';
import 'hz_fenrun_page.dart';

/// 房间列表
class HZRoomMorePage extends StatefulWidget {
  String hzhtID;

  HZRoomMorePage({Key? key, required this.hzhtID}) : super(key: key);

  @override
  State<HZRoomMorePage> createState() => _HZRoomMorePageState();
}

class _HZRoomMorePageState extends State<HZRoomMorePage> {
  var appBar;
  var length = 1;
  List<Lists> list = [];
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('厅列表', true, context, false, 0);

    doPostSearchConsortiaGuild();

    //设置完比例后返回显示
    listen = eventBus.on<BiLiBack>().listen((event) {
      setState(() {
        list[event.index].ratio = '${event.number}%';
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  Widget _itemPeople(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        // //点击进入房间
        // if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
        //   setState(() {
        //     sp.setBool('joinRoom',true);
        //   });
        //   doPostBeforeJoin(list[i].id.toString());
        // }
      }),
      child: Container(
        margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 20.h),
        child: Row(
          children: [
            WidgetUtils.CircleImageNet(ScreenUtil().setHeight(110),
                ScreenUtil().setHeight(110), 10, list[i].logo!),
            WidgetUtils.commonSizedBox(10, 20.h),
            SizedBox(
              height: 76.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  WidgetUtils.onlyText(
                      '厅名称',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black, fontSize: 14)),
                  WidgetUtils.commonSizedBox(0, 5),
                  WidgetUtils.onlyText(
                      list[i].title!.length > 5
                          ? '${list[i].title!.substring(0, 5)}...'
                          : list[i].title!,
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black, fontSize: 14)),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 76.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  WidgetUtils.onlyText(
                      '厅主昵称',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black, fontSize: 14)),
                  WidgetUtils.commonSizedBox(0, 5),
                  WidgetUtils.onlyText(
                      list[i].leaderNickname!,
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black, fontSize: 14)),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 76.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  WidgetUtils.onlyText(
                      '分润',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black, fontSize: 14)),
                  WidgetUtils.commonSizedBox(0, 5),
                  WidgetUtils.onlyText(
                      list[i].ratio!,
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black, fontSize: 14)),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: ((){
                if(MyUtils.checkClick()) {
                  MyUtils.goTransparentPageCom(context, HZFenRunPage(name: list[i].title!, id: list[i].id.toString(),ghID: list[i].id.toString(), index: i, bili:list[i].ratio!));
                }
              }),
              child: WidgetUtils.myContainer(ScreenUtil().setHeight(45), ScreenUtil().setHeight(100), Colors.white, MyColors.homeTopBG, '设置', ScreenUtil().setSp(25), MyColors.homeTopBG),
            )
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
      body: length > 0
          ? ListView.builder(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              itemBuilder: _itemPeople,
              itemCount: list.length,
            )
          : Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Expanded(child: Text('')),
                  WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
                  WidgetUtils.commonSizedBox(10, 0),
                  WidgetUtils.onlyTextCenter(
                      '暂无厅',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g6,
                          fontSize: ScreenUtil().setSp(26))),
                  const Expanded(child: Text('')),
                ],
              ),
            ),
    );
  }

  /// 我的公会
  Future<void> doPostSearchConsortiaGuild() async {
    Loading.show(MyConfig.successTitle);
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'cid': widget.hzhtID,
        'keyword': ''
      };
      hzRoomBean bean = await DataUtils.postSearchConsortiaGuild(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            if (bean.data!.lists!.isNotEmpty) {
              list = bean.data!.lists!;
              length = list.length;
            } else {
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
