import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../bean/fenleiBean.dart';
import '../../../bean/homeTJBean.dart';
import '../../../bean/tjRoomListBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../main.dart';
import '../../../utils/getx_tools.dart';
import 'package:get/get.dart';

import '../wall/happy_wall_model.dart';
import '../wall/happy_wall_page.dart';

class PaiduiController extends GetxController with GetAntiCombo {

  final RefreshController refreshController = RefreshController(initialRefresh: false);
  bool get canRefresh {
    final page = roomListData;
    if (page == null) return false;
    return page.status != LoadStatus.loading;
  }
  final _hwc = Get.put(HapplyWallController());
  late final happyWall = HappyWallBanner();

  @override
  void onReady() {
    _hwc.doPostHappinessWall();
    onLoading();
    super.onReady();
  }

  void onLoading() async {
    listPage?.status == LoadStatus.loading;
    _doPostPushRoom();
    await _doPostRoomType();
    await _doPostTJRoomList2(false);
  }
  void onRefresh() async {
    listPage?.status == LoadStatus.loading;
    _hwc.doPostHappinessWall();
    _doPostPushRoom();
    await _doPostRoomType();
    await _doPostTJRoomList2(true);
  }

  void toRoom(int? id) {
    if (id == null) return;
    final context = Get.context;
    if (context == null) return;
    action(() { 
      joinRoom(id, context);
    });
  }

  final listFL = RxList<DataFL>();
  final _tabSelect = Rxn<DataFL>();
  DataFL? get tabSelect => _tabSelect.value;
  void onTab(DataFL item) {
    if (item.type == _tabSelect.value?.type) return;
    _tabSelect(item);
    final page = listPage;
    _roomListData.trigger(page);
    refreshController.refreshCompleted();
    if (page == null) {
      refreshController.resetNoData();
      onLoading();
    } else {
      if (page.status == LoadStatus.noMore) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }
  final _isList = (sp.getBool('paidui_list_type') ?? true).obs;
  bool get isList => _isList.value;
  String get listType => _isList.value ? 'assets/images/paidui_list_table.png' : 'assets/images/paidui_list_collect.png';
  void onIsList() {
    final value = !_isList.value;
    _isList.value = value;
    sp.setBool('paidui_list_type', value);
  }
                              
  /// 获取分类
  Future<void> _doPostRoomType() async {
    try {
      final bean = await DataUtils.postRoomType();
      doBean(bean.code, bean.msg);
      var data = bean.data;
      //2女厅 3男厅 4新厅 5游戏厅 6交友 7相亲 8点唱
      final list1 = [
        DataFL(type: 2, title: '女神'),
        DataFL(type: 3, title: '男神'),
        DataFL(type: 6, title: '交友'),
      ];
      final list2 = [
        DataFL(type: 4, title: '新厅'),
      ];
      if (data != null && data.isNotEmpty) {
        list1.removeWhere((element) => _removeFL(element, data));
        list2.removeWhere((element) => _removeFL(element, data));
        list1.addAll(data);
      }
      listFL.value = list1 + list2;
    } catch (e) {
      Get.log(e.toString());
    }
  }
  bool _removeFL(DataFL item, List<DataFL> list) {
    for (final element in list) {
      if (item.type == element.type) {
        return true;
      }
    }
    return false;
  }

  final listRoom = RxList<RoomList1>();
  final listRoom2 = RxList<RoomList2>();
  final listRoom3 = RxList<RoomList3>();
  final listBanner = RxList<BannerList>();
  /// 首页 推荐房间/海报轮播/推荐主播
  Future<void> _doPostPushRoom() async {
    try {
      final bean = await DataUtils.postPushRoom();
      doBean(bean.code, bean.msg);
      var data = bean.data;
      if (data == null) throw '数据错误';
      listRoom.value = data.roomList1 ?? [];
      listRoom2.value = data.roomList2 ?? [];
      listRoom3.value = data.roomList3 ?? [];
      listBanner.value = data.bannerList ?? [];
    } catch (e) {
      Get.log(e.toString());
    }
  }

  final Map<int, ListPage> _roomList = {};
  ListPage? get listPage => _roomList[_tabSelect.value?.type];
  final _roomListData = Rxn<ListPage>();
  ListPage? get roomListData => _roomListData.value;
  /// 房间列表
  Future<void> _doPostTJRoomList2(bool isRefresh) async {
    if (listFL.isEmpty) return;
    final current = _tabSelect.value ??= listFL.first;
    final currentType = current.type;
    if (currentType == null) return;
    final listPage = _roomList[currentType] ??= ListPage(currentType, current.title ?? '');
    final int next = isRefresh ? 1 : (listPage.page + 1);
    const pageSize = MyConfig.pageSize;
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'page': next,
        'pageSize': pageSize,
        'type': currentType.toString(),
      };
      tjRoomListBean bean = await DataUtils.postTJRoomList(params);
      doBean(bean.code, bean.msg);
      var data = bean.data ?? [];
      if (isRefresh) {
        listPage.data.clear();
      }
      if (data.isNotEmpty) {
        listPage.page = next;
        listPage.data.addAll(data);
      } 
      listPage.status = data.length < pageSize ? LoadStatus.noMore : LoadStatus.idle;
    } catch (e) {
      listPage.status = LoadStatus.failed;
      Get.log(e.toString());
    }
    if (currentType == _tabSelect.value?.type) {
      _roomListData(listPage);
      refreshController.refreshCompleted();
      if (listPage.status == LoadStatus.noMore) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }
}

class ListPage {
  int page = 0;
  LoadStatus status = LoadStatus.idle;
  final List<DataPH> data = [];
  final int index;
  final String roomType;
  ListPage(this.index, this.roomType);
}