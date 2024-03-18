import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/trends/trends_more_page.dart';
import 'package:yuyinting/utils/my_utils.dart';
import '../../colors/my_colors.dart';
import '../../db/DatabaseHelper.dart';
import '../../utils/event_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../gongping/web_page.dart';

/// 系统消息
class XitongMorePage extends StatefulWidget {
  const XitongMorePage({Key? key}) : super(key: key);

  @override
  State<XitongMorePage> createState() => _XitongMorePageState();
}

class _XitongMorePageState extends State<XitongMorePage> {
  var appBar;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('系统消息', true, context, false, 0);
    getInfos();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 释放ScrollController资源
    super.dispose();
  }

  Widget message(BuildContext context, int i) {
    //类型 1纯文字 2纯图片 3图文 4动态
    if (allData2[i]['type'] == 1) {
      return GestureDetector(
        onTap: (() {}),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              WidgetUtils.commonSizedBox(10, 10),
              WidgetUtils.onlyTextCenter(
                  allData2[i]['add_time'],
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
              Row(
                children: [
                  WidgetUtils.showImages('assets/images/message_xt.webp',
                      ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.onlyTextCenter(
                      '系统消息',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(29))),
                ],
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                padding: const EdgeInsets.only(left: 20, right: 20),
                constraints: BoxConstraints(
                  minHeight: ScreenUtil().setHeight(110),
                ),
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: MyColors.messagePurple,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                ),
                child: WidgetUtils.onlyText(
                    allData2[i]['text'],
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(29))),
              ),
              WidgetUtils.commonSizedBox(20, 0),
            ],
          ),
        ),
      );
    } else if (allData2[i]['type'] == 2) {
      return GestureDetector(
        onTap: (() {
          if (MyUtils.checkClick()) {
            MyUtils.goTransparentPageCom(
                context, WebPage(url: allData2[i]['url']));
          }
        }),
        child: Column(
          children: [
            WidgetUtils.onlyTextCenter(
                allData2[i]['add_time'],
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.commonSizedBox(20, 0),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: WidgetUtils.showImagesNetAuto(
                  allData2[i]['img_url'], double.infinity),
            ),
          ],
        ),
      );
    } else if (allData2[i]['type'] == 3) {
      return GestureDetector(
        onTap: (() {
          if (MyUtils.checkClick()) {
            MyUtils.goTransparentPageCom(
                context, WebPage(url: allData2[i]['url']));
          }
        }),
        child: Column(
          children: [
            WidgetUtils.onlyTextCenter(
                allData2[i]['add_time'],
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.commonSizedBox(20, 0),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      WidgetUtils.showImagesNetAuto(
                          allData2[i]['img_url'], double.infinity),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(90),
                        padding: const EdgeInsets.only(left: 10),
                        color: Colors.black45,
                        child: WidgetUtils.onlyText(
                            allData2[i]['title'],
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(29))),
                      )
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      allData2[i]['text'],
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(29),
                          color: MyColors.g6,
                          overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: (() {
          if (MyUtils.checkClick()) {
            MyUtils.goTransparentPage(
                context, TrendsMorePage(note_id: allData2[i]['url'], index: 0));
          }
        }),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              WidgetUtils.commonSizedBox(10, 10),
              WidgetUtils.onlyTextCenter(
                  allData2[i]['add_time'],
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
              Row(
                children: [
                  WidgetUtils.showImages('assets/images/message_xt.webp',
                      ScreenUtil().setHeight(80), ScreenUtil().setHeight(80)),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.onlyTextCenter(
                      '系统消息',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(29))),
                ],
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 10.h, bottom: 10.h),
                constraints: BoxConstraints(
                  minHeight: ScreenUtil().setHeight(110),
                ),
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: MyColors.messagePurple,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetUtils.onlyText(
                        allData2[i]['text'],
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g6,
                            fontSize: ScreenUtil().setSp(29))),
                    WidgetUtils.commonSizedBox(10.h, 0),
                    WidgetUtils.onlyText(
                        '戳这里查看》',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.btn_d,
                            fontSize: ScreenUtil().setSp(26)))
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(20, 0),
            ],
          ),
        ),
      );
    }
  }

  // 在数据变化后将滚动位置设置为最后一个item的位置
  void scrollToLastItem() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: length > 0
          ? ListView.builder(
              controller: _scrollController,
              itemBuilder: message,
              itemCount: allData2.length,
            )
          : Text(''),
    );
  }

  int length = 0;
  late List<Map<String, dynamic>> allData2;
  Future<void> getInfos() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    // 获取所有数据
    List<Map<String, dynamic>> allData =
        await databaseHelper.getAllData('messageXTTable');
    if (allData.isNotEmpty) {
      setState(() {
        allData2 = allData;
        length = allData2.length;
      });
      for (int i = 0; i < allData.length; i++) {
        if (allData[i]['data_status'] == 0) {
          databaseHelper.updateData(
              'messageXTTable', allData[i]['id'], 'data_status', 1);
        }
      }
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        scrollToLastItem(); // 在widget构建完成后滚动到底部
      });
    }
    eventBus.fire(ResidentBack(isBack: true));
  }
}
