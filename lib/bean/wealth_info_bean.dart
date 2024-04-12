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
  
  // ignore: unused_element
  WealthInfoBeanData._private();
  factory WealthInfoBeanData.fromJson(Map<String, dynamic> map) {
    return WealthInfoBeanData._private()
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
