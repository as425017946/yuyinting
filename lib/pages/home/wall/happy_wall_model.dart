import 'package:get/get.dart';

import '../../../bean/happy_wall_bean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/getx_tools.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../message/geren/people_info_page.dart';
import '../../mine/my/my_info_page.dart';

typedef HapplyWallItem = HappinessWallBeanDataLs;

class HapplyWallController extends GetxController with GetAntiCombo {
  final _item = HapplyWallItem.empty().obs;
  HapplyWallItem? get item => _item.value.isNull ? null : _item.value;
  bool get isShow => !_item.value.isNull;
  final List<HapplyWallItem> _list = [];
  final _listData = List<HapplyWallItem>.empty().obs;
  int get itemCount => _listData.length;
  HapplyWallItem listItem(int index) => _listData[index];

  void _loop() async {
    if (_list.isEmpty) { 
      if (_listData.isEmpty) {
        _item(HapplyWallItem.empty());
        _isRun = false;
        return;
      }
      _list.addAll(_listData);
    }
    _item(_list.removeAt(0));
    await Future.delayed(const Duration(seconds: 5));
    isFirstRun = false;
    _loop();
  }

  bool _isRun = false;
  bool isFirstRun = true;
  void _runLoop() {
    if (_listData.isEmpty || _isRun) {
      return;
    }
    _isRun = true;
    isFirstRun = true;
    _loop();
  }

  bool _checkList(List<HapplyWallItem> l1, RxList<HapplyWallItem> l2) {
    if (l1.length != l2.length) {
      return false;
    }
    for (var i = 0; i < l1.length; i++) {
      if (l1[i].id != l2[i].id) {
        return false;
      }
    }
    return true;
  }
  /// 幸福墙
  Future<void> doPostHappinessWall() async {
    try {
      HappinessWallBean bean = await DataUtils.postHappinessWall();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          final ls = bean.data?.ls ?? [];
          if (!_checkList(ls, _listData)) {
            _listData(ls);
            _list.clear();
            _runLoop();
          }
          break;
        case MyHttpConfig.errorloginCode:
          final context = Get.context;
          if (context != null) {
            // ignore: use_build_context_synchronously
            MyUtils.jumpLogin(context);
          }
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg);
          break;
      }
    } catch (e) {
      LogE(e.toString());
    }
  }

  void toRoom(int id) async {
    action(() {
      final context = Get.context;
      if (context != null) {
        joinRoom(id, context);
      }
    });
  }
  void toInfo(int id) async {
    action(() {
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
}