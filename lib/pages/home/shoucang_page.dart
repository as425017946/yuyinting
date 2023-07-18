import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/OptionGridView.dart';
import '../room/room_page.dart';

///收藏页面
class ShoucangPage extends StatefulWidget {
  const ShoucangPage({Key? key}) : super(key: key);

  @override
  State<ShoucangPage> createState() => _ShoucangPageState();
}

class _ShoucangPageState extends State<ShoucangPage> {
  int length = 10;

  ///收藏使用
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {
        // Future.delayed(const Duration(seconds: 0), (){
        //   Navigator.of(context).push(PageRouteBuilder(
        //       opaque: false,
        //       pageBuilder: (context, animation, secondaryAnimation) {
        //         return const RoomTSMiMaPage();
        //       }));
        // });
        if (index % 2 == 0) {
          Future.delayed(const Duration(seconds: 0), () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return RoomPage(
                    type: 0,
                  );
                }));
          });
        } else {
          Future.delayed(const Duration(seconds: 0), () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return RoomPage(
                    type: 1,
                  );
                }));
          });
        }
      }),
      child: Container(
        height: ScreenUtil().setHeight(260),
        width: ScreenUtil().setHeight(260),
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            WidgetUtils.CircleImageNet(
                ScreenUtil().setHeight(260),
                ScreenUtil().setHeight(260),
                10.0,
                'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  const Spacer(),
                  WidgetUtils.onlyText(
                      '房间标题',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(26))),
                  WidgetUtils.commonSizedBox(5, 0),
                  Row(
                    children: [
                      WidgetUtils.showImages(
                          'assets/images/zhibo2.webp', 10, 15),
                      Text(
                        '10000',
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.homeBG,
      child: length != 0
          ? SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: OptionGridView(
                  itemCount: 20,
                  rowCount: 2,
                  mainAxisSpacing: 15,// 上下间距
                  crossAxisSpacing: 30,//左右间距
                  itemBuilder: _initlistdata,
                ),
              ),
            )
          : Container(
              height: ScreenUtil().setHeight(500),
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(20, 0),
                  WidgetUtils.showImages(
                      'assets/images/guard_group_under_review.png', 180, 180),
                  WidgetUtils.commonSizedBox(20, 0),
                  WidgetUtils.onlyTextCenter(
                      '您还没有收藏的房间',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.homeNoHave,
                          fontSize: ScreenUtil().setSp(32)))
                ],
              ),
            ),
    );
  }
}
