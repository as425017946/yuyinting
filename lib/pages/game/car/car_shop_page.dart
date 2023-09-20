import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../utils/custom_dialog.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/queren_page.dart';
///赛车商城
class CarShopPage extends StatefulWidget {
  const CarShopPage({super.key});

  @override
  State<CarShopPage> createState() => _CarShopPageState();
}

class _CarShopPageState extends State<CarShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
              child: Container(
                color: Colors.transparent,
              )),
          Container(
            height: 750.h,
            width: double.infinity,
            margin: EdgeInsets.all(20.h),
            decoration: const BoxDecoration(
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage('assets/images/car/car_jl_bg.png'),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(40.h, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 350.h),
                    WidgetUtils.showImages('assets/images/car_mogubi.png', 40.h, 40.h),
                    WidgetUtils.commonSizedBox(0, 5.h),
                    WidgetUtils.onlyText('1', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 40.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
                WidgetUtils.commonSizedBox(40.h, 0.h),
                WidgetUtils.onlyTextCenter('在金蘑菇商店里兑换的礼物，价值与V豆相等', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 25.sp)),
                WidgetUtils.commonSizedBox(30.h, 0.h),
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          height: 150.h,
                          width: 150.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)),
                            //设置四周边框
                            border: Border.all(width: 1, color: MyColors.CarZJ),
                          ),
                          child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 130.h, 130.h),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        SizedBox(
                          width: 150.h,
                          child: Row(
                            children: [
                              const Spacer(),
                              WidgetUtils.showImages('assets/images/car_mogubi.png', 20.h, 20.h),
                              WidgetUtils.commonSizedBox(0, 5.h),
                              WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 22.sp, fontWeight: FontWeight.w600)),
                              const Spacer(),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        GestureDetector(
                          onTap: ((){
                            MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车商店', jine: '10', isDuiHuan: true,));
                          }),
                          child: Container(
                            height: 35.h,
                            width: 120.h,
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.CarZJ,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(
                                  Radius.circular(21)),
                            ),
                            child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 24.sp)),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          height: 150.h,
                          width: 150.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)),
                            //设置四周边框
                            border: Border.all(width: 1, color: MyColors.CarZJ),
                          ),
                          child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 130.h, 130.h),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        SizedBox(
                          width: 150.h,
                          child: Row(
                            children: [
                              const Spacer(),
                              WidgetUtils.showImages('assets/images/car_mogubi.png', 20.h, 20.h),
                              WidgetUtils.commonSizedBox(0, 5.h),
                              WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 22.sp, fontWeight: FontWeight.w600)),
                              const Spacer(),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        GestureDetector(
                          onTap: ((){

                          }),
                          child: Container(
                            height: 35.h,
                            width: 120.h,
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.CarZJ,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(
                                  Radius.circular(21)),
                            ),
                            child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 24.sp)),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          height: 150.h,
                          width: 150.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)),
                            //设置四周边框
                            border: Border.all(width: 1, color: MyColors.CarZJ),
                          ),
                          child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 130.h, 130.h),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        SizedBox(
                          width: 150.h,
                          child: Row(
                            children: [
                              const Spacer(),
                              WidgetUtils.showImages('assets/images/car_mogubi.png', 20.h, 20.h),
                              WidgetUtils.commonSizedBox(0, 5.h),
                              WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 22.sp, fontWeight: FontWeight.w600)),
                              const Spacer(),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        GestureDetector(
                          onTap: ((){

                          }),
                          child: Container(
                            height: 35.h,
                            width: 120.h,
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.CarZJ,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(
                                  Radius.circular(21)),
                            ),
                            child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 24.sp)),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                WidgetUtils.commonSizedBox(30.h, 0.h),
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          height: 150.h,
                          width: 150.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)),
                            //设置四周边框
                            border: Border.all(width: 1, color: MyColors.CarZJ),
                          ),
                          child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 130.h, 130.h),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        SizedBox(
                          width: 150.h,
                          child: Row(
                            children: [
                              const Spacer(),
                              WidgetUtils.showImages('assets/images/car_mogubi.png', 20.h, 20.h),
                              WidgetUtils.commonSizedBox(0, 5.h),
                              WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 22.sp, fontWeight: FontWeight.w600)),
                              const Spacer(),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        GestureDetector(
                          onTap: ((){

                          }),
                          child: Container(
                            height: 35.h,
                            width: 120.h,
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.CarZJ,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(
                                  Radius.circular(21)),
                            ),
                            child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 24.sp)),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          height: 150.h,
                          width: 150.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)),
                            //设置四周边框
                            border: Border.all(width: 1, color: MyColors.CarZJ),
                          ),
                          child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 130.h, 130.h),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        SizedBox(
                          width: 150.h,
                          child: Row(
                            children: [
                              const Spacer(),
                              WidgetUtils.showImages('assets/images/car_mogubi.png', 20.h, 20.h),
                              WidgetUtils.commonSizedBox(0, 5.h),
                              WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 22.sp, fontWeight: FontWeight.w600)),
                              const Spacer(),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        GestureDetector(
                          onTap: ((){

                          }),
                          child: Container(
                            height: 35.h,
                            width: 120.h,
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.CarZJ,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(
                                  Radius.circular(21)),
                            ),
                            child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 24.sp)),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          height: 150.h,
                          width: 150.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10)),
                            //设置四周边框
                            border: Border.all(width: 1, color: MyColors.CarZJ),
                          ),
                          child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 130.h, 130.h),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        SizedBox(
                          width: 150.h,
                          child: Row(
                            children: [
                              const Spacer(),
                              WidgetUtils.showImages('assets/images/car_mogubi.png', 20.h, 20.h),
                              WidgetUtils.commonSizedBox(0, 5.h),
                              WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 22.sp, fontWeight: FontWeight.w600)),
                              const Spacer(),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(10.h, 0.h),
                        GestureDetector(
                          onTap: ((){

                          }),
                          child: Container(
                            height: 35.h,
                            width: 120.h,
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.CarZJ,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(
                                  Radius.circular(21)),
                            ),
                            child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 24.sp)),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: WidgetUtils.showImages(
                'assets/images/car/car_guanbi.png', 70.h, 70.h),
          ),
          Expanded(
              child: Container(
                color: Colors.transparent,
              )),
        ],
      ),
    );
  }


  /// 兑换确认
  Future<void> duihuan(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: '是否确认兑换此礼物？',
            callback: (res) {
              //确认兑换后请求接口
            },
            content: '',
          );
        });
  }
}
