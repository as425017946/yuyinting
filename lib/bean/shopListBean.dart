class shopListBean {
  int? code;
  String? msg;
  List<Data>? data;

  shopListBean({this.code, this.msg, this.data});

  shopListBean.fromJson(Map<String, dynamic> json) {
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
  int? gid;
  String? name;
  String? img;
  String? gifImg;
  int? price;
  int? status;
  int? useDay;

  Data(
      {this.gid,
        this.name,
        this.img,
        this.gifImg,
        this.price,
        this.status,
        this.useDay});

  Data.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    name = json['name'];
    img = json['img'];
    gifImg = json['gif_img'];
    price = json['price'];
    status = json['status'];
    useDay = json['use_day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['name'] = this.name;
    data['img'] = this.img;
    data['gif_img'] = this.gifImg;
    data['price'] = this.price;
    data['status'] = this.status;
    data['use_day'] = this.useDay;
    return data;
  }
}
