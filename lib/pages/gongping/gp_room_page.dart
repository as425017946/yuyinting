import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/widget/SVGASimpleImage.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 公屏 邀请进入房间使用
class GPRoomPage extends StatefulWidget {
  const GPRoomPage({super.key});

  @override
  State<GPRoomPage> createState() => _GPRoomPageState();
}

class _GPRoomPageState extends State<GPRoomPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5),(){
      if(mounted) {
        // Navigator.pop(context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          height: 700.h,
          width: double.infinity,
          margin: EdgeInsets.only(right: 55.h, left: 55.h),
          decoration: const BoxDecoration(
            //设置Container修饰
            image: DecorationImage(
              //背景图片修饰
              image: AssetImage('assets/images/gp_room_bg.png'),
              fit: BoxFit.fill, //覆盖
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 50.h,
                child: Center(
                  child: SizedBox(
                    height: 500.h,
                    width: 500.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const SVGASimpleImage(
                          assetsName: 'assets/svga/gp/gp_room2.svga',
                        ),
                        SizedBox(
                          height: 300.h,
                          child: Column(
                            children: [
                              WidgetUtils.commonSizedBox(60.h, 0),
                              WidgetUtils.CircleImageNet(180.h, 180.h, 10.0,
                                  'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F650136a8-b170-43a0-ad8f-54b51c8f311b%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1702799471&t=c8b6986836edef6a1ab22f885d0c388a'),
                              WidgetUtils.commonSizedBox(10.h, 0),
                              WidgetUtils.onlyTextCenter(
                                  '房间名称',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.a5,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // 关闭按钮
              Positioned(
                top: 20.h,
                right: 20.h,
                child: GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: WidgetUtils.showImages(
                        'assets/images/login_colse.png', 30.h, 30.h)),
              ),
              // 进入房间按钮
              Positioned(
                bottom: 50.h,
                child: GestureDetector(
                  onTap: (() {
                    // MyUtils.goTransparentRFPage(context, ChatPage(nickName: list[i].nickname!, otherUid: list[i].uid.toString(), otherImg: list[i].avatar!,));
                  }),
                  child: Container(
                    height: 65.h,
                    width: 400.h,
                    margin: EdgeInsets.only(left: 50.h, right: 50.h),
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: MyColors.peopleBlue2,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(28.h)),
                    ),
                    child: WidgetUtils.onlyTextCenter(
                        '邀请你进入房间',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
