import 'dart:async';

import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/pages/home/ceshi.dart';
import 'package:yuyinting/pages/mine/mine/xc_mine_model.dart';

import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/getx_tools.dart';
import '../../../utils/line_painter2.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/care_home_page.dart';
import '../gonghui/gonghui_home_page.dart';
import '../gonghui/my_gonghui_page.dart';
import '../huizhang/my_huizhang_page.dart';
import '../mine_smz_page.dart';
import '../my/yqyl_page.dart';
import '../my_kefu_page.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  late StreamSubscription<dynamic> listen;
  final c = Get.put(XCMineController(), permanent: true);
  @override
  void initState() {
    super.initState();
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '审核全部完成') {
        c.isShenHe.value = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        c.doPostMyIfon(context);
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mine_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SmartRefresher(
          controller: c.controller,
          header: MyUtils.myHeader(),
          enablePullUp: false,
          enablePullDown: true,
          onRefresh: () {
            c.doPostMyIfon(context);
          },
          child: SingleChildScrollView(
            child: _MinePageContent(),
          ),
        ),
      ),
    );
  }
}

class _MinePageContent extends StatelessWidget {
  _MinePageContent({Key? key}) : super(key: key);
  final XCMineController c = Get.find();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: SizedBox(
            width: 750,
            child: Column(
              children: [
                _top(),
                _friends(),
                _card(),
                _collection2(),
                _more(context),
              ],
            ),
          ),
        ),
        HitTestBlocker(child: _nav(context)),
      ],
    );
  }

  Widget _nav(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Get.statusBarHeight, right: 34.w, left: 34.w),
      height: 50.w,
      width: double.infinity,
      child: Row(
        children: [
          Obx(() {
            if (c.userNumber.value.isEmpty) {
              return const Text('');
            }
            return GestureDetector(
              onTap: () {
                c.onSwitch(context);
              },
              child: Row(
                children: [
                  Image(
                    width: 74.w*0.8,
                    height: 49.w*0.8,
                    image: AssetImage('assets/images/mine_switch_${c.switchValue.value ? 1 : 0}.png'),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '勿扰',
                    style: TextStyle(
                      color: Color(c.switchValue.value ? 0xFFFE5D9C : 0xFF949494),
                      fontSize: 28.sp,
                    ),
                  )
                ],
              ),
            );
          }),
          const Expanded(child: Text('')),
          GestureDetector(
            onTap: () { // 编辑
              if (MyUtils.checkClick()) {
                Get.toNamed('EditMyInfoPage');
              }
            },
            child: Image(
              width: 43.w,
              height: 41.w,
              image: const AssetImage('assets/images/mine_icon_edit.png'),
            ),
          ),
          SizedBox(width: 54.w),
          GestureDetector(
            onTap: () { // 设置
              if (MyUtils.checkClick()) {
                Get.toNamed('SettingPage');
              }
            },
            child: Image(
              width: 47.w,
              height: 44.w,
              image: const AssetImage('assets/images/mine_icon_setting.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _top() {
    return GestureDetector(
      onTap: () { // 主页
        if (MyUtils.checkClick()) {
          Get.toNamed('MyInfoPage');
        }
      },
      child: Container(
        height: 460,
        padding: const EdgeInsets.only(top: 105, left: 30, right: 30),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _head(),
              const SizedBox(height: 17),
              Text(
                c.nickname.value,
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              if (c.userNumber.value.isNotEmpty)
                GestureDetector(
                  onTap: () { // ID
                    Clipboard.setData(ClipboardData(text: c.userNumber.value));
                    MyToastUtils.showToastBottom('已成功复制到剪切板');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        width: 30,
                        height: 30,
                        image: AssetImage('assets/images/mine_icon_id.png'),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        c.userNumber.value,
                        style: const TextStyle(
                          color: Color(0xFF8C8FA1),
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Image(
                        width: 25,
                        height: 25,
                        image: AssetImage('assets/images/mine_icon_copy.png'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _head() {
    const double headWidth = 170;
    const double frameWidth = headWidth * 4 / 3.0;
    return SizedBox(
      width: frameWidth,
      height: frameWidth,
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            WidgetUtils.CircleHeadImage(
              headWidth,
              headWidth,
              c.userHeadImg.value,
            ),
            // WidgetUtils.showImages('assets/images/gz_guowang.gif', headWidth+50.w, headWidth+50.w),
            if (c.avatarFrameImg.value.isNotEmpty)
              WidgetUtils.CircleHeadImage(
                frameWidth,
                frameWidth,
                c.avatarFrameImg.value,
              ),
            if (c.avatarFrameGifImg.value.isNotEmpty)
              SizedBox(
                width: frameWidth,
                height: frameWidth,
                child: SVGASimpleImage(resUrl: c.avatarFrameGifImg.value),
              ),
          ],
        ),
      ),
    );
  }

  Widget _friends() {
    return Container(
      height: 153,
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Row(
          children: [
            _friendsItem(c.care.value, '关注', 0),
            _friendsItem(c.beCare.value, '被关注', 1),
            _friendsItem(c.lookMe.value, '看过我', 2),
          ],
        ),
      ),
    );
  }

  Widget _friendsItem(String content, String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (MyUtils.checkClick()) {
            Get.to(() => CareHomePage(index: index));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 46,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFA4A4A4),
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card() {
    return SizedBox(
      width: 687,
      height: 252,
      child: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/mine_card_guizu.png'),
            fit: BoxFit.fill,
          ),
          Positioned(
            right: 37,
            top: 25,
            child: GestureDetector(
              onTap: () { // 贵族
                if (MyUtils.checkClick()) {
                  Get.toNamed('TequanPage');
                }
              },
              child: const Text(
                '暂未成为贵族，快来解锁贵族特权',
                style: TextStyle(
                  color: Color(0xFF673D27),
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(23, 106, 26, 25),
            child: _collection(),
          )
        ],
      ),
    );
  }

  /// 财富 魅力
  Widget _collection() {
    final Widget wallet = GestureDetector(
      onTap: c.toBigclient,
      child: _collectionItem(
        '财富等级',
        '千元金豆日日领',
        const Color(0xFFFBFBFF),
        const Color(0xFFE3E7FF),
        Obx(() => WealthLevelTag(level: c.grLevel.value)),
      ),
    );
    final Widget liwu = GestureDetector(
      onTap: () => c.action(() {
        Get.toNamed('ChengJiuPage');
      }),
      child: _collectionItem(
        '魅力等级',
        '您的人气象征',
        const Color(0xFFFFFDF5),
        const Color(0xFFFFF3D9),
        Obx(() => CharmLevelTag(level: c.level.value)),
      ),
    );
    return Row(
      children: [
        Expanded(child: wallet),
        const SizedBox(width: 20),
        Expanded(child: liwu),
      ],
    );
  }
  
  Widget _collectionItem(String title, String content, Color end, Color start, Widget child) {
    return Container(
      width: 309,
      height: 121,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [start, end],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'LR',
                      color: Colors.black,
                      fontSize: 33,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    content,
                    style: const TextStyle(
                      color: Color(0xFFA39B86),
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 67,
              height: 69,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  /// 装扮 钱包 礼物记录
  Widget _collection2() {
    final Widget zb = GestureDetector(
      onTap: () => c.action(() {
        Get.toNamed('ZhuangbanPage');
      }),
      child: _collection2Item(
        '装扮商城',
        '座驾头像框',
        'zhuangban',
        const Size(344.0/3.5, 390.0/3.5),
      ),
    );
    final Widget wallet = GestureDetector(
      onTap: () => c.action(() {
        Get.toNamed('WalletPage');
      }),
      child: _collection2Item(
        '我的钱包',
        '充值、兑换',
        'qianbao',
        const Size(362.0/3.5, 363.0/3.5),
      ),
    );
    final Widget liwu = GestureDetector(
      onTap: () => c.action(() {
        Get.toNamed('LiwuPage');
      }),
      child: _collection2Item(
        '礼物记录',
        '收送礼物明细',
        'liwu',
        const Size(378.0/3.5, 377.0/3.5),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Row(
        children: [
          Expanded(child: zb),
          const SizedBox(width: 20),
          Expanded(child: wallet),
          const SizedBox(width: 20),
          Expanded(child: liwu),
        ],
      ),
    );
  }
  
  Widget _collection2Item(String title, String content, String img, Size size) {
    return Container(
      width: 215,
      height: 131,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(26)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            width: size.width,
            height: size.height,
            child: Image(
              image: AssetImage('assets/images/mine_icon_$img.png'),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 15,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFFA39B86),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _more(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      padding: const EdgeInsets.only(left: 37, right: 37, top: 32, bottom: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:  BorderRadius.all(Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '更多服务',
            style: TextStyle(
              color: Color(0xFF212121),
              fontSize: 36,
              fontWeight: FontWeight.w500,
            ),
          ),
          Obx(
            () => GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              children: [
                if (c.userNumber.value.isNotEmpty)
                  c.identity.value == 'president'
                      ? _moreItem('会长后台', 'huizhang', () { 
                        Get.to(() => MyHuiZhangPage(type: c.identity.value));
                      })
                      : _morePoint(
                        c.isShenHe.value, 
                        _moreItem('公会中心', 'gonghui', () {
                          switch (sp.getString('shimingzhi').toString()) {
                            case '2':
                            case '3':
                              MyUtils.goTransparentPageCom(context, const MineSMZPage());
                              break;
                            case '1': //身份 user普通用户，未加入公会 streamer主播 leader会长
                              if (c.identity.value == 'user') {
                                Get.to(() => GonghuiHomePage(kefuUid: c.kefuUid, kefuAvatar: c.kefuAvatar));
                              } else {
                                Get.to(() => MyGonghuiPage(type: c.identity.value));
                              }
                              break;
                            case '0':
                              MyToastUtils.showToastBottom('实名审核中，请耐心等待');
                              break;
                            default:
                          }
                        }),
                      ),
                if (c.userNumber.value.isNotEmpty)
                  c.isAgent.value
                    ? _moreItem('邀请有礼', 'quanmin', () { 
                      Get.toNamed('DailiHomePage');
                    })
                    : _moreItem('邀请有礼', 'yaoqing', () { 
                      Get.to(() => YQYLPage(kefuUid: c.kefuUid, kefUavatar: c.kefuAvatar));
                    }),
                // _moreItem('等级成就', 'dengji', () { 
                //   Get.toNamed('ChengJiuPage');
                // }),
                _moreItem('联系客服', 'kefu', () { 
                  Future.delayed(
                        const Duration(seconds: 0),
                        () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return MyKeFuPage(kefuUid: c.kefuUid, kefuAvatar: c.kefuAvatar);
                              },
                            ),
                          );
                        },
                      );
                }),
                GestureDetector(
                  onTap: () => Get.to(const CeShi()),
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: const Text('去支付', style: TextStyle(fontSize: 30)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _morePoint(bool isPoint, Widget child) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (isPoint)
          Positioned(
            right: 45,
            top: 15,
            child: CustomPaint(painter: LinePainter2(colors: Colors.red)),
          ),
      ],
    );
  }
  Widget _moreItem(String title, String img, void Function() action) {
    return GestureDetector(
        onTap: () {
          if (MyUtils.checkClick()) {
            action();
          }
        },
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                width: 96*0.6,
                height: 99*0.6,
                image: AssetImage('assets/images/mine_icon_$img.png'),
              ),
              const SizedBox(height: 25),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ));
  }
}
