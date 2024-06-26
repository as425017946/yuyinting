import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../bean/userOnlineBean.dart';
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

///在线
class ZaixianPage extends StatefulWidget {
  const ZaixianPage({Key? key}) : super(key: key);

  @override
  State<ZaixianPage> createState() => _ZaixianPageState();
}

class _ZaixianPageState extends State<ZaixianPage> {

  List<Data> list = [];
  var listen, listen2;
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

    listen2 = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '在线') {
        if (mounted) {
          setState(() {
            page = 1;
          });
        }
        doPostRoomJoin();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listen2.cancel();
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
            height: ScreenUtil().setWidth(80 * 1.3),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      MyUtils.goTransparentRFPage(
                          context,
                          PeopleInfoPage(
                            otherId: list[i].uid.toString(),
                            title: '其他',
                          ));
                    }
                  }),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.CircleHeadImage(
                          78 * 1.3.w, 78 * 1.3.w, list[i].avatar!),
                      list[i].live == 1
                          ? WidgetUtils.showImages(
                              'assets/images/zhibozhong.webp',
                              80 * 1.3.w,
                              80 * 1.3.w)
                          : const Text(''),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10 * 2.w),
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
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14 * 2.sp)),
                            WidgetUtils.commonSizedBox(0, 5 * 2.w),
                            Stack(
                              children: [
                                list[i].gender != 0
                                    ? WidgetUtils.showImages(
                                        list[i].gender == 1
                                            ? 'assets/images/avj.png'
                                            : 'assets/images/avk.png',
                                        15 * 2.w,
                                        45 * 2.w)
                                    : const Text(''),
                                Container(
                                  padding: EdgeInsets.only(
                                      right:
                                          int.parse(list[i].age.toString()) > 9
                                              ? 15 * 1.3.w
                                              : 20 * 1.3.w),
                                  width: 45 * 2.w,
                                  height: 15 * 2.w,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    list[i].age.toString(),
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: 12 * 2.sp),
                                  ),
                                ),
                              ],
                            ),
                            // 只有不是新贵或者新锐的时候展示萌新
                            (list[i].isNew.toString() == '1' &&
                                    list[i].newNoble.toString() == '0')
                                ? WidgetUtils.showImages(
                                    'assets/images/dj/room_role_common.png',
                                    40 * 1.3.w,
                                    60 * 1.3.w)
                                : const Text(''),
                            (list[i].isNew.toString() == '1' &&
                                    list[i].newNoble.toString() == '0')
                                ? WidgetUtils.commonSizedBox(0, 5)
                                : const Text(''),
                            // 展示新贵或者新锐图标
                            list[i].newNoble.toString() == '1'
                                ? WidgetUtils.showImages(
                                    'assets/images/dj/room_rui.png',
                                    30 * 1.3.w,
                                    50 * 1.3.w)
                                : list[i].newNoble.toString() == '2'
                                    ? WidgetUtils.showImages(
                                        'assets/images/dj/room_gui.png',
                                        30 * 1.3.w,
                                        50 * 1.3.w)
                                    : list[i].newNoble.toString() == '3'
                                        ? WidgetUtils.showImages(
                                            'assets/images/dj/room_gui.png',
                                            30 * 1.3.w,
                                            50 * 1.3.w)
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
                              fontSize: 14 * 2.sp),
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
                    child: WidgetUtils.showImages(
                        'assets/images/trends_hi.png',
                        ScreenUtil().setWidth(40 * 1.3),
                        ScreenUtil().setWidth(90 * 1.3)),
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
                        ScreenUtil().setWidth(40 * 1.3),
                        ScreenUtil().setWidth(90 * 1.3),
                        Colors.white,
                        MyColors.homeTopBG,
                        '私信',
                        ScreenUtil().setSp(25),
                        MyColors.homeTopBG),
                  ),
                WidgetUtils.commonSizedBox(0, 20 * 2.w),
              ],
            ),
          ),
        ),
        WidgetUtils.myLine(indent: 20, endIndent: 20)
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
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(20 * 1.3)),
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
