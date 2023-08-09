class recommendRoomBean {
  int? code;
  String? msg;
  List<DataTj>? data;

  recommendRoomBean({this.code, this.msg, this.data});

  recommendRoomBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataTj>[];
      json['data'].forEach((v) {
        data!.add(new DataTj.fromJson(v));
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

class DataTj {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;
  int? type;
  int? hotDegree;
  String? notice;
  String? emRoomId;

  DataTj(
      {this.id,
        this.roomNumber,
        this.roomName,
        this.coverImg,
        this.type,
        this.hotDegree,
        this.notice,
        this.emRoomId});

  DataTj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    type = json['type'];
    hotDegree = json['hot_degree'];
    notice = json['notice'];
    emRoomId = json['em_room_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['type'] = this.type;
    data['hot_degree'] = this.hotDegree;
    data['notice'] = this.notice;
    data['em_room_id'] = this.emRoomId;
    return data;
  }
}
