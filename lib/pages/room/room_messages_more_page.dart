import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../bean/Common_bean.dart';
import '../../bean/commonStringBean.dart';
import '../../bean/isPayBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../widget/SwiperPage.dart';
import '../message/hongbao_page.dart';
import '../mine/setting/password_pay_page.dart';

/// 厅内消息详情
class RoomMessagesMorePage extends StatefulWidget {
  String otherUid;
  String otherImg;
  String nickName;
  RoomMessagesMorePage({super.key, required this.otherUid, required this.otherImg, required this.nickName});

  @override
  State<RoomMessagesMorePage> createState() => _RoomMessagesMorePageState();
}

class _RoomMessagesMorePageState extends State<RoomMessagesMorePage> {

  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool playRecord = false; //音频文件播放状态
  List<String> imgList = [];
  var listen,listenHB;
  int length = 0;
  String isGZ = '0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyUtils.addChatListener();
    doPostUserFollowStatus();
    doLocationInfo();
    saveImages();
    listen = eventBus.on<SendMessageBack>().listen((event) {
      doLocationInfo();
    });
    listenHB = eventBus.on<HongBaoBack>().listen((event) {
      LogE('发送了===');
      saveHBinfo(event.info);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listenHB.cancel();
  }
  // 在数据变化后将滚动位置设置为最后一个item的位置
  void scrollToLastItem() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  // 自己头像和他人头像
  String myHeadImg = '', otherHeadImg = '';
  saveImages() async{
    //保存头像
    MyUtils.saveImgTemp(sp.getString('user_headimg').toString(), sp.getString('user_id').toString());
    MyUtils.saveImgTemp(widget.otherImg, widget.otherUid);
    // 保存路径
    Directory? directory = await getTemporaryDirectory();
    myHeadImg = '${directory!.path}/${sp.getString('user_id')}.jpg';
    otherHeadImg = '${directory!.path}/${widget.otherUid}.jpg';
  }

  // 保存发红包的信息 type 1自己给别人发，2收到别人发的红包
  saveHBinfo(String info) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    String combineID = '';
    if (int.parse(sp.getString('user_id').toString()) >
        int.parse(widget.otherUid)) {
      combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
    } else {
      combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id').toString(),
      'otherUid': widget.otherUid,
      'whoUid': sp.getString('user_id').toString(),
      'combineID': combineID,
      'nickName': widget.nickName,
      'content': '送出$info个V豆',
      'headImg': myHeadImg,
      'otherHeadImg': otherHeadImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 6,
      'number': 0,
      'status': 1,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
    };
    // 插入数据
    await databaseHelper.insertData('messageSLTable', params);
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null, whereArgs: [combineID], where: 'combineID = ?');
    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToLastItem(); // 在widget构建完成后滚动到底部
    });
  }

  Widget chatWidget(BuildContext context, int i) {
    double widthAudio = 0;
    if(allData2[i]['type'] == 3){
      widthAudio = ScreenUtil().setHeight(60+allData2[i]['number']*4);
    }


    String addTime = '';
    DateTime date = DateTime.parse(
        DateTime.fromMillisecondsSinceEpoch(int.parse(allData2[i]['add_time']))
            .toString());
    //获取当前时间的月
    int month = date.month;
    //获取当前时间的日
    int day = date.day;
    //获取当前时间的时
    int hour = date.hour;
    //获取当前时间的分
    int minute = date.minute;
    // 获取当前时间对象
    DateTime now = DateTime.now();
    int month2 = now.month;
    //获取当前时间的日
    int day2 = now.day;
    if (month == month2 && day == day2) {
      addTime = '$hour:$minute';
    } else if (month == month2 && day2 - day == 1) {
      addTime = '昨天 $hour:$minute';
    } else if (month == month2 && day2 - day > 1) {
      addTime = '$month月$day日 $hour:$minute';
    } else if (month != month2) {
      addTime = '$month月$day日 $hour:$minute';
    }

    // 判断不是第一个，并且中间时间差距大于10分钟才显示时间
    if (i > 0 &&
        ((int.parse(allData2[i]['add_time']) -
            int.parse(allData2[i - 1]['add_time'])) /
            1000 <=
            600)) {
      addTime = '';
    }

    if (allData2[i]['whoUid'] != sp.getString('user_id')) {
      return Column(
        children: [
          //左侧显示
          WidgetUtils.onlyTextCenter(
              addTime,
              StyleUtils.getCommonTextStyle(
                  color: MyColors.g9, fontSize: ScreenUtil().setSp(20))),
          WidgetUtils.commonSizedBox(
              ScreenUtil().setHeight(10), ScreenUtil().setHeight(10)),
          Row(
            children: [
              WidgetUtils.CircleImageAss(60.h,
                  60.h, 30.h, allData2[i]['headImg']),
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(10)),
              Flexible(
                child: Container(
                  constraints:
                  BoxConstraints(minWidth: ScreenUtil().setHeight(60)),
                  padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 1), // 阴影的偏移量，向右下方偏移3像素
                      ),
                    ],
                  ),
                  child: allData2[i]['type'] == 1
                      ? Text(
                    allData2[i]['content'],
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: Colors.black,
                    ),
                  )
                      : allData2[i]['type'] == 2 ? GestureDetector(
                    onTap: (() {
    if(MyUtils.checkClick()) {
      setState(() {
        imgList.clear();
        imgList.add(allData2[i]['content']);
      });
      MyUtils.goTransparentPageCom(
          context, SwiperPage(imgList: imgList));
    }
                    }),
                    child: Image(
                      image: FileImage(File(allData2[i]['content'])),
                      width: 160.h,
                      height: 200.h,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return WidgetUtils.showImages(
                            'assets/images/img_error.png', 200.h, 160.h);
                      },
                    ),
                  ) : GestureDetector(
                    onTap: (() {
    if(MyUtils.checkClick()) {
      if (playRecord) {
        stopPlayer();
      } else {
        play(allData2[i]['content']);
      }
    }
                    }),
                    child: SizedBox(
                      width: widthAudio,
                      child: Row(
                        children: [
                          WidgetUtils.showImages('assets/images/chat_huatong.png', 20.h, 20.h),
                          WidgetUtils.commonSizedBox(0, 10.h),
                          WidgetUtils.onlyText("${allData2[i]['number']}''", StyleUtils.textStyleb1),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          WidgetUtils.commonSizedBox(
              ScreenUtil().setHeight(20), ScreenUtil().setHeight(10)),
        ],
      );
    } else {
      return Column(
        children: [
          //右侧显示
          WidgetUtils.onlyTextCenter(
              addTime,
              StyleUtils.getCommonTextStyle(
                  color: MyColors.g9, fontSize: ScreenUtil().setSp(20))),
          WidgetUtils.commonSizedBox(
              ScreenUtil().setHeight(10), ScreenUtil().setHeight(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(100)),
              Flexible(
                child: Container(
                  constraints:
                  BoxConstraints(minWidth: ScreenUtil().setHeight(60)),
                  padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 1), // 阴影的偏移量，向右下方偏移3像素
                      ),
                    ],
                  ),
                  child: allData2[i]['type'] == 1
                      ? Text(
                    allData2[i]['content'],
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: Colors.black,
                    ),
                  )
                      : allData2[i]['type'] == 2 ? GestureDetector(
                    onTap: (() {
    if(MyUtils.checkClick()) {
      setState(() {
        imgList.clear();
        imgList.add(allData2[i]['content']);
      });
      MyUtils.goTransparentPageCom(
          context, SwiperPage(imgList: imgList));
    }
                    }),
                    child: Image(
                      image: FileImage(File(allData2[i]['content'])),
                      width: 160.h,
                      height: 200.h,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return WidgetUtils.showImages(
                            'assets/images/img_error.png', 200.h, 160.h);
                      },
                    ),
                  ) : GestureDetector(
                    onTap: (() {
    if(MyUtils.checkClick()) {
      if (playRecord) {
        stopPlayer();
      } else {
        play(allData2[i]['content']);
      }
    }
                    }),
                    child: SizedBox(
                      width: widthAudio,
                      child: Row(
                        children: [
                          const Spacer(),
                          WidgetUtils.onlyText("${allData2[i]['number']}''", StyleUtils.textStyleb1),
                          WidgetUtils.showImages('assets/images/chat_huatong.png', 20.h, 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(10)),
              WidgetUtils.CircleImageAss(60.h,
                 60.h , 30.h, allData2[i]['otherHeadImg']),
            ],
          ),
          WidgetUtils.commonSizedBox(20.h, ScreenUtil().setHeight(10)),
        ],
      );
    }
  }


//播放录音
  void play(String audioUrls) {
    _mPlayer!
        .startPlayer(
        fromURI: audioUrls,
        whenFinished: () {
          setState(() {
            playRecord = false;
          });
        })
        .then((value) {
      setState(() {
        playRecord = true;
      });
    });
  }

//停止播放录音
  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {
        playRecord = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
    if(MyUtils.checkClick()) {
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
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    /// 头部展示
                    SizedBox(
                      height: ScreenUtil().setHeight(80),
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.showImages(
                              'assets/images/room_message_left.png',
                              ScreenUtil().setHeight(22),
                              ScreenUtil().setHeight(13)),
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.onlyText(
                              widget.nickName,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(28))),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
    if(MyUtils.checkClick()) {
      doPostFollow();
    }
                            }),
                            child: SizedBox(
                              width: ScreenUtil().setHeight(80),
                              height: ScreenUtil().setHeight(38),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImagesFill(
                                      'assets/images/room_shoucang.png',
                                      double.infinity,
                                      double.infinity),
                                  Container(
                                    width: ScreenUtil().setHeight(80),
                                    height: ScreenUtil().setHeight(38),
                                    alignment: Alignment.center,
                                    child: Text(
                                      isGZ == '0' ? '关注' : '取关',
                                      style: StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(21)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ),
                    ),
                    length != 0 ? Expanded(
                      child: Container(
                        height: double.infinity,
                        color: MyColors.roomMessageBlackBG,
                        child: ListView.builder(
                          padding:
                              EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                          itemBuilder: chatWidget,
                          itemCount: allData2.length,
                        ),
                      ),
                    ) : const Text('')
                  ],
                ),
                Container(
                  height: 122.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    //背景
                    color: MyColors.roomXZ1,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(child: Container(
                        height: 78.h,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 20.h, right: 20.h),
                        padding: EdgeInsets.only(left: 20.h, right: 20.h),
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.roomXZ2,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(38)),
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.send,
                          // 设置为发送按钮
                          controller: controller,
                          inputFormatters: [
                            RegexFormatter(
                                regex: MyUtils.regexFirstNotNull),
                            LengthLimitingTextInputFormatter(25)//限制输入长度
                          ],
                          style: StyleUtils.loginTextStyle,
                          onSubmitted: (value) {
                            MyUtils.sendMessage(widget.otherUid, value);
                            doPostSendUserMsg(value);
                          },
                          decoration: InputDecoration(
                            // border: InputBorder.none,
                            // labelText: "请输入用户名",
                            // icon: Icon(Icons.people), //前面的图标
                            hintText: '请输入信息...',
                            hintStyle: StyleUtils.loginHintTextStyle,

                            contentPadding:
                            const EdgeInsets.only(top: 0, bottom: 0),
                            border: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                          ),
                        ),
                      ),),
                      GestureDetector(
                        onTap: (() {
                            if(MyUtils.checkClick()){
                              doPostPayPwd();
                            }
                        }),
                        child: WidgetUtils.showImages(
                            'assets/images/chat_hongbao.png',
                            ScreenUtil().setHeight(45),
                            ScreenUtil().setHeight(45)),
                      ),
                      WidgetUtils.commonSizedBox(0, 20.h),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 获取本地数据信息
  Future<void> doLocationInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    // 展示聊天信息
    String combineID = '';
    if (int.parse(sp.getString('user_id').toString()) >
        int.parse(widget.otherUid)) {
      combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
    } else {
      combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
    }
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null, whereArgs: [combineID], where: 'combineID = ?');

    await db.update('messageSLTable',  {'readStatus': 1}, where: 'combineID = ?', whereArgs: [combineID]);

    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToLastItem(); // 在widget构建完成后滚动到底部
    });
  }
  /// 发送消息
  late List<Map<String, dynamic>> allData2;
  Future<void> doPostSendUserMsg(String content) async {
    if(content.trim().isEmpty){
      return;
    }

    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.otherUid,
      'type': '1',
      'content': content
    };
    try {
      CommonBean bean = await DataUtils.postSendUserMsg(params);
      String combineID = '';
      if (int.parse(sp.getString('user_id').toString()) >
          int.parse(widget.otherUid)) {
        combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
      } else {
        combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
      }
      switch (bean.code) {
        case MyHttpConfig.successCode:
          Map<String, dynamic> params = <String, dynamic>{
            'uid': sp.getString('user_id').toString(),
            'otherUid': widget.otherUid,
            'whoUid': sp.getString('user_id').toString(),
            'combineID': combineID,
            'nickName': widget.nickName,
            'content': content,
            'headImg': myHeadImg,
            'otherHeadImg': otherHeadImg,
            'add_time': DateTime.now().millisecondsSinceEpoch,
            'type': 1,
            'number': 0,
            'status': 1,
            'readStatus': 1,
            'liveStatus': 0,
            'loginStatus': 0,
          };
          // 插入数据
          await databaseHelper.insertData('messageSLTable', params);
          setState(() {
            controller.text = '';
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          Map<String, dynamic> params = <String, dynamic>{
            'uid': sp.getString('user_id').toString(),
            'otherUid': widget.otherUid,
            'whoUid': sp.getString('user_id').toString(),
            'combineID': combineID,
            'nickName': widget.nickName,
            'content': content,
            'headImg': myHeadImg,
            'otherHeadImg': otherHeadImg,
            'add_time': DateTime.now().millisecondsSinceEpoch,
            'type': 1,
            'number': 0,
            'status': 0,
            'readStatus': 1,
            'liveStatus': 0,
            'loginStatus': 0,
          };
          // 插入数据
          await databaseHelper.insertData('messageSLTable', params);
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      // 获取所有数据
      List<Map<String, dynamic>> result = await db.query('messageSLTable',
          columns: null, whereArgs: [combineID], where: 'combineID = ?');
      setState(() {
        allData2 = result;
        length = allData2.length;
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        scrollToLastItem(); // 在widget构建完成后滚动到底部
      });
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
  /// 查询关注状态
  Future<void> doPostUserFollowStatus() async {
    Map<String, dynamic> params = <String, dynamic>{
      'follow_id': widget.otherUid,
      'type': '1',
    };
    try {
      CommonStringBean bean = await DataUtils.postUserFollowStatus(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isGZ = bean.data!.status!;
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
  /// 关注还是取关
  Future<void> doPostFollow() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status': isGZ == '0' ? '1' : '0',
      'follow_id': widget.otherUid,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if(isGZ == '0'){
            setState(() {
              isGZ = '1';
            });
            MyToastUtils.showToastBottom("关注成功！");
          }else{
            setState(() {
              isGZ = '0';
            });
            MyToastUtils.showToastBottom("取关成功！");
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


  /// 是否设置了支付密码
  Future<void> doPostPayPwd() async {
    try {
      isPayBean bean = await DataUtils.postPayPwd();
      switch (bean.code) {
        case MyHttpConfig.successCode:
        //1已设置  0未设置
          if(bean.data!.isSet == 1){
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(
                context,
                HongBaoPage(
                  uid: widget.otherUid,
                ));
          }else{
            MyToastUtils.showToastBottom('请先设置支付密码！');
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(
                context,
                const PasswordPayPage());
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
