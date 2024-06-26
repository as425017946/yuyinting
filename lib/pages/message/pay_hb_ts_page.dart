import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/loading.dart';
import 'package:yuyinting/utils/my_utils.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 支付密码弹窗使用
class PayHBTSPage extends StatefulWidget {
  String uid;
  String number;
  String nickName;
  String otherImg;
  PayHBTSPage({super.key, required this.uid,required this.number, required this.nickName, required this.otherImg});

  @override
  State<PayHBTSPage> createState() => _PayHBTSPageState();
}

class _PayHBTSPageState extends State<PayHBTSPage> {
  TextEditingController textEditingController = TextEditingController();
  // 密码够6位，设置为true，其他都是false
  bool isOK = false;
  // 输入的密码
  String mima = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isOK = false;
        });
        return true; // 允许正常的返回操作
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false, // 解决键盘顶起页面
          body: Column(
            children: [
              GestureDetector(
                onTap: (() {
                  setState(() {
                    isOK = false;
                  });
                  Navigator.pop(context);
                }),
                child: Container(
                  height: 300.h,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(506*1.25),
                height: ScreenUtil().setWidth(520*1.25),
                decoration: const BoxDecoration(
                  //设置Container修饰
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage("assets/images/qx_bg1.png"),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(120*2.w, 0),
                    WidgetUtils.onlyTextCenter(
                        '请输入支付密码',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black87,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600)),
                    WidgetUtils.commonSizedBox(80*1.25.w, 0),
                    Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(40*1.25), right: ScreenUtil().setWidth(40*1.25),),
                      child: PinCodeTextField(
                        length: 6,
                        inputFormatters: [
                          // 表示只能输入数字
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        // animationDuration: const Duration(milliseconds: 300),
                        controller: textEditingController,
                        onChanged: (value) {
                          // LogE('返回数据$value');
                          if(value.length == 6 && isOK == false){
                            setState(() {
                              mima = value;
                              isOK = true;
                            });
                            if(MyUtils.checkClick()) {
                              doPostSendRedPacket();
                              MyUtils.hideKeyboard(context);
                            }
                          }
                        },
                        textStyle: StyleUtils.getCommonTextStyle(
                            color: MyColors.btn_a,
                            fontSize: 50.sp),
                        appContext: context,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        // enableActiveFill: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(2*2.w),
                          fieldHeight: 100*1.25.w,
                          fieldWidth: 60*1.25.w,
                          activeFillColor: Colors.transparent,
                          //填充背景色
                          activeColor: MyColors.btn_a,
                          //下划线颜色
                          inactiveFillColor: Colors.white,
                          inactiveColor: Colors.white,
                          selectedColor: Colors.white,
                          selectedFillColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (() {
                    setState(() {
                      isOK = false;
                    });
                    Navigator.pop(context);
                  }),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  /// 发红包
  Future<void> doPostSendRedPacket() async {
    Loading.show('幸运发送中...');
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
      'amount': widget.number,
      'amount_type': '1',
      'pay_pwd': mima
    };
    try {
      CommonBean bean = await DataUtils.postSendRedPacket(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          saveHBinfo(widget.number);
          eventBus.fire(HongBaoBack(info: widget.number));
          MyToastUtils.showToastBottom('红包发送成功');
          Navigator.pop(context);
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      eventBus.fire(HongBaoBack(info: '-1'));
      MyToastUtils.showToastBottom(MyConfig.errorHttpTitle);
      Loading.dismiss();
    }
  }
  // 保存发红包的信息 type 1自己给别人发，2收到别人发的红包
  saveHBinfo(String info) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    String combineID = '';
    if (int.parse(sp.getString('user_id').toString()) >
        int.parse(widget.uid)) {
      combineID = '${widget.uid}-${sp.getString('user_id').toString()}';
    } else {
      combineID = '${sp.getString('user_id').toString()}-${widget.uid}';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id').toString(),
      'otherUid': widget.uid,
      'whoUid': sp.getString('user_id').toString(),
      'combineID': combineID,
      'nickName': widget.nickName,
      'content': '送出$info个金豆',
      'headNetImg': sp.getString('user_headimg').toString(),
      'otherHeadNetImg': widget.otherImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 6,
      'number': 0,
      'status': 1,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
      'weight': widget.uid.toString() == '1' ? 1 : 0,
      'msgId': '',
      'msgRead': 0,
      'msgJson': '',
    };
    // 插入数据
    await databaseHelper.insertData('messageSLTable', params);
  }
}