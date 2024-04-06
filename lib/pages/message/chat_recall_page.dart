import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/my_utils.dart';

mixin MsgReadText {
  Widget msgReadText(int msgRead) {
    switch (msgRead) {
      case 1:
        return Text(
          '已读',
          style: TextStyle(
            color: Colors.green,
            fontSize: ScreenUtil().setSp(20),
          ),
        );
      case 2:
        return Text(
          '未读',
          style: TextStyle(
            color: Colors.grey,
            fontSize: ScreenUtil().setSp(20),
          ),
        );
      default:
        return const Text('');
    }
  }

  void Function()? onImgLongPress(BuildContext context, params) {
    return (() {
      // MyUtils.recallMessage(params);
      // Future.delayed(const Duration(seconds: 0), () {
      //   Navigator.of(context).push(PageRouteBuilder(
      //       opaque: false,
      //       pageBuilder: (context, animation, secondaryAnimation) {
      //         return ChatRecallPage(params: params);
      //       }));
      // });
      Get.bottomSheet(ChatRecallPage(params: params));
    });
  }
}

class ChatRecallPage extends StatelessWidget {
  final dynamic params;
  const ChatRecallPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Get.bottomBarHeight + 180.w,
      color: Colors.white,
      child: Column(
        children: [
          _btn('撤  回', () {
            MyUtils.recallMessage(params);
            Navigator.pop(context);
          }),
          Container(
            width: double.infinity,
            height: 20.w,
            color: const Color(0xFFF5F5F5),
          ),
          _btn('取  消', () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
    // return Stack(
    //   children: [
    //     GestureDetector(
    //       onTap: () {
    //         Navigator.pop(context);
    //       },
    //       child: Container(
    //         width: double.infinity,
    //         height: double.infinity,
    //         color: Colors.black45,
    //       ),
    //     ),
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         _btn('撤  回', () {
    //           MyUtils.recallMessage(params);
    //           Navigator.pop(context);
    //         }),
    //         Container(
    //           width: double.infinity,
    //           height: 20.w,
    //           color: const Color(0xFFF5F5F5),
    //         ),
    //         _btn('取  消', () {
    //           Navigator.pop(context);
    //         }),
    //         Container(
    //           width: double.infinity,
    //           height: MediaQuery.of(context).viewInsets.bottom,
    //           color: Colors.white,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  Widget _btn(String title, void Function() action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        height: 80.w,
        color: Colors.white,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 35.sp,
            ),
          ),
        ),
      ),
    );
  }
}
