class shopListBean {
  int? code;
  String? msg;
  List<DataSC>? data;

  shopListBean({this.code, this.msg, this.data});

  shopListBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataSC>[];
      json['data'].forEach((v) {
        data!.add(new DataSC.fromJson(v));
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

class DataSC {
  int? gid;
  String? name;
  String? img;
  String? gifImg;
  int? price;
  int? status;
  int? useDay;
  List<StepPriceDay>? stepPriceDay;

  DataSC(
      {this.gid,
        this.name,
        this.img,
        this.gifImg,
        this.price,
        this.status,
        this.useDay,
        this.stepPriceDay});

  DataSC.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    name = json['name'];
    img = json['img'];
    gifImg = json['gif_img'];
    price = json['price'];
    status = json['status'];
    useDay = json['use_day'];
    if (json['step_price_day'] != null) {
      stepPriceDay = <StepPriceDay>[];
      json['step_price_day'].forEach((v) {
        stepPriceDay!.add(new StepPriceDay.fromJson(v));
      });
    }
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
    if (this.stepPriceDay != null) {
      data['step_price_day'] =
          this.stepPriceDay!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StepPriceDay {
  String? price1;
  String? useDay1;
  String? price2;
  String? useDay2;
  String? price3;
  String? useDay3;

  StepPriceDay(
      {this.price1,
        this.useDay1,
        this.price2,
        this.useDay2,
        this.price3,
        this.useDay3});

  StepPriceDay.fromJson(Map<String, dynamic> json) {
    price1 = json['price1'];
    useDay1 = json['use_day1'];
    price2 = json['price2'];
    useDay2 = json['use_day2'];
    price3 = json['price3'];
    useDay3 = json['use_day3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price1'] = this.price1;
    data['use_day1'] = this.useDay1;
    data['price2'] = this.price2;
    data['use_day2'] = this.useDay2;
    data['price3'] = this.price3;
    data['use_day3'] = this.useDay3;
    return data;
  }
}
