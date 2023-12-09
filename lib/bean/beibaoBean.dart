class beibaoBean {
  int? code;
  String? msg;
  Data? data;

  beibaoBean({this.code, this.msg, this.data});

  beibaoBean.fromJson(Map<String, dynamic> json) {
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
  List<Gift>? gift;
  String? total;

  Data({this.gift, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['gift'] != null) {
      gift = <Gift>[];
      json['gift'].forEach((v) {
        gift!.add(new Gift.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gift != null) {
      data['gift'] = this.gift!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Gift {
  int? id;
  String? name;
  int? price;
  String? img;
  String? imgRendering;
  int? number;

  Gift(
      {this.id,
        this.name,
        this.price,
        this.img,
        this.imgRendering,
        this.number});

  Gift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    imgRendering = json['img_rendering'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['img'] = this.img;
    data['img_rendering'] = this.imgRendering;
    data['number'] = this.number;
    return data;
  }
}
