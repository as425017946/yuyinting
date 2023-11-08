class liwuBean {
  int? code;
  String? msg;
  List<DataL>? data;

  liwuBean({this.code, this.msg, this.data});

  liwuBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataL>[];
      json['data'].forEach((v) {
        data!.add(new DataL.fromJson(v));
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

class DataL {
  int? id;
  int? type;
  String? name;
  String? price;
  String? img;
  String? imgRendering;
  int? number;

  DataL(
      {this.id,
        this.type,
        this.name,
        this.price,
        this.img,
        this.imgRendering,
        this.number});

  DataL.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    imgRendering = json['img_rendering'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['price'] = this.price;
    data['img'] = this.img;
    data['img_rendering'] = this.imgRendering;
    data['number'] = this.number;
    return data;
  }
}
