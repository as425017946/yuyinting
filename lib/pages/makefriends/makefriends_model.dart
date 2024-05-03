import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';

import '../../bean/find_mate_bean.dart';
import '../../http/data_utils.dart';
import '../../main.dart';
import '../../utils/getx_tools.dart';
import '../../utils/loading.dart';
import '../../widget/SwiperPage.dart';
import '../message/geren/people_info_page.dart';
import '../mine/my/my_info_page.dart';

typedef FindMateItem = FindMateBeanData;

class MakefriendsController extends GetxController with GetAntiCombo {
  final _gender = (sp.getInt('user_gender') ?? 1).obs;
  final _list = List<FindMateItem>.empty().obs;

  int get gender => _gender.value;
  List<FindMateItem> get list => _list;

  @override
  void onReady() async {
    await _mPlayer.closePlayer();
    await _mPlayer.openPlayer();
    super.onReady();
  }

  void onAppear() {
    if (_list.isEmpty) {
      postFindMate(gender: _gender.value);
    }
  }
  void onDisAppear() {
    _stopVoice();
  }

  void onBuild() {

  }

  void onChoose() {
    action(() {
      _stopVoice();
      postFindMate(gender: _gender.value != 1 ? 1 : 2);
    });
  }

  void onItem(FindMateItem item) {
    action(() {
      Get.to(SwiperPage(imgList: [item.avatar]), opaque: false);
    });
  }

  bool _canTa = false;
  void onTa() {
    action(() {
      if (!_canTa || _current >= list.length) {
        return;
      }
      _stopVoice();
      final item = list[_current];
      final id = item.uid;
      // 如果点击的是自己，进入自己的主页
      if (sp.getString('user_id').toString() == id.toString()) {
        Get.to(const MyInfoPage());
      } else {
        sp.setString('other_id', id.toString());
        Get.to(PeopleInfoPage(
          otherId: id.toString(),
          title: '其他',
        ));
      }
    });
  }
  int _current = 0;
  set current(int value) => _current = value;
  void onSwipe(int index, AppinioSwiperDirection direction) {
    _current = index;
    _stopVoice();
    _canTa = true;
  }
  void onSwiping(AppinioSwiperDirection direction) {
    _canTa = false;
  }
  void onSwipeEnd() {
    _canTa = true;
  }

  final _isFirstLoading = true.obs;
  bool get isFirstLoading => _isFirstLoading.value;
  void postFindMate({int? gender}) async {
    try {
      Loading.show();
      final bean = await doRequest(() => DataUtils.postFindMate(gender));
      // if (bean.data.length != _list.length) {
      //   _current = 0;
      // }
      _list.value = bean.data;
      if (gender != null) {
        _gender.value = gender;
      }
      _isFirstLoading.value = false;
      _canTa = true;
    } catch (e) {
      if (e is GetBean) {
        Get.log(e.msg);
      } else {
        Get.log(e.toString());
      }
    } finally {
      Loading.dismiss();
    }
  }

  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  final _voice = ''.obs;
  String get isPlaying => _voice.value;

  bool _canVoice = true;
  void onVoice(String voice) {
    if (!_canVoice) {
      return;
    }
    action(() async {
      try {
        _canVoice = false;
        if (_mPlayer.isPlaying) {
          await _mPlayer.stopPlayer();
        }
        if (_voice.value == voice) {
          _voice.value = '';
        } else {
          _voice.value = voice;
          await _mPlayer.startPlayer(fromURI: voice, whenFinished: () => _voice.value = '');
        }
      } catch (e) {
        _voice.value = '';
        Get.log(e.toString());
      } finally {
        _canVoice = true;
      }
    });
  }
  void _stopVoice() {
    if (_mPlayer.isPlaying) {
      _mPlayer.stopPlayer();
    }
    _voice.value = '';
  }
}