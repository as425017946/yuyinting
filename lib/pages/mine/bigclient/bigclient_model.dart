import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';

class BigClientController extends GetxController {
  var dayBean = '96006'.obs;
  var dayExp = '996'.obs;
  var weekBean = '96006'.obs;
  var weekExp = '996'.obs;
  var monthBean = '96006'.obs;
  var monthExp = '996'.obs;
  var ryz = '荣耀值:0'.obs;
  var select = 0.obs;
  var current = 0.obs;
  late String avatarFrameGifImg, avatarFrameImg, level;
  final List<String> texts = ['曜星', '苍穹', '皓月', '辉耀', '星华', '天域', '银河', '至尊'];
  final List<String> exps = [
    '200',
    '200',
    '200',
    '200',
    '200',
    '200',
    '200',
    '200'
  ];
  var success =
      ['VIP1', 'VIP2', 'VIP3', 'VIP4', 'VIP5', 'VIP6', 'VIP7', 'VIP8'].obs;

  late PageController controller = PageController(initialPage: select.value);
  late SwiperController swiperController = SwiperController();

  void onPageChanged(int value) {
    select.value = value;
  }

  void onLeft() {
    controller.jumpToPage(0);
  }

  void onRight() {
    controller.jumpToPage(1);
  }

  void onIndexChanged(int value) {
    current.value = value;
    // swiperController.move(value);
  }
}
