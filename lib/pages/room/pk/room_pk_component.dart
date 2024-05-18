import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';

import 'room_pk_manager.dart';

class RoomPkChaoFengPage extends StatelessWidget {
  const RoomPkChaoFengPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 646.w,
        height: 782.w,
        padding: EdgeInsets.all(58.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('pk_ridicule_bg'.pkIcon),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '消耗500钻可向对方房间发起嘲讽60秒并增加我方500PK值，且我方房间本场PK发起嘲讽达10次，可扣除对方本场100PK值',
              style: TextStyle(
                fontSize: 25.5.sp,
                color: Colors.white,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 58.w),
            _btn(),
          ],
        ),
      ),
    );
  }

  Widget _btn() {
    final RoomPKController c = Get.find();
    return GestureDetector(
      onTap: () => c.action(() {
        Get.back(result: true);
      }),
      child: Container(
        width: 303.w,
        height: 81.w,
        padding: EdgeInsets.only(top: 10.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('pk_bg_btn'.pkIcon),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '发起嘲讽',
              style: TextStyle(
                fontSize: 30.w,
                color: Colors.white,
                height: 1,
              ),
            ),
            Text(
              '500钻石',
              style: TextStyle(
                fontSize: 18.w,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomPkPiPeiPage extends StatelessWidget {
  const RoomPkPiPeiPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final RoomPKController c = Get.find();
    return FocusDetector(
      onFocusLost: c.timerStop,
      child: _content(c),
    );
  }
  Widget _content(RoomPKController c) {
    return  Container(
      height: 856.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('pk_match_bg2'.pkIcon),
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Column(
        children: [
          _nav(c),
          _pipei(c),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                _null(),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pipei(RoomPKController c) {
    return Container(
      width: 670.w,
      height: 243.w,
      padding: EdgeInsets.only(top: 32.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('pk_match_bg1'.pkIcon),
        ),
      ),
      child: Column(
        children: [
          Image.asset('pk_match_random'.pkIcon, width: 155.w, height: 37.w),
          Container(
            height: 78.w,
            alignment: Alignment.center,
            child: Obx(
              () => Text(
                  c.isPipei ? '正在匹配中...${c.pipeiTime}s' : '随机匹配默认每局PK为${c.pkTime}分钟',
                  style: TextStyle(
                    color: const Color(0xFFFFF9D5),
                    fontSize: 30.sp,
                  ),
                ),
            ),
          ),
          GestureDetector(
            onTap: c.onPipei,
            child: Container(
              width: 273.w,
              height: 76.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('pk_bg_btn'.pkIcon),
                ),
              ),
              child: Obx(
                () => Text(
                  c.isPipei ? '取      消' : '开始匹配',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _null() {
    return Center(
      child: Container(
        width: 400.w,
        height: 400.w,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 50.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('pk_null'.pkIcon),
            fit: BoxFit.contain,
          ),
        ),
        child: Text(
          '暂无可PK房间',
          style: TextStyle(
            color: const Color(0xFFADA5A5),
            fontSize: 24.w,
          ),
        ),
      ),
    );
  }

  Widget _nav(RoomPKController c) {
    return Container(
      height: 68.w,
      margin: EdgeInsets.only(top: 76.w),
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _help(c),
                _search(c),
                const Spacer(),
                _setting(c),
              ],
            ),
          ),
          _state(c),
        ],
      ),
    );
  }

  Widget _help(RoomPKController c) {
    return GestureDetector(
      onTap: ()=> c.action(() {
        Get.dialog(const _ShuoMing());
      }),
      child: Image.asset('pk_match_help'.pkIcon, width: 37.w, height: 37.w),
    );
  }
  Widget _search(RoomPKController c) {
    return GestureDetector(
      onTap: () => c.action(() async {
        final back = await Get.dialog(const _Search());
        if (back is bool && back) {
          Get.back(result: true);
        }
      }),
      child: Container(
        width: 103.w,
        height: 34.w,
        margin: EdgeInsets.only(left: 17.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(17.w)),
        child: Row(
          children: [
            Image.asset('assets/images/sousuo.png', width: 24.w, height: 24.w),
            SizedBox(width: 5.w),
            Text(
              '搜索',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _setting(RoomPKController c) {
    return GestureDetector(
      onTap: () => c.action(() {
        Get.dialog(const _Setting());
      }),
      child: Row(
        children: [
          Image.asset('pk_match_set'.pkIcon, width: 30.w, height: 30.w),
          SizedBox(width: 5.w),
          Text(
            '设置',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _state(RoomPKController c) {
    return Obx(
      () => Image.asset(
        'pk_match_${c.isPipei ? 'matching' : 'waiting'}'.pkIcon,
        fit: BoxFit.contain,
        width: 116.w,
        height: 34.w,
      ),
    );
  }
}

class _ShuoMing extends StatelessWidget {
  const _ShuoMing();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 642.w,
        height: 679.w,
        padding: EdgeInsets.fromLTRB(62.w, 170.w, 62.w, 116.w),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('pk_help_bg'.pkIcon), fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            _text(),
            const Spacer(),
            _btn(),
          ],
        ),
      ),
    );
  }

  Widget _text() {
    return Text(
      '1.房间对战所有类型房间均可开启，仅该房间会长、厅主和管理员可以发起PK；\n\n2.发起房间PK和被邀请PK的房间需满足在麦人数≥3人，且主持位有人。',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
        height: 1.8,
      ),
    );
  }

  Widget _btn() {
    final RoomPKController c = Get.find();
    return GestureDetector(
      onTap: () => c.action(() {
        Get.back();
      }),
      child: Container(
        width: 303.w,
        height: 81.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('pk_bg_btn'.pkIcon),
          ),
        ),
        child: Text(
          '知道了',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
          ),
        ),
      ),
    );
  }
}

class _Setting extends StatelessWidget {
  const _Setting();
  @override
  Widget build(BuildContext context) {
    final RoomPKController c = Get.find();
    final style = TextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.w500);
    return Center(
      child: Container(
        width: 642.w,
        height: 802.w,
        padding: EdgeInsets.fromLTRB(51.w, 139.w, 51.w, 45.w),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('pk_set_bg'.pkIcon), fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            _time(c, style),
            _content(Text('接受PK邀请', style: style), c.sIsYq, c.onYq),
            _content(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('随机匹配', style: style),
                  Text(
                    '开启后，将可能被其他房间匹配自动开启PK',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 19.sp,
                    ),
                  ),
                ],
              ),
              c.sIsPp,
              c.onPp,
            ),
            const Spacer(),
            _btn(c),
          ],
        ),
      ),
    );
  }

  Widget _time(RoomPKController c, TextStyle style) {
    return _bg(
      260.w,
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('发起PK时长', style: style),
          SizedBox(height: 20.w),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 21.w,
              crossAxisSpacing: 24.w,
              childAspectRatio: 220.0 / 60.0,
            ),
            itemCount: c.sTimes.length,
            itemBuilder: _builder,
          ),
        ],
      ),
    );
  }
  Widget _builder(BuildContext context, int index) {
    final RoomPKController c = Get.find();
    final item = c.sTimes[index];
    final Widget text = Text(
      '$item分钟',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30.sp,
        fontWeight: FontWeight.w500,
      ),
    );
    return GestureDetector(
      onTap: () => c.onTime(item),
      child: Obx(() {
        final isSelect = item == c.pkTime;
        final bg = isSelect ? const Color(0xFFB26FEF) : const Color(0xFFF9F9F9).withOpacity(0.3);
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10.w),
            border: isSelect ? Border.all(width: 2.w, color: const Color(0xFFF9F9F9)) : null,
          ),
          alignment: Alignment.center,
          child: text,
        );
      }),
    );
  }

  Widget _content(Widget child, Rx<bool> isOpen, ValueChanged<bool> onChanged) {
    return _bg(
      100.w,
      Row(
        children: [
          Expanded(child: child),
          Transform.translate(
            offset: Offset(26.w, 0),
            child: SizedBox(
              width: 100.w,
              child: FittedBox(
                child: Obx(() => Switch(value: isOpen.value, onChanged: onChanged)),
              ),
            ),
          ),
        ],
      ),
      EdgeInsets.only(top: 26.w),
    );
  }

  Widget _bg(double height, Widget child, [EdgeInsets? margin]) {
    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 36.w),
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9).withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.w),
      ),
      child: child,
    );
  }

  Widget _btn(RoomPKController c) {
    return GestureDetector(
      onTap: () => c.action(() {
        Get.back();
      }),
      child: Container(
        width: 303.w,
        height: 81.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('pk_bg_btn'.pkIcon),
          ),
        ),
        child: Text(
          '确定',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
          ),
        ),
      ),
    );
  }
}

class _Search extends StatelessWidget {
  const _Search();
  @override
  Widget build(BuildContext context) {
    final RoomPKController c = Get.find();
    final style = TextStyle(color: const Color(0xFF212121), fontSize: 30.sp, fontWeight: FontWeight.w500);
    return Center(
      child: GestureDetector(
        onTap: () => c.hideKeyboard(),
        child: Container(
          width: 642.w,
          height: 752.w,
          padding: EdgeInsets.fromLTRB(51.w, 132.w, 51.w, 44.w),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('pk_search_bg'.pkIcon), fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('房间号', style: style),
              ),
              _search(c),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('搜索结果', style: style),
              ),
              _result(c),
              const Spacer(),
              _btn(c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _result(RoomPKController c) {
    return Container(
      height: 165.w,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(top: 15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF3D01D3).withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.w),
      ),
      child: Obx(() {
        final item = c.searchItem;
        final Widget text;
        if (item.isEmpty) {
          text = Text(
            '暂无搜索结果',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 30.sp,
            ),
          );
        } else {
          text = Text(
            item,
            style: TextStyle(
              color: Colors.black,
              fontSize: 30.sp,
            ),
          );
        }
        return Row(
          children: [
            Container(
              width: 124.w,
              height: 124.w,
              margin: EdgeInsets.only(right: 40.w),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.w),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            text,
          ],
        );
      }),
    );
  }

  Widget _search(RoomPKController c) {
    const border = OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
    return Container(
      height: 100.w,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      margin: EdgeInsets.only(top: 17.w, bottom: 46.w),
      decoration: BoxDecoration(
        color: const Color(0xFF3D01D3).withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: c.textController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: border,
                enabledBorder: border,
                disabledBorder: border,
                focusedBorder: border,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: c.onSearch,
            ),
          ),
          _searchBtn(c),
        ],
      ),
    );
  }

  Widget _searchBtn(RoomPKController c) {
    return GestureDetector(
      onTap: c.onSearch,
      child: Container(
        width: 120.w,
        height: 46.w,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(23.w)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/sousuo.png', width: 24.w, height: 24.w),
            SizedBox(width: 5.w),
            Text(
              '搜索',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _btn(RoomPKController c) {
    return GestureDetector(
      onTap: () => c.action(() {
        Get.back(result: true);
      }),
      child: Container(
        width: 303.w,
        height: 81.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('pk_bg_btn'.pkIcon),
          ),
        ),
        child: Text(
          '邀请PK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
          ),
        ),
      ),
    );
  }

}

