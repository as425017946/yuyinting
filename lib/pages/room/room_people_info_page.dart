import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/room/room_liwu_page.dart';
import 'package:yuyinting/pages/room/room_messages_more_page.dart';
import 'package:yuyinting/pages/room/room_send_info_page.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../bean/Common_bean.dart';
import '../../bean/roomInfoBean.dart';
import '../../bean/roomInfoUserManagerBean.dart';
import '../../bean/roomUserInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/SVGASimpleImage.dart';
import '../message/geren/people_info_page.dart';
import '../mine/my/my_info_page.dart';

/// 厅内人员信息详情
class RoomPeopleInfoPage extends StatefulWidget {
  String uid;
  String index;
  String roomID;
  String isClose;
  List<MikeList> listM;

  RoomPeopleInfoPage(
      {super.key,
      required this.uid,
      required this.index,
      required this.roomID,
      required this.isClose,
      required this.listM});

  @override
  State<RoomPeopleInfoPage> createState() => _RoomPeopleInfoPageState();
}

class _RoomPeopleInfoPageState extends State<RoomPeopleInfoPage> {
  // 显示隐藏 禁言拉黑使用
  bool jinyan = false;

  //显示隐藏设置为管理使用
  bool ren = false;
  int sex = 0;
  String userNumber = '',
      headImg = '',
      nickName = '',
      city = '',
      description = '',
      status = '0',
      is_admin = '0',
      is_forbation = '',
      is_black = '',
      avatarFrameImg = '',
      avatarFrameGifImg = '';
  List<String> list_p = [];
  String zhuangtai = '闭麦';
  bool isMai = false; //判断麦上有没有这个人

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRoomUserInfo();
    doPostRoomUserInfoManager();
    LogE('身份 === ${sp.getString('role').toString()}');
    if (widget.isClose == '0') {
      zhuangtai = '闭麦';
    } else {
      zhuangtai = '开麦';
    }
    // 用于判断麦上有没有点击的这个人
    for (int i = 0; i < widget.listM.length; i++) {
      if (widget.uid == widget.listM[i].uid.toString()) {
        setState(() {
          isMai = true;
        });
        break;
      }
    }
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
          SizedBox(
            height: sp.getString('role').toString() == 'user'
                ? ScreenUtil().setHeight(450)
                : ScreenUtil().setHeight(530),
            width: double.infinity,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: sp.getString('role').toString() == 'user'
                      ? ScreenUtil().setHeight(390)
                      : ScreenUtil().setHeight(470),
                  width: double.infinity,
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image: AssetImage("assets/images/room_tc2.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(10, 0),

                      /// @某人
                      sp.getString('role').toString() == 'leader'
                          ? Row(
                              children: [
                                WidgetUtils.commonSizedBox(0, 20),
                                GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      MyUtils.goTransparentPage(
                                          context,
                                          RoomSendInfoPage(
                                            info: nickName,
                                          ));
                                      Navigator.pop(context);
                                    }
                                  }),
                                  child: WidgetUtils.showImages(
                                      'assets/images/room_@ta.png',
                                      ScreenUtil().setHeight(22),
                                      ScreenUtil().setHeight(48)),
                                ),
                                const Expanded(child: Text('')),
                                GestureDetector(
                                  onTap: (() {
                                    setState(() {
                                      ren = !ren;
                                      jinyan = false;
                                    });
                                  }),
                                  child: WidgetUtils.showImages(
                                      'assets/images/room_head.png',
                                      ScreenUtil().setHeight(33),
                                      ScreenUtil().setHeight(33)),
                                ),
                                WidgetUtils.commonSizedBox(0, 20),
                                GestureDetector(
                                  onTap: (() {
                                    setState(() {
                                      jinyan = !jinyan;
                                      ren = false;
                                    });
                                  }),
                                  child: WidgetUtils.showImages(
                                      'assets/images/room_setting.png',
                                      ScreenUtil().setHeight(33),
                                      ScreenUtil().setHeight(33)),
                                ),
                                WidgetUtils.commonSizedBox(0, 20),
                              ],
                            )
                          : sp.getString('role').toString() == 'adminer'
                              ? Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 20),
                                    GestureDetector(
                                      onTap: (() {
                                        if (MyUtils.checkClick()) {
                                          MyUtils.goTransparentPage(
                                              context,
                                              RoomSendInfoPage(
                                                info: nickName,
                                              ));
                                          Navigator.pop(context);
                                        }
                                      }),
                                      child: WidgetUtils.showImages(
                                          'assets/images/room_@ta.png',
                                          ScreenUtil().setHeight(22),
                                          ScreenUtil().setHeight(48)),
                                    ),
                                    const Expanded(child: Text('')),
                                    WidgetUtils.commonSizedBox(0, 20),
                                    GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          jinyan = !jinyan;
                                        });
                                      }),
                                      child: WidgetUtils.showImages(
                                          'assets/images/room_setting.png',
                                          ScreenUtil().setHeight(33),
                                          ScreenUtil().setHeight(33)),
                                    ),
                                    WidgetUtils.commonSizedBox(0, 20),
                                  ],
                                )
                              : Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 20),
                                    GestureDetector(
                                      onTap: (() {
                                        if (MyUtils.checkClick()) {
                                          MyUtils.goTransparentPage(
                                              context,
                                              RoomSendInfoPage(
                                                info: nickName,
                                              ));
                                          Navigator.pop(context);
                                        }
                                      }),
                                      child: WidgetUtils.showImages(
                                          'assets/images/room_@ta.png',
                                          ScreenUtil().setHeight(22),
                                          ScreenUtil().setHeight(48)),
                                    ),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                      const Spacer(),
                      const Spacer(),

                      /// 昵称 性别
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.onlyText(
                              nickName.length > 12
                                  ? '${nickName.substring(0, 12)}...'
                                  : nickName,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(32),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.showImages(
                              sex == 1
                                  ? 'assets/images/room_nan.png'
                                  : 'assets/images/room_nv.png',
                              ScreenUtil().setHeight(31),
                              ScreenUtil().setHeight(29)),
                          WidgetUtils.commonSizedBox(0, 5),
                          isNew == 1
                              ? WidgetUtils.showImages(
                              'assets/images/dj/room_role_common.png',
                              30.h,
                              50.h)
                              : const Text(''),
                          isNew == 1 ? WidgetUtils.commonSizedBox(0, 5): WidgetUtils.commonSizedBox(0, 0),
                          isPretty == 1
                              ? WidgetUtils.showImages(
                              'assets/images/dj/lianghao.png', 30.h, 30.h)
                              : const Text(''),
                          isPretty == 1 ? WidgetUtils.commonSizedBox(0, 5) : WidgetUtils.commonSizedBox(0, 0),
                          // 用户等级
                          level != 0
                              ? Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    WidgetUtils.showImagesFill(
                                        (level >= 1 && level <= 10)
                                            ? 'assets/images/dj/dj_c_1-10.png'
                                            : (level >= 11 && level <= 15)
                                                ? 'assets/images/dj/dj_c_11-15.png'
                                                : (level >= 16 && level <= 20)
                                                    ? 'assets/images/dj/dj_c_16-20.png'
                                                    : (level >= 21 &&
                                                            level <= 25)
                                                        ? 'assets/images/dj/dj_c_21-25.png'
                                                        : (level >= 26 &&
                                                                level <= 30)
                                                            ? 'assets/images/dj/dj_c_26-30.png'
                                                            : (level >= 31 &&
                                                                    level <= 35)
                                                                ? 'assets/images/dj/dj_c_31-35.png'
                                                                : (level >= 36 &&
                                                                        level <=
                                                                            40)
                                                                    ? 'assets/images/dj/dj_c_36-40.png'
                                                                    : (level >= 41 &&
                                                                            level <=
                                                                                45)
                                                                        ? 'assets/images/dj/dj_c_41-45.png'
                                                                        : 'assets/images/dj/dj_c_46-50.png',
                                        ScreenUtil().setHeight(30),
                                        ScreenUtil().setHeight(85)),
                                    Positioned(
                                        left: 45.w,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Text(
                                              'LV.${level.toString()}',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(18),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'ARIAL',
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 2
                                                    ..color = (level >= 1 &&
                                                            level <= 10)
                                                        ? MyColors.djOneM
                                                        : (level >= 11 &&
                                                                level <= 15)
                                                            ? MyColors.djTwoM
                                                            : (level >= 16 &&
                                                                    level <= 20)
                                                                ? MyColors
                                                                    .djThreeM
                                                                : (level >= 21 &&
                                                                        level <=
                                                                            25)
                                                                    ? MyColors
                                                                        .djFourM
                                                                    : (level >= 26 &&
                                                                            level <=
                                                                                30)
                                                                        ? MyColors
                                                                            .djFiveM
                                                                        : (level >= 31 &&
                                                                                level <= 35)
                                                                            ? MyColors.djSixM
                                                                            : (level >= 36 && level <= 40)
                                                                                ? MyColors.djSevenM
                                                                                : (level >= 41 && level <= 45)
                                                                                    ? MyColors.djEightM
                                                                                    : MyColors.djNineM),
                                            ),
                                            Text(
                                              'LV.${level.toString()}',
                                              style: TextStyle(
                                                  color: MyColors.djOne,
                                                  fontSize:
                                                      ScreenUtil().setSp(18),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'ARIAL'),
                                            ),
                                          ],
                                        ))
                                  ],
                                )
                              : const Text(''),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 0),

                      /// id 地区
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.showImages(
                              'assets/images/room_id.png',
                              ScreenUtil().setHeight(26),
                              ScreenUtil().setHeight(18)),
                          WidgetUtils.commonSizedBox(0, 2),
                          WidgetUtils.onlyText(
                              userNumber,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(25),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(0, 5),
                          GestureDetector(
                              onTap: (() {
                                Clipboard.setData(ClipboardData(
                                  text: userNumber,
                                ));
                                MyToastUtils.showToastBottom('已成功复制到剪切板');
                              }),
                              child: WidgetUtils.showImages(
                                  'assets/images/room_fuzhu.png',
                                  ScreenUtil().setHeight(18),
                                  ScreenUtil().setHeight(18))),
                          WidgetUtils.commonSizedBox(0, 20),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.onlyText(
                              city,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(25))),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 0),

                      /// 个性签名
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.showImages(
                              'assets/images/room_cc.png',
                              ScreenUtil().setHeight(26),
                              ScreenUtil().setHeight(21)),
                          WidgetUtils.commonSizedBox(0, 2),
                          WidgetUtils.onlyText(
                              description,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ3,
                                  fontSize: ScreenUtil().setSp(24))),
                        ],
                      ),
                      description.isNotEmpty
                          ? WidgetUtils.commonSizedBox(30, 0)
                          : const Text(''),

                      /// 上麦下麦
                      isMai
                          ? (sp.getString('role').toString() == 'leader' ||
                                  sp.getString('role').toString() == 'adminer')
                              ? Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 20),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Opacity(
                                          opacity: 0.6,
                                          child: Row(
                                            children: [
                                              Container(
                                                height:
                                                    ScreenUtil().setHeight(60),
                                                width:
                                                    ScreenUtil().setHeight(110),
                                                //边框设置
                                                decoration: const BoxDecoration(
                                                  //背景
                                                  color: MyColors.roomMaiLiao2,
                                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              30.0)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (() {
                                            if (MyUtils.checkClick()) {
                                              Navigator.pop(context);
                                              eventBus.fire(RoomBack(
                                                  title: '下麦',
                                                  index:
                                                      '${widget.index};${widget.uid}'));
                                            }
                                          }),
                                          child: WidgetUtils.onlyTextCenter(
                                              '下麦',
                                              StyleUtils.getCommonTextStyle(
                                                  color: MyColors.roomTCWZ1,
                                                  fontSize:
                                                      ScreenUtil().setSp(24))),
                                        ),
                                      ],
                                    ),
                                    const Expanded(child: Text('')),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Opacity(
                                          opacity: 0.6,
                                          child: Row(
                                            children: [
                                              Container(
                                                height:
                                                    ScreenUtil().setHeight(60),
                                                width:
                                                    ScreenUtil().setHeight(110),
                                                //边框设置
                                                decoration: const BoxDecoration(
                                                  //背景
                                                  color: MyColors.roomMaiLiao2,
                                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              30.0)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (() {
                                            if (MyUtils.checkClick()) {
                                              doPostSetClose(widget.index);
                                            }
                                          }),
                                          child: WidgetUtils.onlyTextCenter(
                                              zhuangtai,
                                              StyleUtils.getCommonTextStyle(
                                                  color: MyColors.roomTCWZ1,
                                                  fontSize:
                                                      ScreenUtil().setSp(24))),
                                        ),
                                      ],
                                    ),
                                    WidgetUtils.commonSizedBox(0, 20),
                                  ],
                                )
                              : const Text('')
                          : const Text(''),

                      const Expanded(child: Text('')),

                      /// 关注送礼
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                doPostFollow();
                              }
                            }),
                            child: WidgetUtils.onlyTextCenter(
                                status == '0' ? '关注' : '已关注',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCYellow,
                                    fontSize: ScreenUtil().setSp(28))),
                          )),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          Expanded(
                              child: GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                Navigator.pop(context);
                                MyUtils.goTransparentPage(
                                    context,
                                    RoomLiWuPage(
                                      listM: widget.listM,
                                      uid: widget.uid,
                                    ));
                              }
                            }),
                            child: WidgetUtils.onlyTextCenter(
                                '送礼物',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWhitw,
                                    fontSize: ScreenUtil().setSp(28))),
                          )),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          Expanded(
                              child: GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                doPostCanSendUser();
                              }
                            }),
                            child: WidgetUtils.onlyTextCenter(
                                '私聊',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWhitw,
                                    fontSize: ScreenUtil().setSp(28))),
                          )),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                /// 禁言使用
                jinyan
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Opacity(
                          opacity: 0.55,
                          child: Container(
                            height: ScreenUtil().setHeight(104),
                            width: ScreenUtil().setHeight(117),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.roomTCBlack,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
                jinyan
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Container(
                          height: ScreenUtil().setHeight(104),
                          width: ScreenUtil().setHeight(117),
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: (() {
                                  if (MyUtils.checkClick()) {
                                    if (is_forbation == '1') {
                                      doPostSetRoomForbation('0');
                                    } else {
                                      doPostSetRoomForbation('1');
                                    }
                                  }
                                }),
                                child: WidgetUtils.onlyTextCenter(
                                    is_forbation == '0' ? '禁言' : '解除禁言',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ1,
                                        fontSize: ScreenUtil().setSp(21))),
                              )),
                              Container(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(1),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setHeight(10)),
                                color: MyColors.roomTCWZ1,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                onTap: (() {
                                  Navigator.pop(context);
                                  if (MyUtils.checkClick()) {
                                    if (is_black == '1') {
                                      doPostSetRoomBlack('0');
                                    } else {
                                      doPostSetRoomBlack('1');
                                    }
                                  }
                                }),
                                child: WidgetUtils.onlyTextCenter(
                                    is_black == '0' ? '拉黑' : '解除拉黑',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ1,
                                        fontSize: ScreenUtil().setSp(21))),
                              )),
                            ],
                          ),
                        ),
                      )
                    : const Text(''),

                /// 人员设置使用
                ren
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Opacity(
                          opacity: 0.55,
                          child: Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setHeight(142),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.roomTCBlack,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
                ren
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Container(
                          height: ScreenUtil().setHeight(50),
                          width: ScreenUtil().setHeight(142),
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                if (is_admin == '1') {
                                  doPostSetRoomAdmin('0');
                                } else {
                                  doPostSetRoomAdmin('1');
                                }
                              }
                            }),
                            child: WidgetUtils.onlyTextCenter(
                                is_admin == '0' ? '设置为管理' : '取消管理',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ1,
                                    fontSize: ScreenUtil().setSp(21))),
                          ),
                        ),
                      )
                    : const Text(''),

                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      // 如果点击的是自己，进入自己的主页
                      if (sp.getString('user_id').toString() == widget.uid) {
                        MyUtils.goTransparentRFPage(
                            context, const MyInfoPage());
                      } else {
                        sp.setString('other_id', widget.uid);
                        MyUtils.goTransparentRFPage(
                            context,
                            PeopleInfoPage(
                              otherId: widget.uid,
                            ));
                      }
                    }
                  }),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(120),
                          ScreenUtil().setHeight(120), headImg),
                      // 头像框静态图
                      avatarFrameImg.isNotEmpty
                          ? WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(120),
                              ScreenUtil().setHeight(120),
                              avatarFrameImg)
                          : const Text(''),
                      // 头像框动态图
                      avatarFrameGifImg.isEmpty
                          ? SizedBox(
                              height: 160.h,
                              width: 160.h,
                              child: SVGASimpleImage(
                                resUrl: avatarFrameGifImg,
                              ),
                            )
                          : const Text(''),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int level = 0; //用户等级
  int isNew = 0; // 是否萌新
  int isPretty = 0; // 是否靓号
  /// 查看用户
  Future<void> doPostRoomUserInfo() async {
    Map<String, dynamic> params = <String, dynamic>{'uid': widget.uid};
    try {
      roomUserInfoBean bean = await DataUtils.postRoomUserInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list_p.clear();
          setState(() {
            headImg = bean.data!.avatar!;
            nickName = bean.data!.nickname!;
            userNumber = bean.data!.number.toString();
            city = bean.data!.city!;
            description = bean.data!.description!;
            sex = bean.data!.gender as int;
            status = bean.data!.followStatus!;
            level = bean.data!.level as int;
            isNew = bean.data!.isNew as int;
            isPretty = bean.data!.isPretty as int;
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

  /// 是否为管理、黑名单、禁言
  Future<void> doPostRoomUserInfoManager() async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'room_id': widget.roomID
    };
    try {
      roomInfoUserManagerBean bean =
          await DataUtils.postRoomUserInfoManager(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            is_admin = bean.data!.isAdmin.toString();
            is_forbation = bean.data!.isForbation.toString();
            is_black = bean.data!.isBlack.toString();
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

  /// 取消关注
  Future<void> doPostFollow() async {
    String type = '';
    if (status == '1') {
      type = '0';
    } else {
      type = '1';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status': type,
      'follow_id': widget.uid,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (status == '1') {
              status = '0';
            } else {
              status = '1';
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 设置/取消黑名单
  Future<void> doPostSetRoomBlack(String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'status': status,
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postSetRoomBlack(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("设置成功");
          setState(() {
            is_black = status;
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

  /// 设置/取消房间用户禁言
  Future<void> doPostSetRoomForbation(String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'status': status,
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postSetRoomForbation(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("设置成功");
          setState(() {
            is_forbation = status;
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

  /// 设置/取消管理员
  Future<void> doPostSetRoomAdmin(String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'status': status,
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postSetRoomAdmin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("设置成功");
          setState(() {
            is_admin = status;
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

  /// 闭麦/开麦
  Future<void> doPostSetClose(String serial_number) async {
    String status = '';
    if (zhuangtai == '闭麦') {
      status = 'no';
    } else {
      status = 'yes';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'serial_number': int.parse(serial_number) + 1,
      'uid': widget.uid,
      'status': status
    };
    try {
      CommonBean bean = await DataUtils.postSetClose(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (zhuangtai == '闭麦') {
            // eventBus.fire(RoomBack(title: '闭麦', index: serial_number));
            setState(() {
              zhuangtai = '开麦';
            });
            MyToastUtils.showToastBottom('已闭麦');
          } else {
            setState(() {
              // eventBus.fire(RoomBack(title: '开麦', index: serial_number));
              zhuangtai = '闭麦';
            });
            MyToastUtils.showToastBottom('已开麦');
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

  /// 能否发私聊
  Future<void> doPostCanSendUser() async {
    Map<String, dynamic> params = <String, dynamic>{'uid': widget.uid};
    try {
      CommonBean bean = await DataUtils.postCanSendUser(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          //可以发私聊跳转
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomMessagesMorePage(
                otherUid: widget.uid,
                otherImg: headImg,
                nickName: nickName,
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
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
