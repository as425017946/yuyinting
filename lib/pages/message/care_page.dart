import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../colors/my_colors.dart';
///关注的人
class CarePage extends StatefulWidget {
  const CarePage({Key? key}) : super(key: key);

  @override
  State<CarePage> createState() => _CarePageState();
}

class _CarePageState extends State<CarePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          WidgetUtils.onlyText('关注数（5）', StyleUtils.getCommonTextStyle(color: Colors.black , fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(28))),

          SizedBox(
            height: ScreenUtil().setHeight(130),
            width: double.infinity,
            child: Row(
              children: [
                GestureDetector(
                  onTap: ((){
                        Navigator.pushNamed(context, 'PeopleInfoPage');
                  }),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(110), ScreenUtil().setWidth(110), 'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                      WidgetUtils.showImages('assets/images/zhibozhong.webp', ScreenUtil().setHeight(110), ScreenUtil().setWidth(110),),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Text(
                              '系统消息',
                              style: StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(38)),
                            ),
                              Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setWidth(50),
                                alignment: Alignment.center,
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.dtPink ,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.showImages(
                                        'assets/images/nv.png',
                                    12,
                                    12),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          'aaaaaa',
                          style: StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(30)),
                        ),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setWidth(180),
                  alignment: Alignment.center,
                  //边框设置
                  decoration: const BoxDecoration(
                    //背景
                    color: MyColors.f6 ,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius:
                    BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetUtils.showImages('assets/images/care_guanzhu.png', 15, 20),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.onlyText('已关注', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(30)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
