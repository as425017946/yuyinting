import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../bean/activity_paper_index_bean.dart';
import '../../main.dart';
import '../../utils/getx_tools.dart';
import '../../utils/my_utils.dart';
import '../../widget/SwiperPage.dart';
import '../message/chat_page.dart';
import '../trends/PagePreviewVideo.dart';
import 'makefriends_model.dart';

class CPSpeedPage extends StatefulWidget {
  const CPSpeedPage({Key? key}) : super(key: key);

  @override
  State<CPSpeedPage> createState() => _CPSpeedPageState();
}

class _CPSpeedPageState extends State<CPSpeedPage> with SingleTickerProviderStateMixin {
  final MakefriendsController c = Get.find();

  @override
  void initState() {
    c.animationController = SVGAAnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    c.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 35),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/cp_bj.png"),
          fit: BoxFit.fill,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // _positioned(Rect.fromLTWH(135.w, 364.h - 35, 480.w, 495.h), img: 'cp_gift'),
          // _positioned(Rect.fromLTWH(155.w, 220.h - 35, 422.w, 73.h), img: 'cp_success'),
          _success(),
          Obx(() => _positioned(Rect.fromLTWH(0, -35, 750.w, 1334.h), img: 'cp_svga', child: _svga())),
          _btnMine(),
          Positioned(
            height: 407.h,
            left: 0,
            bottom: 0,
            right: 0,
            child: _bottom(),
          ),
          _nav(),
        ],
      ),
    );
  }

  Widget _nav() {
    return Container(
      height: 60.w,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 44.w, right: 31.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => c.select = 0,
            child: Text(
              'CP速配',
              style: TextStyle(
                color: const Color(0xFFCFD9FF),
                fontSize: 33.sp,
                fontFamily: 'LR',
              ),
            ),
          ),
          SizedBox(width: 44.w),
          Text(
            '告白纸条',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.sp,
              fontFamily: 'LR',
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => c.action(() {
              Get.dialog(_DialogHelp());
            }),
            child: Image.asset('assets/images/cp_help.png', width: 30.w, height: 30.w),
          ),
        ],
      ),
    );
  }

  Widget _success() {
    final fontSize = 36.h;
    return Positioned(
      left: 0,
      right: 0,
      top: 220.h - 35,
      height: 73.h,
      child: Center(
        child: Text(
          c.cpNum,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, shadows: [
            Shadow(
              color: Colors.yellow,
              blurRadius: fontSize,
            ),
            Shadow(
              color: Colors.yellow,
              blurRadius: fontSize,
            ),
          ]),
        ),
      ),
    );
  }

  Widget? _svga() {
    if (c.isSvga) {
      return SVGAImage(c.animationController);
    }
    return null;
  }

  Widget _positioned(Rect rect, {Widget? child, String img = ''}) {
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: child == null
          ? Image.asset("assets/images/$img.png", fit: BoxFit.contain)
          : FittedBox(
              fit: BoxFit.contain,
              child: child,
            ),
    );
  }

  Widget _btnMine() {
    final radius = Radius.circular(15.w);
    return Positioned(
      right: 0,
      top: 293.h - 35,
      width: 44.w,
      height: 156.w,
      child: GestureDetector(
        onTap: () => c.action(() async {
          await c.onMine();
          Get.bottomSheet(_BottomSheet());
        }),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.only(top: 11.w, left: 6.w),
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.only(topLeft: radius, bottomLeft: radius),
          ),
          child: Column(
            children: [
              Image.asset('assets/images/cp_heart.png', width: 28.w, height: 24.w),
              SizedBox(height: 7.w),
              Text(
                '我\n的\n纸\n条',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottom() {
    return Column(
      children: [
        _price(),
        SizedBox(height: 43.h),
        _btns(),
        SizedBox(height: 42.h),
        _banner(),
      ],
    );
  }

  Widget _price() {
    return SizedBox(
      width: 224.w,
      height: 50.h,
      child: FittedBox(
        child: Container(
          width: 224,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0x4CE9DEFF),
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Obx(
            () => Text(
              c.getNum,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => c.action(() async {
            if (await c.runOpen()) Get.dialog(_DialogReceive());
          }),
          child: _btn('cp_btn_chouqu.png'),
        ),
        SizedBox(width: 37.w),
        GestureDetector(
          onTap: () => c.action(() async {
            if (await Get.dialog(_DialogSend())) {
              c.runSend();
            }
          }),
          child: _btn('cp_btn_fangru.png'),
        ),
      ],
    );
  }

  Widget _btn(String img) {
    return Image.asset(
      'assets/images/$img',
      width: 280.w,
      height: 82.h,
      fit: BoxFit.contain,
    );
  }

  Widget _banner() {
    return SizedBox(
      width: double.infinity,
      height: 138.h,
      child: _Banner(),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Barrage('1'),
        const Spacer(),
        _Barrage('2'),
      ],
    );
  }
}

// ignore: must_be_immutable
class _Barrage extends StatelessWidget {
  final String myKey;
  _Barrage(this.myKey);
  final _isFirst = true.obs;
  final _items = [
    _BarrageType.empty().obs,
    _BarrageType.empty().obs,
    _BarrageType.empty().obs,
    _BarrageType.empty().obs,
  ];
  double _total = 0;
  double _width = 0;
  void _callBack(double total, double width) {
    _total = total;
    _width = width;
  }

  void _run(int index, int itemIndex, int time) async {
    final item = _items[itemIndex];
    int t = 7000 + Random().nextInt(3000);
    item(_BarrageType(index, t));
    await Future.delayed(const Duration(milliseconds: 500));
    final interval = t.toDouble() * (_width + 20.h) / (_width + _total);
    await Future.delayed(Duration(milliseconds: interval.toInt() + 1000 + Random().nextInt(500)));
    _run((index + 1), (itemIndex + 1) % _items.length, time);
  }

  final _all = '清风晨曦诗意独步琴瑟浮生梦幻繁星烟雨飘渺落花流水蝴蝶倾城晨曦彼岸柔情倚楼漫步清风听风茉莉蓝天蒙蒙如梦忆梦西游无悔醉舞青春';
  String _getName() {
    if (Random().nextInt(3) == 1) {
      return '萌***';
    }
    final start = Random().nextInt(_all.length);
    final name = _all.substring(start, start + 1);
    return '$name***';
  }

  String _text() {
    final String sex;
    if (Random().nextInt(3) == 1) {
      sex = '男';
    } else {
      sex = '女';
    }
    return '${_getName()}  抽到了  纸条$sex友  ${_getName()}';
  }

  @override
  Widget build(BuildContext context) {
    final MakefriendsController c = Get.find();
    return c.cpBanners[myKey] ??= FocusDetector(
      onFocusGained: () {
        if (_isFirst.value) {
          _isFirst.value = false;
          _run(0, 0, 0);
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 49.h,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: _items.map((element) => Obx(() => _item(element.value, _callBack))).toList(),
        ),
      ),
    );
  }

  Widget _item(_BarrageType type, void Function(double, double) callBack) {
    return _BarrageItem(
      aniKey: type.index,
      text: _text(),
      time: type.time,
      callBack: callBack,
    );
  }
}

class _BarrageType {
  final int index;
  final int time;
  _BarrageType(this.index, this.time);
  factory _BarrageType.empty() {
    return _BarrageType(-1, 0);
  }
}

class _BarrageItem extends StatelessWidget {
  // final double start;
  final int aniKey;
  final String text;
  final int time;
  final void Function(double, double) callBack;
  const _BarrageItem({required this.aniKey, required this.text, required this.time, required this.callBack});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, type) {
      final width = 0.0.obs;
      return AfterLayout(
        callback: (RenderAfterLayout ral) {
          width.value = ral.size.width;
          if (aniKey >= 0) {
            callBack(context.width, ral.size.width);
          }
        },
        child: _switcher(context.width, width),
      );
    });
  }

  Widget _switcher(double total, Rx<double> width) {
    final key = Key(aniKey.toString());
    return Obx(() {
      var tween = Tween<Offset>(begin: Offset.zero, end: Offset(-(total / width.value + 1), 0));
      return Transform.translate(
        offset: Offset(total, 0),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: time),
          transitionBuilder: (child, animation) {
            if (child.key != key || aniKey < 0) {
              return const SizedBox();
            }
            return SlideTransition(
              position: tween.animate(animation),
              child: child,
            );
          },
          child: _item(key),
        ),
      );
    });
  }

  Widget _item(Key key) {
    return Container(
      key: key,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      height: 49.h,
      decoration: BoxDecoration(
        color: const Color(0x4CE9DEFF),
        borderRadius: BorderRadius.circular(24.5.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/cp_heart.png', width: 38.h, height: 33.h),
          SizedBox(width: 7.h),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogReceive extends StatelessWidget with _DialogMixin, _ItemContent {
  ActivityGetPaperBeanData get model => c.getPaperItem;
  @override
  Widget build(BuildContext context) {
    final isShort = model.img_url.isEmpty;
    return content(
      height: isShort ? 620.w : 804.w,
      bg: isShort ? 'cp_choudao' : 'cp_choudao2',
      btn: '立即私聊',
      action: () => c.action(() async {
        Get.off(ChatPage(
          nickName: model.nickname,
          otherUid: model.uid.toString(),
          otherImg: model.avatar,
        ));
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 56.w),
          _head(),
          Padding(
            padding: EdgeInsets.only(top: 55.w),
            child: Text(
              model.content,
              style: TextStyle(
                color: const Color(0xFF212121),
                fontSize: 30.sp,
              ),
              maxLines: 2,
            ),
          ),
          if (!isShort) Expanded(child: Align(alignment: Alignment.bottomLeft, child: itemContent(model))),
        ],
      ),
    );
  }

  Widget _head() {
    return Row(
      children: [
        UserFrameHead(size: 120.w, avatar: model.avatar),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.nickname,
                style: TextStyle(
                  color: const Color(0xFF212121),
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 16.w),
              Row(
                children: [
                  UserGenderCircle(size: 24.w, gender: model.gender),
                  Container(
                    width: 59.w,
                    height: 26.w,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 7.w),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(66, 218, 169, 165),
                      borderRadius: BorderRadius.circular(13.w),
                    ),
                    child: Text(
                      '${model.age}岁',
                      style: TextStyle(
                        color: const Color(0xFFFF1313),
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DialogSend extends StatelessWidget with _DialogMixin {
  final MakefriendsController c = Get.find();
  @override
  Widget build(BuildContext context) {
    return content(
      height: 652.w,
      bg: 'cp_fangru',
      btn: '确认放入',
      action: () => c.action(() async {
        if (await c.postActivityPutPaper()) {
          Get.back(result: true);
        }
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textField(),
          Padding(
            padding: EdgeInsets.only(left: 21.w, top: 24.w, bottom: 15.w),
            child: Text(
              '放张照片更容易吸引Ta',
              style: TextStyle(
                color: const Color(0xFFC0BFBF),
                fontSize: 24.sp,
              ),
            ),
          ),
          _content(),
        ],
      ),
    );
  }

  Widget _textField() {
    const border = OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
    return Container(
      width: double.infinity,
      height: 180.w,
      padding: EdgeInsets.symmetric(vertical: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: TextField(
        controller: c.textController,
        maxLength: 30,
        maxLines: 8,
        style: TextStyle(color: const Color(0xFF666666), fontSize: 30.sp),
        decoration: InputDecoration(
          hintText: '写下你想说的话，放入盒子...',
          hintStyle: TextStyle(color: const Color(0xFFC0BFBF), fontSize: 30.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 23.w),
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: border,
        ),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _content() {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(20.w),
      ),
      clipBehavior: Clip.hardEdge,
      child: Obx(() {
        final pickerItem = c.pickerItem;
        if (pickerItem == null) {
          return GestureDetector(
            onTap: () => c.action(() {
              Get.bottomSheet(GetPickSheet(list: [
                GetPickSheetItem(
                  title: '拍照',
                  action: () => c.action(() {
                    Get.back();
                    c.picker.onTapPickFromCamera((id, file) {
                      c.pick(id, file, false);
                    });
                  }),
                ),
                GetPickSheetItem(
                  title: '相册',
                  action: () => c.action(() {
                    Get.back();
                    c.picker.onTapPickFromGallery(1, (ids, files) {
                      if (ids.isEmpty || files.isEmpty) return;
                      c.pick(ids.first, files.first, false);
                    });
                  }),
                ),
                GetPickSheetItem(
                  title: '视频',
                  action: () => c.action(() {
                    Get.back();
                    c.picker.onTapVideoFromGallery((id, file) {
                      c.pick(id, file, true);
                    });
                  }),
                ),
              ]));
            }),
            child: Container(
              width: 120.w,
              height: 120.w,
              padding: EdgeInsets.all(37.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE7E7E7),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Image.asset('assets/images/cp_add.png'),
            ),
          );
        }
        final videoController = c.videoController?..initialize();
        return Stack(
          alignment: Alignment.center,
          children: [
            if (videoController != null)
              SizedBox(
                width: 120.w,
                height: 120.w,
                child: AspectRatio(
                  aspectRatio: videoController.value.aspectRatio,
                  child: VideoPlayer(videoController),
                ),
              ),
            if (pickerItem.isVideo)
              GestureDetector(
                onTap: () => c.action(() {
                  Get.to(PagePreviewVideo(url: pickerItem.file.path), opaque: false);
                }),
                child: Icon(
                  Icons.play_circle_fill_outlined,
                  color: Colors.white,
                  size: 50.w,
                ),
              )
            else
              Image.file(
                pickerItem.file,
                width: 120.w,
                height: 120.w,
                fit: BoxFit.cover,
              ),
            Positioned(
              right: 3.w,
              top: 3.w,
              child: GestureDetector(
                onTap: c.pickClear,
                child: ClipOval(
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                    padding: EdgeInsets.all(5.w),
                    child: Icon(
                      Icons.close,
                      size: 20.w,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

mixin _DialogMixin {
  Widget content({required double height, required String bg, required String btn, void Function()? action, required Widget child}) {
    return Center(
      child: Container(
        width: 620.w,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/$bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 45.w,
              right: 45.w,
              top: 115.w,
              bottom: 156.w,
              child: child,
            ),
            GestureDetector(
              onTap: action,
              child: Container(
                width: 442.w,
                height: 112.w,
                padding: EdgeInsets.only(bottom: 29.w),
                margin: EdgeInsets.only(bottom: 25.w),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cp_btn_bg.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Text(
                  btn,
                  style: TextStyle(color: Colors.white, fontSize: 30.sp),
                ),
              ),
            ),
            Positioned(
              top: 32.w,
              right: 33.w,
              width: 27.w,
              height: 27.w,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset('assets/images/cp_close.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 620.w,
        height: 760.w,
        padding: EdgeInsets.only(left: 33.w, right: 33.w, top: 33.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.w),
        ),
        child: Column(
          children: [
            _nav(),
            SizedBox(height: 20.w),
            Text(
              _text,
              style: TextStyle(
                fontSize: 17.sp,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nav() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '说明',
            style: TextStyle(
              fontSize: 33.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: Image.asset('assets/images/cp_close.png', width: 27.w, height: 27.w),
        ),
      ],
    );
  }

  final _text = '''
一、游戏简介
你准备好探索未知的交友世界了吗？欢迎来到纸条交友游戏，一个充满神秘与期待的社交平台。在这里，你将有机会抽取来自不同用户的神秘小纸条，同时也有机会让你的小纸条落入他人的手中。但请记住，这是一个充满未知的游戏，你无法预知会抽到谁的小纸条，也无法知道你的小纸条会被谁所发现。
二、真诚交友，认真对待
我们鼓励每一位玩家以真诚的态度参与游戏。当你准备放入小纸条时，请务必认真填写内容，让接收者能够通过你的文字更深入地了解你。乱填或虚假的信息不仅会被视为无效，也是对他人时间的不尊重。
三、真实交友，费用机制
为了确保交友信息的真实性和质量，我们设置了费用机制。当你每天抽放纸条的次数超过3次后，需要支付一定的费用。这样做的目的是为了提高参与门槛，筛选出真正有诚意和需求的用户。
四、信息甄别，保护自我
虽然我们希望每一位玩家都能以真诚的态度参与游戏，但我们也必须提醒你，我们无法保证所有纸条内容的真实性。在与其他玩家交流时，请务必保持警惕，仔细甄别信息。切勿轻易进行转账或其他涉及金钱的交易，以防被骗。
五、祝福与期待
最后，我们衷心祝愿你能在这个纸条交友游戏中收获一段美好的姻缘或深厚的友谊。但请记住，交友需要时间和耐心，不要急于求成。慢慢来，享受这个过程，也许你会发现更多的惊喜和可能。
''';
}

class _BottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(30.w);
    final MakefriendsController c = Get.find();
    return Container(
      width: double.infinity,
      height: 854.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      child: Obx(() {
        switch (c.cpSelect) {
          case 1:
            return _BottomSheetItem1();
          default:
            return _BottomSheetItem0();
        }
      }),
    );
  }
}

class _BottomSheetItem0 extends StatelessWidget with _BottomSheetPositionedMixin {
  @override
  Widget build(BuildContext context) {
    final MakefriendsController c = Get.find();
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        positioned('cp_btn_shoudao_1', Rect.fromLTWH(42.w, -31.w, 335.w, 154.w)),
        positioned('cp_btn_fangru_0', Rect.fromLTWH(449.w, 21.w, 196.w, 29.w), () => c.setCpSelect(1)),
        Positioned(
          top: 123.w,
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomSheetList(0),
        ),
      ],
    );
  }
}

class _BottomSheetItem1 extends StatelessWidget with _BottomSheetPositionedMixin {
  @override
  Widget build(BuildContext context) {
    final MakefriendsController c = Get.find();
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        positioned('cp_btn_fangru_1', Rect.fromLTWH(377.w, -31.w, 335.w, 154.w)),
        positioned('cp_btn_shoudao_0', Rect.fromLTWH(114.w, 21.w, 196.w, 29.w), () => c.setCpSelect(0)),
        Positioned(
          top: 123.w,
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomSheetList(1),
        ),
      ],
    );
  }
}

mixin _BottomSheetPositionedMixin {
  Widget positioned(String img, Rect rect, [void Function()? action]) {
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: GestureDetector(
        onTap: action,
        child: Image.asset('assets/images/$img.png'),
      ),
    );
  }
}

class _BottomSheetList extends StatelessWidget with _ItemContent {
  final int type;
  _BottomSheetList(this.type);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final length = c.getLength(type);
      return Stack(
        children: [
          if (length == 0) _null(),
          SmartRefresher(
            header: MyUtils.myHeader(),
            footer: MyUtils.myFotter(),
            controller: c.paperController(type),
            enablePullUp: true,
            enablePullDown: true,
            onLoading: () => c.onLoading(type),
            onRefresh: () => c.onRefresh(type),
            child: length > 0
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 41.w),
                    itemBuilder: _builder,
                    itemCount: length,
                  )
                : null,
          ),
        ],
      );
    });
  }

  Widget _null() {
    return Center(
      child: Container(
        width: 406.w,
        height: 281.w,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 38.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cp_null.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Text(
          '暂无纸条',
          style: TextStyle(
            color: const Color(0xFFADA5A5),
            fontSize: 30.w,
          ),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, int index) {
    final item = c.paperList(type)[index];
    return Container(
      width: double.infinity,
      // height: 438.w,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
      margin: EdgeInsets.only(bottom: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type == 0) _head(),
          Padding(
            padding: EdgeInsets.only(top: 18.w),
            child: Text(
              item.content,
              style: TextStyle(
                color: const Color(0xFF212121),
                fontSize: 30.sp,
              ),
            ),
          ),
          if (item.img_url.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 27.w),
              child: itemContent(item),
            ),
          Padding(
            padding: EdgeInsets.only(top: 24.w, bottom: 8.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.add_time,
                    style: TextStyle(
                      color: const Color(0xFF999999),
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                if (type == 1)
                  GestureDetector(
                    onTap: () => c.onItemDelete(item.id),
                    child: Text(
                    '删除',
                    style: TextStyle(
                      color: const Color(0xFFFF6666),
                      fontSize: 20.sp,
                    ),
                  ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _head() {
    return Row(
      children: [
        UserFrameHead(size: 80.w, avatar: sp.getString('user_headimg').toString()),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '小美',
                  style: TextStyle(
                    color: const Color(0xFF212121),
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(height: 8.w),
                Row(
                  children: [
                    UserGenderCircle(size: 24.w, gender: 0),
                    Container(
                      width: 59.w,
                      height: 26.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 7.w),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(66, 218, 169, 165),
                        borderRadius: BorderRadius.circular(13.w),
                      ),
                      child: Text(
                        '22岁',
                        style: TextStyle(
                          color: const Color(0xFFFF1313),
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            width: 120.w,
            height: 54.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFDDCF3),
              borderRadius: BorderRadius.circular(27.w),
            ),
            child: Text(
              '私聊',
              style: TextStyle(
                color: const Color(0xFFF13737),
                fontSize: 24.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

mixin _ItemContent {
  final MakefriendsController c = Get.find();
  Widget itemContent(ActivityGetPaperBeanData model) {
    return Container(
      width: 180.w,
      height: 180.w,
      margin: EdgeInsets.only(bottom: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(20.w),
      ),
      clipBehavior: Clip.hardEdge,
      child: model.type == 2 ? _showVideo(model) : _showImag(model),
    );
  }
  
  Widget _showVideo(ActivityGetPaperBeanData model) {
    final videoController = VideoPlayerController.networkUrl(Uri.parse(model.img_url));
    videoController.initialize();
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 180.w,
          height: 180.w,
          child: AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController),
          ),
        ),
        GestureDetector(
          onTap: () => c.action(() {
            Get.to(PagePreviewVideo(url: model.img_url), opaque: false);
          }),
          child: Icon(
            Icons.play_circle_fill_outlined,
            color: Colors.white,
            size: 70.w,
          ),
        )
      ],
    );
    }

  ///显示图片
  Widget _showImag(ActivityGetPaperBeanData model) {
    return GestureDetector(
      onTap: () => c.action(() {
        Get.to(SwiperPage(imgList: [model.img_url]), opaque: false);
      }),
      child: CachedNetworkImage(
        imageUrl: model.img_url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Image.asset(
          'assets/images/img_placeholder.png',
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) {
          Get.log('加载错误提示 $error');
          return Image.asset(
            'assets/images/img_placeholder.png',
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}