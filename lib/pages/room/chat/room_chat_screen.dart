import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';

import 'room_chat_model.dart';

class RoomChatScreen extends StatelessWidget {
  const RoomChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RoomChatController c = Get.find();
    return FocusDetector(
      onFocusGained: c.scrollToEnd,
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 10.h,
          left: 20.h,
        ),
        itemBuilder: c.itemBuilder,
        controller: c.scrollController,
        itemCount: c.list.length,
      ),
    );
  }
}