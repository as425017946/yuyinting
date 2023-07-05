import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../utils/my_toast_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
///在线
class ZaixianPage extends StatefulWidget {
  const ZaixianPage({Key? key}) : super(key: key);

  @override
  State<ZaixianPage> createState() => _ZaixianPageState();
}

class _ZaixianPageState extends State<ZaixianPage> {


  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: ((){
            MyToastUtils.showToastBottom('点击了');
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [

                WidgetUtils.CircleHeadImage(40, 40, 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText('用户名$i', StyleUtils.getCommonTextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14)),
                            WidgetUtils.commonSizedBox(0, 5),
                            Stack(
                              children: [
                                WidgetUtils.showImages('assets/images/avk.png', 15, 45),
                                Container(
                                  padding: const EdgeInsets.only(right: 7),
                                  width: 45,
                                  height: 15,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '21',
                                    style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'a...',
                          textAlign: TextAlign.left,
                          style: StyleUtils.getCommonTextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                WidgetUtils.showImages('assets/images/trends_hi.png', 22, 60),
                WidgetUtils.commonSizedBox(0, 20),

              ],
            ),
          ),
        ),
        WidgetUtils.myLine(indent: 20,endIndent: 20)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.homeBG,
      child: ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: _itemTuiJian,
        itemCount: 15,
      ),
    );
  }
}
