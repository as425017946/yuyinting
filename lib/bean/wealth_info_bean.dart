class WealthInfoBean {
  late int code;
  late String msg;
  WealthInfoBeanData? data;

  // ignore: unused_element
  WealthInfoBean._private();
  factory WealthInfoBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      throw '数据错误';
    }
    return WealthInfoBean._private()
      ..code = map['code'] ?? -1
      ..msg = map['msg'] ?? ''
      ..data = map['data'] is Map<String, dynamic> ? WealthInfoBeanData.fromJson(map['data']) : null;
  }
}

class WealthInfoBeanData {
  late String avatar; //头像
  late String nickname; //昵称
  // ignore: non_constant_identifier_names
  late int gr_level; //当前财富等级
  late int title; //财富称号
  // ignore: non_constant_identifier_names
  late int day_return; //日返
  // ignore: non_constant_identifier_names
  late String next_lv_value; //下一等级需要荣耀值
  // ignore: non_constant_identifier_names
  late String next_title_value; //下一称号需要荣耀值
  // ignore: non_constant_identifier_names
  late String gr_value; // 当前荣耀值
  // ignore: non_constant_identifier_names
  late int day_salary; // 当前等级每日可领取金豆数
  
  // ignore: unused_element
  WealthInfoBeanData._private();
  factory WealthInfoBeanData.fromJson(Map<String, dynamic> map) {
    return WealthInfoBeanData._private()
      ..day_salary = map['day_salary'] ?? 0
      ..gr_value = map['gr_value'] ?? ''
      ..avatar = map['avatar'] ?? ''
      ..nickname = map['nickname'] ?? ''
      ..gr_level = map['gr_level'] ?? 0
      ..title = map['title'] ?? 0
      ..day_return = map['day_return'] ?? 0
      ..next_lv_value = map['next_lv_value'] ?? ''
      ..next_title_value = map['next_title_value'] ?? '';
  }
}

class WealthDayReturnBean {
  late int code;
  late String msg;
  late List<WealthDayReturnBeanData> data;

  // ignore: unused_element
  WealthDayReturnBean._private();
  factory WealthDayReturnBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      throw '数据错误';
    }
    List<WealthDayReturnBeanData> ls = [];
    if (map['data'] is List) {
      for (var element in map['data']) {
        if (element is Map<String, dynamic>) {
          ls.add(WealthDayReturnBeanData.fromJson(element));
        }
      }
    }
    return WealthDayReturnBean._private()
      ..code = map['code'] ?? -1
      ..msg = map['msg'] ?? ''
      ..data = ls;
  }
}

class WealthDayReturnBeanData {
  late int id;
  late int uid; //用户id
  late int type;
  late int amount; //金豆数
// ignore: non_constant_identifier_names
  late int is_receive; //是否领取 1是 0否
// ignore: non_constant_identifier_names
  late String grant_daytime; //发放日期 "04月16日"
// ignore: non_constant_identifier_names
  late int get_time;
// ignore: non_constant_identifier_names
  late int add_time;
  
  // ignore: unused_element
  WealthDayReturnBeanData._private();
  factory WealthDayReturnBeanData.fromJson(Map<String, dynamic> map) {
    return WealthDayReturnBeanData._private()
      ..id = map['id'] ?? 0
      ..uid = map['uid'] ?? 0
      ..type = map['type'] ?? 0
      ..amount = map['amount'] ?? 0
      ..is_receive = map['is_receive'] ?? 0
      ..grant_daytime = map['grant_daytime'] ?? ''
      ..get_time = map['get_time'] ?? 0
      ..add_time = map['add_time'] ?? 0;
  }
}
