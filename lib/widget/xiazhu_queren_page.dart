import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../colors/my_colors.dart';
import '../main.dart';
import '../utils/style_utils.dart';
/// 商品二次确认弹窗
class XiaZhuQueRenPage extends StatefulWidget {
  String cishu;
  String feiyong;
  String title;
  XiaZhuQueRenPage({super.key, required this.cishu, required this.feiyong, required this.title});

  @override
  State<XiaZhuQueRenPage> createState() => _QueRenPageState();
}

class _QueRenPageState extends State<XiaZhuQueRenPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LogE('次数${widget.cishu}');
  }
  // 默认选中今日不在弹出
  bool  isCheck = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: double.infinity,
          height: 300.h,
          margin: EdgeInsets.only(left: 50.h, right: 50.h),
          decoration: const BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(
                Radius.circular(10)),
          ),
          child: Column(
            children: [
              const Spacer(),
              RichText(
                text: TextSpan(
                    text: '本次兑换将消耗',
                    style: StyleUtils.getCommonTextStyle(
                        color: MyColors.g2, fontSize: 32.sp, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                          text: widget.feiyong,
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.origin, fontSize: 32.sp, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text:'个金豆',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g2, fontSize: 32.sp, fontWeight: FontWeight.w600)),
                    ]),
              ),
              WidgetUtils.commonSizedBox(20.h, 20.h),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: ((){
                      setState(() {
                        isCheck = !isCheck;
                      });
                    }),
                    child: WidgetUtils.showImages(isCheck ? 'assets/images/mofang_check_yes.png' : 'assets/images/mofang_check_no.png', 30.h, 30.h),
                  ),
                  WidgetUtils.commonSizedBox(0, 10.h),
                  WidgetUtils.onlyText('今日不在弹出', StyleUtils.getCommonTextStyle(
                      color: MyColors.g2, fontSize: 32.sp, fontWeight: FontWeight.w600)),
                  const Spacer(),
                ],
              ),
              WidgetUtils.commonSizedBox(40.h, 20.h),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: ((){
                      Navigator.pop(context);
                    }),
                    child: Container(
                      width: 200.h,
                      height: 80.h,
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.d8,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: WidgetUtils.onlyTextCenter('取消', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: 32.sp)),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 20.h),
                  GestureDetector(
                    onTap: ((){
                      if(MyUtils.checkClick()){
                        if(isCheck){
                          DateTime now = DateTime.now();
                          int year = now.year;
                          int month = now.month;
                          int day = now.day;
                          if(widget.title == '心动转盘') {
                            sp.setBool('zp1_queren', true);
                            sp.setString('zp1_queren_time', '$year-$month-$day');
                            eventBus.fire(XZQuerenBack(cishu: widget.cishu, feiyong: widget.feiyong, title: '心动转盘'));
                          }else if(widget.title == '超级转盘'){
                            sp.setBool('zp2_queren', true);
                            sp.setString('zp2_queren_time', '$year-$month-$day');
                            eventBus.fire(XZQuerenBack(cishu: widget.cishu, feiyong: widget.feiyong, title: '超级转盘'));
                          }else if(widget.title == '水星魔方'){
                            sp.setBool('mf1_queren', true);
                            sp.setString('mf1_queren_time', '$year-$month-$day');
                            eventBus.fire(ResidentBack(isBack: true));
                            eventBus.fire(XZQuerenBack(cishu: widget.cishu, feiyong: widget.feiyong, title: '水星魔方'));
                          }else if(widget.title == '金星魔方'){
                            sp.setBool('mf2_queren', true);
                            sp.setString('mf2_queren_time', '$year-$month-$day');
                            eventBus.fire(ResidentBack(isBack: true));
                            eventBus.fire(XZQuerenBack(cishu: widget.cishu, feiyong: widget.feiyong, title: '金星魔方'));
                          }
                        }else{
                          if(widget.title == '心动转盘') {
                            sp.setBool('zp1_queren', false);
                            eventBus.fire(XZQuerenBack(cishu: widget.cishu, feiyong: widget.feiyong, title: '心动转盘'));
                          }else if(widget.title == '超级转盘') {
                            sp.setBool('zp2_queren', false);
                            eventBus.fire(XZQuerenBack(cishu: widget.cishu, feiyong: widget.feiyong, title: '超级转盘'));
                          }else if(widget.title == '水星魔方') {
                            sp.setBool('mf1_queren', false);
                            eventBus.fire(ResidentBack(isBack: true));
                            eventBus.fire(XZQuerenBack(cishu: widget.cishu, feiyong: widget.feiyong, title: '水星魔方'));
                          }else if(widget.title == '金星魔方') {
                            sp.setBool('mf2_queren', false);
                            eventBus.fire(ResidentBack(isBack: true));
                            eventBus.fire(XZQuerenBack(cishu: widget.cishu, feiyong: widget.feiyong, title: '金星魔方'));
                          }
                        }
                        Navigator.pop(context);
                      }
                    }),
                    child: Container(
                      width: 200.h,
                      height: 80.h,
                      decoration: BoxDecoration(
                        //背景
                        color: widget.title == '心动转盘' ? MyColors.riBangBg : widget.title == '超级转盘' ? MyColors.peopleYellow : widget.title == '水星魔方' ? MyColors.walletWZBlue : MyColors.roomMessageYellow2,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: WidgetUtils.onlyTextCenter('确认', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 32.sp)),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              WidgetUtils.commonSizedBox(20.h, 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
