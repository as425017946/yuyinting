import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../colors/my_colors.dart';
import '../../utils/my_utils.dart';
import '../../widget/SVGASimpleImage.dart';
import '../message/chat_page.dart';

/// 公屏打招呼使用
class GPHiPage extends StatefulWidget {
  String uid;
  String nickName;
  String avatar;
  String gender;

  GPHiPage(
      {super.key,
      required this.uid,
      required this.nickName,
      required this.avatar,
      required this.gender});

  @override
  State<GPHiPage> createState() => _GPHiPageState();
}

class _GPHiPageState extends State<GPHiPage>
    with SingleTickerProviderStateMixin {
  // 性别
  int gender = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      gender = int.parse(widget.gender);
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: 570.h,
            width: double.infinity,
            margin: EdgeInsets.only(right: 55.h, left: 55.h),
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage('assets/images/say_hi_bg.png'),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 570.h,
                  width: 500.w,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 120.h,
                        child: const SVGASimpleImage(
                          assetsName: 'assets/svga/gp/say_hi_xindong.svga',
                        ),
                      ),
                      Column(
                        children: [
                          WidgetUtils.commonSizedBox(100.h, 0),
                          WidgetUtils.CircleImageNet(
                              180.h, 180.h, 90.h, widget.avatar),
                          WidgetUtils.commonSizedBox(20.h, 0),
                          Row(
                            children: [
                              const Spacer(),
                              WidgetUtils.onlyTextCenter(
                                  widget.nickName,
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.a5,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(0.h, 10.h),
                              gender != 0
                                  ? Container(
                                      height: 30.h,
                                      width: 30.h,
                                      padding: EdgeInsets.all(5.h),
                                      alignment: Alignment.center,
                                      //边框设置
                                      decoration: BoxDecoration(
                                        //背景
                                        color: gender == 0
                                            ? MyColors.dtPink
                                            : MyColors.dtBlue,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.h)),
                                      ),
                                      child: WidgetUtils.showImages(
                                          gender == 0
                                              ? 'assets/images/nv.png'
                                              : 'assets/images/nan.png',
                                          30.h,
                                          30.h),
                                    )
                                  : const Text(''),
                              const Spacer(),
                            ],
                          ),
                          WidgetUtils.commonSizedBox(20.h, 0),
                          WidgetUtils.onlyTextCenter(
                              '正在向你打招呼',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontSize: 27.sp,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                        ],
                      ),
                    ],
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
                      Navigator.pop(context);
                      MyUtils.goTransparentRFPage(
                          context,
                          ChatPage(
                            nickName: widget.nickName,
                            otherUid: widget.uid,
                            otherImg: widget.avatar,
                          ));
                    }),
                    child: Container(
                      height: 68.h,
                      width: 280.w,
                      //边框设置
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          //背景图片修饰
                          image: AssetImage("assets/images/say_hi_btn.png"),
                          fit: BoxFit.fill, //覆盖
                        ),
                      ),
                      child: WidgetUtils.onlyTextCenter(
                          '回  复',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
    // return Scaffold(
    //   backgroundColor: Colors.transparent,
    //   body: SlideTransition(
    //     position: animation,
    //     child: Container(
    //       height: 160.h,
    //       width: double.infinity,
    //       margin: EdgeInsets.only(top: 80.h, right: 10.h, left: 10.h),
    //       decoration: const BoxDecoration(
    //         //设置Container修饰
    //         image: DecorationImage(
    //           //背景图片修饰
    //           image: AssetImage('assets/images/gp_huifu.png'),
    //           fit: BoxFit.fill, //覆盖
    //         ),
    //       ),
    //       child: Stack(
    //         children: [
    //           Row(
    //             children: [
    //               WidgetUtils.commonSizedBox(0, 20.h),
    //               SizedBox(
    //                 height: 120.h,
    //                 width: 120.h,
    //                 child: Stack(
    //                   alignment: Alignment.bottomRight,
    //                   children: [
    //                     WidgetUtils.CircleImageNet(
    //                       120.h,
    //                       120.h,
    //                       60.h,
    //                       widget.avatar,
    //                     ),
    //                     Container(
    //                       height: 30.h,
    //                       width: 30.h,
    //                       padding: EdgeInsets.all(5.h),
    //                       alignment: Alignment.center,
    //                       //边框设置
    //                       decoration: BoxDecoration(
    //                         //背景
    //                         color:
    //                         gender == 0 ? MyColors.dtPink : MyColors.dtBlue,
    //                         //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
    //                         borderRadius: BorderRadius.all(Radius.circular(15.h)),
    //                       ),
    //                       child: WidgetUtils.showImages(
    //                           gender == 0
    //                               ? 'assets/images/nv.png'
    //                               : 'assets/images/nan.png',
    //                           30.h,
    //                           30.h),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               WidgetUtils.commonSizedBox(0, 10.h),
    //               Expanded(
    //                   child: Column(
    //                     children: [
    //                       const Spacer(),
    //                       Row(
    //                         children: [
    //                           WidgetUtils.onlyText(
    //                               widget.nickName,
    //                               StyleUtils.getCommonTextStyle(
    //                                   color: Colors.black87,
    //                                   fontSize: 26.sp,
    //                                   fontWeight: FontWeight.w600)),
    //                           const Spacer(),
    //                         ],
    //                       ),
    //                       WidgetUtils.commonSizedBox(10.h, 20.h),
    //                       WidgetUtils.onlyText(
    //                           '正在向你打招呼',
    //                           StyleUtils.getCommonTextStyle(
    //                               color: MyColors.a5,
    //                               fontSize: 20.sp,
    //                               fontWeight: FontWeight.w600)),
    //                       const Spacer(),
    //                     ],
    //                   )),
    //               GestureDetector(
    //                 onTap: (() {
    //                   Navigator.pop(context);
    //                   MyUtils.goTransparentRFPage(context, ChatPage(nickName: widget.nickName, otherUid: widget.uid, otherImg: widget.avatar,));
    //                 }),
    //                 child: Container(
    //                   height: 56.h,
    //                   width: 130.h,
    //                   //边框设置
    //                   decoration: BoxDecoration(
    //                     //背景
    //                     color: MyColors.peopleBlue2,
    //                     //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
    //                     borderRadius: BorderRadius.all(Radius.circular(28.h)),
    //                   ),
    //                   child: WidgetUtils.onlyTextCenter(
    //                       '回复',
    //                       StyleUtils.getCommonTextStyle(
    //                           color: Colors.white,
    //                           fontSize: 25.sp,
    //                           fontWeight: FontWeight.w600)),
    //                 ),
    //               ),
    //               WidgetUtils.commonSizedBox(0, 20.h),
    //             ],
    //           ),
    //           Positioned(
    //             top: 10.h,
    //             right: 20.h,
    //             child: GestureDetector(
    //                 onTap: (() {
    //                   Navigator.pop(context);
    //                 }),
    //                 child: WidgetUtils.showImages(
    //                     'assets/images/login_colse.png', 20.h, 20.h)),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
