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
      if (e is Map<String, dynamic>) bean.data = _Data.fromJson(e);
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

typedef ActivityGetPaperBean = _GetBean;
typedef ActivityGetPaperBeanData = _GetData;
class _GetBean with GetBean {
  late _GetData data;

  _GetBean._private();
  factory _GetBean.fromJson(Map<String, dynamic>? map) {
    final bean =  _GetBean._private();
    return bean..fromJson(map, (e) {
      if (e is Map<String, dynamic>) bean.data = _GetData.fromJson(e);
    });
  }
}
class _GetData {
  late int id;
  late int uid; //用户uid
  late String content; //文字内容
  late int type; //1图片 2视频
  late String img_id; //图片或视频id
  late int audit_status;
  late String add_time; //放入时间
  late int edit_time;
  late int data_status;
  late String img_url; //地址
  late String nickname; //yonghu nicheng
  late String avatar; //用户头像
  late int gender; //性别 1男 2女
  late int age; //年龄

  late int cid;

  _GetData._private();
  factory _GetData.fromJson(Map<String, dynamic> map) {
    return _GetData._private()
      ..id = map['id'] ?? 0
      ..uid = map['uid'] ?? 0
      // ..cid = map['cid'] ?? 0
      ..content = map['content'] ?? ''
      ..type = map['type'] ?? 0
      // ..img_id = map['img_id'] ?? ''
      // ..audit_status = map['audit_status'] ?? 0
      ..add_time = map['add_time'] ?? ''
      // ..edit_time = map['edit_time'] ?? 0
      // ..data_status = map['data_status'] ?? 0
      ..img_url = map['img_url'] ?? ''
      ..nickname = map['nickname'] ?? ''
      ..avatar = map['avatar'] ?? ''
      ..gender = map['gender'] ?? 0
      ..age = map['age'] ?? 0
    ;
  }
}

typedef ActivityGetPaperListBean = _GetListBean;
class _GetListBean with GetBean {
  List<_GetData> data = [];

  _GetListBean._private();
  factory _GetListBean.fromJson(Map<String, dynamic>? map) {
    final bean = _GetListBean._private();
    return bean..fromJson(map, (e) {
      if (e is List) {
        bean.data.clear();
        for (var element in e) {
          if (element is Map<String, dynamic>) bean.data.add(_GetData.fromJson(element));
        }
      }
    });
  }
}

typedef ActivityPutPaperListBean = _PutListBean;
class _PutListBean with GetBean {
  List<_GetData> data = [];

  _PutListBean._private();
  factory _PutListBean.fromJson(Map<String, dynamic>? map) {
    final bean =  _PutListBean._private();
    return bean..fromJson(map, (e) {
      if (e is List) {
        bean.data.clear();
        for (var element in e) {
          if (element is Map<String, dynamic>) bean.data.add(_GetData.fromJson(element));
        }
      }
    });
  }
}