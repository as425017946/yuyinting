import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/mine/my/edit_biaoqian_page.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../utils/date_picker.dart';
import '../../../utils/widget_utils.dart';
import 'edit_head_page.dart';

///个人资料编辑页面
class EditMyInfoPage extends StatefulWidget {
  const EditMyInfoPage({Key? key}) : super(key: key);

  @override
  State<EditMyInfoPage> createState() => _EditMyInfoPageState();
}

class _EditMyInfoPageState extends State<EditMyInfoPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerGexing = TextEditingController();
  var appBar;
  List<File> imgArray = [];
  //0-未知 1-男 2-女
  int sex = 0;
  late List<String> list_sex = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('编辑个人资料', true, context, true, 1);
    list_sex.add('男');
    list_sex.add('女');
  }

  ///data设置数据源，selectData设置选中下标
  void _onClickItem(var data, var selectData) {
    Pickers.showSinglePicker(
      context,
      data: data,
      selectData: selectData,
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {
        print('longer >>> 返回数据下标：$position');
        print('longer >>> 返回数据：$p');
        print('longer >>> 返回数据类型：${p.runtimeType}');
        setState(() {

        });
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(20, 0),
            /// 头像
            GestureDetector(
              onTap: ((){
                Future.delayed(const Duration(seconds: 0), (){
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const EditHeadPage();
                      }));
                });
              }),
              child: Container(
                height: ScreenUtil().setHeight(140),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    WidgetUtils.onlyText(
                        '头像',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28))),
                    const Expanded(child: Text('')),
                    WidgetUtils.CircleHeadImage(
                        ScreenUtil().setHeight(130),
                        ScreenUtil().setWidth(130),
                        'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    WidgetUtils.commonSizedBox(0, 10),
                    WidgetUtils.showImages('assets/images/mine_more2.png',
                        ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                  ],
                ),
              ),
            ),
            WidgetUtils.myLine(indent: 20, endIndent: 20),

            /// 昵称
            Container(
              height: ScreenUtil().setHeight(140),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const Expanded(child: Text('')),
                  WidgetUtils.onlyText(
                      '昵称',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(28))),
                  WidgetUtils.commonTextField(controller, '请输入昵称')
                ],
              ),
            ),
            WidgetUtils.myLine(indent: 20, endIndent: 20),

            /// 性别
            GestureDetector(
              onTap: ((){
                _onClickItem(list_sex, '非必选');
              }),
              child: Container(
                height: ScreenUtil().setHeight(140),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    WidgetUtils.onlyText(
                        '性别',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28))),
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyText(
                        '男',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g6,
                            fontSize: ScreenUtil().setSp(28))),
                    WidgetUtils.commonSizedBox(0, 10),
                    WidgetUtils.showImages('assets/images/mine_more2.png',
                        ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                  ],
                ),
              ),
            ),
            WidgetUtils.myLine(indent: 20, endIndent: 20),

            /// 个性签名
            Container(
              height: ScreenUtil().setHeight(140),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const Expanded(child: Text('')),
                  WidgetUtils.onlyText(
                      '个性签名',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(28))),
                  WidgetUtils.commonTextField(
                      controllerGexing, '输入签名，展示你的独特个性吧')
                ],
              ),
            ),
            WidgetUtils.myLine(indent: 20, endIndent: 20),

            /// 生日
            GestureDetector(
              onTap: ((){
                DatePicker.show(
                  context,
                  startDate: DateTime(2022, 2, 2),
                  selectedDate: DateTime(2023, 3, 3),
                  endDate: DateTime(2025, 5, 5),
                  onSelected: (date) {

                  },
                );
              }),
              child: Container(
                height: ScreenUtil().setHeight(140),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                          children: [
                            const Expanded(child: Text('')),
                            WidgetUtils.onlyText(
                                '生日',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(28))),
                            WidgetUtils.commonSizedBox(10, 0),
                            WidgetUtils.onlyText(
                                '未填写',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.g6,
                                    fontSize: ScreenUtil().setSp(28))),
                          ],
                        )),
                    WidgetUtils.showImages('assets/images/mine_more2.png',
                        ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                  ],
                ),
              ),
            ),
            WidgetUtils.myLine(indent: 20, endIndent: 20),

            /// 声音名片
            GestureDetector(
              onTap: ((){
                Navigator.pushNamed(context, 'EditAudioPage');
              }),
              child: Container(
                height: ScreenUtil().setHeight(140),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    WidgetUtils.onlyText(
                        '声音名片',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28))),
                    const Expanded(child: Text('')),
                    WidgetUtils.showImages('assets/images/mine_more2.png',
                        ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                  ],
                ),
              ),
            ),
            WidgetUtils.myLine(indent: 20, endIndent: 20),

            /// 所在城市
            GestureDetector(
              onTap: ((){
              }),
              child: Container(
                height: ScreenUtil().setHeight(140),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    WidgetUtils.onlyText(
                        '所在城市',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28))),
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyText(
                        '唐山',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g6,
                            fontSize: ScreenUtil().setSp(28))),
                    WidgetUtils.commonSizedBox(0, 10),
                    WidgetUtils.showImages('assets/images/mine_more2.png',
                        ScreenUtil().setHeight(27), ScreenUtil().setHeight(16))
                  ],
                ),
              ),
            ),
            WidgetUtils.myLine(thickness: 10),

            /// 我的标签
            GestureDetector(
              onTap: ((){
                Future.delayed(const Duration(seconds: 0), (){
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const EditBiaoqianPage();
                      }));
                });
              }),
              child: Container(
                height: ScreenUtil().setHeight(140),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        WidgetUtils.onlyText(
                            '我的标签',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.bold)),
                        const Expanded(child: Text('')),
                        WidgetUtils.showImages(
                            'assets/images/mine_more2.png',
                            ScreenUtil().setHeight(27),
                            ScreenUtil().setHeight(16))
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        WidgetUtils.myContainerZishiying(
                            MyColors.f2,
                            '唱歌',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(26))),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.myContainerZishiying(
                            MyColors.f2,
                            '二次元',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(26))),
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.myContainerZishiying(
                            MyColors.f2,
                            '二次元',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(26))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            WidgetUtils.myLine(thickness: 10),

            /// 照片墙
            Container(
              height: ScreenUtil().setHeight(220),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(10, 0),
                  WidgetUtils.onlyText(
                      '照片墙',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.bold)),
                  WidgetUtils.commonSizedBox(10, 0),
                  Row(
                    children: [
                      WidgetUtils.CircleImageNet(55, 55, 10,
                          'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                      const Expanded(child: Text('')),
                      WidgetUtils.CircleImageNet(55, 55, 10,
                          'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                      const Expanded(child: Text('')),
                      WidgetUtils.CircleImageNet(55, 55, 10,
                          'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                      const Expanded(child: Text('')),
                      WidgetUtils.CircleImageNet(55, 55, 10,
                          'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                      const Expanded(child: Text('')),
                      WidgetUtils.CircleImageNet(55, 55, 10,
                          'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
