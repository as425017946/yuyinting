class shoucangBean {
  int? code;
  String? msg;
  Data? data;

  shoucangBean({this.code, this.msg, this.data});

  shoucangBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<ListSC>? list;
  int? count;

  Data({this.list, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListSC>[];
      json['list'].forEach((v) {
        list!.add(new ListSC.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class ListSC {
  int? id;
  String? roomName;
  String? coverImg;
  String? notice;
  int? hotDegree;
  int? type;

  ListSC(
      {this.id,
        this.roomName,
        this.coverImg,
        this.notice,
        this.hotDegree,
        this.type});

  ListSC.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    notice = json['notice'];
    hotDegree = json['hot_degree'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['notice'] = this.notice;
    data['hot_degree'] = this.hotDegree;
    data['type'] = this.type;
    return data;
  }
}
