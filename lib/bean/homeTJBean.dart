class homeTJBean {
  int? code;
  String? msg;
  Data? data;

  homeTJBean({this.code, this.msg, this.data});

  homeTJBean.fromJson(Map<String, dynamic> json) {
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
  List<BannerList>? bannerList;
  List<RoomList1>? roomList1;
  List<RoomList2>? roomList2;
  List<RoomList3>? roomList3;

  Data(
      {this.bannerList,
        this.roomList1,
        this.roomList2,
        this.roomList3});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banner_list'] != null) {
      bannerList = <BannerList>[];
      json['banner_list'].forEach((v) {
        bannerList!.add(new BannerList.fromJson(v));
      });
    }
    if (json['room_list_1'] != null) {
      roomList1 = <RoomList1>[];
      json['room_list_1'].forEach((v) {
        roomList1!.add(new RoomList1.fromJson(v));
      });
    }
    if (json['room_list_2'] != null) {
      roomList2 = <RoomList2>[];
      json['room_list_2'].forEach((v) {
        roomList2!.add(new RoomList2.fromJson(v));
      });
    }
    if (json['room_list_3'] != null) {
      roomList3 = <RoomList3>[];
      json['room_list_3'].forEach((v) {
        roomList3!.add(new RoomList3.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bannerList != null) {
      data['banner_list'] = this.bannerList!.map((v) => v.toJson()).toList();
    }
    if (this.roomList1 != null) {
      data['room_list_1'] = this.roomList1!.map((v) => v.toJson()).toList();
    }
    if (this.roomList2 != null) {
      data['room_list_2'] = this.roomList2!.map((v) => v.toJson()).toList();
    }
    if (this.roomList3 != null) {
      data['room_list_3'] = this.roomList3!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerList {
  int? id;
  String? img;
  String? url;

  BannerList({this.id, this.img, this.url});

  BannerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img'] = this.img;
    data['url'] = this.url;
    return data;
  }
}

class RoomList1 {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;
  int? hotDegree;

  RoomList1(
      {this.id, this.roomNumber, this.roomName, this.coverImg, this.hotDegree});

  RoomList1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    hotDegree = json['hot_degree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['hot_degree'] = this.hotDegree;
    return data;
  }
}

class RoomList2 {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;
  int? hotDegree;

  RoomList2(
      {this.id, this.roomNumber, this.roomName, this.coverImg, this.hotDegree});

  RoomList2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    hotDegree = json['hot_degree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['hot_degree'] = this.hotDegree;
    return data;
  }
}

class RoomList3 {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;
  int? hotDegree;

  RoomList3(
      {this.id, this.roomNumber, this.roomName, this.coverImg, this.hotDegree});

  RoomList3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    hotDegree = json['hot_degree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['hot_degree'] = this.hotDegree;
    return data;
  }
}
