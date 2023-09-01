class chatUserInfoBean {
  int? code;
  String? msg;
  Data? data;

  chatUserInfoBean({this.code, this.msg, this.data});

  chatUserInfoBean.fromJson(Map<String, dynamic> json) {
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
  RoomInfo? roomInfo;
  List<String>? note;
  int? noteId;
  int? black;

  Data({this.roomInfo, this.note, this.noteId, this.black});

  Data.fromJson(Map<String, dynamic> json) {
    roomInfo = json['room_info'] != null
        ? new RoomInfo.fromJson(json['room_info'])
        : null;
    note = json['note'].cast<String>();
    noteId = json['note_id'];
    black = json['black'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roomInfo != null) {
      data['room_info'] = this.roomInfo!.toJson();
    }
    data['note'] = this.note;
    data['note_id'] = this.noteId;
    data['black'] = this.black;
    return data;
  }
}

class RoomInfo {
  int? id;
  String? name;

  RoomInfo({this.id, this.name});

  RoomInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
