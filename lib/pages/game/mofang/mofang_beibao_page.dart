import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../utils/my_toast_utils.dart';

/// 厅内礼物
class MoFangBeiBaoPage extends StatefulWidget {
  const MoFangBeiBaoPage({super.key});

  @override
  State<MoFangBeiBaoPage> createState() => _MoFangBeiBaoPageState();
}

class _MoFangBeiBaoPageState extends State<MoFangBeiBaoPage> {
  int leixing = 0;

  Widget _itemPeople(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        MyToastUtils.showToastBottom('点击了');
      }),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        height: ScreenUtil().setHeight(60),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            WidgetUtils.CircleHeadImage(
                ScreenUtil().setHeight(50),
                ScreenUtil().setHeight(50),
                'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
            WidgetUtils.showImages('assets/images/room_tingzhu.png',
                ScreenUtil().setHeight(20), ScreenUtil().setHeight(20)),
            Container(
              width: ScreenUtil().setHeight(20),
              height: ScreenUtil().setHeight(20),
              alignment: Alignment.center,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.roomCirle,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(width: 0.5, color: MyColors.roomTCWZ2),
              ),
              child: Text(
                '1',
                style: StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: ScreenUtil().setSp(14)),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 礼物
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {}),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setHeight(150),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(5, 0),
                  WidgetUtils.showImagesNet('https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500',
                      ScreenUtil().setHeight(100), ScreenUtil().setHeight(140)),
                  WidgetUtils.onlyTextCenter('礼物名称', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyTextCenter('1999钻', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(21))),
                ],
              ),
            ),
            WidgetUtils.showImagesFill('assets/images/room_liwu_bg.png',
                ScreenUtil().setHeight(200), ScreenUtil().setHeight(150)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(490),
            width: double.infinity,
            padding: EdgeInsets.only(left: 30.h, right: 20.h),
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(10, 0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          leixing = 0;
                        });
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          '背包',
                          StyleUtils.getCommonTextStyle(
                              color: leixing == 0
                                  ? MyColors.roomTCWZ2
                                  : MyColors.roomTCWZ3,
                              fontSize: leixing == 0 ? ScreenUtil().setSp(28) : ScreenUtil().setSp(25))),
                    ),
                  ],
                ),
                /// 展示礼物
                Expanded(child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 30.h, //设置列间距
                      mainAxisSpacing: 0.h, //设置行间距
                    ),
                    itemBuilder: _initlistdata)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
