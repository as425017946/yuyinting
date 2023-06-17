import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 麦上声波
class ShengboPage extends StatefulWidget {
  const ShengboPage({Key? key}) : super(key: key);

  @override
  State<ShengboPage> createState() => _ShengboPageState();
}

class _ShengboPageState extends State<ShengboPage> {
  var length = 0;

  Widget _itemLiwu(BuildContext context, int i) {
    return GestureDetector(
      onTap: ((){

      }),
      child: Container(
        width: ScreenUtil().setHeight(211),
        height: ScreenUtil().setHeight(315),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/zhuangban_bg1.png"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(20, 20),
            WidgetUtils.showImagesNet('https://img-blog.csdnimg.cn/3d809148c83f4720b5e2a6567f816d89.jpeg', ScreenUtil().setHeight(200) , ScreenUtil().setHeight(200)),
            WidgetUtils.commonSizedBox(10, 20),
            WidgetUtils.onlyTextCenter('礼物名称', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.commonSizedBox(10, 20),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return length > 0 ?
    GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        itemCount: 40,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10, //设置列间距
          mainAxisSpacing: 20, //设置行间距
          childAspectRatio: 3/5,
        ),
        itemBuilder: _itemLiwu)
        :
    Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          const Expanded(child: Text('')),
          WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.onlyTextCenter('这里空空如野', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
          const Expanded(child: Text('')),
        ],
      ),
    );
  }
}
