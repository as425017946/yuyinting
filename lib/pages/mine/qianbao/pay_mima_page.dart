import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../../utils/log_util.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 支付密码
class PayMiMaPage extends StatefulWidget {
  const PayMiMaPage({super.key});

  @override
  State<PayMiMaPage> createState() => _PayMiMaPageState();
}

class _PayMiMaPageState extends State<PayMiMaPage> {

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        resizeToAvoidBottomInset: false, // 解决键盘顶起页面
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (() {
                  Navigator.pop(context);
                }),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              width: ScreenUtil().setHeight(506),
              height: ScreenUtil().setHeight(262),
              decoration: const BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage("assets/images/room_jiaoyimm.png"),
                  fit: BoxFit.fill, //覆盖
                ),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(20, 0),
                  WidgetUtils.onlyTextCenter(
                      '请输入交易密码',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(29))),
                  WidgetUtils.commonSizedBox(50, 0),
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: ScreenUtil().setHeight(80), right: ScreenUtil().setHeight(80),),
                    child: PinCodeTextField(
                      length: 6,
                      inputFormatters: [
                        // 表示只能输入字母大写小写都可以
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      // animationDuration: const Duration(milliseconds: 300),
                      controller: textEditingController,
                      onChanged: (value) {
                        LogE('返回数据$value');
                      },
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      textStyle: StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(38)),
                      appContext: context,
                      keyboardType: TextInputType.number,
                      autoFocus: true,
                      // enableActiveFill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(2),
                        borderWidth: 0.2,
                        fieldHeight: ScreenUtil().setHeight(64),
                        fieldWidth: ScreenUtil().setHeight(43),
                        activeFillColor: Colors.transparent,
                        //填充背景色
                        activeColor: MyColors.g6,
                        //下划线颜色
                        inactiveFillColor: MyColors.g6,
                        inactiveColor: MyColors.g6,
                        selectedColor: MyColors.g6,
                        selectedFillColor: MyColors.g6,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (() {
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
        ));
  }
}
