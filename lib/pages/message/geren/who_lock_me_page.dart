import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
/// 谁看过我
class WhoLockMePage extends StatefulWidget {
  const WhoLockMePage({Key? key}) : super(key: key);

  @override
  State<WhoLockMePage> createState() => _WhoLockMePageState();
}

class _WhoLockMePageState extends State<WhoLockMePage> {
  // var appbar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appbar = WidgetUtils.getAppBar('谁看过我', true, context, false, 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: ScreenUtil().setHeight(130),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        width: double.infinity,
        child: Row(
          children: [
            GestureDetector(
              onTap: ((){
                Navigator.pushNamed(context, 'PeopleInfoPage');
              }),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(110), ScreenUtil().setWidth(110), 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                  WidgetUtils.showImages('assets/images/zhibozhong.webp', ScreenUtil().setHeight(110), ScreenUtil().setWidth(110),),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(0, 10),
            Expanded(
              child: Column(
                children: [
                  const Expanded(child: Text('')),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          '系统消息',
                          style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32)),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(20),
                          width: ScreenUtil().setWidth(40),
                          margin: const EdgeInsets.only(left: 5),
                          alignment: Alignment.center,
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: MyColors.dtPink ,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: WidgetUtils.showImages(
                              'assets/images/nv.png',
                              10,
                              10),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(
                      'aaaaaa',
                      style: StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(30)),
                    ),
                  ),
                  const Expanded(child: Text('')),
                ],
              ),
            ),
            Column(
              children: [
                const Expanded(child: Text('')),
                WidgetUtils.onlyTextCenter('05-21', StyleUtils.getCommonTextStyle(color: MyColors.homeNoHave, fontSize: ScreenUtil().setSp(21))),
                WidgetUtils.onlyTextCenter('10:30', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
                const Expanded(child: Text('')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}