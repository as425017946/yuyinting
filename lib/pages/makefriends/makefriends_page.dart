import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../../utils/getx_tools.dart';
import 'cp_speed_page.dart';
import 'makefriends_model.dart';

class DatingPage extends StatefulWidget {
  const DatingPage({Key? key}) : super(key: key);

  @override
  State<DatingPage> createState() => _DatingPageState();
}

class _DatingPageState extends State<DatingPage> {
  @override
  void initState() {
    Get.lazyPut(() => MakefriendsController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final MakefriendsController c = Get.find();
      switch (c.select) {
        case 1:
          return const CPSpeedPage();
        default:
          return MakefriendsPage();
      }
    });
  }
}

class MakefriendsPage extends StatelessWidget {
  final MakefriendsController c = Get.find();
  MakefriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: c.onAppear,
      onFocusLost: c.onDisAppear,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(top: 35, left: 28.w, right: 28.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/all_bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Obx(
          () => Column(
            children: [
              _nav(),
              _choose(),
              Expanded(
                child: c.list.isEmpty
                    ? _null()
                    : Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          _bottom(),
                          Expanded(child: _content()),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nav() {
    return Container(
      height: 60.w,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 25.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset('assets/images/makefriends_bhi.png', width: 160.w, height: 43.w),
          SizedBox(width: 44.w),
          GestureDetector(
            onTap: () => c.select = 1,
            child: Text(
              '告白纸条',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 33.sp,
                fontFamily: 'LR',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _choose() {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: c.onChoose,
          child: Obx(() => Image.asset('assets/images/makefriends_${c.gender != 1 ? 'nan' : 'nv'}.png', width: 122.w, height: 42.w,)),
        )
      ],
    );
  }

  Widget _content() {
    return Column(
      children: [
        Container(
          width: 600.w,
          height: 740.h,
          margin: EdgeInsets.only(top: 59.h, bottom: 30.h),
          child: _swiper(),
        ),
      ],
    );
  }

  Widget _null() {
    return Center(
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: c.isFirstLoading ? [] : [
            Image.asset('assets/images/guard_group_under_review.png', width: 200.w, height: 200.w),
            SizedBox(height: 20.w),
            Text(
              '没能匹配到合适人选',
              style: TextStyle(color: const Color(0xFFAFBACA), fontSize: 28.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _swiper() {
    return AppinioSwiper(
      key: Key(c.list.length.toString()),
      cardsCount: c.list.length,
      loop: true,
      cardsSpacing: -50.h,
      backgroundCardsCount: 2,
      padding: EdgeInsets.zero,
      onSwipe: c.onSwipe,
      cardsBuilder: _builder,
      onSwiping: c.onSwiping,
      onEnd: c.onSwipeEnd,
      onSwipeCancelled: c.onSwipeEnd,
    );
  }
  Widget _builder(BuildContext context, int index) {
    c.current = index;
    final item = c.list[index];
    return GestureDetector(
      onTap: () => c.onItem(item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.w)),
          color: Colors.white,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: item.avatar,
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
            Positioned(
              left: 30.w,
              bottom: 30.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nickname,
                    style: TextStyle(color: Colors.white, fontSize: 36.sp),
                  ),
                  if (item.label.isNotEmpty) _tag(item.label),
                  if (item.voice_card.isNotEmpty) _voice(item.voice_card),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String label) {
    return Row(
      children: label
          .split(',')
          .map(
            (e) => Container(
              height: 36.w,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              margin: EdgeInsets.only(top: 10.w, right: 10.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18.w)),
                color: Colors.black38,
              ),
              child: Text(
                e,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _voice(String voice) {
    return GestureDetector(
      onTap: () => c.onVoice(voice),
      child: Obx(() => VoiceCardBtn(isPlay: c.isPlaying == voice)),
    );
  }

  Widget _bottom() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: c.onTa,
            child: Container(
              width: 504.w,
              height: 106.w,
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SVGASimpleImage(assetsName: 'assets/svga/makefriends_selectta.svga'),
                  Text(
                    '选择TA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontFamily: 'LR',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.w),
          Text(
            '*封面仅为形象展示声音类型',
            style: TextStyle(
              color: const Color(0xFF999999),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}