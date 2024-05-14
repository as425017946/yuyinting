import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../bean/userOnlineBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../message/chat_page.dart';
import '../message/geren/people_info_page.dart';
import '../trends/trends_hi_page.dart';
/// 全服在线
class ReDuOnLinePage extends StatefulWidget {
  const ReDuOnLinePage({super.key});

  @override
  State<ReDuOnLinePage> createState() => _ReDuOnLinePageState();
}

class _ReDuOnLinePageState extends State<ReDuOnLinePage> {
  List<Data> list = [];
  var listen;
  int page = 1;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // 重新初始化
    _refreshController.resetNoData();
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostRoomJoin();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {
        page++;
      });
    }
    doPostRoomJoin();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRoomJoin();
    listen = eventBus.on<HiBack>().listen((event) {
      if (event.isBack) {
        setState(() {
          //目的是为了有打过招呼的这个人的hi都变成私信按钮
          for (int i = 0; i < list.length; i++) {
            if (list[i].uid.toString() == event.index) {
              list[i].isHi = 1;
            }
          }
        });
      }
    });
  }

  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {}),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      MyUtils.goTransparentRFPage(
                          context,
                          PeopleInfoPage(
                            otherId: list[i].uid.toString(),title: '小主页',
                          ));
                    }
                  }),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.CircleHeadImage(78.h, 78.h, list[i].avatar!),
                      list[i].live == 1
                          ? WidgetUtils.showImages(
                          'assets/images/zhibozhong.webp', 80.h, 80.h)
                          : const Text(''),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                list[i].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontWeight: FontWeight.w600,
                                    fontSize: ScreenUtil().setSp(25))),
                            WidgetUtils.commonSizedBox(0, 5),
                            Stack(
                              children: [
                                list[i].gender != 0
                                    ? WidgetUtils.showImages(
                                    list[i].gender == 1
                                        ? 'assets/images/avj.png'
                                        : 'assets/images/avk.png',
                                    15,
                                    45)
                                    : const Text(''),
                                Container(
                                  padding: EdgeInsets.only(
                                      right: int.parse(list[i].age.toString()) >
                                          9 ? 15.h : 20.h),
                                  width: 45,
                                  height: 15,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    list[i].age.toString(),
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            // 只有不是新贵或者新锐的时候展示萌新
                            (list[i].isNew.toString() == '1' &&
                                list[i].newNoble.toString() == '0')
                                ? WidgetUtils.showImagesFill(
                                'assets/images/dj/room_role_common.png',
                                45.w, 85.w)
                                : const Text(''),
                            (list[i].isNew.toString() == '1' &&
                                list[i].newNoble.toString() == '0')
                                ? WidgetUtils.commonSizedBox(0, 5)
                                : const Text(''),
                            // 展示新贵或者新锐图标
                            list[i].newNoble.toString() == '1'
                                ? WidgetUtils.showImages(
                                'assets/images/dj/room_rui.png', 35.w, 85.w)
                                : list[i].newNoble.toString() == '2'
                                ? WidgetUtils.showImages(
                                'assets/images/dj/room_gui.png',
                                35.w, 85.w)
                                : list[i].newNoble.toString() == '3'
                                ? WidgetUtils.showImages(
                                'assets/images/dj/room_qc.png',
                                35.w, 85.w)
                                : const Text(''),
                            list[i].newNoble.toString() != '0'
                                ? WidgetUtils.commonSizedBox(0, 5)
                                : const Text(''),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          list[i].description!,
                          textAlign: TextAlign.left,
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                if (list[i].isHi == 0)
                  GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        MyUtils.goTransparentPageCom(
                            context,
                            TrendsHiPage(
                                imgUrl: list[i].avatar!,
                                uid: list[i].uid.toString(),
                                index: i));
                      }
                    }),
                    child: WidgetUtils.showImages('assets/images/trends_hi.png',
                        ScreenUtil().setHeight(40), ScreenUtil().setHeight(90)),
                  )
                else
                  GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        MyUtils.goTransparentRFPage(
                            context,
                            ChatPage(
                              nickName: list[i].nickname!,
                              otherUid: list[i].uid.toString(),
                              otherImg: list[i].avatar!,
                            ));
                      }
                    }),
                    child: WidgetUtils.myContainer(
                        ScreenUtil().setHeight(40),
                        ScreenUtil().setHeight(90),
                        Colors.white,
                        MyColors.homeTopBG,
                        '私信',
                        ScreenUtil().setSp(25),
                        MyColors.homeTopBG),
                  ),
                WidgetUtils.commonSizedBox(0, 20),
              ],
            ),
          ),
        ),
        WidgetUtils.myLine(indent: 20, endIndent: 20),
        WidgetUtils.commonSizedBox(20.h,0)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return list.isNotEmpty
        ? SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: true,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        itemBuilder: _itemTuiJian,
        itemCount: list.length,
      ),
    )
        : const Text('');
  }

  /// 在线用户
  Future<void> doPostRoomJoin() async {
    Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'pageSize': MyConfig.pageSize,
    };
    try {
      Loading.show();
      userOnlineBean bean = await DataUtils.postUserOnline(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              list.clear();
            }
            if (bean.data!.isNotEmpty) {
              for (int i = 0; i < bean.data!.length; i++) {
                list.add(bean.data![i]);
              }
            } else {
              if (page > 1) {
                if (bean.data!.length < MyConfig.pageSize) {
                  _refreshController.loadNoData();
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}