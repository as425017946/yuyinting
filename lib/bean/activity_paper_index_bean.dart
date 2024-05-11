// ignore_for_file: non_constant_identifier_names

import '../utils/getx_tools.dart';

typedef ActivityPaperIndexBean = _Bean;
typedef ActivityPaperIndexBeanData = _Data;

class _Bean with GetBean {
  late _Data data;

  _Bean._private();
  factory _Bean.fromJson(Map<String, dynamic>? map) {
    final bean =  _Bean._private();
    return bean..fromJson(map, (e) {
      bean.data = _Data.fromJson(e);
    });
  }
}

class _Data {
  late int get_num; //已抽取次数
  late int cp_num; //脱单人数
  late List cp_ls; //脱单列表

  _Data._private();
  factory _Data.fromJson(Map<String, dynamic> map) {
    return _Data._private()
      ..get_num = map['get_num'] ?? 0
      ..cp_num = map['cp_num'] ?? 0
      ..cp_ls = map['cp_ls'] ?? [];
  }
}
