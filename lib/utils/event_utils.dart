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
