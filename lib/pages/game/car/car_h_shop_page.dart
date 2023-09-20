import 'package:flutter/material.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/queren_page.dart';
/// 横屏赛车商店
class CarHShopPage extends StatefulWidget {
  const CarHShopPage({super.key});

  @override
  State<CarHShopPage> createState() => _CarHShopPageState();
}

class _CarHShopPageState extends State<CarHShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Row(
        children: [
          const Spacer(),
          Opacity(
            opacity: 0,
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: WidgetUtils.showImages(
                  'assets/images/car/car_guanbi.png', 35, 35),
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: Container(
                    color: Colors.transparent,
                  )),
              Container(
                height: 320,
                width: 290,
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage('assets/images/car_h_shop.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(12, 0),
                    Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 175),
                        WidgetUtils.showImages('assets/images/car_mogubi.png', 18, 18),
                        WidgetUtils.commonSizedBox(0, 2.5),
                        WidgetUtils.onlyText('1', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    WidgetUtils.onlyTextCenter('在金蘑菇商店里兑换的礼物，价值与V豆相等', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 10)),
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
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
                              child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 65, 65),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            SizedBox(
                              width: 75,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  WidgetUtils.showImages('assets/images/car_mogubi.png', 15, 15),
                                  WidgetUtils.commonSizedBox(0, 2.5),
                                  WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 9, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            GestureDetector(
                              onTap: ((){
                                MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车商店', jine: '10', isDuiHuan: true,));
                              }),
                              child: Container(
                                height: 16,
                                width: 60,
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.CarZJ,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(9)),
                                ),
                                child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
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
                              child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 65, 65),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            SizedBox(
                              width: 75,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  WidgetUtils.showImages('assets/images/car_mogubi.png', 15, 15),
                                  WidgetUtils.commonSizedBox(0, 2.5),
                                  WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 9, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            GestureDetector(
                              onTap: ((){
                                MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车商店', jine: '10', isDuiHuan: true,));
                              }),
                              child: Container(
                                height: 16,
                                width: 60,
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.CarZJ,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(9)),
                                ),
                                child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
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
                              child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 65, 65),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            SizedBox(
                              width: 75,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  WidgetUtils.showImages('assets/images/car_mogubi.png', 15, 15),
                                  WidgetUtils.commonSizedBox(0, 2.5),
                                  WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 9, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            GestureDetector(
                              onTap: ((){
                                MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车商店', jine: '10', isDuiHuan: true,));
                              }),
                              child: Container(
                                height: 16,
                                width: 60,
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.CarZJ,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(9)),
                                ),
                                child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
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
                              child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 65, 65),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            SizedBox(
                              width: 75,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  WidgetUtils.showImages('assets/images/car_mogubi.png', 15, 15),
                                  WidgetUtils.commonSizedBox(0, 2.5),
                                  WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 9, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            GestureDetector(
                              onTap: ((){
                                MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车商店', jine: '10', isDuiHuan: true,));
                              }),
                              child: Container(
                                height: 16,
                                width: 60,
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.CarZJ,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(9)),
                                ),
                                child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
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
                              child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 65, 65),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            SizedBox(
                              width: 75,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  WidgetUtils.showImages('assets/images/car_mogubi.png', 15, 15),
                                  WidgetUtils.commonSizedBox(0, 2.5),
                                  WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 9, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            GestureDetector(
                              onTap: ((){
                                MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车商店', jine: '10', isDuiHuan: true,));
                              }),
                              child: Container(
                                height: 16,
                                width: 60,
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.CarZJ,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(9)),
                                ),
                                child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
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
                              child: WidgetUtils.showImagesNet('http://static.runoob.com/images/demo/demo2.jpg', 65, 65),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            SizedBox(
                              width: 75,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  WidgetUtils.showImages('assets/images/car_mogubi.png', 15, 15),
                                  WidgetUtils.commonSizedBox(0, 2.5),
                                  WidgetUtils.onlyText('100', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 9, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            GestureDetector(
                              onTap: ((){
                                MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车商店', jine: '10', isDuiHuan: true,));
                              }),
                              child: Container(
                                height: 16,
                                width: 60,
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.CarZJ,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(9)),
                                ),
                                child: WidgetUtils.onlyTextCenter('兑换', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
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
              Expanded(
                  child: Container(
                    color: Colors.transparent,
                  )),
            ],
          ),
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              height: double.infinity,
              width: 35,
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 20),
              child: WidgetUtils.showImages(
                  'assets/images/car/car_guanbi.png', 35, 35),
            ),
          ),
          const Spacer(),
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
