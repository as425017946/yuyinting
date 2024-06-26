import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/bean/userStatusBean.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/message/chat_page.dart';
import 'package:yuyinting/pages/message/xitong_more_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import '../../bean/xtListBean.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/custom_dialog.dart';
import '../../utils/line_painter2.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import 'geren/people_info_page.dart';

///消息
class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<ListXT> list = [];
  List<Map<String, dynamic>> listMessage = [];
  List<int> listRead = [];
  String info = '', time = '';
  int unRead = 0;
  int length = 0;
  var list1, list2, list3, listenMessage;

  // 设备是安卓还是ios
  String isDevices = 'android';

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  bool isUp = false; //是否允许上拉
  bool isDown = true; //是否允许下拉
  void _onRefresh() async {
    // 重新初始化
    _refreshController.resetNoData();
    setState(() {
      isUp = false;
    });
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostSystemMsgList();
  }

  void _onLoading() async {
    setState(() {
      isDown = false;
    });
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {
        page++;
      });
    }
    doPostSystemMsgList();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      setState(() {
        isDevices = 'android';
      });
    } else if (Platform.isIOS) {
      setState(() {
        isDevices = 'ios';
      });
    }
    doPostSystemMsgList();
    MyUtils.addChatListener();
    list1 = eventBus.on<ResidentBack>().listen((event) {
      setState(() {
        unRead = 0;
      });
    });
    list2 = eventBus.on<XXBack>().listen((event) {
      if (event.number == '消息') {
        doPostSystemMsgList2();
      }
    });
    list3 = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '聊天返回') {
        doPostSystemMsgList();
      }
    });
    listenMessage = eventBus.on<SendMessageBack>().listen((event) {
      if(event.uid.isNotEmpty){
        doPostSystemMsgList();
      }
    });
    _scListener = () {
      setState(() {
        _scOffset = _sc.offset;
      });
    };
    _sc.addListener(_scListener!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    list1.cancel();
    list2.cancel();
    list3.cancel();
    listenMessage.cancel();
    if (_scListener != null) {
      _sc.removeListener(_scListener!);
    }
    super.dispose();
  }

  void Function()? _scListener;
  final ScrollController _sc = ScrollController();
  double _scOffset = 0;

  Widget buildIconSlideAction(
      String title, IconData icons, Color color, int i) {
    return Container(
      width: 50,
      child: IconSlideAction(
        caption: title,
        color: color,
        icon: icons,
        onTap: () {
          // MyToastUtils.showToastBottom('第几个$i');
          doDelete(listMessage[i]['combineID']);
          //移除当前项
          setState(() {
            listMessage.removeAt(i);
          });
        },
      ),
    );
  }

  Widget message(BuildContext context, int i) {
    final DataU dataU = listU.firstWhere(
        (element) => element.uid.toString() == listMessage[i]['otherUid'],
        orElse: () => DataU(liveStatus: 0, loginStatus: 0, nobleID: 0));
    return Slidable(
      //列表中只有一个能滑动
      key: Key(UniqueKey().toString()),
      actionExtentRatio: 0.3,
      //滑动的动画
      actionPane: const SlidableStrechActionPane(),
      //右侧滑出
      secondaryActions: [
        buildIconSlideAction("删除", Icons.delete, Colors.red, i)
      ],
      child: Container(
        height: ScreenUtil().setHeight(130),
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: (() {
                if(MyUtils.checkClick()){
                  // 点击头像进入个人主页
                  MyUtils.goTransparentRFPage(
                      context,
                      PeopleInfoPage(
                        otherId: listMessage[i]['otherUid'],
                        title: '其他',
                      ));
                }
              }),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  WidgetUtils.CircleImageNet(
                      100.h, 100.h, 50.h, listMessage[i]['otherHeadNetImg']),
                  dataU.liveStatus == 1
                      ? WidgetUtils.showImages(
                          'assets/images/zhibozhong.webp',
                          110.h,
                          110.h,
                        )
                      : dataU.loginStatus == 1
                          ? Container(
                              height: 60.h,
                              width: 60.h,
                              alignment: Alignment.bottomRight,
                              child: CustomPaint(
                                painter: LinePainter2(colors: Colors.green),
                              ),
                            )
                          : const Text(''),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(0, 10),
            Expanded(
              child: GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    MyUtils.goTransparentPageCom(
                        context,
                        ChatPage(
                            nickName: listMessage[i]['nickName'] ?? '',
                            otherUid: listMessage[i]['otherUid'],
                            otherImg: listMessage[i]['otherHeadNetImg']));
                  }
                }),
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            dataU.nobleID as int > 5
                                ? ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [MyColors.gz5, MyColors.gz6],
                                      ).createShader(Offset.zero & bounds.size);
                                    },
                                    blendMode: BlendMode.srcATop,
                                    child: Text(
                                      listMessage[i]['nickName'] ?? '',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(32),
                                          color: const Color(0xffffffff)),
                                    ),
                                  )
                                : Text(
                                    listMessage[i]['nickName'] ?? '',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(32)),
                                  ),
                            const Expanded(child: Text('')),
                            listMessage[i]['nickName'].toString() == '小柴客服'
                                ? Text(
                                    '官方客服',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: MyColors.homeTopBG,
                                        fontSize: ScreenUtil().setSp(25)),
                                  )
                                : Text(
                                    DateTime.parse(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    int.parse(listMessage[i]
                                                        ['add_time']))
                                                .toString())
                                        .toString()
                                        .substring(0, 10),
                                    style: StyleUtils.getCommonTextStyle(
                                        color: MyColors.g9,
                                        fontSize: ScreenUtil().setSp(25)),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            (listMessage[i]['type'] == 1 &&
                                    !listMessage[i]['content']
                                        .toString()
                                        .contains('.jpg'))
                                ? Text(
                                    listMessage[i]['content']
                                                .toString()
                                                .length >
                                            15
                                        ? listMessage[i]['content']
                                            .toString()
                                            .substring(0, 15)
                                        : listMessage[i]['content'],
                                    overflow: TextOverflow.ellipsis,
                                    style: StyleUtils.getCommonTextStyle(
                                        color: MyColors.g9,
                                        fontSize: ScreenUtil().setSp(25)),
                                  )
                                : (listMessage[i]['type'] == 1 &&
                                        listMessage[i]['content']
                                            .toString()
                                            .contains('.jpg'))
                                    ? Text(
                                        '[图片]',
                                        style: StyleUtils.getCommonTextStyle(
                                            color: MyColors.homeTopBG,
                                            fontSize: ScreenUtil().setSp(23)),
                                      )
                                    : listMessage[i]['type'] == 2
                                        ? Text(
                                            '[图片]',
                                            style:
                                                StyleUtils.getCommonTextStyle(
                                                    color: MyColors.homeTopBG,
                                                    fontSize:
                                                        ScreenUtil().setSp(23)),
                                          )
                                        : listMessage[i]['type'] == 3
                                            ? Text(
                                                '[语音]',
                                                style: StyleUtils
                                                    .getCommonTextStyle(
                                                        color:
                                                            MyColors.homeTopBG,
                                                        fontSize: ScreenUtil()
                                                            .setSp(23)),
                                              )
                                            : Text(
                                                '[红包]',
                                                style: StyleUtils
                                                    .getCommonTextStyle(
                                                        color: Colors.red,
                                                        fontSize: ScreenUtil()
                                                            .setSp(23)),
                                              ),
                            const Spacer(),
                            listRead[i] > 0
                                ? Container(
                                    width: 30.h,
                                    height: 30.h,
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.red,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      listRead[i].toString(),
                                      style: StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(22),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : const Text('')
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String mbIdl = '';

  void doDelete(String cbID) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    //删除
    db.delete('messageSLTable', where: 'combineID = ?', whereArgs: [cbID]);
    doPostSystemMsgList();
  }
  void doDeleteBlack() async {
    if (listU.isEmpty) return;
    List<int> uids = [];
    for (var element in listU) {
      if (element.accountStatus == 0 && element.uid != null) { // 0封禁 其他正常
        uids.add(element.uid!);
      }
    }
    if (uids.isEmpty) return;
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    for (var element in uids) {
      final item = listMessage.firstWhere((e) => e['otherUid'] == element.toString(), orElse: () => {});
      if (item.isNotEmpty) {
        //删除
        db.delete('messageSLTable', where: 'combineID = ?', whereArgs: [item['combineID']]);
      }
    }
    doPostSystemMsgList();
  }

  @override
  Widget build(BuildContext context) {
    final top = isDevices == 'ios' ? 80.h : 60.h;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            //设置Container修饰
            image: DecorationImage(
              //背景图片修饰
              image: AssetImage("assets/images/all_bg.png"),
              fit: BoxFit.fill, //覆盖
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SmartRefresher(
                header: MyUtils.myHeader(),
                footer: MyUtils.myFotter(),
                controller: _refreshController,
                enablePullUp: false,
                onLoading: _onLoading,
                onRefresh: _onRefresh,
                scrollController: _sc,
                child: SingleChildScrollView(
                  child: _content(),
                ),
              ),
              _nav(top),
            ],
          ),
        ));
  }

  Widget _nav(double top) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: top, bottom: 5),
      height: top + 60.h + 5,
      width: double.infinity,
      alignment: Alignment.bottomLeft,
      color: _scOffset > 35 ? Colors.white : Colors.transparent,
      child: Row(
        children: [
          WidgetUtils.onlyTextBottom(
              '消息',
              StyleUtils.getCommonTextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(46),
                  fontWeight: FontWeight.w600)),
          const Expanded(child: Text('')),
          GestureDetector(
            onTap: (() {
              exitLogin(context);
            }),
            child: Container(
              height: 50.h,
              width: 50.h,
              color: Colors.transparent,
              alignment: Alignment.centerRight,
              child: WidgetUtils.showImages('assets/images/messages_yidu.png',
                  ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
            ),
          )
        ],
      ),
    );
  }

  Widget _content() {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(isDevices == 'ios' ? 80.h : 60.h, 0),
        WidgetUtils.commonSizedBox(35 + 60.h, 0),

        /// 系统消息
        GestureDetector(
          onTap: (() {
            MyUtils.goTransparentRFPage(context, const XitongMorePage());
          }),
          child: Container(
            color: Colors.transparent,
            height: ScreenUtil().setHeight(130),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/message_xt.png',
                        ScreenUtil().setHeight(100),
                        ScreenUtil().setHeight(100)),
                    unRead > 0
                        ? Positioned(
                            top: ScreenUtil().setHeight(10),
                            right: ScreenUtil().setHeight(20),
                            child: CustomPaint(
                              painter: LinePainter2(colors: Colors.red),
                            ))
                        : const Text('')
                  ],
                ),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Text(
                              '系统消息',
                              style: StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(32)),
                            ),
                            const Expanded(child: Text('')),
                            Text(
                              time,
                              style: StyleUtils.getCommonTextStyle(
                                  color: MyColors.g9,
                                  fontSize: ScreenUtil().setSp(25)),
                            ),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10.h, 0),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          info,
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(25)),
                        ),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        (listMessage.isNotEmpty && listU.isNotEmpty)
            ? ListView.builder(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                itemBuilder: message,
                itemCount: listMessage.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              )
            : const Text('')
      ],
    );
  }

  /// 一键已读
  Future<void> exitLogin(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: '是否标记一键已读？',
            callback: (res) {
              readInfo();
            },
            content: '',
          );
        });
  }

  /// 一键已读使用
  void readInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    // 执行查询操作
    List<Map<String, dynamic>> result = await db.query(
      'messageSLTable',
      columns: ['MAX(id) AS id', 'combineID'],
      groupBy: 'combineID',
    );
    // 把未读信息都改成已读
    for (int i = 0; i < result.length; i++) {
      LogE('标记已读 ${result[i]['combineID']}');

      await db.update('messageSLTable', {'readStatus': 1},
          whereArgs: [result[i]['combineID'], sp.getString('user_id')],
          where: 'combineID = ? and uid = ?');
    }
    // 修改数据成功后在重新查询一遍
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
        'SELECT * FROM messageSLTable WHERE id IN ($placeholders)  and uid = ${sp.getString('user_id')} order by add_time desc';
    List<dynamic> args = listId;
    // 执行查询
    List<Map<String, dynamic>> result2 = await db.rawQuery(query, args);
    LogE('长度 ** == $result2');
    String myIds = '';
    setState(() {
      listMessage = result2;
      listRead.clear();
      for (int i = 0; i < listMessage.length; i++) {
        listRead.add(0);
        if (myIds.isNotEmpty) {
          myIds = '$myIds,${listMessage[i]['otherUid'].toString()}';
        } else {
          myIds = listMessage[i]['otherUid'].toString();
        }
      }
    });
    eventBus.fire(SendMessageBack(type: 5, msgID: '0', uid: ''));
  }

  /// 获取系统消息
  Future<void> doPostSystemMsgList2() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'is_all': sp.getString('isFirstMessage') == '1' ? '1' : '',
      };
      xtListBean bean = await DataUtils.postSystemMsgList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            sp.setString('isFirstMessage', '2');
          });
          if (bean.data!.list!.isNotEmpty) {
            setState(() {
              info = bean.data!.list![bean.data!.list!.length - 1].text!;
              time = bean.data!.list![bean.data!.list!.length - 1].addTime!
                  .substring(0, 10);
              unRead = bean.data!.list!.length;
            });
            for (int i = 0; i < bean.data!.list!.length; i++) {
              Map<String, dynamic> params = <String, dynamic>{
                'messageID': bean.data!.list![i].id as int,
                'type': bean.data!.list![i].type,
                'title': bean.data!.list![i].title,
                'text': bean.data!.list![i].text,
                'img': bean.data!.list![i].img,
                'url': bean.data!.list![i].url,
                'add_time': bean.data!.list![i].addTime,
                'data_status': 0,
                'img_url': bean.data!.list![i].imgUrl,
              };
              // 插入数据
              await databaseHelper.insertData('messageXTTable', params);
            }
          } else {
            // 获取所有数据
            List<Map<String, dynamic>> allData =
                await databaseHelper.getAllData('messageXTTable');
            if (allData.isNotEmpty) {
              for (int i = 0; i < allData.length; i++) {
                if (allData[i]['data_status'] == 0) {
                  setState(() {
                    unRead++;
                  });
                }
              }
              setState(() {
                info = allData[allData.length - 1]['text'];
                time = allData[allData.length - 1]['add_time'].substring(0, 10);
              });
            }
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
      LogE('错误信息$e');
    }
  }

  /// 获取系统消息
  Future<void> doPostSystemMsgList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'is_all': sp.getString('isFirstMessage') == '1' ? '1' : '',
      };
      xtListBean bean = await DataUtils.postSystemMsgList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            sp.setString('isFirstMessage', '2');
          });
          if (bean.data!.list!.isNotEmpty) {
            setState(() {
              info = bean.data!.list![bean.data!.list!.length - 1].text!;
              time = bean.data!.list![bean.data!.list!.length - 1].addTime!
                  .substring(0, 10);
              unRead = bean.data!.list!.length;
            });
            for (int i = 0; i < bean.data!.list!.length; i++) {
              Map<String, dynamic> params = <String, dynamic>{
                'messageID': bean.data!.list![i].id as int,
                'type': bean.data!.list![i].type,
                'title': bean.data!.list![i].title,
                'text': bean.data!.list![i].text,
                'img': bean.data!.list![i].img,
                'url': bean.data!.list![i].url,
                'add_time': bean.data!.list![i].addTime,
                'data_status': 0,
                'img_url': bean.data!.list![i].imgUrl,
              };
              // 插入数据
              await databaseHelper.insertData('messageXTTable', params);
            }
          } else {
            // 获取所有数据
            List<Map<String, dynamic>> allData =
                await databaseHelper.getAllData('messageXTTable');
            if (allData.isNotEmpty) {
              for (int i = 0; i < allData.length; i++) {
                if (allData[i]['data_status'] == 0) {
                  setState(() {
                    unRead++;
                  });
                }
              }
              setState(() {
                info = allData[allData.length - 1]['text'];
                time = allData[allData.length - 1]['add_time'].substring(0, 10);
              });
            }
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
      // 执行查询操作
      String queryM =
          'select MAX(id) AS id from messageSLTable group by combineID order by weight desc, add_time desc';
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
          'SELECT * FROM messageSLTable WHERE id IN ($placeholders) and uid = ${sp.getString('user_id')} order by weight desc,add_time desc';
      List<dynamic> args = listId;
      // 执行查询
      List<Map<String, dynamic>> result2 = await db.rawQuery(query, args);
      LogE('长度== ${result2}');
      String myIds = '';
      if (result2 != listMessage) {
        setState(() {
          listMessage = result2;
          listRead.clear();
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
              "SELECT * FROM messageSLTable WHERE  combineID = '${listMessage[i]['combineID']}' and readStatus = 0  and uid = ${sp.getString('user_id')} ";
          List<Map<String, dynamic>> result3 = await db.rawQuery(query);
          if (result3.isNotEmpty) {
            setState(() {
              listRead[i] = result3.length;
              LogE('结果==${listRead.length}');
            });
          } else {
            setState(() {
              listRead[i] = 0;
            });
          }
        }
        if (myIds.isNotEmpty) {
          //调用接口
          doPostSendUserMsg(myIds);
        }
      }
    } catch (e) {
      LogE('错误信息$e');
    }
  }

  /// 用户开播、在线状态
  List<DataU> listU = [];

  Future<void> doPostSendUserMsg(String uids) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uids': uids,
    };
    try {
      userStatusBean bean = await DataUtils.postUserStatus(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listU.clear();
            if (bean.data!.isNotEmpty) {
              listU = bean.data!;
              doDeleteBlack();
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
      LogE('错误信息== ${e.toString()}');
    }
  }
}
