import 'dart:io';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../bean/Common_bean.dart';
import '../../bean/activity_paper_index_bean.dart';
import '../../bean/find_mate_bean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/getx_tools.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../widget/SwiperPage.dart';
import '../message/geren/people_info_page.dart';
import '../mine/my/my_info_page.dart';
import 'cp_assets_picker.dart';

typedef FindMateItem = FindMateBeanData;

class MakefriendsController extends GetxController with GetAntiCombo  {
  final _select = 0.obs;
  int get select => _select.value;
  set select(int value) {
    Loading.dismiss();
    _isSvga.value = false;
    canTap = true;
    switch (value) {
      case 1:
        postActivityPaperIndex();
        break;
      default:
        _select.value = value;
        eventBus.fire(BottomBarVisibleBack(visible: value != 1));
    }
  }

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

  final _cpSelect = 0.obs;
  int get cpSelect => _cpSelect.value;
  Map<String, Widget> cpBanners = {};
  final _getNum = 0.obs; //已抽取次数
  String get getNum => _getNum.value < 3 ? '免费抽取 ${3 - _getNum.value} 次' : '50金豆/次';
  int _cpNum = 0; //脱单人数
  String get cpNum => '已有$_cpNum人脱单成功';

  void postActivityPaperIndex() async {
    try {
      Loading.show();
      final bean = await doRequest(() => DataUtils.postActivityPaperIndex());
      _cpNum = bean.data.cp_num;
      _getNum.value = bean.data.get_num;
      _select.value = 1;
      eventBus.fire(BottomBarVisibleBack(visible: false));
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

  final TextEditingController textController = TextEditingController();
  Future<bool> postActivityPutPaper() async {
    hideKeyboard();
    final content = textController.text.trim();
    if (content.isEmpty) {
      MyToastUtils.showToastBottom("文本信息不能为空！");
      return false;
    }
    bool result = false;
    try {
      Loading.show();
      final pickerItem = _pickerItem.value;
      final String id, type;
      if (pickerItem == null) {
        id = '';
        type = '0';
      } else {
        id = pickerItem.id;
        type = pickerItem.type;
      }
      await doRequest(() => DataUtils.postActivityPutPaper(content, id, type));
      result = true;
    } catch (e) {
      if (e is GetBean) {
        Get.log(e.msg);
      } else {
        Get.log(e.toString());
      }
    } finally {
      Loading.dismiss();
    }
    return result;
  }

  final _isSvga = false.obs;
  bool get isSvga => _isSvga.value;
  late SVGAAnimationController animationController;
  void runSend() {
    _loadAnimation('cp_send');
    textController.text = '';
    pickClear();
  }
  Future<bool> runOpen() async {
    try {
      Loading.show();
      final bean = await doRequest(() => DataUtils.postActivityGetPaper());
      getPaperItem = bean.data;
      _getNum.value += 1;
    } catch (e) {
      if (e is GetBean) {
        Get.log(e.msg);
      } else {
        Get.log(e.toString());
      }
      return false;
    } finally {
      Loading.dismiss();
    }
    canTap = false;
    await _loadAnimation('cp_open');
    Future.delayed(const Duration(milliseconds: 200), () => canTap = true);
    return true;
  }
  Future<void> _loadAnimation(String name) async {
    final videoItem = await SVGAParser.shared.decodeFromAssets('assets/svga/$name.svga');
    animationController.videoItem = videoItem;
    _isSvga.value = true;
    await animationController
        .forward()
        .whenComplete(() {
          animationController.videoItem = null;
          _isSvga.value = false;
        })
        .onError((error, stackTrace) {
          Get.log(error.toString());
          animationController.videoItem = null;
          _isSvga.value = false;
        })
        .catchError((e) {
          Get.log(e.toString());
          animationController.videoItem = null;
          _isSvga.value = false;
        });

  }
  final picker = CPAssetsPicker();
  VideoPlayerController? videoController;
  final _pickerItem = Rxn<CPPickerItem>();
  CPPickerItem? get pickerItem => _pickerItem.value;
  void pick(String id, File file, bool isVideo) {
    videoController = isVideo ? VideoPlayerController.file(file) : null;
    _pickerItem(CPPickerItem(id, isVideo, file));
  }
  void pickClear() {
    videoController = null;
    _pickerItem.trigger(null);
  }

  late ActivityGetPaperBeanData getPaperItem;

  int _getPage = 0;
  final List<ActivityGetPaperBeanData> _getList = [];
  final _getLength = 0.obs;
  int _putPage = 0;
  final List<ActivityGetPaperBeanData> _putList = [];
  final _putLength = 0.obs;
  bool _setPage(int next, int type, bool isFirst) {
    if (isFirst || next == (type == 1 ? _putPage : _getPage) + 1) {
      _nextPage(next, type);
      return true;
    }
    return false;
  }
  void _nextPage(int next, int type) {
    switch (type) {
      case 1:
        _putPage = next;
        break;
      default:
        _getPage = next;
    }
  }
  int getLength(int type) => type == 1 ? _putLength.value : _getLength.value;
  Future<LoadStatus> postActivityPaperList(int type, bool isFirst, [int pageSize = 10]) async {
    LoadStatus status = LoadStatus.idle;
    // ignore: prefer_typing_uninitialized_variables
    final list, post, getLength, next;
    switch (type) {
      case 1:
        list = _putList;
        post = DataUtils.postActivityPutPaperList;
        getLength = _putLength;
        next = isFirst ? 1 :( _putPage + 1);
        break;
      default:
        list = _getList;
        post = DataUtils.postActivityGetPaperList;
        getLength = _getLength;
        next = isFirst ? 1 :( _getPage + 1);
    }
    try {
      final bean = await doRequest(() => post(next, pageSize));
      if (_setPage(next, type, isFirst)) {
        if (next == 1) list.clear();
        if (bean.data.isNotEmpty) list.addAll(bean.data);
        if (bean.data.length < pageSize) status = LoadStatus.noMore;
        getLength.value = list.length;
      }
    } catch (e) {
      if (e is GetBean) {
        Get.log(e.msg);
      } else {
        Get.log(e.toString());
      }
      status = LoadStatus.failed;
    }
    return status;
  }
  Future<void> onMine() async {
    _getPage = 0;
    _getLength.value = 0;
    _paperGetController.refreshCompleted();
    _paperGetController.loadComplete();
    _putPage = 0;
    _putLength.value = 0;
    _paperPutController.refreshCompleted();
    _paperPutController.loadComplete();
    await setCpSelect(0);
  }
  Future<void> setCpSelect(int type) async {
    bool needLoad = false;
    switch (type) {
      case 0:
        if (_getPage == 0) needLoad = true;
        break;
      case 1:
        if (_putPage == 0) needLoad = true;
        break;
      default:
        return;
    }
    if (needLoad) {
      Loading.show();
      await onRefresh(type);
      Loading.dismiss();
    }
    _cpSelect.value = type;
  }
  List<ActivityGetPaperBeanData> paperList(int type) => type == 1 ? _putList : _getList;
  final _paperGetController = RefreshController(initialRefresh: false, initialRefreshStatus: RefreshStatus.idle);
  final _paperPutController = RefreshController(initialRefresh: false, initialRefreshStatus: RefreshStatus.idle);
  RefreshController paperController(int type) => type == 1 ? _paperPutController : _paperGetController;
  void onLoading(int type) async {
    final c = paperController(type);
    c.refreshCompleted();
    switch (await postActivityPaperList(type, false)) {
      case LoadStatus.noMore:
        c.loadNoData();
        break;
      case LoadStatus.failed:
        c.loadFailed();
        break;
      default:
        c.loadComplete();
    }
  }
  Future<void> onRefresh(int type) async {
    final c = paperController(type);
    switch (await postActivityPaperList(type, true)) {
      case LoadStatus.noMore:
        c.loadNoData();
        c.refreshCompleted();
        break;
      case LoadStatus.failed:
        c.refreshFailed();
        if (getLength(type) == 0) c.loadNoData();
        break;
      default:
        c.resetNoData();
        c.loadComplete();
        c.refreshCompleted();
    }
  }
  void onItemDelete(int id) {
    action(() async {
      Loading.show();
      if (await doPostDelPaper(id.toString())) {
        await postActivityPaperList(1, true, 10 * _putPage);
      }
      Loading.dismiss();
    });
  }

  /// 删除纸条
  Future<bool> doPostDelPaper(String id) async {
    bool isSuccess = false;
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'id': id,
      };
      CommonBean bean = await DataUtils.postDelPaper(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          isSuccess = true;
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      Get.log(e.toString());
    }
    return isSuccess;
  }
}

class CPPickerItem {
  String id;
  bool isVideo;
  File file;
  CPPickerItem(this.id, this.isVideo, this.file);
  String get type => isVideo ? '2' : '1';
}