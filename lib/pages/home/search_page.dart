import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../bean/Common_bean.dart';
import '../../bean/joinRoomBean.dart';
import '../../bean/searchAllBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';
import '../message/geren/people_info_page.dart';
import '../mine/my/my_info_page.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';

/// 搜索房间或用户
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _souSuoName = TextEditingController();

  // 搜索后的显示
  bool isShowInfo = true;

  //是显示房间还是用户 0房间 1用户
  int type = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchInfo();
  }

  Widget jilu(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        if (type == 0) {
          if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
            setState(() {
              sp.setBool('joinRoom', true);
            });
            doPostBeforeJoin(listRoom[i].id.toString());
          }
        } else {
          if (MyUtils.checkClick()) {
            // 如果点击的是自己，进入自己的主页
            if (sp.getString('user_id').toString() ==
                listUser[i].uid.toString()) {
              MyUtils.goTransparentRFPage(context, const MyInfoPage());
            } else {
              sp.setString('other_id', listUser[i].uid.toString());
              MyUtils.goTransparentRFPage(
                  context,
                  PeopleInfoPage(
                    otherId: listUser[i].uid.toString(),
                    title: '其他',
                  ));
            }
          }
        }
      }),
      child: SizedBox(
        height: 130.h,
        child: Row(
          children: [
            WidgetUtils.CircleImageNet(100.h, 100.h, type == 0 ? 10.h : 50.h,
                type == 0 ? listRoom[i].coverImg! : listUser[i].avatar!),
            WidgetUtils.commonSizedBox(0, 15.w),
            Expanded(
                child: Column(
              children: [
                const Spacer(),
                WidgetUtils.onlyText(
                    type == 0 ? listRoom[i].roomName! : listUser[i].nickname!,
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w600)),
                WidgetUtils.commonSizedBox(10.h, 0),
                WidgetUtils.onlyText(
                    type == 0 ? 'ID ${listRoom[i].roomNumber.toString()}' : '',
                    StyleUtils.getCommonTextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil().setSp(24),
                    )),
                const Spacer(),
              ],
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
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
              WidgetUtils.commonSizedBox(65.h, 0),
              Row(
                children: [
                  GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        Navigator.pop(context);
                      }
                    }),
                    child: WidgetUtils.showImages('assets/images/back.jpg',
                        ScreenUtil().setHeight(35), ScreenUtil().setHeight(25)),
                  ),
                  Expanded(
                      child: Container(
                    height: 100.h,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: 50,
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      //边框设置
                      decoration: BoxDecoration(
                        //背景
                        color: MyColors.home_hx,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(50.h)),
                        //设置四周边框
                        border: Border.all(width: 1, color: MyColors.home_hx),
                      ),
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.showImages(
                              'assets/images/sousuo_hui.png', 25.h, 25.h),
                          WidgetUtils.commonSizedBox(0, 10),
                          Expanded(
                              child: WidgetUtils.commonTextField(
                                  _souSuoName, '搜索ID昵称房间名')),
                        ],
                      ),
                    ),
                  )),
                  GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          if (_souSuoName.text.trim().isEmpty) {
                            MyToastUtils.showToastBottom('请输入要搜索的信息');
                            return;
                          } else {
                            saveInfo();
                            doPostSearchAll();
                            MyUtils.hideKeyboard(context);
                          }
                        }
                      }),
                      child: WidgetUtils.onlyText(
                          '搜索',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.loginBtnP,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600))),
                  WidgetUtils.commonSizedBox(0, 20.w),
                ],
              ),
              WidgetUtils.commonSizedBox(20.h, 0),
              WidgetUtils.onlyText(
                  '搜索历史',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.w600)),
              WidgetUtils.commonSizedBox(20.h, 0),
              Container(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: ScreenUtil().setHeight(15),
                  runSpacing: ScreenUtil().setHeight(15),
                  children: List.generate(
                      list_label.length,
                      (index) => GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                setState(() {
                                  _souSuoName.text = list_label[index]['text'];
                                  doPostSearchAll();
                                  MyUtils.hideKeyboard(context);
                                });
                              }
                            }),
                            child: WidgetUtils.myContainerZishiying(
                                MyColors.d8,
                                list_label[index]['text'].toString().length > 6
                                    ? '${list_label[index]['text'].toString().substring(0, 6)}...'
                                    : list_label[index]['text'],
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(26))),
                          )),
                ),
              ),
              WidgetUtils.commonSizedBox(20.h, 0),
              // 房间和用户的按钮
              Row(
                children: [
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        type = 0;
                      });
                    }),
                    child: Container(
                      width: 100.w,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter(
                              '房间',
                              StyleUtils.getCommonTextStyle(
                                  color: type == 0 ? Colors.black : MyColors.g6,
                                  fontSize: ScreenUtil().setSp(32),
                                  fontWeight: type == 0
                                      ? FontWeight.w600
                                      : FontWeight.w400)),
                          WidgetUtils.commonSizedBox(5.h, 0),
                          type == 0
                              ? Container(
                                  width: ScreenUtil().setHeight(20),
                                  height: ScreenUtil().setHeight(4),
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.homeTopBG,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                )
                              : Opacity(
                                  opacity: 0,
                                  child: Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.homeTopBG,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        type = 1;
                      });
                    }),
                    child: Container(
                      width: 100.w,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          WidgetUtils.onlyTextCenter(
                              '用户',
                              StyleUtils.getCommonTextStyle(
                                  color: type == 1 ? Colors.black : MyColors.g6,
                                  fontSize: ScreenUtil().setSp(32),
                                  fontWeight: type == 1
                                      ? FontWeight.w600
                                      : FontWeight.w400)),
                          WidgetUtils.commonSizedBox(5.h, 0),
                          type == 1
                              ? Container(
                                  width: ScreenUtil().setHeight(20),
                                  height: ScreenUtil().setHeight(4),
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.homeTopBG,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                )
                              : Opacity(
                                  opacity: 0,
                                  child: Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.homeTopBG,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // // 搜索显示房间和用户
              isShowInfo
                  ? Expanded(
                      child: SizedBox(
                        child: // 展示信息
                            type == 0
                                ? listRoom.isNotEmpty
                                    ? ListView.builder(
                                        padding:
                                            const EdgeInsets.only(top: 2.5),
                                        itemBuilder: jilu,
                                        itemCount: listRoom.length,
                                      )
                                    : Container(
                                        height: 400.h,
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.showImages(
                                                'assets/images/no_have.png',
                                                100,
                                                100),
                                            WidgetUtils.commonSizedBox(10, 0),
                                            WidgetUtils.onlyTextCenter(
                                                '暂无搜索房间',
                                                StyleUtils.getCommonTextStyle(
                                                    color: MyColors.g6,
                                                    fontSize: ScreenUtil()
                                                        .setSp(26))),
                                            const Expanded(child: Text('')),
                                          ],
                                        ),
                                      )
                                : listUser.isNotEmpty
                                    ? ListView.builder(
                                        padding:
                                            const EdgeInsets.only(top: 2.5),
                                        itemBuilder: jilu,
                                        itemCount: listUser.length,
                                      )
                                    : Container(
                                        height: 400.h,
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.showImages(
                                                'assets/images/no_have.png',
                                                100,
                                                100),
                                            WidgetUtils.commonSizedBox(10, 0),
                                            WidgetUtils.onlyTextCenter(
                                                '暂无搜索人员',
                                                StyleUtils.getCommonTextStyle(
                                                    color: MyColors.g6,
                                                    fontSize: ScreenUtil()
                                                        .setSp(26))),
                                            const Expanded(child: Text('')),
                                          ],
                                        ),
                                      ),
                      ),
                    )
                  : const Text('')
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> list_label = [];

  /// 保存搜索记录
  void saveInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id').toString(),
      'text': _souSuoName.text.trim(),
      'add_time': DateTime.now().millisecondsSinceEpoch,
    };
    // 插入数据
    await databaseHelper.insertData('searchTable', params);
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query(
      'searchTable',
      columns: null,
      whereArgs: [sp.getString('user_id')],
      where: 'uid = ?',
      orderBy: 'add_time desc',
      limit: 5, // 限制结果为前5条记录
    );
    setState(() {
      list_label = result;
    });
  }

  /// 查询有无历史记录
  void searchInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query(
      'searchTable',
      columns: null,
      whereArgs: [sp.getString('user_id')],
      where: 'uid = ?',
      orderBy: 'add_time desc',
      limit: 5, // 限制结果为前5条记录
    );
    LogE('搜索历史 == $result');
    setState(() {
      list_label = result;
    });
  }

  List<UserList> listUser = [];
  List<RoomList> listRoom = [];

  /// 推荐页搜索房间和用户
  Future<void> doPostSearchAll() async {
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{
      'keywords': _souSuoName.text.trim().toString()
    };
    try {
      searchAllBean bean = await DataUtils.postSearchAll(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listUser.clear();
            listRoom.clear();
            listUser = bean.data!.userList!;
            listRoom = bean.data!.roomList!;
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

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    //判断房间id是否为空的
    if (sp.getString('roomID') == null || sp.getString('roomID').toString().isEmpty) {
      return;
    } else {
      // 不是空的，并且不是之前进入的房间
      if (sp.getString('roomID').toString() != roomID) {
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
          doPostRoomJoin(roomID, '', bean.data!.rtc!);
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomTSMiMaPage(
                  roomID: roomID, roomToken: bean.data!.rtc!, anchorUid: ''));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间
  Future<void> doPostRoomJoin(roomID, password, roomToken) async {
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
                beforeId: '',
                roomToken: roomToken,
              ));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
