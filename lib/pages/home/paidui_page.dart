import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

///派对页面
class PaiduiPage extends StatefulWidget {
  const PaiduiPage({Key? key}) : super(key: key);

  @override
  State<PaiduiPage> createState() => _PaiduiPageState();
}

class _PaiduiPageState extends State<PaiduiPage> {
  final TextEditingController _souSuoName = TextEditingController();
  int index = 0;

  Widget _itemPaihang(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            MyToastUtils.showToastBottom('点击了');
          }),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(160),
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 10),
                WidgetUtils.CircleImageNet(
                    ScreenUtil().setHeight(140),
                    ScreenUtil().setHeight(140),
                    10,
                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(10, 0),
                      WidgetUtils.onlyText(
                          '用户名$i',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const Expanded(child: Text('')),
                      Row(
                        children: [
                          WidgetUtils.paiduiBtn(MyColors.paiduiOrange, '新厅',
                              'assets/images/paidui_xinting.png'),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.onlyText(
                              '正在玩大转盘',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.paiduiPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(20)))
                        ],
                      ),
                      const Expanded(child: Text('')),
                      Row(
                        children: [
                          WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(30),
                              ScreenUtil().setHeight(30),
                              'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText(
                              '张三',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(20))),
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(30),
                              ScreenUtil().setHeight(30),
                              'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                          Transform.translate(
                            offset: const Offset(-8, 0),
                            child: WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(30),
                                ScreenUtil().setHeight(30),
                                'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                          ),
                          Transform.translate(
                            offset: const Offset(-15, 0),
                            child: WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(30),
                                ScreenUtil().setHeight(30),
                                'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                          ),
                          Transform.translate(
                            offset: const Offset(-20, 0),
                            child: WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(30),
                                ScreenUtil().setHeight(30),
                                'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                          ),Transform.translate(
                            offset: const Offset(-25, 0),
                            child: WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(30),
                                ScreenUtil().setHeight(30),
                                'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                          ),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                    ],
                  ),
                ),

                /// 热度
                Row(
                  children: [
                    WidgetUtils.showImages('assets/images/paidui_redu.png',
                        ScreenUtil().setHeight(30), ScreenUtil().setHeight(24)),
                    WidgetUtils.commonSizedBox(0, 5),
                    WidgetUtils.onlyText(
                        '1.0w',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(30)))
                  ],
                ),
                WidgetUtils.commonSizedBox(0, 10),
              ],
            ),
          ),
        ),
        WidgetUtils.commonSizedBox(8, 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.homeBG,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: WidgetUtils.onlyText(
                  '热门排行',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.bold)),
            ),
            WidgetUtils.commonSizedBox(10, 0),

            ///顶部排行
            SizedBox(
              width: double.infinity,
              height: ScreenUtil().setHeight(300),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        WidgetUtils.CircleImageNet(
                            double.infinity,
                            double.infinity,
                            10,
                            'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                        Transform.translate(
                          offset: const Offset(-5, -5),
                          child: WidgetUtils.showImages(
                              'assets/images/paidui_one.png',
                              ScreenUtil().setHeight(84),
                              ScreenUtil().setWidth(79)),
                        )
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 5),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              WidgetUtils.CircleImageNet(
                                  double.infinity,
                                  double.infinity,
                                  10,
                                  'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                              Transform.translate(
                                offset: const Offset(-5, -4),
                                child: WidgetUtils.showImages(
                                    'assets/images/paidui_two.png',
                                    ScreenUtil().setHeight(60),
                                    ScreenUtil().setWidth(55)),
                              )
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(5, 0),
                        Expanded(
                          child: WidgetUtils.CircleImageNet(
                              double.infinity,
                              double.infinity,
                              10,
                              'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                        )
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 5),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              WidgetUtils.CircleImageNet(
                                  double.infinity,
                                  double.infinity,
                                  10,
                                  'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                              Transform.translate(
                                offset: const Offset(-5, -4),
                                child: WidgetUtils.showImages(
                                    'assets/images/paidui_three.png',
                                    ScreenUtil().setHeight(60),
                                    ScreenUtil().setWidth(42)),
                              )
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(5, 0),
                        Expanded(
                          child: WidgetUtils.CircleImageNet(
                              double.infinity,
                              double.infinity,
                              10,
                              'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(5, 0),
            /// 标题栏 、 导航栏
            Row(
              children: [
                GestureDetector(
                  onTap: (() {
                    setState(() {
                      index = 0;
                    });
                  }),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(56),
                      ScreenUtil().setHeight(140),
                      index == 0 ? MyColors.btn_d : MyColors.homeBG,
                      index == 0 ? MyColors.btn_d : MyColors.homeBG,
                      '声音派对',
                      ScreenUtil().setSp(28),
                      index == 0 ? Colors.white : MyColors.g6),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: (() {
                    setState(() {
                      index = 1;
                    });
                  }),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(56),
                    width: ScreenUtil().setHeight(160),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        index == 1
                            ? WidgetUtils.showImagesFill(
                                'assets/images/paidui_diantai_bg.png',
                                ScreenUtil().setHeight(56),
                                ScreenUtil().setHeight(160))
                            : const Text(''),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: ScreenUtil().setHeight(160),
                          padding: const EdgeInsets.only(left: 9),
                          child: WidgetUtils.showImages(
                              'assets/images/paidui_diantai1.png',
                              ScreenUtil().setHeight(24),
                              ScreenUtil().setHeight(116)),
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: (() {
                    setState(() {
                      index = 2;
                    });
                  }),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(56),
                      ScreenUtil().setHeight(100),
                      index == 2 ? MyColors.btn_d : MyColors.homeBG,
                      index == 2 ? MyColors.btn_d : MyColors.homeBG,
                      '新厅',
                      ScreenUtil().setSp(28),
                      index == 2 ? Colors.white : MyColors.g6),
                ),
              ],
            ),
            ListView.builder(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _itemPaihang,
              itemCount: 15,
            ),
          ],
        ),
      ),
    );
  }
}
