import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../colors/my_colors.dart';

/// 公屏打招呼使用
class GPHiPage extends StatefulWidget {
  const GPHiPage({super.key});

  @override
  State<GPHiPage> createState() => _GPHiPageState();
}

class _GPHiPageState extends State<GPHiPage> with SingleTickerProviderStateMixin {
  // 性别
  int gender = 0;
  late AnimationController controller;
  late Animation<Offset> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    controller.addListener(() {
      if (controller.isCompleted) {
        // 在动画完成时执行操作，例如关闭页面
        Navigator.pop(context);
      }
    });

    animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: const Offset(0, -2), end: Offset.zero), weight: 20),
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: Offset.zero), weight: 80),
    ]).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SlideTransition(
        position: animation,
        child: Container(
          height: 160.h,
          width: double.infinity,
          margin: EdgeInsets.only(top: 80.h, right: 10.h, left: 10.h),
          decoration: const BoxDecoration(
            //设置Container修饰
            image: DecorationImage(
              //背景图片修饰
              image: AssetImage('assets/images/gp_huifu.png'),
              fit: BoxFit.fill, //覆盖
            ),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20.h),
                  SizedBox(
                    height: 120.h,
                    width: 120.h,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        WidgetUtils.CircleImageNet(
                          120.h,
                          120.h,
                          60.h,
                          'http://static.runoob.com/images/demo/demo2.jpg',
                        ),
                        Container(
                          height: 30.h,
                          width: 30.h,
                          padding: EdgeInsets.all(5.h),
                          alignment: Alignment.center,
                          //边框设置
                          decoration: BoxDecoration(
                            //背景
                            color:
                            gender == 0 ? MyColors.dtPink : MyColors.dtBlue,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(15.h)),
                          ),
                          child: WidgetUtils.showImages(
                              gender == 0
                                  ? 'assets/images/nv.png'
                                  : 'assets/images/nan.png',
                              30.h,
                              30.h),
                        ),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 10.h),
                  Expanded(
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            children: [
                              WidgetUtils.onlyText(
                                  '昵称',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.black87,
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                            ],
                          ),
                          WidgetUtils.commonSizedBox(10.h, 20.h),
                          WidgetUtils.onlyText(
                              '正在向你打招呼',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.a5,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                        ],
                      )),
                  GestureDetector(
                    onTap: (() {
                      // MyUtils.goTransparentRFPage(context, ChatPage(nickName: list[i].nickname!, otherUid: list[i].uid.toString(), otherImg: list[i].avatar!,));
                    }),
                    child: Container(
                      height: 56.h,
                      width: 130.h,
                      //边框设置
                      decoration: BoxDecoration(
                        //背景
                        color: MyColors.peopleBlue2,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(28.h)),
                      ),
                      child: WidgetUtils.onlyTextCenter(
                          '回复',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 20.h),
                ],
              ),
              Positioned(
                top: 10.h,
                right: 20.h,
                child: GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: WidgetUtils.showImages(
                        'assets/images/login_colse.png', 20.h, 20.h)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
