class roomBGBean {
  int? code;
  String? msg;
  Data? data;

  roomBGBean({this.code, this.msg, this.data});

  roomBGBean.fromJson(Map<String, dynamic> json) {
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
  List<DefaultBgList>? defaultBgList;
  List<CustomBglist>? customBglist;

  Data({this.defaultBgList, this.customBglist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['defaultBgList'] != null) {
      defaultBgList = <DefaultBgList>[];
      json['defaultBgList'].forEach((v) {
        defaultBgList!.add(new DefaultBgList.fromJson(v));
      });
    }
    if (json['customBglist'] != null) {
      customBglist = <CustomBglist>[];
      json['customBglist'].forEach((v) {
        customBglist!.add(new CustomBglist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.defaultBgList != null) {
      data['defaultBgList'] =
          this.defaultBgList!.map((v) => v.toJson()).toList();
    }
    if (this.customBglist != null) {
      data['customBglist'] = this.customBglist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DefaultBgList {
  int? bgId;
  String? img;
  int? type;
  int? bgType;

  DefaultBgList({this.bgId, this.img, this.type, this.bgType});

  DefaultBgList.fromJson(Map<String, dynamic> json) {
    bgId = json['bg_id'];
    img = json['img'];
    type = json['type'];
    bgType = json['bg_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bg_id'] = this.bgId;
    data['img'] = this.img;
    data['type'] = this.type;
    data['bg_type'] = this.bgType;
    return data;
  }
}


class CustomBglist {
  int? bgId;
  String? img;
  int? type;
  int? bgType;

  CustomBglist({this.bgId, this.img, this.type, this.bgType});

  CustomBglist.fromJson(Map<String, dynamic> json) {
    bgId = json['bg_id'];
    img = json['img'];
    type = json['type'];
    bgType = json['bg_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bg_id'] = this.bgId;
    data['img'] = this.img;
    data['type'] = this.type;
    data['bg_type'] = this.bgType;
    return data;
  }
}
