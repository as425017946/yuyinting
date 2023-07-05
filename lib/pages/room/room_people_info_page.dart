import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/widget_utils.dart';

/// 厅内人员信息详情
class RoomPeopleInfoPage extends StatefulWidget {
  const RoomPeopleInfoPage({super.key});

  @override
  State<RoomPeopleInfoPage> createState() => _RoomPeopleInfoPageState();
}

class _RoomPeopleInfoPageState extends State<RoomPeopleInfoPage> {
  bool jinyan = false;
  bool ren = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: ((){
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(590),
            width: double.infinity,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: ScreenUtil().setHeight(530),
                  width: double.infinity,
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image: AssetImage("assets/images/room_tc2.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(10, 0),
                      /// @某人
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.showImages(
                              'assets/images/room_@ta.png',
                              ScreenUtil().setHeight(22),
                              ScreenUtil().setHeight(48)),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                ren = !ren;
                              });
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/room_head.png',
                                ScreenUtil().setHeight(33),
                                ScreenUtil().setHeight(33)),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                jinyan = !jinyan;
                              });
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/room_setting.png',
                                ScreenUtil().setHeight(33),
                                ScreenUtil().setHeight(33)),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(25, 0),
                      /// 昵称 性别
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.onlyText('昵称', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.showImages('assets/images/room_nan.png', ScreenUtil().setHeight(31), ScreenUtil().setHeight(29)),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      /// 昵称 性别
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.showImages('assets/images/room_id.png', ScreenUtil().setHeight(26), ScreenUtil().setHeight(18)),
                          WidgetUtils.commonSizedBox(0, 2),
                          WidgetUtils.onlyText('12345678', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.showImages('assets/images/room_fuzhu.png', ScreenUtil().setHeight(18), ScreenUtil().setHeight(18)),
                          WidgetUtils.commonSizedBox(0, 20),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.onlyText('地址', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(25))),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      /// 个性签名
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WidgetUtils.showImages('assets/images/room_cc.png', ScreenUtil().setHeight(26), ScreenUtil().setHeight(21)),
                          WidgetUtils.commonSizedBox(0, 2),
                          WidgetUtils.onlyText('个性签名展示', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(24))),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(30, 0),
                      /// 上麦下麦
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.6,
                                child: Row(
                                  children: [
                                    Container(
                                      height: ScreenUtil().setHeight(60),
                                      width: ScreenUtil().setHeight(110),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomMaiLiao2,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              WidgetUtils.onlyTextCenter(
                                  '下麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ1,
                                      fontSize: ScreenUtil().setSp(24))),
                            ],
                          ),
                          const Expanded(child: Text('')),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.6,
                                child: Row(
                                  children: [
                                    Container(
                                      height: ScreenUtil().setHeight(60),
                                      width: ScreenUtil().setHeight(110),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomMaiLiao2,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              WidgetUtils.onlyTextCenter(
                                  '上麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ1,
                                      fontSize: ScreenUtil().setSp(24))),
                            ],
                          ),
                          const Expanded(child: Text('')),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.6,
                                child: Row(
                                  children: [
                                    Container(
                                      height: ScreenUtil().setHeight(60),
                                      width: ScreenUtil().setHeight(110),
                                      //边框设置
                                      decoration: const BoxDecoration(
                                        //背景
                                        color: MyColors.roomMaiLiao2,
                                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              WidgetUtils.onlyTextCenter(
                                  '闭麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomTCWZ1,
                                      fontSize: ScreenUtil().setSp(24))),
                            ],
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ),
                      const Expanded(child: Text('')),
                      /// 关注送礼
                      Row(
                        children: [
                         Expanded(child:  WidgetUtils.onlyTextCenter(
                             '关注',
                             StyleUtils.getCommonTextStyle(
                                 color: MyColors.roomTCYellow,
                                 fontSize: ScreenUtil().setSp(28)))),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          Expanded(child:  WidgetUtils.onlyTextCenter(
                              '送礼物',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWhitw,
                                  fontSize: ScreenUtil().setSp(28)))),
                          Container(
                            height: ScreenUtil().setHeight(10),
                            width: ScreenUtil().setWidth(1),
                            color: MyColors.g9,
                          ),
                          Expanded(child:  WidgetUtils.onlyTextCenter(
                              '私聊',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWhitw,
                                  fontSize: ScreenUtil().setSp(28)))),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(40, 0),
                    ],
                  ),
                ),

                /// 禁言使用
                jinyan
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Opacity(
                          opacity: 0.55,
                          child: Container(
                            height: ScreenUtil().setHeight(104),
                            width: ScreenUtil().setHeight(117),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.roomTCBlack,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
                jinyan
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Container(
                          height: ScreenUtil().setHeight(104),
                          width: ScreenUtil().setHeight(117),
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Expanded(
                                  child: WidgetUtils.onlyTextCenter(
                                      '禁言',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomTCWZ1,
                                          fontSize: ScreenUtil().setSp(21)))),
                              Container(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(1),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setHeight(10)),
                                color: MyColors.roomTCWZ1,
                              ),
                              Expanded(
                                  child: WidgetUtils.onlyTextCenter(
                                      '拉黑',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomTCWZ1,
                                          fontSize: ScreenUtil().setSp(21)))),
                            ],
                          ),
                        ),
                      )
                    : const Text(''),

                /// 人员设置使用
                ren
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Opacity(
                          opacity: 0.55,
                          child: Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setHeight(142),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.roomTCBlack,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
                ren
                    ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(120),
                        child: Container(
                          height: ScreenUtil().setHeight(50),
                          width: ScreenUtil().setHeight(142),
                          color: Colors.transparent,
                          child: WidgetUtils.onlyTextCenter(
                              '设置为管理',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ1,
                                  fontSize: ScreenUtil().setSp(21))),
                        ),
                      )
                    : const Text(''),

                WidgetUtils.CircleHeadImage(80, 80,
                    'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342')
              ],
            ),
          )
        ],
      ),
    );
  }
}
