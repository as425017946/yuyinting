class allGiftBean {
  int? code;
  String? msg;
  Data? data;

  allGiftBean({this.code, this.msg, this.data});

  allGiftBean.fromJson(Map<String, dynamic> json) {
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
  List<AllGiftArr>? allGiftArr;
  int? allGiftType;

  Data({this.allGiftArr, this.allGiftType});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['all_gift_arr'] != null) {
      allGiftArr = <AllGiftArr>[];
      json['all_gift_arr'].forEach((v) {
        allGiftArr!.add(new AllGiftArr.fromJson(v));
      });
    }
    allGiftType = json['all_gift_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allGiftArr != null) {
      data['all_gift_arr'] = this.allGiftArr!.map((v) => v.toJson()).toList();
    }
    data['all_gift_type'] = this.allGiftType;
    return data;
  }
}

class AllGiftArr {
  String? img;
  int? status;
  int? count;
  String? name;

  AllGiftArr({this.img, this.status, this.count, this.name});

  AllGiftArr.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    status = json['status'];
    count = json['count'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['status'] = this.status;
    data['count'] = this.count;
    data['name'] = this.name;
    return data;
  }
}
