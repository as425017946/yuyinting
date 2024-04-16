import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/loading.dart';
import 'happy_wall_model.dart';

class HappyWallBanner extends StatelessWidget {
  HappyWallBanner({super.key});
  final c = Get.put(HapplyWallController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => c.action(() {
        Get.to(HappyWallPage());
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(20.w),
        height: c.isShow ? 100.w : 0,
        color: Colors.red,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(child: _animate(_builder)),
            Container(
              width: 10.w,
              height: 30.w,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _builder(dynamic item) {
    return Row(
      children: [
         Text(item),
      ],
    );
  }
  Widget _animate(Widget Function(dynamic) builder) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (child, animation) {
          final double start = animation.isDismissed ? -1 : 1;
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
          key: Key(c.text),
          child: builder(c.text),
        ),
      ),
    );
  }
}

class HappyWallPage extends StatelessWidget {
  HappyWallPage({super.key});

  final HapplyWallController c = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true, //设置为true时，当SliverAppBar内容滑出屏幕时，将始终渲染一个固定在顶部的收起状态
            expandedHeight: 100,
            collapsedHeight: 56,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.pink,
              ),
            ),
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
                fontSize: 33.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(_content, childCount: 1),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, int index) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemBuilder: _builder,
        itemCount: 20,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _builder(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 120,
      color: Colors.blue,
    );
  }
}