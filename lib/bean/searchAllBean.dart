class searchAllBean {
  int? code;
  String? msg;
  Data? data;

  searchAllBean({this.code, this.msg, this.data});

  searchAllBean.fromJson(Map<String, dynamic> json) {
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
  List<UserList>? userList;
  List<RoomList>? roomList;

  Data({this.userList, this.roomList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['user_list'] != null) {
      userList = <UserList>[];
      json['user_list'].forEach((v) {
        userList!.add(new UserList.fromJson(v));
      });
    }
    if (json['room_list'] != null) {
      roomList = <RoomList>[];
      json['room_list'].forEach((v) {
        roomList!.add(new RoomList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userList != null) {
      data['user_list'] = this.userList!.map((v) => v.toJson()).toList();
    }
    if (this.roomList != null) {
      data['room_list'] = this.roomList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserList {
  String? nickname;
  int? number;
  String? avatar;
  int? uid;

  UserList({this.nickname, this.number, this.avatar, this.uid});

  UserList.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    number = json['number'];
    avatar = json['avatar'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['number'] = this.number;
    data['avatar'] = this.avatar;
    data['uid'] = this.uid;
    return data;
  }
}

class RoomList {
  int? roomNumber;
  String? roomName;
  String? coverImg;
  int? id;

  RoomList({this.roomNumber, this.roomName, this.coverImg, this.id});

  RoomList.fromJson(Map<String, dynamic> json) {
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['id'] = this.id;
    return data;
  }
}
