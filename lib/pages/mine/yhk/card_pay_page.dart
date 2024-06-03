import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/yhk/card_add_page.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 银行卡充值
class CardPayPage extends StatefulWidget {
  const CardPayPage({super.key});

  @override
  State<CardPayPage> createState() => _CardPayPageState();
}

class _CardPayPageState extends State<CardPayPage> {
  TextEditingController controllerSMS = TextEditingController();
  String? cardInfo = '请选择您的银行卡';
  List<String> cardList = ['请选择您的银行卡','123','456'];
  var appBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('银行卡充值', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(20.w, 20.w),
          Container(
            height: 200.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.showImagesFill(
                    'assets/images/card_bg.png', 200.h, double.infinity),
                Positioned(
                    top: 40.w,
                    child: WidgetUtils.onlyTextCenter(
                        '充值金豆:990',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.newHomeBlack,
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w600))),
                Positioned(
                    top: 130.w,
                    child: Row(
                      children: [
                        WidgetUtils.onlyTextCenter(
                            '充值金额:',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.newHomeBlack, fontSize: 30.sp)),
                        WidgetUtils.commonSizedBox(0, 5.w),
                        WidgetUtils.onlyTextCenter(
                            '99',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.newHomeBlack, fontSize: 48.sp)),
                        WidgetUtils.commonSizedBox(0, 5.w),
                        WidgetUtils.onlyTextCenter(
                            '元',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.newHomeBlack, fontSize: 30.sp))
                      ],
                    )),
              ],
            ),
          ),
          Container(
              height: 80.h,
              width: double.infinity,
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              child: WidgetUtils.onlyText(
                  '选择银行卡',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.newHomeBlack, fontSize: 30.sp))),
          Container(
            height: 80.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                Container(
                  width: 600.w,
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(Radius.circular(20.w)),
                    // border: Border.all(width: 1, color: MyColors.d8),
                  ),
                  alignment: Alignment.center,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none, // 设置为无边框
                    ),
                    value: cardInfo,
                    style: TextStyle(fontSize:30.sp, color: MyColors.newHomeBlack),
                    items: cardList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      print('Selected $value');
                      setState(() {
                        cardInfo = value;
                      });
                    },
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10.w),
                GestureDetector(
                  onTap: ((){
                    if(MyUtils.checkClick()){
                      MyUtils.goTransparentPageCom(context, const CardAddPage());
                    }
                  }),
                  child: WidgetUtils.onlyText(
                      '新增+',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.card2, fontSize: 28.sp)),
                )
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(10.h, 10.w),
          Container(
            height: 40.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: WidgetUtils.onlyText(
                '姓名：',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: 24.sp)),
          ),
          Container(
            height: 40.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: WidgetUtils.onlyText(
                '身份证号：',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: 24.sp)),
          ),
          Container(
            height: 40.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: WidgetUtils.onlyText(
                '银行名称：',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: 24.sp)),
          ),
          Container(
            height: 40.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: WidgetUtils.onlyText(
                '银行卡号：',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: 24.sp)),
          ),
          Container(
            height: 40.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: WidgetUtils.onlyText(
                '卡类：',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: 24.sp)),
          ),
          Container(
              height: 80.h,
              width: double.infinity,
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              child: WidgetUtils.onlyText(
                  '预留手机号',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.newHomeBlack, fontSize: 30.sp))),
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20.w),
              Expanded(
                child: WidgetUtils.cardTextField(controllerSMS, '请输入验证码'),
              ),
              WidgetUtils.commonSizedBox(0, 40.w),
              SizedBox(
                height: 70.h,
                width: 200.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.showImagesFill(
                        'assets/images/card_btn_lv.png', 70.h, 200.w),
                    WidgetUtils.onlyTextCenter(
                        '发送验证码',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.newHomeBlack, fontSize: 30.sp)),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(0, 20.w),
            ],
          ),
          WidgetUtils.commonSizedBox(50.w, 20.w),
          GestureDetector(
            onTap: (() {}),
            child: SizedBox(
              height: 100.h,
              width: 500.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  WidgetUtils.showImagesFill(
                      'assets/images/card_btn_fen.png', 100.h, 500.w),
                  Positioned(
                      top: 30.w,
                      child: WidgetUtils.onlyTextCenter(
                          '确认支付',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(50.w, 20.w),
          Container(
            height: 40.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: WidgetUtils.onlyText(
                '提示：',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: 24.sp)),
          ),
          Container(
            height: 40.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: WidgetUtils.onlyText(
                '1.请先绑定银行卡后再进行充值',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: 24.sp)),
          ),
          Container(
            height: 40.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: WidgetUtils.onlyText(
                '2.每笔金额充值均需核验验证码',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6, fontSize: 24.sp)),
          ),
        ],
      ),
    );
  }
}
