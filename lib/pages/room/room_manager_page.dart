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
import 'package:yuyinting/pages/room/room_gonggao_page.dart';
import 'package:yuyinting/pages/room/room_guanliyuan_page.dart';
import 'package:yuyinting/pages/room/room_jinyan_page.dart';
import 'package:yuyinting/pages/room/room_name.dart';
import 'package:yuyinting/pages/room/room_password_page.dart';
import '../../bean/Common_bean.dart';
import '../../bean/managerBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostAdminList();
  }

  onTapPickFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('选择照片路径:${image?.path}');

    doPostPostFileUpload(image!.path);
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
          widget.type == 0 ? Container(
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
                        sp.getString('roomImage').toString()),
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
                                onTap: ((){
                                  Clipboard.setData(ClipboardData(
                                    text: sp.getString('roomNumber').toString(),
                                  ));
                                  MyToastUtils.showToastBottom('已成功复制到剪切板');
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
                    child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.onlyText(
                        '房间管理员',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCWZ2,
                            fontSize: ScreenUtil().setSp(25))),
                    const Expanded(child: Text('')),
                    list.isNotEmpty ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), list[0].avatar!) : const Text(''),
                    WidgetUtils.commonSizedBox(0, 2),
                    list.length > 1 ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), list[1].avatar!): const Text(''),
                    WidgetUtils.commonSizedBox(0, 2),
                    list.length > 2 ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), list[2].avatar!): const Text(''),
                    WidgetUtils.commonSizedBox(0, 10),
                    Image(
                      image: const AssetImage('assets/images/mine_more.png'),
                      width: ScreenUtil().setHeight(12),
                      height: ScreenUtil().setHeight(20),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                )),
              ],
            ),
          )
              :
          Container(
            height: ScreenUtil().setHeight(950),
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
                      onTap: ((){
                        onTapPickFromGallery();
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
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '编辑',
                              style: StyleUtils.getCommonTextStyle(color: Colors.white70, fontSize: 25.sp),
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
                            onTap: ((){
                              Navigator.pop(context);
                              MyUtils.goTransparentPageCom(context, const RoomName());
                            }),
                            child: Row(
                              children: [
                                WidgetUtils.onlyText(
                                    sp.getString('roomName').toString(),
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ2,
                                        fontSize: ScreenUtil().setSp(30))),
                                WidgetUtils.commonSizedBox(0, 5.h),
                                WidgetUtils.showImages('assets/images/room_bianji.png', 20.h, 20.h)
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
                                onTap: ((){
                                  Clipboard.setData(ClipboardData(
                                    text: sp.getString('roomNumber').toString(),
                                  ));
                                  MyToastUtils.showToastBottom('已成功复制到剪切板');
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
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentPage(context, RoomGuanLiYuanPage(type: 1, roomID: widget.roomID,));
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.onlyText(
                            '房间管理员',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        list.isNotEmpty ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), list[0].avatar!) : const Text(''),
                        WidgetUtils.commonSizedBox(0, 2),
                        list.length > 1 ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), list[1].avatar!): const Text(''),
                        WidgetUtils.commonSizedBox(0, 2),
                        list.length > 2 ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(60), ScreenUtil().setHeight(60), list[2].avatar!): const Text(''),
                        WidgetUtils.commonSizedBox(0, 10),
                        Image(
                          image: const AssetImage('assets/images/mine_more.png'),
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
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentPage(context, RoomGongGaoPage(roomID: widget.roomID,));
                    Navigator.pop(context);
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
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
                          image: const AssetImage('assets/images/mine_more.png'),
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
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentPage(context, const RoomBGPage());
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
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
                          image: const AssetImage('assets/images/mine_more.png'),
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
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    Navigator.pop(context);
                    MyUtils.goTransparentPage(context, RoomPasswordPage(type: 0, roomID: widget.roomID));
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
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
                          image: const AssetImage('assets/images/mine_more.png'),
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
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentPage(context, RoomBlackPage(roomID: widget.roomID,));
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
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
                          image: const AssetImage('assets/images/mine_more.png'),
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
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentPage(context, RoomJinYanPage(roomID: widget.roomID,));
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(80),
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
                          image: const AssetImage('assets/images/mine_more.png'),
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
                  child: WidgetUtils.myLine(color: MyColors.g9, indent: 20, endIndent: 20),
                ),
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

  /// 上传房间缩略图
  Future<void> doPostPostFileUpload(path) async {
    var dir = await path_provider.getTemporaryDirectory();
    String targetPath = '';
    if(path.toString().contains('.gif') || path.toString().contains('.GIF')){
      targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.gif";
    }else{
      targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
    }
    var result = await FlutterImageCompress.compressAndGetFile(
      path, targetPath,
      quality: 50,
      rotate: 180,
    );
    Loading.show("上传中...");
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formdata = FormData.fromMap(
      {
        'room_id': sp.getString('roomID').toString(),
        "cover_img": await MultipartFile.fromFile(result!.path,
          filename: name,)
      },
    );
    BaseOptions option = BaseOptions(
        contentType: 'multipart/form-data', responseType: ResponseType.plain);
    option.headers["Authorization"] = sp.getString('user_token')??'';
    Dio dio = Dio(option);
    //application/json
    try {
      var respone = await dio.post(
          MyHttpConfig.editRoom,
          data: formdata);
      Map jsonResponse = json.decode(respone.data.toString());
      if (respone.statusCode == 200) {
        MyToastUtils.showToastBottom('上传成功');

        Loading.dismiss();
      }else if(respone.statusCode == 401){
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
      }else{
        MyToastUtils.showToastBottom(jsonResponse['msg']);
      }

      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }

  }

}
