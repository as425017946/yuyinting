class whoLockMe {
  int? code;
  String? msg;
  List<Data>? data;

  whoLockMe({this.code, this.msg, this.data});

  whoLockMe.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? nickname;
  int? gender;
  String? avatar;
  String? description;
  String? addTime;

  Data(
      {this.nickname,
        this.gender,
        this.avatar,
        this.description,
        this.addTime});

  Data.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    gender = json['gender'];
    avatar = json['avatar'];
    description = json['description'];
    addTime = json['add_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['description'] = this.description;
    data['add_time'] = this.addTime;
    return data;
  }
}
