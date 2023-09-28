import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bean/Common_bean.dart';
import '../../bean/managerBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 厅内管理员列表
class RoomGuanLiYuanPage extends StatefulWidget {
  /// 0 用户查看管理员页面，1厅主查看
  int type;
  String roomID;
  RoomGuanLiYuanPage({super.key, required this.type, required this.roomID});

  @override
  State<RoomGuanLiYuanPage> createState() => _RoomGuanLiYuanPageState();
}

class _RoomGuanLiYuanPageState extends State<RoomGuanLiYuanPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostAdminList();
  }

  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            // MyToastUtils.showToastBottom('点击了');
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(130),
            child: Row(
              children: [
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(80),
                    ScreenUtil().setHeight(80),
                    list[i].avatar!),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                list[i].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(25))),
                          ],
                        ),
                      ),
                      const Expanded(child: Text(''))
                    ],
                  ),
                ),
                widget.type == 1 ? GestureDetector(
                  onTap: ((){
                    doPostSetRoomAdmin(list[i].uid.toString(),i);
                  }),
                  child: Container(
                    width: ScreenUtil().setHeight(100),
                    height: ScreenUtil().setHeight(45),
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: Colors.transparent,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      //设置四周边框
                      border: Border.all(width: 1, color: MyColors.loginPurple),
                    ),
                    child: WidgetUtils.onlyTextCenter('解除', StyleUtils.getCommonTextStyle(color: MyColors.loginPurple, fontSize: ScreenUtil().setSp(25))),
                  ),
                ): const Text(''),
                WidgetUtils.commonSizedBox(0, 20),
              ],
            ),
          ),
        ),
      ],
    );
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
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(917),
            width: double.infinity,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(15, 0),
                WidgetUtils.onlyTextCenter(
                    '管理员列表',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(32))),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(20)),
                    itemBuilder: _itemTuiJian,
                    itemCount: list.length,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Data> list = [];
  /// 房间管理员列表
  Future<void> doPostAdminList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
    };
    try {
      managerBean bean = await DataUtils.postAdminList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list.clear();
          setState(() {
            list = bean.data!;
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }


  /// 设置/取消管理员
  Future<void> doPostSetRoomAdmin(String uid, int index) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': uid,
      'status': '0',
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postSetRoomAdmin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("成功取消管理");
          setState(() {
            list.removeAt(index);
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
