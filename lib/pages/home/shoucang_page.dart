import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
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
      onTap: ((){
        if(index%2 == 0){
          Future.delayed(const Duration(seconds: 0), (){
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return RoomPage(type: 0,);
                }));
          });
        }else{
          Future.delayed(const Duration(seconds: 0), (){
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return RoomPage(type: 1,);
                }));
          });
        }
      }),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            WidgetUtils.CircleImageNet(ScreenUtil().setHeight(320),ScreenUtil().setHeight(320),10.0,'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 120, 10, 0),
              child: Text(
                '欲望女神  全麦等一个...',
                style: StyleUtils.getCommonTextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 150, 10, 0),
              child: Row(
                children: [
                  WidgetUtils.showImages('assets/images/zhibo2.webp', 10, 15),
                  Text(
                    '10000',
                    style: StyleUtils.getCommonTextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(18),fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),

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
          ? GridView.builder(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20, //设置列间距
            mainAxisSpacing: 10, //设置行间距
          ),
          itemBuilder: _initlistdata)
          : Container(
        height: ScreenUtil().setHeight(500),
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(20, 0),
            WidgetUtils.showImages(
                'assets/images/guard_group_under_review.png',
                180,
                180),
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
