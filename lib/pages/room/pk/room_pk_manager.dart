import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/getx_tools.dart';
import 'room_pk_component.dart';


extension RoomPkImageName on String {
  String get pkSvga => 'assets/跨房PK/$this.svga';
  String get pkIcon => 'assets/跨房PK/icon/$this.png';
  String get pkGifSuccess => 'assets/跨房PK/胜利表情包/$this.gif';
  String get pkGifFailure => 'assets/跨房PK/失败者表情/$this.gif';
}

class RoomPkGif {
  static String get success => _success[Random().nextInt(_success.length)].pkGifSuccess;
  static final List<String> _success = [
    '01d2bf62284fc111013f01cd10ed5b',
    '01ed8162284fc211013f01cd728979',
    '014ebd62284fc211013e8cd0ede369',
    '01326862284fca11013f01cdb39cbc',
  ];
  
  static String get failure => _failure[Random().nextInt(_failure.length)].pkGifFailure;
  static final List<String> _failure = [
    '01b6365e0b5fc5a801216518e0d30d',
    '012e2c5e0b5fdca80120a8954e364e',
    '017de25e0b5fcfa801216518340e4c',
    '0191de5e0b5fa8a8012165183e1a93',
  ];
}

class RoomPkManager {
  final _ = Get.lazyPut(() => RoomPKController());

  void onChaoFeng(void Function() callBack) async {
    final back = await Get.dialog(const RoomPkChaoFengPage());
    if (back is bool && back) {
      callBack();
    }
  }

  void onPiPei(void Function() callBack) async {
    final back = await Get.bottomSheet(const RoomPkPiPeiPage());
    if (back is bool && back) {
      callBack();
    }
  }
}

class RoomPKController extends GetxController with GetAntiCombo {
  @override
  void onClose() {
    super.onClose();
    timerStop();
  }

  final _isPipei = false.obs;
  bool get isPipei => _isPipei.value;
  final _pipeiTime = 0.obs;
  int get pipeiTime => _pipeiTime.value;
  final _pkTime = 15.obs;
  int get pkTime => _pkTime.value;
  Timer? _timer;
  void timerStop() {
    _isPipei.value = false;
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }
  void onPipei() {
    action(() {
      if (_isPipei.value) {
        timerStop();
      } else {
        _pipeiTime.value = 0;
        _isPipei.value = true;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          ++_pipeiTime.value;
        });
      }
    });
  }

  final List<int> sTimes = [5, 15, 30, 60];
  void onTime(int value) {
    _pkTime.value = value;
  }
  final sIsYq = false.obs;
  void onYq(bool value) {
    sIsYq.value = value;
  }
  final sIsPp = false.obs;
  void onPp(bool value) {
    sIsPp.value = value;
  }

  TextEditingController textController = TextEditingController();
  final _searchItem = ''.obs;
  String get searchItem => _searchItem.value;
  void onSearch([_]) {
    hideKeyboard();
    _searchItem.value = textController.text;
  }
}