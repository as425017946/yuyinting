import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 绑定手机号
class BingPhonePage extends StatefulWidget {
  String title;
  BingPhonePage({Key? key, required this.title}) : super(key: key);

  @override
  State<BingPhonePage> createState() => _BingPhonePageState();
}

class _BingPhonePageState extends State<BingPhonePage> {
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerMsg = TextEditingController();
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar(widget.title, true, context, false, 0);
  }


  late Timer _timer;
  int _timeCount = 60;
  var _autoCodeText = '获取短信验证码';
  void _startTimer() {
    MyToastUtils.showToastBottom('短信验证码已发送，请注意查收');
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) => {
      setState(() {
        if(_timeCount <= 0){
          _autoCodeText = '重新获取';
          _timer.cancel();
          _timeCount = 60;
        }else {
          _timeCount -= 1;
          _autoCodeText = "$_timeCount" + 's';
        }
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: ((){
              Navigator.pushNamed(context, 'ChooseCountryPage');
            }),
            child: Container(
              height: ScreenUtil().setHeight(90),
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.only(left: 20, right: 20),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //设置四周边框
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Row(
                children: [
                  WidgetUtils.onlyText('手机号归属地', StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(32))),
                  const Expanded(child: Text('')),
                  WidgetUtils.onlyText('+86', StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(29))),
                  WidgetUtils.commonSizedBox(0, 5),
                  WidgetUtils.showImages('assets/images/mine_more.png', 15, 20)
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(20, 0),
          Container(
            height: ScreenUtil().setHeight(90),
            margin: const EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.only(left: 20, right: 20),
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              //设置四周边框
              border: Border.all(width: 1, color: Colors.white),
            ),
            child: Row(
              children: [
                Expanded(
                    child: WidgetUtils.commonTextFieldNumber(controller: controllerPhone, hintText: '请输入手机号')
                ),
                GestureDetector(
                  onTap: ((){
                    if(controllerPhone.text.isEmpty){
                      MyToastUtils.showToastBottom('请输入手机号');
                    }else{
                      _startTimer();
                    }
                  }),
                  child: WidgetUtils.onlyText(_autoCodeText, StyleUtils.getCommonTextStyle(
                      color: MyColors.homeTopBG, fontSize: ScreenUtil().setSp(29))),
                ),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(20, 0),
          Container(
            height: ScreenUtil().setHeight(90),
            margin: const EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.only(left: 20, right: 20),
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              //设置四周边框
              border: Border.all(width: 1, color: Colors.white),
            ),
            child: WidgetUtils.commonTextFieldNumber(controller: controllerMsg, hintText: '请输入验证码'),
          ),
          WidgetUtils.commonSizedBox(100, 0),
          GestureDetector(
            onTap: ((){
              Navigator.pushNamed(context, 'JiesuanPage');
            }),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: WidgetUtils.myContainer(ScreenUtil().setHeight(80), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '下一步', ScreenUtil().setSp(33), Colors.white),
            ) ,
          ),
        ],
      ),
    );
  }
}