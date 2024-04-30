// ignore_for_file: non_constant_identifier_names

import '../utils/getx_tools.dart';

class FindMateBean with GetBean {
  late List<FindMateBeanData> data;

  FindMateBean._private();
  factory FindMateBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      throw '数据错误';
    }
    List<FindMateBeanData> ls = [];
    if (map['data'] is List) {
      for (var element in map['data']) {
        if (element is Map<String, dynamic>) {
          ls.add(FindMateBeanData.fromJson(element));
        }
      }
    }
    return FindMateBean._private()
      ..code = map['code'] ?? -1
      ..msg = map['msg'] ?? ''
      ..data = ls;
  }
}

class FindMateBeanData {
  late int uid; //用户uid
  late int number; //用户id
  late String nickname; //昵称
  late String avatar; //头像
  late String voice_card; //声音名片
  late String description; //个性签名
  late String label_id;
  late String label;

  FindMateBeanData._private();
  factory FindMateBeanData.fromJson(Map<String, dynamic> map) {
    return FindMateBeanData._private()
      ..uid = map['uid'] ?? 0
      ..number = map['number'] ?? 0
      ..nickname = map['nickname'] ?? ''
      ..avatar = map['avatar'] ?? ''
      ..voice_card = map['voice_card'] ?? ''
      ..label_id = map['label_id'] ?? ''
      ..label = map['label'] ?? ''
      ..description = map['description'] ?? '';
  }
}
