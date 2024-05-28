import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../bean/roomInfoBean.dart';
import '../../../utils/getx_tools.dart';
import '../room_items.dart';

class RoomChatController extends GetxController with GetAntiCombo {
  late final ScrollController scrollController = ScrollController();
  String roomId = '';
  List<Map> list = [];
  List<MikeList> listm = [];

  @override
  void onReady() {
    super.onReady();
  }

  void scrollToLastItem() {
    Get.log('加载完成//////');
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void scrollToEnd() {
    try {
      if (list.isNotEmpty) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  Widget itemBuilder(BuildContext context, int i) {
    return RoomItems.itemMessages(context, i, roomId, list, listm);
  }
}