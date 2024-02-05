import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/mine/my/edit_audio_page.dart';
import 'package:yuyinting/pages/mine/my/edit_photo_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/cityBean.dart';
import '../../../bean/userInfoBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/date_picker.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/regex_formatter.dart';
import '../../../utils/widget_utils.dart';
import 'edit_head_page.dart';

///个人资料编辑页面
class EditMyInfoPage extends StatefulWidget {
  const EditMyInfoPage({Key? key}) : super(key: key);

  @override
  State<EditMyInfoPage> createState() => _EditMyInfoPageState();
}

class _EditMyInfoPageState extends State<EditMyInfoPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerGexing = TextEditingController();
  var appBar, listen, listen2, listen3;
  List<File> imgArray = [];

  // //0-未知 1-男 2-女
  int sex = 0;

  // late List<String> list_sex = [];
  late List<String> listCity = [];
  List<String> list_p = [];
  List<String> list_pID = [];
  List<String> list_label = [];
  List<AssetEntity> lista = [];
  List<String> listaID= [];

  String headImg = '',
      headImgID = '',
      nickName = '',
      userNumber = '',
      voiceCardUrl = '',
      description = '',
      city = '',
      photo_id = '',
      constellation = '',
      birthday = '',
      voice_cardID = '';

  //保存之前信息，然后判断有无修改项
  String headImg2 = '',
      headImgID2 = '',
      nickName2 = '',
      voiceCardUrl2 = '',
      description2 = '',
      city2 = '',
      photo_id2 = '',
      constellation2 = '',
      birthday2 = '',
      voice_cardID2 = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // list_sex.add('男');
    // list_sex.add('女');
    doPostMyIfon();
    doPstGetCity();
    listen = eventBus.on<FileBack>().listen((event) {
      // 修改头像
      if (event.type == 0) {
        setState(() {
          headImg = event.info;
          headImgID = event.id;
        });
      } else if (event.type == 1) {
        // 修改声音名片
        setState(() {
          voice_cardID = event.id;
        });
      }
    });

    listen2 = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '标签选完') {
        setState(() {
          list_label = sp.getString('label_name').toString().split(',');
          list_label.removeAt(list_label.length - 1);
        });
      }else if(event.title == '编辑个人资料取消保存'){
        MyUtils.hideKeyboard(context);
        Navigator.pop(context);
      }
    });
    listen3 = eventBus.on<PhotoBack>().listen((event) {
      setState(() {
        if(lista.isEmpty){
          lista = event.selectAss!;
        }else{
          for(int i = 0; i < event.selectAss!.length; i++){
            lista.add(event.selectAss![i]);
          }
        }
        if(listaID.isEmpty){
          listaID = event.id.split(',');
        }else{
          List<String> listID = event.id.split(',');
          for(int i = 0; i < listID.length; i++){
            listaID.add(listID[i]);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listen2.cancel();
    listen3.cancel();
  }

  /// 离开编辑页
  Future<void> exitBianji(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: '是否保存本次修改？',
            enterTxt: '保存',
            callback: (res) {
              if(MyUtils.checkClick()) {
                doPostModifyUserInfo();
              }
            },
            content: '',
          );
        });
  }

  ///data设置数据源，selectData设置选中下标
  void _onClickItem(var data, var selectData) {
    Pickers.showSinglePicker(
      context,
      data: data,
      selectData: selectData,
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {
        print('longer >>> 返回数据下标：$position');
        print('longer >>> 返回数据：$p');
        print('longer >>> 返回数据类型：${p.runtimeType}');
        setState(() {
          city = p;
        });
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      list_p.removeAt(index);
      list_pID.removeAt(index);
      LogE('移除== $index');
    });
  }

  void _removeImage2(int index) {
    setState(() {
      lista.removeAt(index);
      listaID.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //标题居中
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: (() {
            photo_id = '';
            for (int i = 0; i < list_pID.length; i++) {
              if (photo_id.isNotEmpty) {
                photo_id = '$photo_id${list_pID[i]},';
              } else {
                photo_id = '${list_pID[i]},';
              }
            }
            for(int i = 0; i < listaID.length; i++){
              if (photo_id.isNotEmpty) {
                photo_id = '$photo_id${listaID[i]},';
              } else {
                photo_id = '${listaID[i]},';
              }
            }
            LogE('结果上传1 === $photo_id');
            if (headImg != headImg2 ||
                headImgID != headImgID2 ||
                nickName != nickName2 ||
                voiceCardUrl != voiceCardUrl2 ||
                description != description2 ||
                city != city2 ||
                photo_id != photo_id2 ||
                constellation != constellation2 ||
                birthday != birthday2 ||
                voice_cardID != voice_cardID2) {
              exitBianji(context);
            }else{
              Navigator.of(context).pop();
              MyUtils.hideKeyboard(context);
            }
          }),
        ),
        actions: [
          GestureDetector(
            onTap: (() {
              if(MyUtils.checkClick()) {
                doPostModifyUserInfo();
              }
            }),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 15),
              child: Text(
                '完成',
                style: StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
        title: Text(
          '编辑个人资料',
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
              fontSize: ScreenUtil().setSp(34),
              fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        //去掉Appbar底部阴影
        //背景颜色
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          photo_id = '';
          for (int i = 0; i < list_pID.length; i++) {
            if (photo_id.isNotEmpty) {
              photo_id = '$photo_id${list_pID[i]},';
            } else {
              photo_id = '${list_pID[i]},';
            }
          }
          for(int i = 0; i < listaID.length; i++){
            if (photo_id.isNotEmpty) {
              photo_id = '$photo_id${listaID[i]},';
            } else {
              photo_id = '${listaID[i]},';
            }
          }
          LogE('结果上传2 === $photo_id');
          //这里可以响应物理返回键
          if (headImg != headImg2 ||
              headImgID != headImgID2 ||
              nickName != nickName2 ||
              voiceCardUrl != voiceCardUrl2 ||
              description != description2 ||
              city != city2 ||
              photo_id != photo_id2 ||
              constellation != constellation2 ||
              birthday != birthday2 ||
              voice_cardID != voice_cardID2) {
            exitBianji(context);
          }else{
            Navigator.of(context).pop();
            MyUtils.hideKeyboard(context);
          }
          return true;
        },
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20, 0),

                /// 头像
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      Future.delayed(const Duration(seconds: 0), () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return const EditHeadPage();
                            }));
                      });
                    }
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(110),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '头像',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                        const Expanded(child: Text('')),
                        WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(90),
                            ScreenUtil().setHeight(90), headImg),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.showImages('assets/images/mine_more2.png',
                            ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                      ],
                    ),
                  ),
                ),
                WidgetUtils.myLine(indent: 20, endIndent: 20),

                /// 昵称
                Container(
                  height: ScreenUtil().setHeight(100),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      WidgetUtils.onlyText(
                          '昵称',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28))),
                      SizedBox(
                        height: ScreenUtil().setHeight(60),
                        child: TextField(
                          controller: controller,
                          inputFormatters: [
                            RegexFormatter(regex: MyUtils.regexFirstNotNull),
                            LengthLimitingTextInputFormatter(8) //限制输入长度
                          ],
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g3, fontSize: ScreenUtil().setSp(25)),
                          onChanged: (value) {
                            setState(() {
                              nickName = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: '请输入昵称',
                            hintStyle: StyleUtils.getCommonTextStyle(
                                color: MyColors.g9, fontSize: ScreenUtil().setSp(25)),

                            contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
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
                      )
                    ],
                  ),
                ),
                WidgetUtils.myLine(indent: 20, endIndent: 20),

                /// 性别
                Container(
                  height: ScreenUtil().setHeight(80),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      WidgetUtils.onlyText(
                          '性别',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28))),
                      const Expanded(child: Text('')),
                      WidgetUtils.onlyText(
                          sex == 0
                              ? '未知'
                              : sex == 1
                                  ? '男'
                                  : '女',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(28))),
                      WidgetUtils.commonSizedBox(0, 10),
                      Opacity(
                        opacity: 0,
                        child: WidgetUtils.showImages(
                            'assets/images/mine_more2.png',
                            ScreenUtil().setHeight(27),
                            ScreenUtil().setHeight(16)),
                      )
                    ],
                  ),
                ),
                WidgetUtils.myLine(indent: 20, endIndent: 20),

                /// 个性签名
                Container(
                  height: ScreenUtil().setHeight(100),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      WidgetUtils.onlyText(
                          '个性签名',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28))),
                      SizedBox(
                        height: ScreenUtil().setHeight(60),
                        child: TextField(
                          controller: controllerGexing,
                          inputFormatters: [
                            RegexFormatter(regex: MyUtils.regexFirstNotNull),
                            LengthLimitingTextInputFormatter(16) //限制输入长度
                          ],
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g3, fontSize: ScreenUtil().setSp(25)),
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: '输入签名，展示你的独特个性吧',
                            hintStyle: StyleUtils.getCommonTextStyle(
                                color: MyColors.g9, fontSize: ScreenUtil().setSp(25)),

                            contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
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
                      )
                    ],
                  ),
                ),
                WidgetUtils.myLine(indent: 20, endIndent: 20),

                /// 生日
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      DateTime now = DateTime.now();
                      int year = now.year;
                      int month = now.month;
                      int day = now.day;
                      DatePicker.show(
                        context,
                        startDate: DateTime(1970, 1, 1),
                        selectedDate: DateTime(year, month, day),
                        endDate: DateTime(2024, 12, 31),
                        onSelected: (date) {
                          setState(() {
                            birthday = date.toString().substring(0, 10);
                          });
                        },
                      );
                    }
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(100),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            const Expanded(child: Text('')),
                            WidgetUtils.onlyText(
                                '生日',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(28))),
                            WidgetUtils.commonSizedBox(10, 0),
                            WidgetUtils.onlyText(
                                birthday == '0' ? '未填写' : birthday,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.g6,
                                    fontSize: ScreenUtil().setSp(28))),
                          ],
                        )),
                        WidgetUtils.showImages('assets/images/mine_more2.png',
                            ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                      ],
                    ),
                  ),
                ),
                WidgetUtils.myLine(indent: 20, endIndent: 20),

                // /// 声音名片
                // GestureDetector(
                //   onTap: (() {
                //     if (MyUtils.checkClick()) {
                //       MyUtils.goTransparentPageCom(
                //           context, EditAudioPage(audioUrl: voiceCardUrl));
                //     }
                //   }),
                //   child: Container(
                //     height: ScreenUtil().setHeight(100),
                //     alignment: Alignment.center,
                //     padding: const EdgeInsets.only(left: 20, right: 20),
                //     child: Row(
                //       children: [
                //         WidgetUtils.onlyText(
                //             '声音名片',
                //             StyleUtils.getCommonTextStyle(
                //                 color: Colors.black,
                //                 fontSize: ScreenUtil().setSp(28))),
                //         const Expanded(child: Text('')),
                //         WidgetUtils.showImages('assets/images/mine_more2.png',
                //             ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                //       ],
                //     ),
                //   ),
                // ),
                // WidgetUtils.myLine(indent: 20, endIndent: 20),

                /// 所在城市
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      _onClickItem(listCity, '未知');
                    }
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(100),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '所在城市',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28))),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText(
                            city.isEmpty ? '未知' : city,
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g6,
                                fontSize: ScreenUtil().setSp(28))),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.showImages('assets/images/mine_more2.png',
                            ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                      ],
                    ),
                  ),
                ),
                WidgetUtils.myLine(thickness: 10),

                /// 我的标签
                // GestureDetector(
                //   onTap: (() {
                //     if (MyUtils.checkClick()) {
                //       Future.delayed(const Duration(seconds: 0), () {
                //         Navigator.of(context).push(PageRouteBuilder(
                //             opaque: false,
                //             pageBuilder: (context, animation, secondaryAnimation) {
                //               return const EditBiaoqianPage();
                //             }));
                //       });
                //     }
                //   }),
                //   child: Container(
                //     constraints: BoxConstraints(
                //       minHeight: ScreenUtil().setHeight(120),
                //     ),
                //     alignment: Alignment.center,
                //     padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                //     child: Column(
                //       children: [
                //         WidgetUtils.commonSizedBox(10, 0),
                //         Row(
                //           children: [
                //             WidgetUtils.onlyText(
                //                 '我的标签',
                //                 StyleUtils.getCommonTextStyle(
                //                     color: Colors.black,
                //                     fontSize: ScreenUtil().setSp(28),
                //                     fontWeight: FontWeight.w600)),
                //             const Expanded(child: Text('')),
                //             WidgetUtils.showImages(
                //                 'assets/images/mine_more2.png',
                //                 ScreenUtil().setHeight(27),
                //                 ScreenUtil().setHeight(16))
                //           ],
                //         ),
                //         WidgetUtils.commonSizedBox(10, 0),
                //         Container(
                //           alignment: Alignment.centerLeft,
                //           child: Wrap(
                //             alignment: WrapAlignment.start,
                //             spacing: ScreenUtil().setHeight(15),
                //             runSpacing: ScreenUtil().setHeight(15),
                //             children: List.generate(
                //                 list_label.length,
                //                 (index) => WidgetUtils.myContainerZishiying(
                //                     MyColors.careBlue,
                //                     list_label[index],
                //                     StyleUtils.getCommonTextStyle(
                //                         color: Colors.white,
                //                         fontSize: ScreenUtil().setSp(26)))),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // WidgetUtils.myLine(thickness: 10),

                /// 照片墙
                Container(
                  height: ScreenUtil().setHeight(220),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(10, 0),
                      WidgetUtils.onlyText(
                          '照片墙',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600)),
                      WidgetUtils.commonSizedBox(10, 0),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10.h,
                          children: [
                            for (int i = 0; i < list_p.length; i++)
                              SizedBox(
                                height: 150.h,
                                width: 190.w,
                                child: Stack(
                                  children: [
                                    WidgetUtils.CircleImageNet(
                                        150.h,
                                        190.w,
                                        ScreenUtil().setHeight(20),
                                        list_p[i]),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (MyUtils.checkClick()) {
                                            setState(() {
                                              _removeImage(i);
                                            });
                                          }
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.white.withOpacity(0.7),
                                            width: 20,
                                            height: 20,
                                            child: const Icon(
                                              Icons.close,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            for (int i = 0; i < lista.length; i++)
                              Stack(
                                children: [
                                  Container(
                                    height: 150.h,
                                    width: 190.w,
                                    //超出部分，可裁剪
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setHeight(20)),
                                    ),
                                    child: AssetEntityImage(
                                      lista[i],
                                      width: ScreenUtil().setHeight(120),
                                      height: ScreenUtil().setHeight(120),
                                      fit: BoxFit.cover,
                                      isOriginal: false,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (MyUtils.checkClick()) {
                                          setState(() {
                                            _removeImage2(i);
                                          });
                                        }
                                      },
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.white.withOpacity(0.7),
                                          width: 20,
                                          height: 20,
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            list_p.length + lista.length < 3
                                ? GestureDetector(
                                    onTap: (() {
                                      if (MyUtils.checkClick()) {
                                        Future.delayed(const Duration(seconds: 0),
                                            () {
                                          Navigator.of(context).push(
                                              PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder: (context, animation,
                                                      secondaryAnimation) {
                                                    return EditPhotoPage(
                                                      length: 3 -
                                                          list_p.length -
                                                          lista.length,
                                                    );
                                                  }));
                                        });
                                      }
                                    }),
                                    child: WidgetUtils.showImages(
                                        'assets/images/images_add.png',
                                        150.h,
                                        190.w),
                                  )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 我的详情
  Future<void> doPostMyIfon() async {
    Loading.show(MyConfig.successTitle);
    LogE('用户id${sp.getString('user_id')}');
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id')
    };
    try {
      userInfoBean bean = await DataUtils.postUserInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list_p.clear();
          setState(() {
            sp.setString("user_headimg", bean.data!.avatarUrl!);
            sp.setString("label_id", bean.data!.labelId!);
            headImg = bean.data!.avatarUrl!;
            headImgID = bean.data!.avatar.toString();
            headImg2 = bean.data!.avatarUrl!;
            headImgID2 = bean.data!.avatar.toString();
            sex = bean.data!.gender as int;
            nickName = bean.data!.nickname!;
            nickName2 = bean.data!.nickname!;
            userNumber = bean.data!.number.toString();
            voiceCardUrl = bean.data!.voiceCardUrl!;
            voiceCardUrl2 = bean.data!.voiceCardUrl!;
            birthday = bean.data!.birthday!;
            birthday2 = bean.data!.birthday!;
            description = bean.data!.description!;
            description2 = bean.data!.description!;
            controller.text = nickName;
            controllerGexing.text = description;
            city = bean.data!.city!;
            city2 = bean.data!.city!;
            voice_cardID = bean.data!.voiceCard.toString();
            voice_cardID2 = bean.data!.voiceCard.toString();
            if (bean.data!.label!.isNotEmpty) {
              list_label = bean.data!.label!.split(',');
            }
            if (bean.data!.photoId!.isNotEmpty) {
              photo_id2 = bean.data!.photoId!;
              List<String> listPid = bean.data!.photoId!.split(',');
              for(int i = 0; i < listPid.length; i++){
                if(listPid[i].isNotEmpty){
                  list_pID.add(listPid[i]);
                }
              }
              if (bean.data!.photoUrl!.length > 3) {
                list_p.add(bean.data!.photoUrl![0]);
                list_p.add(bean.data!.photoUrl![1]);
                list_p.add(bean.data!.photoUrl![2]);
              } else {
                list_p = bean.data!.photoUrl!;
              }
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

  /// 获取城市
  Future<void> doPstGetCity() async {
    try {
      cityBean bean = await DataUtils.postGetCity();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          listCity.clear();
          setState(() {
            listCity = bean.data!;
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

  /// 修改个人资料
  Future<void> doPostModifyUserInfo() async {

    photo_id = '';
    for (int i = 0; i < list_pID.length; i++) {
      if (photo_id.isNotEmpty && list_pID[i].isNotEmpty) {
        photo_id = '$photo_id${list_pID[i]},';
      } else if (photo_id.isEmpty){
        photo_id = '${list_pID[i]},';
      }
    }
    for(int i = 0; i < listaID.length; i++){
      if (photo_id.isNotEmpty && listaID[i].isNotEmpty) {
        photo_id = '$photo_id${listaID[i]},';
      } else if (photo_id.isEmpty){
        photo_id = '${listaID[i]},';
      }
    }
    LogE('结果上传 === $photo_id');
    if (controller.text.trim().isEmpty) {
      MyToastUtils.showToastBottom('昵称不为空');
      return;
    }

    if (controller.text.trim().toString().contains('维C客服')) {
      MyToastUtils.showToastBottom('昵称不合法');
      return;
    }

    Loading.show('提交中...');
    Map<String, dynamic> params = <String, dynamic>{
      'avatar': headImgID,
      'nickname': controller.text.trim(),
      'description': controllerGexing.text.trim(),
      'birthday': birthday,
      'voice_card': voice_cardID,
      'city': city,
      'label_id': sp.getString('label_id'),
      'photo_id': photo_id
    };
    try {
      CommonBean bean = await DataUtils.postModifyUserInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (headImg != headImg2 ||
              headImgID != headImgID2 ||
              nickName != nickName2 ||
              description != description2 ||
              photo_id != photo_id2 ) {
            MyToastUtils.showToastBottom('资料提交成功，请耐心等待审核');
          }else{
            MyToastUtils.showToastBottom('资料更新成功');
          }
          Navigator.pop(context);
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
