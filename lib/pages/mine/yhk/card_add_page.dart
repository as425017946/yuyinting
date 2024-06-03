import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../utils/widget_utils.dart';

/// 添加银行卡
class CardAddPage extends StatefulWidget {
  const CardAddPage({super.key});

  @override
  State<CardAddPage> createState() => _CardAddPageState();
}

class _CardAddPageState extends State<CardAddPage> {
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerCardNum = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerCard = TextEditingController();
  TextEditingController controllerSMS = TextEditingController();

  var appBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('新增银行卡', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(20.h, 0),
          Container(
            height: 200.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(30.w)),
            ),
            child: Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20.w),
                    WidgetUtils.onlyText('银行名称:', StyleUtils.getCommonTextStyle(color: MyColors.newHomeBlack, fontSize: 30.sp)),
                    WidgetUtils.commonSizedBox(0, 10.w),
                    Expanded(child: WidgetUtils.cardTextField(controllerAddress, '请输入银行名称'),),
                    WidgetUtils.commonSizedBox(0, 20.w),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20.w),
                    WidgetUtils.onlyText('银行卡号:', StyleUtils.getCommonTextStyle(color: MyColors.newHomeBlack, fontSize: 30.sp)),
                    WidgetUtils.commonSizedBox(0, 10.w),
                    Expanded(child: WidgetUtils.cardTextField(controllerAddress, '请输入银行卡号'),),
                    WidgetUtils.commonSizedBox(0, 20.w),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
            height: 80.h,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20.w),
                WidgetUtils.onlyText('卡        类:', StyleUtils.getCommonTextStyle(color: MyColors.newHomeBlack, fontSize: 30.sp)),
                WidgetUtils.commonSizedBox(0, 20.w),
                Container(
                  height: 50.h,
                  width: 130.w,
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: MyColors.card2,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.w)),
                    border: Border.all(width: 1, color: MyColors.card1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '借记卡',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 20.w),
                Container(
                  height: 50.h,
                  width: 130.w,
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: MyColors.homeBG,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.w)),
                    border: Border.all(width: 1, color: MyColors.card1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '贷记卡',
                    style: TextStyle(
                      color: MyColors.card2,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200.h,
            width: double.infinity,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(30.w)),
            ),
            child: Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20.w),
                    WidgetUtils.onlyText('姓        名:', StyleUtils.getCommonTextStyle(color: MyColors.newHomeBlack, fontSize: 30.sp)),
                    WidgetUtils.commonSizedBox(0, 10.w),
                    Expanded(child: WidgetUtils.cardTextField(controllerAddress, '请输入姓名'),),
                    WidgetUtils.commonSizedBox(0, 20.w),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20.w),
                    WidgetUtils.onlyText('身份证号:', StyleUtils.getCommonTextStyle(color: MyColors.newHomeBlack, fontSize: 30.sp)),
                    WidgetUtils.commonSizedBox(0, 10.w),
                    Expanded(child: WidgetUtils.cardTextField(controllerAddress, '请输入身份证号'),),
                    WidgetUtils.commonSizedBox(0, 20.w),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          Container(
              height: 80.h,
              width: double.infinity,
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              child: WidgetUtils.onlyText('预留手机号', StyleUtils.getCommonTextStyle(color: MyColors.newHomeBlack, fontSize: 30.sp))),
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20.w),
              Expanded(child: WidgetUtils.cardTextField(controllerSMS, '请输入验证码'),),
              WidgetUtils.commonSizedBox(0, 40.w),
              SizedBox(
                height: 70.h,
                width: 200.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.showImagesFill('assets/images/card_btn_lv.png', 70.h, 200.w),
                    WidgetUtils.onlyTextCenter('发送验证码', StyleUtils.getCommonTextStyle(color: MyColors.newHomeBlack, fontSize: 30.sp)),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(0, 20.w),
            ],
          ),
          WidgetUtils.commonSizedBox(50.w, 20.w),
          GestureDetector(
            onTap: ((){

            }),
            child: SizedBox(
              height: 100.h,
              width: 500.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  WidgetUtils.showImagesFill('assets/images/card_btn_fen.png', 100.h, 500.w),
                  Positioned(
                    top: 30.w,
                      child: WidgetUtils.onlyTextCenter('新增绑定', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
