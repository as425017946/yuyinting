class carYZBean {
  int? code;
  String? msg;
  Data? data;

  carYZBean({this.code, this.msg, this.data});

  carYZBean.fromJson(Map<String, dynamic> json) {
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
  int? curType;
  int? mushroom;
  int? goldBean;
  int? diamond;
  int? time;

  Data({this.curType, this.mushroom, this.goldBean, this.diamond, this.time});

  Data.fromJson(Map<String, dynamic> json) {
    curType = json['cur_type'];
    mushroom = json['mushroom'];
    goldBean = json['gold_bean'];
    diamond = json['diamond'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cur_type'] = this.curType;
    data['mushroom'] = this.mushroom;
    data['gold_bean'] = this.goldBean;
    data['diamond'] = this.diamond;
    data['time'] = this.time;
    return data;
  }
}
