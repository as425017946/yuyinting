class liwuMoreBean {
  int? code;
  String? msg;
  List<Data>? data;

  liwuMoreBean({this.code, this.msg, this.data});

  liwuMoreBean.fromJson(Map<String, dynamic> json) {
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
  int? number;
  String? amount;
  String? addTime;
  String? username;
  String? avatar;
  String? giftImg;
  String? giftName;

  Data(
      {this.number,
        this.amount,
        this.addTime,
        this.username,
        this.avatar,
        this.giftImg,
        this.giftName});

  Data.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    amount = json['amount'];
    addTime = json['add_time'];
    username = json['username'];
    avatar = json['avatar'];
    giftImg = json['gift_img'];
    giftName = json['gift_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['amount'] = this.amount;
    data['add_time'] = this.addTime;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['gift_img'] = this.giftImg;
    data['gift_name'] = this.giftName;
    return data;
  }
}
