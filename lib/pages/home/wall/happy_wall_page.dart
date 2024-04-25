import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../utils/getx_tools.dart';
import '../../../utils/loading.dart';
import 'happy_wall_model.dart';

class HappyWallBanner extends StatelessWidget {
  HappyWallBanner({super.key});
  final HapplyWallController c = Get.find();

  @override
  Widget build(BuildContext context) { // 994*156
    final double width = 750.w - 20;
    final double height = width*156.0/994.0;
    return GestureDetector(
      onTap: () => c.action(() {
        Get.to(HappyWallPage());
      }),
      child: Obx(() => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 30.w),
        height: c.isShow ? height : 0,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/happy_wall_flag.png'), fit: BoxFit.fill,)
        ),
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(child: _animate(_builder)),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 26.w,
            ),
          ],
        ),
      )),
    );
  }

  Widget _builder(HapplyWallItem item) {
    const style = TextStyle(color: Colors.purple);
    return FittedBox(
      fit: BoxFit.fitWidth,
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 650.w),
        child: Text.rich(
          TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 26.sp
            ),
            children: [
              TextSpan(
                text: item.from_nickname,
                style: style,
              ),
              const TextSpan(text: ' 送给了 '),
              TextSpan(
                text: '${item.to_nickname} ${item.gift_name}x${item.number}',
                style: style,
              ),
              const TextSpan(text: ' 去围观'),
            ]
          ),
         ),
      ),
    )
    ;
  }
  Widget _animate(Widget Function(HapplyWallItem) builder) {
    return Obx(() {
      final item = c.item;
      if (item == null) {
        return const Text('');
      }
      return AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (child, animation) {
          if (c.isFirstRun) {
            return child;
          }
          final double start = animation.isDismissed ? 1 : -1;
          var tween = Tween<Offset>(begin: Offset(0, start), end: Offset.zero);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: tween.animate(animation),
              child: child,
            ),
          );
        },
        child: SizedBox(
          key: Key(item.id.toString()),
          height: 40.w,
          child: builder(item),
        ),
      );
    });
  }
}

class HappyWallPage extends StatelessWidget {
  HappyWallPage({super.key});

  final HapplyWallController c = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: (() {
            Loading.dismiss();
            Get.back();
          }),
        ),
        centerTitle: true,
        title: Text(
          "幸福墙",
          style: TextStyle(
            color: Colors.black,
            fontSize: 34.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/happy_wall_bj.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 290.w),
        child: _list(),
      ),
    );
  }

  Widget _list() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.w),
      itemBuilder: _builder,
      itemCount: 10,
    );
  }

  Widget _builder(BuildContext context, int index) {
    final img = 'assets/images/happy_wall_box_${index%2 + 1}.png';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.w),
      height: 404.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(img),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _head(sp.getString('user_headimg').toString(), '骄阳骄阳骄阳骄阳骄阳骄阳骄阳骄阳骄阳', 1),
              SizedBox(width: 189.w),
              _head(sp.getString('user_headimg').toString(), '骄阳', 0),
            ],
          ),
          SizedBox(height: 30.w),
          _text(),
        ],
      ),
    );
  }

  Widget _head(String avatar, String name, int gender) {
    return Container(
      width: 200.w,
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          UserFrameHead(size: 125.w, avatar: avatar),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 168.w),
                child: Text(
                name,
                style: TextStyle(
                  color: const Color(0xFF181926),
                  fontSize: 21.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              ),
              SizedBox(width: 8.w),
              UserGenderCircle(size: 24.w, gender: gender),
            ],
          )
        ],
      ),
    );
  }

  Widget _text() {
    return Container(
      height: 30.w,
      margin: EdgeInsets.fromLTRB(60.w, 0, 60.w, 60.w),
      child: Text.rich(
        TextSpan(
          text: '2024-04-15 送出了',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Arial',
            fontSize: 21.sp,
          ),
          children: [
            TextSpan(
              text: '锡纸城堡',
              style: TextStyle(
                color: const Color(0xFF8B2BE7),
                fontFamily: 'Arial',
                fontSize: 21.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}