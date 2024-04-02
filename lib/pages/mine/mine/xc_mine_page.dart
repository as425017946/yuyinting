import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/pages/mine/mine/xc_mine_model.dart';

import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/line_painter2.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/care_home_page.dart';
import '../gonghui/gonghui_home_page.dart';
import '../gonghui/my_gonghui_page.dart';
import '../huizhang/my_huizhang_page.dart';
import '../mine_smz_page.dart';
import '../my/my_info_page.dart';
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
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        c.doPostMyIfon(context);
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/all_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: _MinePageContent(),
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
                _more(context),
              ],
            ),
          ),
        ),
        _nav(),
      ],
    );
  }

  Widget _nav() {
    return Container(
      margin: EdgeInsets.only(top: Get.statusBarHeight, right: 34.w),
      height: 50.w,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
            Get.to(CareHomePage(index: index));
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

  /// 钱包 礼物记录
  Widget _collection() {
    final Widget wallet = GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick()) {
          Get.toNamed('WalletPage');
        }
      }),
      child: _collectionItem(
        '我的钱包',
        '充值、兑换',
        const Color(0xFFFBFBFF),
        const Color(0xFFE3E7FF),
        const Image(
          image: AssetImage('assets/images/mine_qianbao.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
    final Widget liwu = GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick()) {
          Get.toNamed('LiwuPage');
        }
      }),
      child: _collectionItem(
        '礼物记录',
        '收送礼物明细',
        const Color(0xFFFFFDF5),
        const Color(0xFFFFF3D9),
        const Image(
          image: AssetImage('assets/images/mine_liwu.png'),
          fit: BoxFit.contain,
        ),
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
                      color: Colors.black,
                      fontSize: 33,
                      fontWeight: FontWeight.w600,
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

  Widget _more(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 32),
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
                childAspectRatio: 0.8,
              ),
              children: [
                GestureDetector(
                  onTap: () {
                    if (MyUtils.checkClick()) {
                      Get.toNamed('ZhuangbanPage');
                    }
                  },
                  child: Text('装扮商城'),
                ),
                if (c.userNumber.value.isNotEmpty)
                  c.identity == 'president'
                      ? GestureDetector(
                          onTap: () {
                            if (MyUtils.checkClick()) {
                              Get.to(MyHuiZhangPage(type: c.identity.value));
                            }
                          },
                          child: Text('会长后台'),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (MyUtils.checkClick()) {
                              switch (sp.getString('shimingzhi').toString()) {
                                case '2':
                                case '3':
                                  MyUtils.goTransparentPageCom(
                                      context, const MineSMZPage());
                                  break;
                                case '1': //身份 user普通用户，未加入公会 streamer主播 leader会长
                                  if (c.identity.value == 'user') {
                                    Get.to(GonghuiHomePage(kefuUid: c.kefuUid, kefuAvatar: c.kefuAvatar));
                                  } else {
                                    Get.to(MyGonghuiPage(type: c.identity.value));
                                  }
                                  break;
                                case '0':
                                  MyToastUtils.showToastBottom('实名审核中，请耐心等待');
                                  break;
                                default:
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Text('公会中心'),
                              if (c.isShenHe.value)
                                Transform.translate(
                                  offset: Offset(0, -5.h),
                                  child: CustomPaint(
                                    painter: LinePainter2(colors: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                        ),
                if (c.userNumber.value.isNotEmpty)
                  c.isAgent.value
                    ? GestureDetector(
                          onTap: () {
                            if (MyUtils.checkClick()) {
                              Get.toNamed('DailiHomePage');
                            }
                          },
                          child: Text('全民代理'),
                        )
                    : GestureDetector(
                          onTap: () {
                            if (MyUtils.checkClick()) {
                              Get.to(YQYLPage(kefuUid: c.kefuUid, kefUavatar: c.kefuAvatar));
                            }
                          },
                          child: Text('邀请有礼'),
                    ),
                GestureDetector(
                  onTap: () {
                    if (MyUtils.checkClick()) {
                      Get.toNamed('ChengJiuPage');
                    }
                  },
                  child: Text('等级成就'),
                ),
                if (c.userNumber.value.isNotEmpty)
                  Column(
                    children: [
                      CupertinoSwitch(
                              value: c.switchValue.value,
                              onChanged: (value) {
                                c.onSwitch(value, context);
                              },
                              activeColor: const Color(0xFF5b46b9),
                            ),
                      Text('勿扰模式'),
                    ],
                  ),
                GestureDetector(
                  onTap: () {
                    if (MyUtils.checkClick()) {
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
                    }
                  },
                  child: Text('联系客服'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
