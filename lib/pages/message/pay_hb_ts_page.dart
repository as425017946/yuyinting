import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/loading.dart';
import 'package:yuyinting/utils/my_utils.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 支付密码弹窗使用
class PayHBTSPage extends StatefulWidget {
  String uid;
  String number;
  PayHBTSPage({super.key, required this.uid,required this.number});

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
                width: ScreenUtil().setHeight(506),
                height: ScreenUtil().setHeight(520),
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
                    WidgetUtils.commonSizedBox(120, 0),
                    WidgetUtils.onlyTextCenter(
                        '请输入支付密码',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black87,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600)),
                    WidgetUtils.commonSizedBox(80.h, 0),
                    Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: ScreenUtil().setHeight(40), right: ScreenUtil().setHeight(40),),
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
                              Navigator.pop(context);
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
                          borderRadius: BorderRadius.circular(2),
                          fieldHeight: 100.h,
                          fieldWidth: 60.h,
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
          eventBus.fire(HongBaoBack(info: widget.number));
          MyToastUtils.showToastBottom('红包发送成功');
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
}