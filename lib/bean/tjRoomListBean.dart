class tjRoomListBean {
  int? code;
  String? msg;
  List<DataPH>? data;

  tjRoomListBean({this.code, this.msg, this.data});

  tjRoomListBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataPH>[];
      json['data'].forEach((v) {
        data!.add(new DataPH.fromJson(v));
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

class DataPH {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;
  int? type;
  int? hotDegree;
  String? notice;
  String? emRoomId;
  int? addTime;
  List<String>? hostInfo;
  List<MemberList>? memberList;
  int? isNew;

  DataPH(
      {this.id,
        this.roomNumber,
        this.roomName,
        this.coverImg,
        this.type,
        this.hotDegree,
        this.notice,
        this.emRoomId,
        this.addTime,
        this.hostInfo,
        this.memberList,
        this.isNew});

  DataPH.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    type = json['type'];
    hotDegree = json['hot_degree'];
    notice = json['notice'];
    emRoomId = json['em_room_id'];
    addTime = json['add_time'];
    hostInfo = json['host_info'].cast<String>();
    if (json['member_list'] != null) {
      memberList = <MemberList>[];
      json['member_list'].forEach((v) {
        memberList!.add(new MemberList.fromJson(v));
      });
    }
    isNew = json['is_new'];
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
    data['add_time'] = this.addTime;
    data['host_info'] = this.hostInfo;
    if (this.memberList != null) {
      data['member_list'] = this.memberList!.map((v) => v.toJson()).toList();
    }
    data['is_new'] = this.isNew;
    return data;
  }
}

class MemberList {
  int? uid;
  String? avatar;

  MemberList({this.uid, this.avatar});

  MemberList.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['avatar'] = this.avatar;
    return data;
  }
}
