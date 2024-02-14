import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/regex_formatter.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 主播分瑞比例
class FenRunPage extends StatefulWidget {
  String name;
  String id;

  FenRunPage({super.key, required this.name, required this.id});

  @override
  State<FenRunPage> createState() => _FenRunPageState();
}

class _FenRunPageState extends State<FenRunPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
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
                  ))),
          Container(
            height: 300.h,
            width: 450.h,
            alignment: Alignment.center,
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20.h, 0),
                WidgetUtils.onlyTextCenter(
                    widget.name,
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: 28.sp)),
                const Spacer(),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0.h, 20.h),
                    WidgetUtils.onlyTextCenter(
                        '设置比例：',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black, fontSize: 24.sp)),
                    Expanded(
                        child: TextField(
                      controller: controller,
                      inputFormatters: [
                        RegexFormatter(regex: MyUtils.regexFirstNotNull),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      //设置键盘为数字
                      style: StyleUtils.loginTextStyle,
                      onChanged: (value) {

                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // labelText: "请输入用户名",
                        // icon: Icon(Icons.people), //前面的图标
                        hintText: '请填写50以上的数字',
                        hintStyle: StyleUtils.loginHintTextStyle,
                        // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                      ),
                    )),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: ((){
                    Navigator.pop(context);
                  }),
                  child: Container(
                    height: 70.h,
                    width: 150.h,
                    margin: EdgeInsets.only(bottom: 50.h),
                    alignment: Alignment.center,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.homeTopBG,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Text(
                      '确认',
                      style: StyleUtils.getCommonTextStyle(color: Colors.white,fontSize: 24.sp),
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
                  ))),
        ],
      ),
    );
  }
}
