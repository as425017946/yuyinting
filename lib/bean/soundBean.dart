class soundBean {
  int? code;
  String? msg;
  Data? data;

  soundBean({this.code, this.msg, this.data});

  soundBean.fromJson(Map<String, dynamic> json) {
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
  int? findSound;
  int? amuse;

  Data({this.findSound, this.amuse});

  Data.fromJson(Map<String, dynamic> json) {
    findSound = json['find_sound'];
    amuse = json['amuse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['find_sound'] = this.findSound;
    data['amuse'] = this.amuse;
    return data;
  }
}
