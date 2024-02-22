import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bean/rankListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/geren/people_info_page.dart';
import '../../mine/my/my_info_page.dart';
///魅力日榜
class MeiLiDayPage extends StatefulWidget {
  String category;
  MeiLiDayPage({super.key, required this.category});

  @override
  State<MeiLiDayPage> createState() => _MeiLiDayPageState();
}

class _MeiLiDayPageState extends State<MeiLiDayPage> {
  int page = 1;
  List<ListBD> _list = [];
  List<ListBD> _list2 = [];
  // 日榜day 周榜week 月榜month
  String date_type = 'day';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRankList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_list.length == 1)
          SizedBox(
            height: ScreenUtil().setHeight(400),
            child: Row(
              children: [
                const Expanded(child: Text('')),
                Opacity(
                  opacity: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    height: ScreenUtil().setHeight(400),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(100.h, 100.h, _list[0].avatar!),
                        WidgetUtils.showImages(
                            'assets/images/py_two.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        Positioned(
                            bottom: 70.h,
                            child: WidgetUtils.onlyTextCenter(
                                _list[0].nickname!.length > 4 ? '${_list[0].nickname!.substring(0,4)}...' : _list[0].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.homeTopBG,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600))),
                        Positioned(
                            left: 0.w,
                            bottom: 10.h,
                            child: _list[0].liveStatus == 1
                                ? Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(98)),
                              width: 150.w,
                              height: 50.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(20),
                                          ScreenUtil().setWidth(20)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(20))),
                                    ],
                                  )
                                ],
                              ) /* add child content here */,
                            )
                                : const Text(''))
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                GestureDetector(
                  onTap: (() {
                    if(MyUtils.checkClick()){
                      // 如果点击的是自己，进入自己的主页
                      if(sp.getString('user_id').toString() == _list[0].uid.toString()){
                        MyUtils.goTransparentRFPage(context, const MyInfoPage());
                      }else{
                        sp.setString('other_id', _list[0].uid.toString());
                        MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[0].uid.toString(), title: '其他',));
                      }
                    }
                  }),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: ScreenUtil().setHeight(400),
                    width: ScreenUtil().setWidth(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                            top:50.h,
                            child: WidgetUtils.CricleImagess(160.h, 160.h, _list[0].avatar!)),
                        Positioned(
                          top:10.h,
                          child: SizedBox(
                            height: ScreenUtil().setHeight(231),
                            width: ScreenUtil().setWidth(228),
                            child:  WidgetUtils.showImages(
                                'assets/images/py_one.png',
                                ScreenUtil().setHeight(231),
                                ScreenUtil().setWidth(228)),
                          ),
                        ),
                        Positioned(
                            bottom: 40.h,
                            child: _list[0].liveStatus == 1
                                ? Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(98)),
                              width: 150.w,
                              height: 50.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(20),
                                          ScreenUtil().setWidth(20)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(20))),
                                    ],
                                  )
                                ],
                              ) /* add child content here */,
                            )
                                : const Text('')),
                        Positioned(
                          bottom: 100.h,
                          child: WidgetUtils.onlyTextBottom(
                              _list[0].nickname!.length > 8 ? '${_list[0].nickname!.substring(0,8)}...' : _list[0].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeTopBG,
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                Opacity(opacity: 0, child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  height: ScreenUtil().setHeight(400),
                  width: ScreenUtil().setWidth(180),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.CricleImagess(100.h, 100.h, _list[0].avatar!),
                      WidgetUtils.showImages(
                          'assets/images/py_three.png',
                          ScreenUtil().setHeight(154),
                          ScreenUtil().setWidth(146)),
                      Positioned(
                          bottom: 70.h,
                          child: WidgetUtils.onlyTextCenter(
                              _list[0].nickname!.length > 4 ? '${_list[0].nickname!.substring(0,4)}...' : _list[0].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeTopBG,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600))),
                      Positioned(
                          right: 0.w,
                          bottom: 10.h,
                          child: _list[0].liveStatus == 0
                              ? Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(98)),
                            width: 150.w,
                            height: 50.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/zhibo2.webp',
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setWidth(20)),
                                    WidgetUtils.onlyText(
                                        '在房间',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            ScreenUtil().setSp(20))),
                                  ],
                                )
                              ],
                            ) /* add child content here */,
                          )
                              : const Text(''))
                    ],
                  ),
                ),),
                const Expanded(child: Text('')),
              ],
            ),
          ),
        if (_list.length == 2)
          SizedBox(
            height: ScreenUtil().setHeight(400),
            child: Row(
              children: [
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: (() {
                    if(MyUtils.checkClick()){
                      // 如果点击的是自己，进入自己的主页
                      if(sp.getString('user_id').toString() == _list[1].uid.toString()){
                        MyUtils.goTransparentRFPage(context, const MyInfoPage());
                      }else{
                        sp.setString('other_id', _list[1].uid.toString());
                        MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[1].uid.toString(), title: '其他',));
                      }
                    }
                  }),
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    height: ScreenUtil().setHeight(400),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(100.h, 100.h, _list[1].avatar!),
                        WidgetUtils.showImages(
                            'assets/images/py_two.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        Positioned(
                            bottom: 70.h,
                            child: WidgetUtils.onlyTextCenter(
                                _list[1].nickname!.length > 4 ? '${_list[1].nickname!.substring(0,4)}...' : _list[1].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.homeTopBG,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600))),
                        Positioned(
                            left: 0.w,
                            bottom: 10.h,
                            child: _list[1].liveStatus == 1
                                ? Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(98)),
                              width: 150.w,
                              height: 50.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(20),
                                          ScreenUtil().setWidth(20)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(20))),
                                    ],
                                  )
                                ],
                              ) /* add child content here */,
                            )
                                : const Text(''))
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                GestureDetector(
                  onTap: (() {
                    if(MyUtils.checkClick()){
                      // 如果点击的是自己，进入自己的主页
                      if(sp.getString('user_id').toString() == _list[0].uid.toString()){
                        MyUtils.goTransparentRFPage(context, const MyInfoPage());
                      }else{
                        sp.setString('other_id', _list[0].uid.toString());
                        MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[0].uid.toString(), title: '其他',));
                      }
                    }
                  }),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: ScreenUtil().setHeight(400),
                    width: ScreenUtil().setWidth(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                            top:50.h,
                            child: WidgetUtils.CricleImagess(160.h, 160.h, _list[0].avatar!)),
                        Positioned(
                          top:10.h,
                          child: SizedBox(
                            height: ScreenUtil().setHeight(231),
                            width: ScreenUtil().setWidth(228),
                            child:  WidgetUtils.showImages(
                                'assets/images/py_one.png',
                                ScreenUtil().setHeight(231),
                                ScreenUtil().setWidth(228)),
                          ),
                        ),
                        Positioned(
                            bottom: 40.h,
                            child: _list[0].liveStatus == 1
                                ? Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(98)),
                              width: 150.w,
                              height: 50.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(20),
                                          ScreenUtil().setWidth(20)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(20))),
                                    ],
                                  )
                                ],
                              ) /* add child content here */,
                            )
                                : const Text('')),
                        Positioned(
                          bottom: 100.h,
                          child: WidgetUtils.onlyTextBottom(
                              _list[0].nickname!.length > 8 ? '${_list[0].nickname!.substring(0,8)}...' : _list[0].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeTopBG,
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                Opacity(opacity: 0, child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  height: ScreenUtil().setHeight(400),
                  width: ScreenUtil().setWidth(180),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.CricleImagess(100.h, 100.h, _list[1].avatar!),
                      WidgetUtils.showImages(
                          'assets/images/py_three.png',
                          ScreenUtil().setHeight(154),
                          ScreenUtil().setWidth(146)),
                      Positioned(
                          bottom: 70.h,
                          child: WidgetUtils.onlyTextCenter(
                              _list[1].nickname!.length > 4 ? '${_list[1].nickname!.substring(0,4)}...' : _list[1].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeTopBG,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600))),
                      Positioned(
                          right: 0.w,
                          bottom: 10.h,
                          child: _list[1].liveStatus == 0
                              ? Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(98)),
                            width: 150.w,
                            height: 50.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/zhibo2.webp',
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setWidth(20)),
                                    WidgetUtils.onlyText(
                                        '在房间',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            ScreenUtil().setSp(20))),
                                  ],
                                )
                              ],
                            ) /* add child content here */,
                          )
                              : const Text(''))
                    ],
                  ),
                ),),
                const Expanded(child: Text('')),
              ],
            ),
          ),
        if (_list.length >= 3)
          SizedBox(
            height: ScreenUtil().setHeight(400),
            child: Row(
              children: [
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: (() {
                    if(MyUtils.checkClick()){
                      // 如果点击的是自己，进入自己的主页
                      if(sp.getString('user_id').toString() == _list[1].uid.toString()){
                        MyUtils.goTransparentRFPage(context, const MyInfoPage());
                      }else{
                        sp.setString('other_id', _list[1].uid.toString());
                        MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[1].uid.toString(), title: '其他',));
                      }
                    }
                  }),
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    height: ScreenUtil().setHeight(400),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(100.h, 100.h, _list[1].avatar!),
                        WidgetUtils.showImages(
                            'assets/images/py_two.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        Positioned(
                            bottom: 70.h,
                            child: WidgetUtils.onlyTextCenter(
                                _list[1].nickname!.length > 4 ? '${_list[1].nickname!.substring(0,4)}...' : _list[1].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.homeTopBG,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600))),
                        Positioned(
                            left: 0.w,
                            bottom: 10.h,
                            child: _list[1].liveStatus == 1
                                ? Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(98)),
                              width: 150.w,
                              height: 50.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(20),
                                          ScreenUtil().setWidth(20)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(20))),
                                    ],
                                  )
                                ],
                              ) /* add child content here */,
                            )
                                : const Text(''))
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                GestureDetector(
                  onTap: (() {
                    if(MyUtils.checkClick()){
                      // 如果点击的是自己，进入自己的主页
                      if(sp.getString('user_id').toString() == _list[0].uid.toString()){
                        MyUtils.goTransparentRFPage(context, const MyInfoPage());
                      }else{
                        sp.setString('other_id', _list[0].uid.toString());
                        MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[0].uid.toString(), title: '其他',));
                      }
                    }
                  }),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: ScreenUtil().setHeight(400),
                    width: ScreenUtil().setWidth(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                            top:50.h,
                            child: WidgetUtils.CricleImagess(160.h, 160.h, _list[0].avatar!)),
                        Positioned(
                          top:10.h,
                          child: SizedBox(
                            height: ScreenUtil().setHeight(231),
                            width: ScreenUtil().setWidth(228),
                            child:  WidgetUtils.showImages(
                                'assets/images/py_one.png',
                                ScreenUtil().setHeight(231),
                                ScreenUtil().setWidth(228)),
                          ),
                        ),
                        Positioned(
                            bottom: 40.h,
                            child: _list[0].liveStatus == 1
                                ? Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(98)),
                              width: 150.w,
                              height: 50.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(20),
                                          ScreenUtil().setWidth(20)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(20))),
                                    ],
                                  )
                                ],
                              ) /* add child content here */,
                            )
                                : const Text('')),
                        Positioned(
                          bottom: 100.h,
                          child: WidgetUtils.onlyTextBottom(
                              _list[0].nickname!.length > 8 ? '${_list[0].nickname!.substring(0,8)}...' : _list[0].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeTopBG,
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                GestureDetector(
                  onTap: (() {
                    if(MyUtils.checkClick()){
                      // 如果点击的是自己，进入自己的主页
                      if(sp.getString('user_id').toString() == _list[2].uid.toString()){
                        MyUtils.goTransparentRFPage(context, const MyInfoPage());
                      }else{
                        sp.setString('other_id', _list[2].uid.toString());
                        MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[2].uid.toString(), title: '其他',));
                      }
                    }
                  }),
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    height: ScreenUtil().setHeight(400),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(100.h, 100.h, _list[2].avatar!),
                        WidgetUtils.showImages(
                            'assets/images/py_three.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        Positioned(
                            bottom: 70.h,
                            child: WidgetUtils.onlyTextCenter(
                                _list[2].nickname!.length > 4 ? '${_list[2].nickname!.substring(0,4)}...' : _list[2].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.homeTopBG,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600))),
                        Positioned(
                            right: 0.w,
                            bottom: 10.h,
                            child: _list[2].liveStatus == 1
                                ? Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(98)),
                              width: 150.w,
                              height: 50.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(20),
                                          ScreenUtil().setWidth(20)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(20))),
                                    ],
                                  )
                                ],
                              ) /* add child content here */,
                            )
                                : const Text(''))
                      ],
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
          ),
        WidgetUtils.commonSizedBox(ScreenUtil().setHeight(50), 0),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                for (int i = 0; i < _list2.length; i++)
                  GestureDetector(
                    onTap: (() {
                      if(MyUtils.checkClick()){
                        // 如果点击的是自己，进入自己的主页
                        if(sp.getString('user_id').toString() == _list2[i].uid.toString()){
                          MyUtils.goTransparentRFPage(context, const MyInfoPage());
                        }else{
                          sp.setString('other_id', _list2[i].uid.toString());
                          MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list2[i].uid.toString(), title: '其他',));
                        }
                      }
                    }),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(40),
                          right: ScreenUtil().setWidth(20),
                          bottom: 15.h),
                      child: Container(
                        height: ScreenUtil().setHeight(90),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60.w,
                              child: WidgetUtils.onlyTextCenter(
                                  (i + 4).toString(),
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(40))),
                            ),
                            WidgetUtils.commonSizedBox(0, 15.h),
                            Container(
                              height: ScreenUtil().setHeight(90),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  WidgetUtils.CricleImagess(
                                      50, 50, _list2[i].avatar!),
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                            WidgetUtils.onlyText(
                                _list2[i].nickname!.length > 8
                                    ? '${_list2[i].nickname!.substring(0, 8)}...'
                                    : _list2[i].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(28))),
                            const Spacer(),
                            _list2[i].liveStatus == 1
                                ? Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.showImagesFill("assets/images/py_tishi.png", 35.h, 150.w),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/zhibo2.webp',
                                        ScreenUtil().setWidth(20),
                                        ScreenUtil().setWidth(20)),
                                    WidgetUtils.onlyText(
                                        '在房间',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            ScreenUtil().setSp(20))),
                                  ],
                                )
                              ],
                            )
                                : const Text(''),
                            WidgetUtils.commonSizedBox(0, 40.w),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }

  /// 榜单
  Future<void> doPostRankList() async {
    //财富榜传wealth 魅力榜传charm
    Map<String, dynamic> params = <String, dynamic>{
      'category': widget.category,
      'date_type': date_type,
      'page': page,
      'pageSize': '30'
    };
    try {
      Loading.show(MyConfig.successTitle);
      rankListBean bean = await DataUtils.postRankList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.list!.isNotEmpty) {
              for (int i = 0; i < bean.data!.list!.length; i++) {
                _list.add(bean.data!.list![i]);
              }
              if(bean.data!.list!.length>3){
                for (int i = 3; i < bean.data!.list!.length; i++) {
                  _list2.add(bean.data!.list![i]);
                }
              }
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
