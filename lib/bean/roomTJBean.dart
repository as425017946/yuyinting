class roomTJBean {
  int? code;
  String? msg;
  List<DataTJ>? data;

  roomTJBean({this.code, this.msg, this.data});

  roomTJBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataTJ>[];
      json['data'].forEach((v) {
        data!.add(new DataTJ.fromJson(v));
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

class DataTJ {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;
  int? type;
  int? hotDegree;
  String? emRoomId;
  int? addTime;
  int? gameId;

  DataTJ(
      {this.id,
        this.roomNumber,
        this.roomName,
        this.coverImg,
        this.type,
        this.hotDegree,
        this.emRoomId,
        this.addTime,
        this.gameId});

  DataTJ.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    type = json['type'];
    hotDegree = json['hot_degree'];
    emRoomId = json['em_room_id'];
    addTime = json['add_time'];
    gameId = json['game_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['type'] = this.type;
    data['hot_degree'] = this.hotDegree;
    data['em_room_id'] = this.emRoomId;
    data['add_time'] = this.addTime;
    data['game_id'] = this.gameId;
    return data;
  }
}
