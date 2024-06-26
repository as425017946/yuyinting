import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/room/room_bg_page.dart';
import 'package:yuyinting/pages/room/room_black_page.dart';
import 'package:yuyinting/pages/room/room_data_page.dart';
import 'package:yuyinting/pages/room/room_gonggao_page.dart';
import 'package:yuyinting/pages/room/room_guanliyuan_page.dart';
import 'package:yuyinting/pages/room/room_jinyan_page.dart';
import 'package:yuyinting/pages/room/room_name.dart';
import 'package:yuyinting/pages/room/room_password_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import '../../bean/CommonMyIntBean.dart';
import '../../bean/Common_bean.dart';
import '../../bean/managerBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../cos/upload_httpclient.dart';

/// 房间管理
class RoomManagerPage extends StatefulWidget {
  int type;
  String roomID;

  RoomManagerPage({super.key, required this.type, required this.roomID});

  @override
  State<RoomManagerPage> createState() => _RoomManagerPageState();
}

class _RoomManagerPageState extends State<RoomManagerPage> {
  List<Data> list = [];

  // 厅头图片
  String ttImg = '';
  var listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostAdminList();
    setState(() {
      ttImg = sp.getString('roomImage').toString();
    });

    /// 腾讯云上传成功回调
    listen = eventBus.on<TencentBack>().listen((event) {
      if (event.title == '房间管理') {
        doPostRoomJoin(event.filePath);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  onTapPickFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('选择照片路径:${image?.path}');
    yasuo(image!.path);
    // doPostPostFileUpload(image!.path);
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
                if (MyUtils.checkClick()) {
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
          widget.type == 0
              ? Container(
                  height: ScreenUtil().setHeight(350),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image: AssetImage("assets/images/room_tc3.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(15, 0),
                      WidgetUtils.onlyTextCenter(
                          '房间管理',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(32))),
                      WidgetUtils.commonSizedBox(15, 0),
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.CircleImageNet(
                              ScreenUtil().setHeight(122),
                              ScreenUtil().setHeight(122),
                              15,
                              ttImg),
                          WidgetUtils.commonSizedBox(0, 15),
                          Expanded(
                            child: Column(
                              children: [
                                WidgetUtils.onlyText(
                                    sp.getString('roomName').toString(),
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ2,
                                        fontSize: ScreenUtil().setSp(30))),
                                WidgetUtils.commonSizedBox(20, 0),
                                Row(
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_id.png',
                                        ScreenUtil().setHeight(26),
                                        ScreenUtil().setHeight(18)),
                                    WidgetUtils.commonSizedBox(0, 2),
                                    WidgetUtils.onlyText(
                                        sp.getString('roomNumber').toString(),
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomTCWZ2,
                                            fontSize: ScreenUtil().setSp(25),
                                            fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    GestureDetector(
                                      onTap: (() {
                                        Clipboard.setData(ClipboardData(
                                          text: sp
                                              .getString('roomNumber')
                                              .toString(),
                                        ));
                                        MyToastUtils.showToastBottom(
                                            '已成功复制到剪切板');
                                      }),
                                      child: WidgetUtils.showImages(
                                          'assets/images/room_fuzhu.png',
                                          ScreenUtil().setHeight(18),
                                          ScreenUtil().setHeight(18)),
                                    ),
                                    WidgetUtils.commonSizedBox(0, 20),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      WidgetUtils.commonSizedBox(15, 0),
                      Opacity(
                        opacity: 0.2,
                        child: WidgetUtils.myLine(color: MyColors.g9),
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomGuanLiYuanPage(
                                  type: 0,
                                  roomID: widget.roomID,
                                ));
                          }
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              WidgetUtils.onlyText(
                                  '房间管理员',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25))),
                              const Expanded(child: Text('')),
                              list.isNotEmpty
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(60),
                                      ScreenUtil().setHeight(60),
                                      list[0].avatar!)
                                  : const Text(''),
                              WidgetUtils.commonSizedBox(0, 2),
                              list.length > 1
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(60),
                                      ScreenUtil().setHeight(60),
                                      list[1].avatar!)
                                  : const Text(''),
                              WidgetUtils.commonSizedBox(0, 2),
                              list.length > 2
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(60),
                                      ScreenUtil().setHeight(60),
                                      list[2].avatar!)
                                  : const Text(''),
                              WidgetUtils.commonSizedBox(0, 10),
                              Image(
                                image: const AssetImage(
                                    'assets/images/mine_more.png'),
                                width: ScreenUtil().setHeight(12),
                                height: ScreenUtil().setHeight(20),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                )
              : Container(
                  height: ScreenUtil().setHeight(1030),
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
                          '房间管理',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ2,
                              fontSize: ScreenUtil().setSp(32))),
                      WidgetUtils.commonSizedBox(15, 0),
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                onTapPickFromGallery();
                              }
                            }),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                WidgetUtils.CircleImageNet(
                                    ScreenUtil().setHeight(122),
                                    ScreenUtil().setHeight(122),
                                    15,
                                    sp.getString('roomImage').toString()),
                                Container(
                                  height: 30.h,
                                  width: 122.h,
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: Colors.black54,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                        bottomLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '编辑',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.white70, fontSize: 25.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 15),
                          Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      Navigator.pop(context);
                                      MyUtils.goTransparentPageCom(
                                          context, const RoomName());
                                    }
                                  }),
                                  child: Row(
                                    children: [
                                      WidgetUtils.onlyText(
                                          sp.getString('roomName').toString(),
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomTCWZ2,
                                              fontSize:
                                                  ScreenUtil().setSp(30))),
                                      WidgetUtils.commonSizedBox(0, 5.h),
                                      WidgetUtils.showImages(
                                          'assets/images/room_bianji.png',
                                          20.h,
                                          20.h)
                                    ],
                                  ),
                                ),
                                WidgetUtils.commonSizedBox(20, 0),
                                Row(
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/room_id.png',
                                        ScreenUtil().setHeight(26),
                                        ScreenUtil().setHeight(18)),
                                    WidgetUtils.commonSizedBox(0, 2),
                                    WidgetUtils.onlyText(
                                        sp.getString('roomNumber').toString(),
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomTCWZ2,
                                            fontSize: ScreenUtil().setSp(25),
                                            fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    GestureDetector(
                                      onTap: (() {
                                        Clipboard.setData(ClipboardData(
                                          text: sp
                                              .getString('roomNumber')
                                              .toString(),
                                        ));
                                        MyToastUtils.showToastBottom(
                                            '已成功复制到剪切板');
                                      }),
                                      child: WidgetUtils.showImages(
                                          'assets/images/room_fuzhu.png',
                                          ScreenUtil().setHeight(18),
                                          ScreenUtil().setHeight(18)),
                                    ),
                                    WidgetUtils.commonSizedBox(0, 20),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      WidgetUtils.commonSizedBox(15, 0),
                      Opacity(
                        opacity: 0.2,
                        child: WidgetUtils.myLine(
                            color: MyColors.g9, indent: 20, endIndent: 20),
                      ),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomGuanLiYuanPage(
                                  type: 1,
                                  roomID: widget.roomID,
                                ));
                          }
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              WidgetUtils.onlyText(
                                  '房间管理员',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25))),
                              const Expanded(child: Text('')),
                              list.isNotEmpty
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(60),
                                      ScreenUtil().setHeight(60),
                                      list[0].avatar!)
                                  : const Text(''),
                              WidgetUtils.commonSizedBox(0, 2),
                              list.length > 1
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(60),
                                      ScreenUtil().setHeight(60),
                                      list[1].avatar!)
                                  : const Text(''),
                              WidgetUtils.commonSizedBox(0, 2),
                              list.length > 2
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(60),
                                      ScreenUtil().setHeight(60),
                                      list[2].avatar!)
                                  : const Text(''),
                              WidgetUtils.commonSizedBox(0, 10),
                              Image(
                                image: const AssetImage(
                                    'assets/images/mine_more.png'),
                                width: ScreenUtil().setHeight(12),
                                height: ScreenUtil().setHeight(20),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.2,
                        child: WidgetUtils.myLine(
                            color: MyColors.g9, indent: 20, endIndent: 20),
                      ),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomGongGaoPage(
                                  roomID: widget.roomID,
                                ));
                            Navigator.pop(context);
                          }
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              WidgetUtils.onlyText(
                                  '房间公告',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25))),
                              const Expanded(child: Text('')),
                              Image(
                                image: const AssetImage(
                                    'assets/images/mine_more.png'),
                                width: ScreenUtil().setHeight(12),
                                height: ScreenUtil().setHeight(20),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.2,
                        child: WidgetUtils.myLine(
                            color: MyColors.g9, indent: 20, endIndent: 20),
                      ),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            MyUtils.goTransparentPage(
                                context, const RoomBGPage());
                          }
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              WidgetUtils.onlyText(
                                  '房间背景',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25))),
                              const Expanded(child: Text('')),
                              Image(
                                image: const AssetImage(
                                    'assets/images/mine_more.png'),
                                width: ScreenUtil().setHeight(12),
                                height: ScreenUtil().setHeight(20),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.2,
                        child: WidgetUtils.myLine(
                            color: MyColors.g9, indent: 20, endIndent: 20),
                      ),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            Navigator.pop(context);
                            MyUtils.goTransparentPage(
                                context,
                                RoomPasswordPage(
                                    type: 0, roomID: widget.roomID));
                          }
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              WidgetUtils.onlyText(
                                  '房间密码',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25))),
                              const Expanded(child: Text('')),
                              Image(
                                image: const AssetImage(
                                    'assets/images/mine_more.png'),
                                width: ScreenUtil().setHeight(12),
                                height: ScreenUtil().setHeight(20),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.2,
                        child: WidgetUtils.myLine(
                            color: MyColors.g9, indent: 20, endIndent: 20),
                      ),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomBlackPage(
                                  roomID: widget.roomID,
                                ));
                          }
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              WidgetUtils.onlyText(
                                  '房间黑名单',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25))),
                              const Expanded(child: Text('')),
                              Image(
                                image: const AssetImage(
                                    'assets/images/mine_more.png'),
                                width: ScreenUtil().setHeight(12),
                                height: ScreenUtil().setHeight(20),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.2,
                        child: WidgetUtils.myLine(
                            color: MyColors.g9, indent: 20, endIndent: 20),
                      ),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomJinYanPage(
                                  roomID: widget.roomID,
                                ));
                          }
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(80),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              WidgetUtils.onlyText(
                                  '禁言列表',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ2,
                                      fontSize: ScreenUtil().setSp(25))),
                              const Expanded(child: Text('')),
                              Image(
                                image: const AssetImage(
                                    'assets/images/mine_more.png'),
                                width: ScreenUtil().setHeight(12),
                                height: ScreenUtil().setHeight(20),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.2,
                        child: WidgetUtils.myLine(
                            color: MyColors.g9, indent: 20, endIndent: 20),
                      ),
                      (sp.getString('role').toString() == 'leader' ||
                              sp.getString('role').toString() == 'president')
                          ? GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick()) {
                                  MyUtils.goTransparentPage(
                                      context,
                                      RoomDataPage(
                                        roomID: widget.roomID,
                                      ));
                                }
                              }),
                              child: Container(
                                height: ScreenUtil().setHeight(80),
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 20),
                                    WidgetUtils.onlyText(
                                        '房间数据',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomTCWZ2,
                                            fontSize: ScreenUtil().setSp(25))),
                                    const Expanded(child: Text('')),
                                    Image(
                                      image: const AssetImage(
                                          'assets/images/mine_more.png'),
                                      width: ScreenUtil().setHeight(12),
                                      height: ScreenUtil().setHeight(20),
                                    ),
                                    WidgetUtils.commonSizedBox(0, 20),
                                  ],
                                ),
                              ),
                            )
                          : WidgetUtils.commonSizedBox(0, 0),
                      (sp.getString('role').toString() == 'leader' ||
                              sp.getString('role').toString() == 'president')
                          ? Opacity(
                              opacity: 0.2,
                              child: WidgetUtils.myLine(
                                  color: MyColors.g9,
                                  indent: 20,
                                  endIndent: 20),
                            )
                          : WidgetUtils.commonSizedBox(0, 0),
                    ],
                  ),
                )
        ],
      ),
    );
  }

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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 设置/取消管理员
  Future<void> doPostSetRoomAdmin(String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.roomID,
      'status': status,
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postSetRoomAdmin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("设置成功");

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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 上传房间缩略图
  Future<void> doPostPostFileUpload(path) async {
    var dir = await path_provider.getTemporaryDirectory();
    String targetPath = '';
    var result;
    if (path.toString().contains('.gif') || path.toString().contains('.GIF')) {
      targetPath = path;
    } else if (path.toString().contains('.jpg') ||
        path.toString().contains('.GPG')) {
      targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else if (path.toString().contains('.jpeg') ||
        path.toString().contains('.GPEG')) {
      targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else if (path.toString().contains('.svga') ||
        path.toString().contains('.SVGA')) {
      MyToastUtils.showToastBottom('不支持svga格式图片上传');
      return;
    } else if (path.toString().contains('.webp') ||
        path.toString().contains('.WEBP')) {
      targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.webp";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else {
      targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    }

    Loading.show("上传中...");
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formdata = FormData.fromMap(
      {
        'room_id': sp.getString('roomID').toString(),
        "cover_img": await MultipartFile.fromFile(
          path.toString().contains('.gif') || path.toString().contains('.GIF')
              ? targetPath
              : result!.path,
          filename: name,
        )
      },
    );
    BaseOptions option = BaseOptions(
        contentType: 'multipart/form-data', responseType: ResponseType.plain);
    option.headers["Authorization"] = sp.getString('user_token') ?? '';
    Dio dio = Dio(option);
    //application/json
    try {
      var respone = await dio.post(MyHttpConfig.editRoom, data: formdata);
      Map jsonResponse = json.decode(respone.data.toString());

      if (jsonResponse['code'] == 200) {
        sp.setString('roomImage', path);
        setState(() {
          ttImg = path;
        });
        eventBus.fire(RoomBack(title: '厅头修改', index: path));
        MyToastUtils.showToastBottom('上传成功');
        Loading.dismiss();
      } else if (jsonResponse['code'] == 401) {
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
      } else {
        MyToastUtils.showToastBottom(jsonResponse['msg']);
      }

      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitleFile);
    }
  }

  /// 上传房间缩略图
  Future<void> doPostPostFileUploadTX(String imgID) async {
    FormData formdata = FormData.fromMap(
      {'room_id': sp.getString('roomID').toString(), "img_id": imgID},
    );
    BaseOptions option = BaseOptions(
        contentType: 'multipart/form-data', responseType: ResponseType.plain);
    option.headers["Authorization"] = sp.getString('user_token') ?? '';
    Dio dio = Dio(option);
    //application/json
    try {
      var respone = await dio.post(MyHttpConfig.editRoom, data: formdata);
      Map jsonResponse = json.decode(respone.data.toString());
      LogE('上传厅头== $jsonResponse');
      if (jsonResponse['code'] == 200) {
        sp.setString('roomImage', sp.getString('local_path').toString());
        setState(() {
          ttImg = sp.getString('local_path').toString();
        });
        eventBus.fire(RoomBack(
            title: '厅头修改', index: sp.getString('local_path').toString()));
        MyToastUtils.showToastBottom('上传成功');
        Loading.dismiss();
      } else if (jsonResponse['code'] == 401) {
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
      } else {
        MyToastUtils.showToastBottom(jsonResponse['msg']);
      }

      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitleFile);
    }
  }

  /// 压缩图片
  void yasuo(String path) async {
    var dir = await path_provider.getTemporaryDirectory();
    String targetPath = '';
    var result;
    if (path.toString().contains('.gif') || path.toString().contains('.GIF')) {
      targetPath = path;
    } else if (path.toString().contains('.jpg') ||
        path.toString().contains('.GPG')) {
      targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else if (path.toString().contains('.jpeg') ||
        path.toString().contains('.GPEG')) {
      targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else if (path.toString().contains('.svga') ||
        path.toString().contains('.SVGA')) {
      MyToastUtils.showToastBottom('不支持svga格式图片上传');
      return;
    } else if (path.toString().contains('.webp') ||
        path.toString().contains('.WEBP')) {
      targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.webp";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else {
      targetPath =
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    }

    _upload(
        path.toString().contains('.gif') || path.toString().contains('.GIF')
            ? targetPath
            : result!.path,
        'image');
  }

  /// 上传  String? _pickFilePath;选择的文件路径
  void _upload(String pickFilePath, String type) async {
    sp.setString('local_path', pickFilePath);
    if (pickFilePath == null) {
      MyToastUtils.showToastBottom('请先选择需要上传的文件');
      return;
    }
    try {
      print("使用原生http client库上传");
      await UploadHttpClient.upload(
          pickFilePath!, type, '房间管理', (count, total) {});
    } catch (e) {
      LogE('上传失败${e.toString()}');
    }
  }

  /// 腾讯云id
  Future<void> doPostRoomJoin(String filePath) async {
    LogE('头像上传成功 $filePath');
    String fileType = '';
    if (filePath.contains('.gif') ||
        filePath.contains('.GIF') ||
        filePath.contains('.jpg') ||
        filePath.contains('.JPG') ||
        filePath.contains('.jpeg') ||
        filePath.contains('.GPEG') ||
        filePath.contains('.webp') ||
        filePath.contains('.WEBP') ||
        filePath.contains('.png') ||
        filePath.contains('.png')) {
      fileType = 'image';
    } else if (filePath.contains('.avi') ||
        filePath.contains('.AVI') ||
        filePath.contains('.wmv') ||
        filePath.contains('.WMV') ||
        filePath.contains('.mpeg') ||
        filePath.contains('.MPEG') ||
        filePath.contains('.mp4') ||
        filePath.contains('.MP4') ||
        filePath.contains('.m4v') ||
        filePath.contains('.M4V') ||
        filePath.contains('.mov') ||
        filePath.contains('.MOV') ||
        filePath.contains('.asf') ||
        filePath.contains('.ASF') ||
        filePath.contains('.flv') ||
        filePath.contains('.FLV') ||
        filePath.contains('.f4v') ||
        filePath.contains('.F4V') ||
        filePath.contains('.rmvb') ||
        filePath.contains('.RMVB') ||
        filePath.contains('.rm') ||
        filePath.contains('.RM') ||
        filePath.contains('.3gp') ||
        filePath.contains('.3GP') ||
        filePath.contains('.vob') ||
        filePath.contains('.VOB')) {
      fileType = 'video';
    } else if (filePath.contains('.mp3') ||
        filePath.contains('.MP3') ||
        filePath.contains('.wma') ||
        filePath.contains('.WMA') ||
        filePath.contains('.wav') ||
        filePath.contains('.WAV') ||
        filePath.contains('.flac') ||
        filePath.contains('.FLAC') ||
        filePath.contains('.ogg') ||
        filePath.contains('.OGG') ||
        filePath.contains('.aac') ||
        filePath.contains('.AAC') ||
        filePath.contains('.mp4') ||
        filePath.contains('.MP4')) {
      fileType = 'audio';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'file_type': fileType,
      'file_path': filePath,
    };
    try {
      CommonMyIntBean bean = await DataUtils.postTencentID(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostPostFileUploadTX(bean.data.toString());
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
