import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 实名制认证
class ShimingzhiPage extends StatefulWidget {
  const ShimingzhiPage({Key? key}) : super(key: key);

  @override
  State<ShimingzhiPage> createState() => _ShimingzhiPageState();
}

class _ShimingzhiPageState extends State<ShimingzhiPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerCard = TextEditingController();
  var appBar;
  bool isShow = false;
  var listen,listen2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //设置身份证号和姓名为空
    sp.setString('identity', '');
    sp.setString('realname', '');

    appBar = WidgetUtils.getAppBar('实名认证', true, context, false, 0);
    listen = eventBus.on<InfoBack>().listen((event) {
        if(event.info.isNotEmpty){
          LogE('返回结果${controllerName.text} **** ${controllerCard.text}');
          if(controllerName.text.isNotEmpty && controllerCard.text.isNotEmpty){
            setState(() {
              isShow = true;
            });
          }else{
            setState(() {
              isShow = false;
            });
          }
        }
    });

    listen2 = eventBus.on<RenzhengBack>().listen((event) {
      if(event.isBack){
        Navigator.pop(context);
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listen2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(100),
            alignment: Alignment.center,
            child: Row(
              children: [
                const Expanded(child: Text('')),
                SizedBox(
                  height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setHeight(60),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: ScreenUtil().setHeight(40),
                        height: ScreenUtil().setHeight(40),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.homeTopBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      WidgetUtils.onlyTextCenter(
                          '1',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(30))),
                    ],
                  ),
                ),
                WidgetUtils.onlyText(
                    '填写身份资料',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                WidgetUtils.commonSizedBox(0, 5),
                WidgetUtils.onlyText(
                    '-----',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g9, fontSize: ScreenUtil().setSp(29))),
                WidgetUtils.commonSizedBox(0, 5),
                SizedBox(
                  height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setHeight(60),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: ScreenUtil().setHeight(40),
                        height: ScreenUtil().setHeight(40),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.g9,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      WidgetUtils.onlyTextCenter(
                          '2',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(30))),
                    ],
                  ),
                ),
                WidgetUtils.onlyText(
                    '身份认证',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g9, fontSize: ScreenUtil().setSp(29))),
                const Expanded(child: Text('')),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(150),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            color: Colors.white,
            child: Column(
              children: [
                WidgetUtils.onlyText(
                    '姓名',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                WidgetUtils.commonSizedBox(10, 10),
                WidgetUtils.commonTextFieldRenzheng(controllerName, '请输入真实姓名'),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(10, 10),
          Container(
            height: ScreenUtil().setHeight(150),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            color: Colors.white,
            child: Column(
              children: [
                WidgetUtils.onlyText(
                    '身份证号',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                WidgetUtils.commonSizedBox(10, 10),
                WidgetUtils.commonTextFieldRenzheng(controllerCard, '请输入身份证号码'),
              ],
            ),
          ),
          WidgetUtils.renzhengText(
              '温馨提示:\n1.根据相关法律法规，在使用直播、提现服务之前，您需要填写身份信息实名认证;\n2.未满18周岁的用户无法进行实名，部分功能将无法正常使用，如无法成功提现;\n3.请您填写准确、真实的身份信息，实名信息将被作为身份识别，判定您的账号使用权归属依据；\n4.您所提交的身份信息将被严格保密，不会被用于其他用途'),
          WidgetUtils.commonSizedBox(20, 10),
          GestureDetector(
            onTap: (() {
              MyUtils.hideKeyboard(context);
              if(MyUtils.verifyCardId(controllerCard.text.trim())){
                sp.setString('identity', controllerCard.text.trim());
                sp.setString('realname', controllerName.text.trim());
                Navigator.pushNamed(context, 'ShimingzhiCardPage');
              }else{
                MyToastUtils.showToastBottom('输入的身份证号不合法');
              }

            }),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: WidgetUtils.myContainer(
                  ScreenUtil().setHeight(80),
                  double.infinity,
                  isShow == true ? MyColors.homeTopBG : MyColors.d8,
                  isShow == true ? MyColors.homeTopBG : MyColors.d8,
                  '下一步',
                  ScreenUtil().setSp(33),
                  Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
