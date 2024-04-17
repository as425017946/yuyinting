import 'package:get/get.dart';

import '../../../utils/getx_tools.dart';

class HapplyWallController extends GetxController with GetAntiCombo {
  final _text = ''.obs;
  String get text => _text.value;
  final _list = [].obs;
  bool get isShow => _text.isNotEmpty || _list.isNotEmpty;

  @override
  void onReady() {
    _list.value = ['A送B瑞林X10', 'A送B飞虎X20'];
    _loop();
    super.onReady();
  }

  void _loop() async {
    await Future.delayed(const Duration(seconds: 5));
    if (_text.isNotEmpty) {
      _list.add(_text.value);
    }
    if (_list.isNotEmpty) {
      _text.value = _list.removeAt(0);
    }
    _loop();
  }
}