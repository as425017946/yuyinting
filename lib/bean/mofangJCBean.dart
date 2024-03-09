// 魔方奖池
class mofangJCBean {
  int? code;
  String? msg;
  List<Data>? data;

  mofangJCBean({this.code, this.msg, this.data});

  mofangJCBean.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? price;
  String? img;
  String? gl;

  Data({this.name, this.price, this.img, this.gl});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    img = json['img'];
    gl = json['gl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['img'] = this.img;
    data['gl'] = this.gl;
    return data;
  }
}
