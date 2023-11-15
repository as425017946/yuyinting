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
  int? type;
  int? curType;
  String? price;
  int? objId;
  String? addTime;

  Data({this.type, this.curType, this.price, this.objId, this.addTime});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    curType = json['cur_type'];
    price = json['price'];
    objId = json['obj_id'];
    addTime = json['add_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['cur_type'] = this.curType;
    data['price'] = this.price;
    data['obj_id'] = this.objId;
    data['add_time'] = this.addTime;
    return data;
  }
}
