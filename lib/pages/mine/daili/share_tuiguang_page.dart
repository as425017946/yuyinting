import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/widget_utils.dart';
/// 推广页
class ShareTuiguangPage extends StatefulWidget {
  const ShareTuiguangPage({Key? key}) : super(key: key);

  @override
  State<ShareTuiguangPage> createState() => _ShareTuiguangPageState();
}

class _ShareTuiguangPageState extends State<ShareTuiguangPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('推广分享', true, context, false, 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(20, 20),
          /// 保存按钮
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: ((){
                    Navigator.pushNamed(context, 'ShareTuiguangPage');
                  }),
                  child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), ScreenUtil().setHeight(200), MyColors.dailiShare, MyColors.dailiShare, '保存图片', ScreenUtil().setSp(33), Colors.black) ,
                ),
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                  child: GestureDetector(
                    onTap: ((){

                    }),
                    child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '复制推广网址', ScreenUtil().setSp(33), Colors.white) ,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
