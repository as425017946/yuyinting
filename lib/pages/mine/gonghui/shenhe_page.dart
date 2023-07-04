import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 入驻审核
class ShenhePage extends StatefulWidget {
  const ShenhePage({Key? key}) : super(key: key);

  @override
  State<ShenhePage> createState() => _ShenhePageState();
}

class _ShenhePageState extends State<ShenhePage> {
  var appBar;
  var length = 10;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('入驻审核', true, context, false, 0);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  /// 公会成员
  Widget _itemPeople(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
      width: double.infinity,
      height: ScreenUtil().setHeight(120),
      child: Row(
        children: [
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setWidth(100), 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
          WidgetUtils.commonSizedBox(0, 10),
          WidgetUtils.onlyText('用户名$i', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: 14)),
          WidgetUtils.commonSizedBox(0, 5),
          Container(
            height: ScreenUtil().setHeight(25),
            width: ScreenUtil().setWidth(40),
            alignment: Alignment.center,
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: i % 2 == 0 ? MyColors.dtPink : MyColors.dtBlue,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius:
              const BorderRadius.all(Radius.circular(30.0)),
            ),
            child: WidgetUtils.showImages(
                i % 2 == 0
                    ? 'assets/images/nv.png'
                    : 'assets/images/nan.png',
                10,
                10),
          ),
          const Expanded(child: Text('')),
          GestureDetector(
            onTap: ((){

            }),
            child: WidgetUtils.myContainer(ScreenUtil().setHeight(45), ScreenUtil().setHeight(90), Colors.white, MyColors.homeTopBG, '同意', ScreenUtil().setSp(25), MyColors.homeTopBG),
          ),
          WidgetUtils.commonSizedBox(0, 10),
          GestureDetector(
            onTap: ((){

            }),
            child: WidgetUtils.myContainer(ScreenUtil().setHeight(45), ScreenUtil().setHeight(90), Colors.white, MyColors.peopleRed, '拒绝', ScreenUtil().setSp(25), MyColors.peopleRed),
          ),
          WidgetUtils.commonSizedBox(0, 20),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: length > 0 ? ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        itemBuilder: _itemPeople,
        itemCount: length,
      )
      :
      Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: [
            const Expanded(child: Text('')),
            WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
            WidgetUtils.commonSizedBox(10, 0),
            WidgetUtils.onlyTextCenter('暂无申请人员', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
            const Expanded(child: Text('')),
          ],
        ),
      ),
    );
  }
}
