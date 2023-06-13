import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
///动态

class DongtaiPage extends StatefulWidget {
  const DongtaiPage({Key? key}) : super(key: key);

  @override
  State<DongtaiPage> createState() => _DongtaiPageState();
}

class _DongtaiPageState extends State<DongtaiPage> {
  int length = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          length == 0 ? Container(
            height: ScreenUtil().setHeight(500),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetUtils.showImages('assets/images/trends_no.jpg', ScreenUtil().setHeight(150), ScreenUtil().setWidth(150)),
                WidgetUtils.commonSizedBox(20, 0),
                WidgetUtils.onlyTextCenter('这个人很懒，还没有发布过动态哦~', StyleUtils.textStyleG3),
              ],
            ),
          )
              :
              Text('111')
      ],
    );
  }
}
