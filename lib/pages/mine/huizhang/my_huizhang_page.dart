import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/mine/gonghui/setting_gonghui_page.dart';
import '../../../bean/hzghBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/chat_page.dart';
import 'huizhang_people_page.dart';
import 'hz_room_liushui_page.dart';
import 'hz_room_more_page.dart';
import 'hz_zhubo_liushui_page.dart';

/// 会长后台-我的公会
class MyHuiZhangPage extends StatefulWidget {
  String type;

  MyHuiZhangPage({Key? key, required this.type}) : super(key: key);

  @override
  State<MyHuiZhangPage> createState() => _MyHuiZhangPageState();
}

class _MyHuiZhangPageState extends State<MyHuiZhangPage> {
  var appBar;
  // ratio分润比例
  String logo = '',
      ghName = '',
      ghId = '',
      ghAddTime = '',
      identity = '',
      kefUavatar = '',
      kefuUid = '',
      ratio = '',
      guildID = '';
  List<StreamerList> listPeople = [];
  List<GuildList> listGuild = [];
  int qianyue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('会长后台', true, context, false, 40);
    sp.setString('my_identity', widget.type);
    doPostMyGh();
    // doPostApplySignList();
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
                      // WidgetUtils.CircleImageNet(ScreenUtil().setHeight(144),
                      //     ScreenUtil().setHeight(144), 10, logo),
                      // WidgetUtils.commonSizedBox(0, 20),
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
                            WidgetUtils.commonSizedBox(10, 20),
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
                              child: Container(
                                height: 60.h,
                                width: 60.h,
                                color: Colors.transparent,
                                alignment: Alignment.centerRight,
                                child: WidgetUtils.showImages(
                                    'assets/images/gonghui_bianji.png',
                                    ScreenUtil().setHeight(38),
                                    ScreenUtil().setHeight(38)),
                              ),
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
                            '公会主播列表(${listPeople.length})',
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
                                builder: (context) => HuiZhangPeoplePage(hzhtID: guildID,),
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
                                Container(
                                  alignment: Alignment.center,
                                  height: 90.h,
                                  width: 30.h,
                                  child: WidgetUtils.showImages(
                                      'assets/images/people_right.png',
                                      ScreenUtil().setHeight(25),
                                      ScreenUtil().setHeight(15)),
                                )
                              ],
                            ),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(30, 20),
                        WidgetUtils.onlyText(
                            '厅列表(${listGuild.length})',
                            StyleUtils.getCommonTextStyle(
                              color: MyColors.g2,
                              fontSize: ScreenUtil().setSp(29),
                            )),
                        WidgetUtils.commonSizedBox(20, 20),
                        Wrap(
                          runSpacing: 20.h,
                          children: [
                            if (listGuild.length > 3)
                              for (int i = 0; i < 3; i++)
                                GestureDetector(
                                  onTap: (() {
                                    if(MyUtils.checkClick()){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HZRoomMorePage(hzhtID: guildID,),
                                        ),
                                      ).then((value) {
                                        doPostMyGh();
                                      });
                                    }
                                  }),
                                  child: Row(
                                    children: [
                                      WidgetUtils.CircleImageNet(
                                          ScreenUtil().setHeight(110),
                                          ScreenUtil().setHeight(110),
                                          10,
                                          listGuild[i].logo!),
                                      WidgetUtils.commonSizedBox(10, 20),
                                      WidgetUtils.onlyText(
                                          listGuild[i].title!,
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.g2,
                                              fontSize: ScreenUtil().setSp(25),
                                              fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 110.h,
                                        width: 30.h,
                                        child: WidgetUtils.showImages(
                                            'assets/images/people_right.png',
                                            ScreenUtil().setHeight(25),
                                            ScreenUtil().setHeight(15)),
                                      )
                                    ],
                                  ),
                                ),
                            WidgetUtils.myLine(color: MyColors.f4),
                            if (listGuild.length <= 3)
                              for (int i = 0; i < listGuild.length; i++)
                                GestureDetector(
                                  onTap: (() {
                                    if(MyUtils.checkClick()){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HZRoomMorePage(hzhtID: guildID,),
                                        ),
                                      ).then((value) {
                                        doPostMyGh();
                                      });
                                    }
                                  }),
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        WidgetUtils.CircleImageNet(
                                            ScreenUtil().setHeight(110),
                                            ScreenUtil().setHeight(110),
                                            10,
                                            listGuild[i].logo!),
                                        WidgetUtils.commonSizedBox(10, 20),
                                        WidgetUtils.onlyText(
                                            listGuild[i].title!,
                                            StyleUtils.getCommonTextStyle(
                                                color: MyColors.g2,
                                                fontSize:
                                                    ScreenUtil().setSp(25),
                                                fontWeight: FontWeight.w600)),
                                        const Spacer(),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 110.h,
                                          width: 30.h,
                                          child: WidgetUtils.showImages(
                                              'assets/images/people_right.png',
                                              ScreenUtil().setHeight(25),
                                              ScreenUtil().setHeight(15)),
                                        )
                                      ],
                                    ),
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
          Container(
            height: ScreenUtil().setHeight(70),
            margin:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        MyUtils.goTransparentRFPage(
                            context,
                            ChatPage(
                              nickName: '维C客服',
                              otherUid: kefuUid,
                              otherImg: kefUavatar,
                            ));
                      }
                    }),
                    child: WidgetUtils.myContainer(
                        ScreenUtil().setHeight(70),
                        double.infinity,
                        MyColors.homeTopBG,
                        MyColors.homeTopBG,
                        '新增厅主',
                        ScreenUtil().setSp(28),
                        Colors.white),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if(MyUtils.checkClick()){
                        MyUtils.goTransparentPageCom(context, HZRoomLiuShuiPage(ghID: guildID,));
                      }
                    }),
                    child: WidgetUtils.myContainer(
                        ScreenUtil().setHeight(70),
                        double.infinity,
                        MyColors.homeTopBG,
                        MyColors.homeTopBG,
                        '厅流水',
                        ScreenUtil().setSp(28),
                        Colors.white),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if(MyUtils.checkClick()){
                        MyUtils.goTransparentPageCom(context, HZZhuBoLiuShuiPage(ghID: guildID,));
                      }
                    }),
                    child: WidgetUtils.myContainer(
                        ScreenUtil().setHeight(70),
                        double.infinity,
                        MyColors.homeTopBG,
                        MyColors.homeTopBG,
                        '主播流水',
                        ScreenUtil().setSp(28),
                        Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 我的公会
  Future<void> doPostMyGh() async {
    Loading.show(MyConfig.successTitle);
    try {
      hzghBean bean = await DataUtils.postHomepage();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            logo = bean.data!.consortiaInfo!.logo!;
            guildID = bean.data!.consortiaInfo!.id.toString();
            sp.setString('guild_logo', bean.data!.consortiaInfo!.logo!);
            ghName = bean.data!.consortiaInfo!.title!;
            ghId = bean.data!.consortiaInfo!.number.toString();
            ghAddTime = bean.data!.consortiaInfo!.addTime!;
            if (bean.data!.streamerList!.isNotEmpty) {
              listPeople = bean.data!.streamerList!;
            }
            if (bean.data!.guildList!.isNotEmpty) {
              listGuild = bean.data!.guildList!;
            }
            kefUavatar = bean.data!.kefuUid.toString();
            kefuUid = bean.data!.kefuUid!.toString();
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

}
