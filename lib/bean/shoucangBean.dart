class shoucangBean {
  int? code;
  String? msg;
  List<DataS>? data;

  shoucangBean({this.code, this.msg, this.data});

  shoucangBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataS>[];
      json['data'].forEach((v) {
        data!.add(new DataS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataS {
  int? id;
  String? roomName;
  String? coverImg;
  String? notice;
  int? hotDegree;
  int? type;

  DataS(
      {this.id,
        this.roomName,
        this.coverImg,
        this.notice,
        this.hotDegree,
        this.type});

  DataS.fromJson(Map<String, dynamic> json) {
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
