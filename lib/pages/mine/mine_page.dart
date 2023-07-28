import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/message/care_home_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../bean/myInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';
import 'my_kefu_page.dart';

///我的
class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  var guizuType = 0, gender = 0, isFirst = 0;
  var listen;
  String headImg = '',
      nickName = '',
      userNumber = '',
      care = '',
      beCare = '',
      lookMe = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '我的装扮') {
        // Navigator.pushNamed(context, 'DengjiPage');
        Navigator.pushNamed(context, 'ZhuangbanPage');
      } else if (event.title == '公会中心') {
        Navigator.pushNamed(context, 'GonghuiHomePage');
        // if(mounted){
        //   Navigator.pushNamed(context, 'MyGonghuiPage');
        // }
      } else if (event.title == '全民代理') {
        if (mounted) {
          Navigator.pushNamed(context, 'DailiHomePage');
        }
      } else if (event.title == '联系客服') {
        if (mounted) {
          // Navigator.pushNamed(context, 'KefuPage');
          Future.delayed(const Duration(seconds: 0), () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const MyKeFuPage();
                }));
          });
        }
      }
    });

    doPostMyIfon();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/mine_bg.jpg"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(35, 0),
            GestureDetector(
              onTap: (() {
                Navigator.pushNamed(context, 'SettingPage');
              }),
              child: Row(
                children: [
                  const Expanded(child: Text('')),
                  WidgetUtils.showImages('assets/images/mine_icon_setting.png',
                      ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                ],
              ),
            ),

            ///头像等信息
            Row(
              children: [
                GestureDetector(
                  onTap: (() {
                    Navigator.pushNamed(context, 'MyInfoPage');
                  }),
                  child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(90),
                      ScreenUtil().setHeight(90), headImg),
                ),
                WidgetUtils.commonSizedBox(0, 15),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            Text(
                              nickName,
                              style: StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(38)),
                            ),
                            WidgetUtils.commonSizedBox(0, 5),
                            Container(
                              height: ScreenUtil().setHeight(25),
                              width: ScreenUtil().setWidth(50),
                              alignment: Alignment.center,
                              //边框设置
                              decoration: BoxDecoration(
                                //背景
                                color: gender == 1
                                    ? MyColors.dtBlue
                                    : MyColors.dtPink,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              child: WidgetUtils.showImages(
                                  gender == 1
                                      ? 'assets/images/nan.png'
                                      : 'assets/images/nv.png',
                                  12,
                                  12),
                            ),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      GestureDetector(
                        onTap: (() {
                          Clipboard.setData(ClipboardData(
                            text: userNumber,
                          ));
                          MyToastUtils.showToastBottom('已成功复制到剪切板');
                        }),
                        child: Row(
                          children: [
                            Text(
                              'ID:$userNumber',
                              style: StyleUtils.getCommonTextStyle(
                                  color: MyColors.mineGrey,
                                  fontSize: ScreenUtil().setSp(25)),
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                            WidgetUtils.showImages(
                                'assets/images/mine_fuzhi.png',
                                ScreenUtil().setHeight(20),
                                ScreenUtil().setHeight(20))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.pushNamed(context, 'MyInfoPage');
                  }),
                  child: Row(
                    children: [
                      WidgetUtils.onlyText(
                          '主页',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.mineGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(25))),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.showImages(
                          'assets/images/mine_more.png',
                          ScreenUtil().setHeight(22),
                          ScreenUtil().setHeight(10))
                    ],
                  ),
                )
              ],
            ),
            WidgetUtils.commonSizedBox(18, 0),

            /// 升级贵族
            SizedBox(
              width: double.infinity,
              height: ScreenUtil().setHeight(200),
              child: Stack(
                children: [
                  WidgetUtils.showImagesFill('assets/images/mine_gz_bg.png',
                      ScreenUtil().setHeight(130), double.infinity),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(100),
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (() {
                        Navigator.pushNamed(context, 'TequanPage');
                      }),
                      child: guizuType == 1
                          ? WidgetUtils.myContainer(
                              ScreenUtil().setHeight(45),
                              ScreenUtil().setHeight(100),
                              Colors.transparent,
                              MyColors.mineOrange,
                              '已开通',
                              ScreenUtil().setSp(21),
                              MyColors.mineOrange)
                          : SizedBox(
                              width: ScreenUtil().setHeight(116),
                              height: ScreenUtil().setHeight(39),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImages(
                                      'assets/images/mine_kaitong_bg.png',
                                      ScreenUtil().setHeight(45),
                                      ScreenUtil().setHeight(100)),
                                  WidgetUtils.onlyTextCenter(
                                      '开通',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(21))),
                                ],
                              ),
                            ),
                    ),
                  ),
                  Container(
                      height: ScreenUtil().setHeight(150),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                      decoration: const BoxDecoration(
                        //背景
                        color: Colors.white,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child:

                          /// 关注
                          Row(
                        children: [
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return CareHomePage(index: 0);
                              }));
                            }),
                            child: Column(
                              children: [
                                // Container(
                                //   width: ScreenUtil().setHeight(80),
                                //   alignment: Alignment.topRight,
                                //   child: Text(
                                //       '+1',
                                //       style : StyleUtils.getCommonTextStyle(
                                //           color: MyColors.mineRed,
                                //           fontSize: ScreenUtil().setSp(25))),
                                // ),
                                const Expanded(child: Text('')),
                                WidgetUtils.onlyText(
                                    care,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(38),
                                        fontWeight: FontWeight.w600)),
                                WidgetUtils.onlyText(
                                    '关注',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.mineGrey,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          ),
                          const Expanded(flex: 2, child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return CareHomePage(index: 1);
                              }));
                            }),
                            child: Column(
                              children: [
                                // Container(
                                //   width: ScreenUtil().setHeight(80),
                                //   alignment: Alignment.topRight,
                                //   child: Text(
                                //       '+1',
                                //       style : StyleUtils.getCommonTextStyle(
                                //           color: MyColors.mineRed,
                                //           fontSize: ScreenUtil().setSp(25))),
                                // ),
                                const Expanded(child: Text('')),
                                WidgetUtils.onlyText(
                                    beCare,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(38),
                                        fontWeight: FontWeight.w600)),
                                WidgetUtils.onlyText(
                                    '被关注',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.mineGrey,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          ),
                          const Expanded(flex: 2, child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return CareHomePage(index: 2);
                              }));
                            }),
                            child: Column(
                              children: [
                                // Container(
                                //   width: ScreenUtil().setHeight(80),
                                //   alignment: Alignment.topRight,
                                //   child: Text(
                                //       '+1',
                                //       style : StyleUtils.getCommonTextStyle(
                                //           color: MyColors.mineRed,
                                //           fontSize: ScreenUtil().setSp(25))),
                                // ),
                                const Expanded(child: Text('')),
                                WidgetUtils.onlyText(
                                    lookMe,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(38),
                                        fontWeight: FontWeight.w600)),
                                WidgetUtils.onlyText(
                                    '看过我',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.mineGrey,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ))
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(18, 0),

            /// 展示信息
            WidgetUtils.containerNo(
                pad: 20,
                height: ScreenUtil().setHeight(600),
                width: double.infinity,
                color: Colors.white,
                ra: 20,
                w: Column(
                  children: [
                    /// 钱包 礼物记录
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: (() {
                            Navigator.pushNamed(context, 'WalletPage');
                          }),
                          child: WidgetUtils.containerNo(
                              height: ScreenUtil().setHeight(110),
                              width: double.infinity,
                              color: MyColors.mineYellow,
                              ra: 10,
                              w: Row(
                                children: [
                                  WidgetUtils.commonSizedBox(0, 10),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Expanded(child: Text('')),
                                        WidgetUtils.onlyText(
                                            '我的钱包',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(32),
                                                fontWeight: FontWeight.w600)),
                                        WidgetUtils.onlyText(
                                            '充值、兑换',
                                            StyleUtils.getCommonTextStyle(
                                                color: MyColors.mineGrey,
                                                fontSize:
                                                    ScreenUtil().setSp(22))),
                                        const Expanded(child: Text('')),
                                      ],
                                    ),
                                  ),
                                  WidgetUtils.showImages(
                                      'assets/images/mine_qianbao.png',
                                      ScreenUtil().setHeight(67),
                                      ScreenUtil().setHeight(67)),
                                  WidgetUtils.commonSizedBox(0, 10),
                                ],
                              )),
                        )),
                        WidgetUtils.commonSizedBox(0, 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: (() {
                              Navigator.pushNamed(context, 'LiwuPage');
                            }),
                            child: WidgetUtils.containerNo(
                                height: ScreenUtil().setHeight(110),
                                width: double.infinity,
                                color: MyColors.minePink,
                                ra: 10,
                                w: Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.onlyText(
                                              '礼物记录',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      ScreenUtil().setSp(32),
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.onlyText(
                                              '收送礼物明细',
                                              StyleUtils.getCommonTextStyle(
                                                  color: MyColors.mineGrey,
                                                  fontSize:
                                                      ScreenUtil().setSp(22))),
                                          const Expanded(child: Text('')),
                                        ],
                                      ),
                                    ),
                                    WidgetUtils.showImages(
                                        'assets/images/mine_liwu.png',
                                        ScreenUtil().setHeight(67),
                                        ScreenUtil().setHeight(67)),
                                    WidgetUtils.commonSizedBox(0, 10),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(20, 0),
                    WidgetUtils.whiteKuang(
                        'assets/images/mine_zhuangban.png', '我的装扮', false),
                    WidgetUtils.whiteKuang(
                        'assets/images/mine_gonghui.png', '公会中心', false),
                    WidgetUtils.whiteKuang(
                        'assets/images/mine_daili.png', '全民代理', false),
                    WidgetUtils.whiteKuang(
                        'assets/images/mine_kefu.png', '联系客服', false),
                  ],
                ))
          ],
        ) /* add child content here */,
      ),
    );
  }

  /// 关于我们
  Future<void> doPostMyIfon() async {
    var type;
    // 透明状态栏
    if (Platform.isAndroid) {
      type = '2';
    }
    if (Platform.isIOS) {
      type = '1';
    }

    Map<String, dynamic> params = <String, dynamic>{
      'system': type,
      'version': sp.getString('myVersion1')
    };
    try {
      MyInfoBean bean = await DataUtils.postMyIfon(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            sp.setString('myVersion2', bean.data!.currentVersion!);
            sp.setString('versionStatus', bean.data!.status!);
            sp.setString('shimingzhi', bean.data!.auditStatus.toString());
            sp.setString("user_headimg", bean.data!.avatar!);
            headImg = bean.data!.avatar!;
            gender = bean.data!.gender as int;
            nickName = bean.data!.nickname!;
            userNumber = bean.data!.number.toString();
            care = bean.data!.followNum.toString();
            beCare = bean.data!.isFollowNum.toString();
            lookMe = bean.data!.lookNum.toString();
            guizuType = bean.data!.nobleID as int;
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
