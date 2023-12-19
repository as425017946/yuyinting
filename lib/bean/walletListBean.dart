class walletListBean {
  int? code;
  String? msg;
  Data? data;

  walletListBean({this.code, this.msg, this.data});

  walletListBean.fromJson(Map<String, dynamic> json) {
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
  List<Result>? result;
  Total? total;

  Data({this.result, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    total = json['total'] != null ? new Total.fromJson(json['total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    if (this.total != null) {
      data['total'] = this.total!.toJson();
    }
    return data;
  }
}

class Result {
  int? uid;
  int? type;
  int? curType;
  int? walletType;
  String? price;
  int? objId;
  String? addTime;
  String? name;
  String? img;

  Result(
      {this.uid,
        this.type,
        this.curType,
        this.walletType,
        this.price,
        this.objId,
        this.addTime,
        this.name,
        this.img});

  Result.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    type = json['type'];
    curType = json['cur_type'];
    walletType = json['wallet_type'];
    price = json['price'];
    objId = json['obj_id'];
    addTime = json['add_time'];
    name = json['name'];
    img = json['img'];
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
    return data;
  }
}

class Total {
  int? totalGoldBean;
  int? totalDiamond;
  int? totalGoldCoin;

  Total({this.totalGoldBean, this.totalDiamond, this.totalGoldCoin});

  Total.fromJson(Map<String, dynamic> json) {
    totalGoldBean = json['total_gold_bean'];
    totalDiamond = json['total_diamond'];
    totalGoldCoin = json['total_gold_coin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_gold_bean'] = this.totalGoldBean;
    data['total_diamond'] = this.totalDiamond;
    data['total_gold_coin'] = this.totalGoldCoin;
    return data;
  }
}
