import 'package:event_bus/event_bus.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


EventBus eventBus = new EventBus();

///返回数据解析
class ResidentBack {
  bool isBack;

  ResidentBack({required this.isBack});
}
///提交类的按钮
class SubmitButtonBack {
  String title;

  SubmitButtonBack({required this.title});
}

///提交类的按钮
class InfoBack {
  String info;

  InfoBack({required this.info});
}

///贵族使用
class GuizuButtonBack {
  int index;
  String title;
  GuizuButtonBack({required this.index, required this.title});
}

///选择地区使用
class AddressBack {
  String info;
  AddressBack({required this.info});
}

///上传文件返回
class FileBack {
  String info;
  String id;
  int type; // 0 图片 1音频 2视频
  FileBack({required this.info, required this.id, required this.type});
}

///上传文件返回
class PhotoBack {
  List<AssetEntity>? selectAss;
  String id;
  PhotoBack({required this.selectAss, required this.id});
}


///切换魔方
class MofangBack {
  int info;
  MofangBack({required this.info});
}


///实名认证
class RenzhengBack {
  bool isBack;
  RenzhengBack({required this.isBack});
}

///关注使用
class CareBack {
  String info;
  CareBack({required this.info});
}

///打招呼使用
class HiBack {
  bool isBack;
  int index;
  HiBack({required this.isBack, required this.index});
}

///打招呼使用
class SendMessageBack {
  int type;
  String msgID;
  SendMessageBack({required this.type, required this.msgID});
}


///登录弹窗使用
class LoginBack {
  bool isBack;
  LoginBack({required this.isBack});
}

///二次确认弹窗使用
class QuerenBack {
  String title;
  String jine;
  QuerenBack({required this.title, required this.jine});
}

/// 厅内使用
class RoomBack {
  String title;
  String? index;
  RoomBack({required this.title, required this.index});
}

/// 房间背景
class RoomBGBack {
  String bgID;
  String bgType;
  String bgImagUrl;
  RoomBGBack({required this.bgID, required this.bgType, required this.bgImagUrl});
}

/// 房间背景
class CheckBGBack {
  String bgType;
  String bgImagUrl;
  CheckBGBack({required this.bgType, required this.bgImagUrl});
}

/// 自定义消息
class ZDYBack {
  Map<String, String>? map;
  String type;
  ZDYBack({required this.map, required this.type});
}

/// im进入房间
class JoinRoomYBack {
  Map<dynamic, dynamic> map;
  String type;
  JoinRoomYBack({required this.map, required this.type});
}


/// 礼物显示效果使用
class LiWuShowBack {
  //礼物图地址
  String url;
  // 送到哪里
  List<String> listPeople;
  // 赠送数量
  String numbers;
  LiWuShowBack({required this.url, required this.listPeople, required this.numbers});
}

/// 选中送谁的时候使用
class ChoosePeopleBack {
  // 送到哪里
  List<bool> listPeople;
  ChoosePeopleBack({required this.listPeople});
}