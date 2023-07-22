import 'package:event_bus/event_bus.dart';


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
  FileBack({required this.info, required this.id});
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
