import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BigClientController extends GetxController {
  var dayBean = '96006'.obs;
  var dayExp = '996'.obs;
  var weekBean = '96006'.obs;
  var weekExp = '996'.obs;
  var monthBean = '96006'.obs;
  var monthExp = '996'.obs;
  PageController controller = PageController();
  void onPageChanged(int value) {}
}
