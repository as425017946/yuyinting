class payLsitBean {
  int? code;
  String? msg;
  List<DataCZ>? data;

  payLsitBean({this.code, this.msg, this.data});

  payLsitBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <DataCZ>[];
      json['data'].forEach((v) {
        data!.add(new DataCZ.fromJson(v));
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

class DataCZ {
  int? id;
  int? amount;
  int? goldBean;
  int? isFirst;
  String? payType;

  DataCZ({this.id, this.amount, this.goldBean, this.isFirst, this.payType});

  DataCZ.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    goldBean = json['gold_bean'];
    isFirst = json['is_first'];
    payType = json['pay_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['gold_bean'] = this.goldBean;
    data['is_first'] = this.isFirst;
    data['pay_type'] = this.payType;
    return data;
  }
}
