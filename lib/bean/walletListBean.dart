class walletListBean {
  int? code;
  String? msg;
  List<Data>? data;

  walletListBean({this.code, this.msg, this.data});

  walletListBean.fromJson(Map<String, dynamic> json) {
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
  int? uid;
  int? type;
  int? curType;
  int? walletType;
  String? price;
  int? objId;
  String? addTime;
  String? name;
  String? img;
  int? number;

  Data(
      {this.uid,
        this.type,
        this.curType,
        this.walletType,
        this.price,
        this.objId,
        this.addTime,
        this.name,
        this.img,
        this.number});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    type = json['type'];
    curType = json['cur_type'];
    walletType = json['wallet_type'];
    price = json['price'];
    objId = json['obj_id'];
    addTime = json['add_time'];
    name = json['name'];
    img = json['img'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['type'] = this.type;
    data['cur_type'] = this.curType;
    data['wallet_type'] = this.walletType;
    data['price'] = this.price;
    data['obj_id'] = this.objId;
    data['add_time'] = this.addTime;
    data['name'] = this.name;
    data['img'] = this.img;
    data['number'] = this.number;
    return data;
  }
}
