import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/pages/room/room_bg1_page.dart';
import 'package:yuyinting/pages/room/room_bg2_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 房间背景
class RoomBGPage extends StatefulWidget {
  const RoomBGPage({super.key});

  @override
  State<RoomBGPage> createState() => _RoomBGPageState();
}

class _RoomBGPageState extends State<RoomBGPage> {
  int _currentIndex = 0;
  late final PageController _controller;
  bool isOK = true;
  var listen;
  String bgID = '', bgType = '', bgImagUrl = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );

    listen = eventBus.on<RoomBGBack>().listen((event) {
      if(event.bgID.isNotEmpty){
        LogE('删除状态  ${event.delete}');
        if(event.delete){
          setState(() {
            bgID = '';
            bgType = '';
            bgImagUrl = '';
          });
        }else{
          setState(() {
            bgID = event.bgID;
            bgType = event.bgType;
            bgImagUrl = event.bgImagUrl;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
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
                if(MyUtils.checkClick()) {
                  Navigator.pop(context);
                }
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(1072),
            width: double.infinity,
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
                WidgetUtils.commonSizedBox(15, 0),
                Row(
                  children: [
                    Container(
                      width: ScreenUtil().setHeight(180),
                    ),
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyTextCenter(
                        '房间背景',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCWZ2,
                            fontSize: ScreenUtil().setSp(32))),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        if(MyUtils.checkClick()) {
                          if(bgID.isEmpty){
                            MyToastUtils.showToastBottom('请选择要更换的厅图');
                          }else{
                            doPostCheckRoomBg();
                            Navigator.pop(context);
                          }
                        }
                      }),
                      child: Container(
                        width: ScreenUtil().setHeight(180),
                        height: 50.h,
                        color: Colors.transparent,
                        padding:
                            EdgeInsets.only(right: ScreenUtil().setHeight(40)),
                        alignment: Alignment.centerRight,
                        child: Text(
                          '确定',
                          style: StyleUtils.getCommonTextStyle(
                              color: isOK ? Colors.white : MyColors.roomTCWZ3,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      ),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(20, 0),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            _currentIndex = 0;
                            _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          });
                        }),
                        child: Container(
                          height: 60.h,
                          width: 150.h,
                          color: Colors.red,
                          child: Column(
                            children: [
                              Text(
                                '默认背景',
                                style: StyleUtils.getCommonTextStyle(
                                    color: _currentIndex == 0 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3,
                                    fontSize: ScreenUtil().setSp(28),
                                    fontWeight: FontWeight.w600),
                              ),
                              WidgetUtils.commonSizedBox(5, 0),
                              Opacity(
                                opacity: _currentIndex == 0 ? 1 : 0,
                                child: Container(
                                  height: ScreenUtil().setHeight(6),
                                  width: ScreenUtil().setWidth(26),
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.roomTCWZ2,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            _currentIndex = 1;
                            _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          });
                        }),
                        child: Container(
                          height: 60.h,
                          width: 150.h,
                          color: Colors.blue,
                          child: Column(
                            children: [
                              Text(
                                '我的背景',
                                style: StyleUtils.getCommonTextStyle(
                                    color: _currentIndex == 1 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3,
                                    fontSize: ScreenUtil().setSp(28),
                                    fontWeight: FontWeight.w600),
                              ),
                              WidgetUtils.commonSizedBox(5, 0),
                              Opacity(
                                opacity: _currentIndex == 1 ? 1 : 0,
                                child: Container(
                                  height: ScreenUtil().setHeight(6),
                                  width: ScreenUtil().setWidth(26),
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.roomTCWZ2,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        // 更新当前的索引值
                        _currentIndex = index;
                      });
                    },
                    children: const [
                      RoomBG1Page(),
                      RoomBG2Page(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// 选择房间背景图
  Future<void> doPostCheckRoomBg() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': sp.getString('roomID').toString(),
      'bg_id': bgID,
      'bg_type': bgType,
    };
    try {
      CommonBean bean = await DataUtils.postCheckRoomBg(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          eventBus.fire(CheckBGBack(bgType: bgType, bgImagUrl: bgImagUrl));
          MyToastUtils.showToastBottom('房间背景更换成功');
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
