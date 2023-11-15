import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/bean/myGhBean.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/mine/gonghui/room_more_page.dart';
import 'package:yuyinting/pages/mine/gonghui/setting_gonghui_page.dart';
import 'package:yuyinting/pages/mine/gonghui/shenhe_page.dart';

import '../../../bean/qyListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/line_painter2.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import 'gonghui_people_page.dart';

/// 我的公会
class MyGonghuiPage extends StatefulWidget {
  String type;

  MyGonghuiPage({Key? key, required this.type}) : super(key: key);

  @override
  State<MyGonghuiPage> createState() => _MyGonghuiPageState();
}

class _MyGonghuiPageState extends State<MyGonghuiPage> {
  var appBar;
  String logo = '', ghName = '', ghId = '', ghAddTime = '', identity = '';
  List<StreamerList> listPeople = [];
  List<RoomList> listRoom = [];
  int qianyue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == 'leader') {
      appBar = WidgetUtils.getAppBar('我的公会', true, context, true, 4);
    } else {
      appBar = WidgetUtils.getAppBar('我的公会', true, context, false, 4);
    }
    sp.setString('my_identity', widget.type);
    doPostMyGh();
    doPostApplySignList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  WidgetUtils.showImagesFill(
                      'assets/images/gonghui_more_bg.jpg',
                      ScreenUtil().setHeight(300),
                      double.infinity),
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(20, 20),
                      WidgetUtils.CircleImageNet(ScreenUtil().setHeight(144),
                          ScreenUtil().setHeight(144), 10, logo),
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                WidgetUtils.onlyText(
                                    ghName,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(36),
                                        fontWeight: FontWeight.w600)),
                                // WidgetUtils.showImages(, height, width)
                              ],
                            ),
                            WidgetUtils.commonSizedBox(10, 20),
                            WidgetUtils.onlyText(
                                'ID: $ghId',
                                StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(25),
                                )),
                            WidgetUtils.commonSizedBox(10, 20),
                            WidgetUtils.onlyText(
                                '创建时间: $ghAddTime',
                                StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(25),
                                )),
                          ],
                        ),
                      ),
                      identity == 'leader'
                          ? GestureDetector(
                              onTap: (() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const SettingGonghuiPage(),
                                  ),
                                ).then((value) {
                                  doPostMyGh();
                                });
                              }),
                              child: WidgetUtils.showImages(
                                  'assets/images/gonghui_bianji.png',
                                  ScreenUtil().setHeight(38),
                                  ScreenUtil().setHeight(38)),
                            )
                          : const Text(''),
                      WidgetUtils.commonSizedBox(20, 20),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -15),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        WidgetUtils.commonSizedBox(20, 20),
                        WidgetUtils.onlyText(
                            '主播列表(${listPeople.length})',
                            StyleUtils.getCommonTextStyle(
                              color: MyColors.g2,
                              fontSize: ScreenUtil().setSp(29),
                            )),
                        WidgetUtils.commonSizedBox(10, 20),
                        GestureDetector(
                          onTap: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GonghuiPeoplePage(),
                              ),
                            ).then((value) {
                              doPostMyGh();
                            });
                          }),
                          child: Container(
                            height: ScreenUtil().setHeight(130),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 10,
                              children: [
                                if (listPeople.length > 5)
                                  for (int i = 0; i < 5; i++)
                                    SizedBox(
                                      width: ScreenUtil().setHeight(90),
                                      child: Column(
                                        children: [
                                          WidgetUtils.CircleHeadImage(
                                              ScreenUtil().setHeight(90),
                                              ScreenUtil().setHeight(90),
                                              listPeople[i].avatar!),
                                          WidgetUtils.onlyTextCenter(
                                              listPeople[i].nickname!,
                                              StyleUtils.getCommonTextStyle(
                                                color: MyColors.g6,
                                                fontSize:
                                                    ScreenUtil().setSp(21),
                                              )),
                                        ],
                                      ),
                                    ),
                                if (listPeople.length <= 5)
                                  for (int i = 0; i < listPeople.length; i++)
                                    SizedBox(
                                      width: ScreenUtil().setHeight(90),
                                      child: Column(
                                        children: [
                                          WidgetUtils.CircleHeadImage(
                                              ScreenUtil().setHeight(90),
                                              ScreenUtil().setHeight(90),
                                              listPeople[i].avatar!),
                                          WidgetUtils.onlyTextCenter(
                                              listPeople[i].nickname!,
                                              StyleUtils.getCommonTextStyle(
                                                color: MyColors.g6,
                                                fontSize:
                                                    ScreenUtil().setSp(21),
                                              )),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(30, 20),
                        WidgetUtils.onlyText(
                            '公会房间(${listRoom.length})',
                            StyleUtils.getCommonTextStyle(
                              color: MyColors.g2,
                              fontSize: ScreenUtil().setSp(29),
                            )),
                        WidgetUtils.commonSizedBox(20, 20),
                        Wrap(
                          runSpacing: 20.h,
                          children: [
                            if (listRoom.length > 3)
                              for (int i = 0; i < 3; i++)
                                GestureDetector(
                                  onTap: (() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RoomMorePage(),
                                      ),
                                    ).then((value) {
                                      doPostMyGh();
                                    });
                                  }),
                                  child: Row(
                                    children: [
                                      WidgetUtils.CircleImageNet(
                                          ScreenUtil().setHeight(110),
                                          ScreenUtil().setHeight(110),
                                          10,
                                          listRoom[i].coverImg!),
                                      WidgetUtils.commonSizedBox(10, 20),
                                      WidgetUtils.onlyText(
                                          listRoom[i].roomName!,
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.g2,
                                              fontSize: ScreenUtil().setSp(25),
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                            WidgetUtils.myLine(color: MyColors.f4),
                            if (listRoom.length <= 3)
                              for (int i = 0; i < listRoom.length; i++)
                                GestureDetector(
                                  onTap: (() {
                                    Navigator.pushNamed(
                                        context, 'RoomMorePage');
                                  }),
                                  child: Row(
                                    children: [
                                      WidgetUtils.CircleImageNet(
                                          ScreenUtil().setHeight(110),
                                          ScreenUtil().setHeight(110),
                                          10,
                                          listRoom[i].coverImg!),
                                      WidgetUtils.commonSizedBox(10, 20),
                                      WidgetUtils.onlyText(
                                          listRoom[i].roomName!,
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.g2,
                                              fontSize: ScreenUtil().setSp(25),
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                            WidgetUtils.commonSizedBox(10, 20),
                            WidgetUtils.myLine(color: MyColors.f4),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),

          /// 应聘咨询按钮
          identity == 'leader'
              ? Container(
                  height: ScreenUtil().setHeight(70),
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pushNamed(context, 'KefuPage');
                          }),
                          child: WidgetUtils.myContainer(
                              ScreenUtil().setHeight(70),
                              double.infinity,
                              MyColors.homeTopBG,
                              MyColors.homeTopBG,
                              '开设房间',
                              ScreenUtil().setSp(31),
                              Colors.white),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const ShenhePage(),
                              ),
                            ).then((value) {
                              doPostMyGh();
                            });
                          }),
                          child: SizedBox(
                            child: Stack(
                              children: [
                                WidgetUtils.myContainer(
                                    ScreenUtil().setHeight(70),
                                    double.infinity,
                                    MyColors.homeTopBG,
                                    MyColors.homeTopBG,
                                    '入驻审核',
                                    ScreenUtil().setSp(31),
                                    Colors.white),
                                qianyue == 1 ? Positioned(
                                    right: ScreenUtil().setHeight(30),
                                    top: ScreenUtil().setHeight(10),
                                    child: CustomPaint(
                                    painter: LinePainter2(colors: Colors.red),
                                )) : const Text('')
                              ],
                            ),
                          ),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pushNamed(context, 'JiesuanPage');
                          }),
                          child: WidgetUtils.myContainer(
                              ScreenUtil().setHeight(70),
                              double.infinity,
                              MyColors.homeTopBG,
                              MyColors.homeTopBG,
                              '结算账单',
                              ScreenUtil().setSp(31),
                              Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : const Text('')
        ],
      ),
    );
  }

  /// 我的公会
  Future<void> doPostMyGh() async {
    Loading.show(MyConfig.successTitle);
    try {
      myGhBean bean = await DataUtils.postMyGh();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            logo = bean.data!.guildInfo!.logo!;
            sp.setString('guild_logo', bean.data!.guildInfo!.logo!);
            ghName = bean.data!.guildInfo!.title!;
            ghId = bean.data!.guildInfo!.number.toString();
            ghAddTime = bean.data!.guildInfo!.addTime!;
            if (bean.data!.streamerList!.isNotEmpty) {
              listPeople = bean.data!.streamerList!;
            }
            if (bean.data!.roomList!.isNotEmpty) {
              listRoom = bean.data!.roomList!;
            }
            identity = bean.data!.identity!;
            sp.setString('guild_id', bean.data!.guildInfo!.id.toString());
            sp.setString('guild_notice', bean.data!.guildInfo!.notice.toString());
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


  /// 签约列表
  Future<void> doPostApplySignList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'guild_id': sp.getString('guild_id'),
    };
    try {
      qyListBean bean = await DataUtils.postApplySignList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            qianyue = bean.data!.length;
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

}
