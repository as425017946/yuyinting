import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
///收到的记录
class LiwuShoudaoPage extends StatefulWidget {
  const LiwuShoudaoPage({Key? key}) : super(key: key);

  @override
  State<LiwuShoudaoPage> createState() => _LiwuShoudaoPageState();
}

class _LiwuShoudaoPageState extends State<LiwuShoudaoPage> {
  var length = 0;

  Widget _itemLiwu(BuildContext context, int i) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(80),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,//宽度
                color: MyColors.f5, //边框颜色
              ),
            ),
          ),
          child: Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.CircleHeadImage(30, 30, 'https://img-blog.csdnimg.cn/3d809148c83f4720b5e2a6567f816d89.jpeg'),
              WidgetUtils.commonSizedBox(0, 10),
              WidgetUtils.onlyText('用户名$i', StyleUtils.getCommonTextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(31))),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('送给您的礼物', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(31))),
              WidgetUtils.commonSizedBox(0, 20),
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(200),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 10,//宽度
                color: MyColors.f5, //边框颜色
              ),
            ),
          ),
          child: Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.showImagesNet('https://img-blog.csdnimg.cn/3d809148c83f4720b5e2a6567f816d89.jpeg', ScreenUtil().setHeight(125), ScreenUtil().setHeight(125)),
              WidgetUtils.commonSizedBox(0, 20),
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyText('礼物：魔法星球x10', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                    WidgetUtils.commonSizedBox(10, 0),
                    WidgetUtils.onlyText('价格：1999 金币', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                    WidgetUtils.commonSizedBox(10, 0),
                    WidgetUtils.onlyText('时间：2023-06-09 13:00:00', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return length > 0 ? ListView.builder(
      itemBuilder: _itemLiwu,
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
          WidgetUtils.onlyTextCenter('暂无礼物', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
          const Expanded(child: Text('')),
        ],
      ),
    );
  }
}
