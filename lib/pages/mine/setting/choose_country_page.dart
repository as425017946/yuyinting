import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 选择国家区号
class ChooseCountryPage extends StatefulWidget {
  const ChooseCountryPage({Key? key}) : super(key: key);

  @override
  State<ChooseCountryPage> createState() => _ChooseCountryPageState();
}

class _ChooseCountryPageState extends State<ChooseCountryPage> {
  TextEditingController controllerName = TextEditingController();
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('选择国家地区', true, context, false, 0);
  }


  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: ((){
            MyToastUtils.showToastBottom('点击了');
          }),
          child: SizedBox(
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                WidgetUtils.onlyText('中国$i', StyleUtils.getCommonTextStyle(color: MyColors.g3,fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(33))),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('+86', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(31))),
              ],
            ),
          ),
        ),
        WidgetUtils.myLine()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child:  Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: ScreenUtil().setHeight(70),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      //边框设置
                      decoration: BoxDecoration(
                        //背景
                        color: MyColors.f4,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                        //设置四周边框
                        border: Border.all(width: 1, color: MyColors.f4),
                      ),
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 10),
                          GestureDetector(
                            onTap: ((){
                              if(controllerName.text.isNotEmpty){

                              }else{
                                MyToastUtils.showToastBottom('请输入名称');
                              }
                            }),
                            child: WidgetUtils.showImages('assets/images/sousuo_hui.png',
                                ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                          Expanded(child: WidgetUtils.commonTextField(controllerName, '请输入名称')),
                        ],
                      ),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 0),
              WidgetUtils.onlyText('常用', StyleUtils.getCommonTextStyle(
                  color: MyColors.g3, fontSize: ScreenUtil().setSp(42), fontWeight: FontWeight.bold)),
              WidgetUtils.commonSizedBox(20, 0),
              ListView.builder(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: _itemTuiJian,
                itemCount: 6,
              ),
              WidgetUtils.commonSizedBox(20, 0),
              WidgetUtils.onlyText('#', StyleUtils.getCommonTextStyle(
                  color: MyColors.g3, fontSize: ScreenUtil().setSp(42), fontWeight: FontWeight.bold)),
              WidgetUtils.commonSizedBox(20, 0),
              ListView.builder(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: _itemTuiJian,
                itemCount: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
