import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';

/// 座驾
class ZuojiaPage extends StatefulWidget {
  const ZuojiaPage({Key? key}) : super(key: key);

  @override
  State<ZuojiaPage> createState() => _ZuojiaPageState();
}

class _ZuojiaPageState extends State<ZuojiaPage> {
  var length = 20;
  List<bool> listB = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // for (int i = 0; i < length; i++) {
    //   listB.add(false);
    // }
  }

  Widget _itemLiwu(BuildContext context, int i) {
    return sp.getString('isShop').toString() == '1'
        ? GestureDetector(
            onTap: (() {
              setState(() {
                for (int a = 0; a < length; a++) {
                  if (a == i) {
                    listB[a] = !listB[a];
                  } else {
                    listB[a] = false;
                  }
                }
              });
            }),
            child: Container(
              width: ScreenUtil().setHeight(211),
              height: ScreenUtil().setHeight(325),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage(listB[i] == true
                      ? "assets/images/zhuangban_bg2.png"
                      : "assets/images/zhuangban_bg1.png"),
                  fit: BoxFit.fill, //覆盖
                ),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(20, 20),
                  WidgetUtils.showImagesNet(
                      'https://img-blog.csdnimg.cn/3d809148c83f4720b5e2a6567f816d89.jpeg',
                      ScreenUtil().setHeight(200),
                      ScreenUtil().setHeight(200)),
                  WidgetUtils.commonSizedBox(10, 20),
                  WidgetUtils.onlyTextCenter(
                      '礼物名称',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyTextCenter(
                      '有效时长：5天',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.commonSizedBox(10, 20),
                ],
              ),
            ),
          )
        : Container(
            width: ScreenUtil().setHeight(211),
            height: ScreenUtil().setHeight(325),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage(listB[i] == true
                    ? "assets/images/zhuangban_bg2.png"
                    : "assets/images/zhuangban_bg1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20, 20),
                WidgetUtils.showImagesNet(
                    'https://img-blog.csdnimg.cn/3d809148c83f4720b5e2a6567f816d89.jpeg',
                    ScreenUtil().setHeight(200),
                    ScreenUtil().setHeight(200)),
                WidgetUtils.commonSizedBox(10, 20),
                WidgetUtils.onlyTextCenter(
                    '礼物名称2',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyTextCenter(
                    '剩余时长：5天',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.commonSizedBox(10, 20),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return length > 0
        ? SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: OptionGridView(
              itemCount: 20,
              rowCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemBuilder: _itemLiwu,
            ),
          ),
        )
        : Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Column(
              children: [
                const Expanded(child: Text('')),
                WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
                WidgetUtils.commonSizedBox(10, 0),
                WidgetUtils.onlyTextCenter(
                    '这里空空如野',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
                const Expanded(child: Text('')),
              ],
            ),
          );
  }
}
