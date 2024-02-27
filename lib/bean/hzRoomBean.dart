class hzRoomBean {
  int? code;
  String? msg;
  Data? data;

  hzRoomBean({this.code, this.msg, this.data});

  hzRoomBean.fromJson(Map<String, dynamic> json) {
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
  List<Lists>? lists;
  int? total;

  Data({this.lists, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <Lists>[];
      json['lists'].forEach((v) {
        lists!.add(new Lists.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Lists {
  int? id;
  int? number;
  String? title;
  int? uid;
  String? ratio;
  String? logo;
  String? leaderNickname;

  Lists(
      {this.id,
        this.number,
        this.title,
        this.uid,
        this.ratio,
        this.logo,
        this.leaderNickname});

  Lists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    uid = json['uid'];
    ratio = json['ratio'];
    logo = json['logo'];
    leaderNickname = json['leader_nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    data['uid'] = this.uid;
    data['ratio'] = this.ratio;
    data['logo'] = this.logo;
    data['leader_nickname'] = this.leaderNickname;
    return data;
  }
}
