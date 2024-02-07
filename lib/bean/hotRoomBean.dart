class hotRoomBean {
  int? code;
  String? msg;
  List<DataHot>? data;

  hotRoomBean({this.code, this.msg, this.data});

  hotRoomBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataHot>[];
      json['data'].forEach((v) {
        data!.add(new DataHot.fromJson(v));
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

class DataHot {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;
  int? type;
  int? hotDegree;

  DataHot(
      {this.id,
        this.roomNumber,
        this.roomName,
        this.coverImg,
        this.type,
        this.hotDegree});

  DataHot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    type = json['type'];
    hotDegree = json['hot_degree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['type'] = this.type;
    data['hot_degree'] = this.hotDegree;
    return data;
  }
}
