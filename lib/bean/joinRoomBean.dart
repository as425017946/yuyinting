class joinRoomBean {
  int? code;
  String? msg;
  Data? data;

  joinRoomBean({this.code, this.msg, this.data});

  joinRoomBean.fromJson(Map<String, dynamic> json) {
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
  String? rtc;
  String? rtm;

  Data({this.rtc, this.rtm});

  Data.fromJson(Map<String, dynamic> json) {
    rtc = json['rtc'];
    rtm = json['rtm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rtc'] = this.rtc;
    data['rtm'] = this.rtm;
    return data;
  }
}
