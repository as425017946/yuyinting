class ghRoomBean {
  int? code;
  String? msg;
  Data? data;

  ghRoomBean({this.code, this.msg, this.data});

  ghRoomBean.fromJson(Map<String, dynamic> json) {
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
  List<ListR>? list;
  int? total;

  Data({this.list, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListR>[];
      json['list'].forEach((v) {
        list!.add(new ListR.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ListR {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;

  ListR({this.id, this.roomNumber, this.roomName, this.coverImg});

  ListR.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    return data;
  }
}
