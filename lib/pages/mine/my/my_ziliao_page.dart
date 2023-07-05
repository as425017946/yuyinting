import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

///资料

class MyZiliaoPage extends StatefulWidget {
  const MyZiliaoPage({Key? key}) : super(key: key);

  @override
  State<MyZiliaoPage> createState() => _MyZiliaoPageState();
}

class _MyZiliaoPageState extends State<MyZiliaoPage> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 0),
        Container(
          height: ScreenUtil().setHeight(260),
          padding: const EdgeInsets.only(left: 10, right: 10),
          //边框设置
          decoration: const BoxDecoration(
            //背景
            color: MyColors.peopleLiwu,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: ((){
                  Navigator.pushNamed(context, 'WallPage');
                }),
                child: Container(
                  height: ScreenUtil().setHeight(44),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      WidgetUtils.showImages('assets/images/people_liwu.png', ScreenUtil().setHeight(35), ScreenUtil().setHeight(35)),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.onlyText('礼物墙', StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(32))),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.onlyText('共收到0/300款', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(26))),
                      const Expanded(child: Text('')),
                      WidgetUtils.onlyText('查看', StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(26))),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.showImages('assets/images/people_right.png', ScreenUtil().setHeight(25), ScreenUtil().setHeight(15)),
                      WidgetUtils.commonSizedBox(0, 10),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(140), ScreenUtil().setWidth(140), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 10),
                    WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(140), ScreenUtil().setWidth(140), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 10),
                    WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(140), ScreenUtil().setWidth(140), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 10),
                    WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(140), ScreenUtil().setWidth(140), 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342')
                  ],
                ),
              )
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(20, 0),
        WidgetUtils.onlyText('关于我', StyleUtils.getCommonTextStyle(color: Colors.black , fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(28))),
        Container(
          height: ScreenUtil().setHeight(70),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              WidgetUtils.showImages('assets/images/people_xingzuo.png', ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
              WidgetUtils.commonSizedBox(0, 10),
              WidgetUtils.onlyText('未知', StyleUtils.getCommonTextStyle(color: MyColors.g3 ,  fontSize: ScreenUtil().setSp(25))),
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(70),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              WidgetUtils.showImages('assets/images/people_age.png', ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
              WidgetUtils.commonSizedBox(0, 10),
              WidgetUtils.onlyText('未知', StyleUtils.getCommonTextStyle(color: MyColors.g3 ,  fontSize: ScreenUtil().setSp(25))),
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(70),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              WidgetUtils.showImages('assets/images/people_dingwei.png', ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
              WidgetUtils.commonSizedBox(0, 10),
              WidgetUtils.onlyText('未知', StyleUtils.getCommonTextStyle(color: MyColors.g3 , fontSize: ScreenUtil().setSp(25))),
            ],
          ),
        ),
        WidgetUtils.myLine(thickness: 5),
        WidgetUtils.commonSizedBox(10, 0),
        WidgetUtils.onlyText('签名', StyleUtils.getCommonTextStyle(color: Colors.black , fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(28))),
        WidgetUtils.commonSizedBox(10, 0),
        WidgetUtils.onlyText('努力赚钱！！！！！', StyleUtils.getCommonTextStyle(color: Colors.black , fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(25))),
        WidgetUtils.commonSizedBox(20, 0),
        Row(
          children: [
            WidgetUtils.CircleImageNet(55, 55, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
            const Expanded(child: Text('')),
            WidgetUtils.CircleImageNet(55, 55, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
            const Expanded(child: Text('')),
            WidgetUtils.CircleImageNet(55, 55, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
            const Expanded(child: Text('')),
            WidgetUtils.CircleImageNet(55, 55, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
            const Expanded(child: Text('')),
            WidgetUtils.CircleImageNet(55, 55, 10, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
          ],
        )
      ],
    );
  }
}
