class giftListBean {
  int? code;
  String? msg;
  Data? data;

  giftListBean({this.code, this.msg, this.data});

  giftListBean.fromJson(Map<String, dynamic> json) {
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
  List<ClassicList>? classicList;
  List<PrivilegeList>? privilegeList;
  List<PackList>? packList;

  Data({this.classicList, this.privilegeList, this.packList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['classic_list'] != null) {
      classicList = <ClassicList>[];
      json['classic_list'].forEach((v) {
        classicList!.add(new ClassicList.fromJson(v));
      });
    }
    if (json['privilege_list'] != null) {
      privilegeList = <PrivilegeList>[];
      json['privilege_list'].forEach((v) {
        privilegeList!.add(new PrivilegeList.fromJson(v));
      });
    }
    if (json['pack_list'] != null) {
      packList = <PackList>[];
      json['pack_list'].forEach((v) {
        packList!.add(new PackList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classicList != null) {
      data['classic_list'] = this.classicList!.map((v) => v.toJson()).toList();
    }
    if (this.privilegeList != null) {
      data['privilege_list'] =
          this.privilegeList!.map((v) => v.toJson()).toList();
    }
    if (this.packList != null) {
      data['pack_list'] = this.packList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassicList {
  int? id;
  int? type;
  String? name;
  int? price;
  String? img;
  String? imgRendering;
  int? sort;

  ClassicList(
      {this.id,
        this.type,
        this.name,
        this.price,
        this.img,
        this.imgRendering,
        this.sort});

  ClassicList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    imgRendering = json['img_rendering'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['price'] = this.price;
    data['img'] = this.img;
    data['img_rendering'] = this.imgRendering;
    data['sort'] = this.sort;
    return data;
  }
}


class PrivilegeList {
  int? id;
  int? type;
  String? name;
  int? price;
  String? img;
  String? imgRendering;
  int? sort;

  PrivilegeList(
      {this.id,
        this.type,
        this.name,
        this.price,
        this.img,
        this.imgRendering,
        this.sort});

  PrivilegeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    imgRendering = json['img_rendering'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['price'] = this.price;
    data['img'] = this.img;
    data['img_rendering'] = this.imgRendering;
    data['sort'] = this.sort;
    return data;
  }
}


class PackList {
  int? id;
  int? type;
  String? name;
  int? price;
  String? img;
  String? imgRendering;
  int? sort;

  PackList(
      {this.id,
        this.type,
        this.name,
        this.price,
        this.img,
        this.imgRendering,
        this.sort});

  PackList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    imgRendering = json['img_rendering'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['price'] = this.price;
    data['img'] = this.img;
    data['img_rendering'] = this.imgRendering;
    data['sort'] = this.sort;
    return data;
  }
}