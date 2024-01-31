import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/pages/room/room_messages_more_page.dart';
import '../../colors/my_colors.dart';
import '../../db/DatabaseHelper.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 厅内消息列表
class RoomMessagesPage extends StatefulWidget {
  const RoomMessagesPage({super.key});

  @override
  State<RoomMessagesPage> createState() => _RoomMessagesPageState();
}

class _RoomMessagesPageState extends State<RoomMessagesPage> {
  List<Map<String, dynamic>> listMessage = [];
  List<int> listRead = [];
  var listen,listen2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostSystemMsgList();
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '厅内聊天返回'){
        doPostSystemMsgList();
      }
    });
    listen2 = eventBus.on<SendMessageBack>().listen((event) {
      doPostSystemMsgList();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listen2.cancel();
  }

  /// 消息列表
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick()) {
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return RoomMessagesMorePage(
                        otherUid: listMessage[i]['otherUid'],
                        nickName: listMessage[i]['nickName'],
                        otherImg: listMessage[i]['otherHeadNetImg'],
                      );
                    }));
              });
            }
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(100),
            color: Colors.transparent,
            child: Row(
              children: [
                WidgetUtils.CircleImageNet(
                    ScreenUtil().setHeight(90),
                    ScreenUtil().setHeight(90),
                    45.h,
                    listMessage[i]['otherHeadNetImg'],),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                listMessage[i]['nickName'],
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(28))),
                            WidgetUtils.commonSizedBox(0, 5),
                            // WidgetUtils.showImages(
                            //     'assets/images/room_nan.png',
                            //     ScreenUtil().setHeight(31),
                            //     ScreenUtil().setHeight(29)),
                            const Expanded(child: Text('')),
                            WidgetUtils.onlyText(
                                DateTime.parse(
                                        DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    listMessage[i]['add_time']))
                                            .toString())
                                    .toString()
                                    .substring(0, 10),
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ3,
                                    fontSize: ScreenUtil().setSp(25)))
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      Row(
                        children: [
                          listMessage[i]['type'] == 1
                              ? Text(
                            listMessage[i]['content'].toString().length > 15 ? listMessage[i]['content'].toString().substring(0,15) : listMessage[i]['content'],
                            overflow: TextOverflow.ellipsis,
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.g9,
                                fontSize: ScreenUtil().setSp(25)),
                          )
                              :  listMessage[i]['type'] == 2 ? Text(
                            '[图片]',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.homeTopBG,
                                fontSize: ScreenUtil().setSp(23)),
                          ) : listMessage[i]['type'] == 3 ? Text(
                            '[语音]',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.homeTopBG,
                                fontSize: ScreenUtil().setSp(23)),
                          ) : Text(
                            '[红包]',
                            style: StyleUtils.getCommonTextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil().setSp(23)),
                          ),
                          const Spacer(),
                          listRead[i] > 0 ? Container(
                            width: 30.h,
                            height: 30.h,
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: Colors.red,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              listRead[i].toString(),
                              style: StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(22),
                                  fontWeight: FontWeight.w600),
                            ),
                          ) : const Text('')
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        WidgetUtils.commonSizedBox(20, 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          eventBus.fire(SendMessageBack(type: 5, msgID: '0'));
          Navigator.of(context).pop();
          return true;
        },
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    eventBus.fire(SendMessageBack(type: 5, msgID: '0'));
                    Navigator.pop(context);
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
              height: ScreenUtil().setHeight(856),
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
                      '消息列表',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(32))),

                  /// 展示在线用户
                  Expanded(
                    child: listMessage.isNotEmpty
                        ? ListView.builder(
                            padding:
                                EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                            itemBuilder: _itemTuiJian,
                            itemCount: listMessage.length,
                          )
                        : const Text(''),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 获取系统消息
  Future<void> doPostSystemMsgList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;

    List<Map<String, dynamic>> allData =
        await databaseHelper.getAllData('messageSLTable');
    // 执行查询操作
    String queryM =
        'select MAX(id) AS id from messageSLTable group by combineID order by weight desc,add_time desc';
    List<Map<String, dynamic>> result = await db.rawQuery(queryM);
    // 查询出来后在查询单条信息具体信息
    List<int> listId = [];
    String ids = '';
    for (int i = 0; i < result.length; i++) {
      listId.add(result[i]['id']);
      if (ids.isNotEmpty) {
        ids = '$ids,${result[i]['id'].toString()}';
      } else {
        ids = result[i]['id'].toString();
      }
    }
    // 生成占位符字符串，例如: ?,?,?,?
    String placeholders =
        List.generate(listId.length, (index) => '?').join(',');
    // 构建查询语句和参数
    String query =
        'SELECT * FROM messageSLTable WHERE id IN ($placeholders)  and uid = ${sp.getString('user_id')}';
    List<dynamic> args = listId;
    // 执行查询
    List<Map<String, dynamic>> result2 = await db.rawQuery(query, args);

    String myIds = '';
    setState(() {
      listMessage = result2;

      for (int i = 0; i < listMessage.length; i++) {
        listRead.add(0);
        if (myIds.isNotEmpty) {
          myIds = '$myIds,${listMessage[i]['otherUid'].toString()}';
        } else {
          myIds = listMessage[i]['otherUid'].toString();
        }
      }
    });
    for (int i = 0; i < listMessage.length; i++) {
      // 更新头像和昵称
      await db.update(
          'messageSLTable',
          {
            'otherHeadNetImg': listMessage[i]['otherHeadNetImg'],
            'nickName': listMessage[i]['nickName']
          },
          whereArgs: [listMessage[i]['combineID']],
          where: 'combineID = ?');
      String query =
          "SELECT * FROM messageSLTable WHERE  combineID = '${listMessage[i]['combineID']}' and readStatus = 0 and uid = ${sp.getString('user_id')} ";
      List<Map<String, dynamic>> result3 = await db.rawQuery(query);
      if (result3.isNotEmpty) {
        setState(() {
          listRead[i] = result3.length;
        });
      } else {
        setState(() {
          listRead[i] = 0;
        });
      }
    }
    // if (myIds.isNotEmpty) {
    //   //调用是否开播接口
    //   // doPostSendUserMsg(myIds);
    // }
  }
}
