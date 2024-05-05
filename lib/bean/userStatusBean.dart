class userStatusBean {
  int? code;
  String? msg;
  List<DataU>? data;

  userStatusBean({this.code, this.msg, this.data});

  userStatusBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataU>[];
      json['data'].forEach((v) {
        data!.add(new DataU.fromJson(v));
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

class DataU {
  int? uid;
  int? loginStatus;
  int? liveStatus;
  int? nobleID;

  DataU({this.uid, this.loginStatus, this.liveStatus, this.nobleID});

  DataU.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    loginStatus = json['login_status'];
    liveStatus = json['live_status'];
    nobleID = json['noble_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['login_status'] = this.loginStatus;
    data['live_status'] = this.liveStatus;
    data['noble_id'] = this.nobleID;
    return data;
  }
}
