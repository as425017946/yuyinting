class gzBean {
  int? code;
  String? msg;
  Data? data;

  gzBean({this.code, this.msg, this.data});

  gzBean.fromJson(Map<String, dynamic> json) {
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
  My? my;
  List<Ls>? ls;

  Data({this.my, this.ls});

  Data.fromJson(Map<String, dynamic> json) {
    my = json['my'] != null ? new My.fromJson(json['my']) : null;
    if (json['ls'] != null) {
      ls = <Ls>[];
      json['ls'].forEach((v) {
        ls!.add(new Ls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.my != null) {
      data['my'] = this.my!.toJson();
    }
    if (this.ls != null) {
      data['ls'] = this.ls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class My {
  int? uid;
  int? nobleId;
  String? nobleExpireTime;
  String? nobleValue;

  My({this.uid, this.nobleId, this.nobleExpireTime, this.nobleValue});

  My.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    nobleId = json['noble_id'];
    nobleExpireTime = json['noble_expire_time'];
    nobleValue = json['noble_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['noble_id'] = this.nobleId;
    data['noble_expire_time'] = this.nobleExpireTime;
    data['noble_value'] = this.nobleValue;
    return data;
  }
}

class Ls {
  int? id;
  String? name;
  String? upValue;
  String? keepValue;

  Ls({this.id, this.name, this.upValue, this.keepValue});

  Ls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    upValue = json['up_value'];
    keepValue = json['keep_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['up_value'] = this.upValue;
    data['keep_value'] = this.keepValue;
    return data;
  }
}
