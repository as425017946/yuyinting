class myShopListBean {
  int? code;
  String? msg;
  List<DataMy>? data;

  myShopListBean({this.code, this.msg, this.data});

  myShopListBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataMy>[];
      json['data'].forEach((v) {
        data!.add(new DataMy.fromJson(v));
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

class DataMy {
  int? dressId;
  String? name;
  String? img;
  String? gifImg;
  int? isWear;
  String? expireTime;
  int? isLong;
  int? status;

  DataMy(
      {this.dressId,
        this.name,
        this.img,
        this.gifImg,
        this.isWear,
        this.expireTime,
        this.isLong,
        this.status});

  DataMy.fromJson(Map<String, dynamic> json) {
    dressId = json['dress_id'];
    name = json['name'];
    img = json['img'];
    gifImg = json['gif_img'];
    isWear = json['is_wear'];
    expireTime = json['expire_time'];
    isLong = json['is_long'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dress_id'] = this.dressId;
    data['name'] = this.name;
    data['img'] = this.img;
    data['gif_img'] = this.gifImg;
    data['is_wear'] = this.isWear;
    data['expire_time'] = this.expireTime;
    data['is_long'] = this.isLong;
    data['status'] = this.status;
    return data;
  }
}
