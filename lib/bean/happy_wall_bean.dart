// ignore_for_file: non_constant_identifier_names

class HappinessWallBean {
  late int code;
  late String msg;
  HappinessWallBeanData? data;

  // ignore: unused_element
  HappinessWallBean._private();
  factory HappinessWallBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      throw '数据错误';
    }
    return HappinessWallBean._private()
      ..code = map['code'] ?? -1
      ..msg = map['msg'] ?? ''
      ..data = map['data'] is Map<String, dynamic> ? HappinessWallBeanData.fromJson(map['data']) : null;
  }
}

class HappinessWallBeanData {
  late List<HappinessWallBeanDataLs> ls;
  
  // ignore: unused_element
  HappinessWallBeanData._private();
  factory HappinessWallBeanData.fromJson(Map<String, dynamic> map) {
    List<HappinessWallBeanDataLs> ls = [];
    if (map['ls'] is List) {
      for (var element in map['ls']) {
        if (element is Map<String, dynamic>) {
          ls.add(HappinessWallBeanDataLs.fromJson(element));
        }
      }
    }
    return HappinessWallBeanData._private()
      ..ls = ls;
  }
}

class HappinessWallBeanDataLs {
  late int id;
  late int room_id; //房间ID 
  late int from_uid; //送礼物用户uid
  late int to_uid; //收礼物用户uid
  late int gift_id; //礼物id
  late int number; //礼物数量 100
  late String add_time; //送礼时间 "2024-04-25"
  late int edit_time; // 0
  late int data_status; // 1
  late String room_name; //房间名称 "7777"
  late String from_nickname; //送礼物用户昵称 "六子"
  late String from_avatar; //送礼物用户头像 "https://oawawb.cn/image/202404/03/660d199951bd9.png"
  late int from_gender; //性别 1男 2女
  late String to_nickname; //收礼物用户昵称 "萌新59936"
  late String to_avatar; //收礼物用户头像 "https://oawawb.cn/image/202404/03/660d199951bd9.png"
  late int to_gender; //性别 1男 2女
  late String gift_name; //礼物名称 "风之铃"
  late String gift_img; //礼物图片 "https://oawawb.cn/resouce/img/gift/风之铃.png"
  late String gift_amount; //总价

  bool isNull = false;
  factory HappinessWallBeanDataLs.empty() {
    return HappinessWallBeanDataLs._private()..isNull = true;
  }
  // ignore: unused_element
  HappinessWallBeanDataLs._private();
  factory HappinessWallBeanDataLs.fromJson(Map<String, dynamic> map) {
    return HappinessWallBeanDataLs._private()
      ..id = map['id'] ?? 0
      ..room_id = map['room_id'] ?? 0
      ..from_uid = map['from_uid'] ?? 0
      ..to_uid = map['to_uid'] ?? 0
      ..gift_id = map['gift_id'] ?? 0
      ..number = map['number'] ?? 0
      ..add_time = map['add_time'] ?? ''
      ..edit_time = map['edit_time'] ?? 0
      ..data_status = map['data_status'] ?? 0
      ..room_name = map['room_name'] ?? ''
      ..from_nickname = map['from_nickname'] ?? ''
      ..from_avatar = map['from_avatar'] ?? ''
      ..from_gender = map['from_gender'] ?? 0
      ..to_nickname = map['to_nickname'] ?? ''
      ..to_avatar = map['to_avatar'] ?? ''
      ..to_gender = map['to_gender'] ?? 0
      ..gift_name = map['gift_name'] ?? ''
      ..gift_amount = map['gift_amount'] ?? ''
      ..gift_img = map['gift_img'] ?? '';
  }
}
