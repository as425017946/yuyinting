import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/bean/Common_bean.dart';

import '../../bean/careListBean.dart';
import '../../bean/joinRoomBean.dart';
import '../../bean/recommendRoomBean.dart';
import '../../bean/shoucangBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/OptionGridView.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';

///收藏页面
class ShoucangPage extends StatefulWidget {
  const ShoucangPage({Key? key}) : super(key: key);

  @override
  State<ShoucangPage> createState() => _ShoucangPageState();
}

class _ShoucangPageState extends State<ShoucangPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int length = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  List<DataS> _list = [];
  List<DataTj> listTJ = [];
  bool isUp = false; //是否允许上拉
  bool isDown = true; //是否允许下拉
  void _onRefresh() async {
    // 重新初始化
    _refreshController.resetNoData();
    setState(() {
      isUp = false;
    });
    // monitor network fetch
    // await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    await doPostFollowList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    setState(() {
      isDown = false;
    });
    // monitor network fetch
    // await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {
        page++;
      });
    }
    await doPostFollowList();
    _refreshController.loadComplete();
  }

  ///收藏使用
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
          setState(() {
            sp.setBool('joinRoom', true);
          });
          doPostBeforeJoin(_list[index].id.toString());
        }
      }),
      child: Container(
        height: ScreenUtil().setHeight(260),
        width: ScreenUtil().setHeight(260),
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            WidgetUtils.CircleImageNet(ScreenUtil().setHeight(260),
                ScreenUtil().setHeight(260), 10.0, _list[index].coverImg!),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  const Spacer(),
                  WidgetUtils.onlyText(
                      _list[index].roomName!,
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(26))),
                  WidgetUtils.commonSizedBox(5, 0),
                  Row(
                    children: [
                      WidgetUtils.showImages(
                          'assets/images/zhibo2.webp', 10, 15),
                      Text(
                        _list[index].hotDegree.toString(),
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///没有收藏使用
  Widget _initlistdata2(context, index) {
    final view = GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
          setState(() {
            sp.setBool('joinRoom', true);
          });
          doPostBeforeJoin(listTJ[index].id.toString());
        }
      }),
      child: Container(
        height: ScreenUtil().setHeight(260),
        width: ScreenUtil().setHeight(260),
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            WidgetUtils.CircleImageNet(ScreenUtil().setHeight(260),
                ScreenUtil().setHeight(260), 10.0, listTJ[index].coverImg!),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  const Spacer(),
                  WidgetUtils.onlyText(
                      listTJ[index].roomName!,
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(26))),
                  WidgetUtils.commonSizedBox(5, 0),
                  Row(
                    children: [
                      WidgetUtils.showImages(
                          'assets/images/zhibo2.webp', 10, 15),
                      Text(
                        listTJ[index].hotDegree.toString(),
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                ],
              ),
            )
          ],
        ),
      ),
    );
    return FittedBox(child: view);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostFollowList();
    doPostRecommendRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: length != 0
          ? SmartRefresher(
              header: MyUtils.myHeader(),
              footer: MyUtils.myFotter(),
              controller: _refreshController,
              enablePullUp: isUp, //是否允许上拉加载更多
              enablePullDown: isDown, // 是否允许下拉刷新
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: OptionGridView(
                    itemCount: _list.length,
                    rowCount: 2,
                    mainAxisSpacing: 15,
                    // 上下间距
                    crossAxisSpacing: 30,
                    //左右间距
                    itemBuilder: _initlistdata,
                  ),
                ),
              ),
            )
          : SmartRefresher(
              header: MyUtils.myHeader(),
              footer: MyUtils.myFotter(),
              controller: _refreshController,
              enablePullUp: false,
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    Container(
                      height: ScreenUtil().setHeight(400),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Spacer(),
                          WidgetUtils.showImages(
                              'assets/images/guard_group_under_review.png',
                              ScreenUtil().setHeight(200),
                              ScreenUtil().setHeight(200)),
                          WidgetUtils.commonSizedBox(20, 0),
                          WidgetUtils.onlyTextCenter(
                              '您还没有收藏的房间',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeNoHave,
                                  fontSize: ScreenUtil().setSp(28))),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: WidgetUtils.onlyText(
                          '推荐房间',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: OptionGridView(
                        itemCount: listTJ.length,
                        rowCount: 2,
                        mainAxisSpacing: (15 * 2).w,
                        // 上下间距
                        crossAxisSpacing: (30 * 2).w,
                        //左右间距
                        itemBuilder: _initlistdata2,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  /// 收藏列表
  Future<void> doPostFollowList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '2',
      'is_follow': '1',
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      // Loading.show(MyConfig.successTitle);
      shoucangBean bean = await DataUtils.postFollowListRoom(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.isNotEmpty) {
              for (int i = 0; i < bean.data!.length; i++) {
                _list.add(bean.data![i]);
              }
              // 把没有更多的提示去掉
              // if (bean.data!.list!.length < MyConfig.pageSize) {
              //   _refreshController.loadNoData();
              // }

              length = bean.data!.length;
            } else {
              if (page == 1) {
                length = 0;
              } else {
                // _refreshController.loadNoData();
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
      // Loading.dismiss();
    } catch (e) {
      // Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 关注列表
  Future<void> doPostRecommendRoom() async {
    try {
      recommendRoomBean bean = await DataUtils.postRecommendRoom();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listTJ = bean.data!;
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
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    //判断房间id是否为空的
    if (roomID == null || roomID.toString().isEmpty) {
      return;
    } else {
      // 不是空的，并且不是之前进入的房间
      if (sp.getString('roomID').toString() != roomID) {
        sp.setString('roomID', roomID);
        eventBus.fire(SubmitButtonBack(title: '加入其他房间'));
      }
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      Loading.show();
      joinRoomBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if(sp.getString('sqRoomID').toString() == roomID){
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentRFPage(
                context,
                RoomPage(
                  roomId: roomID,
                  beforeId: '',
                  roomToken: bean.data!.rtc!,
                ));
          }else{
            doPostRoomJoin(roomID, '', bean.data!.rtc!);
          }
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomTSMiMaPage(
                  roomID: roomID, roomToken: bean.data!.rtc!, anchorUid: ''));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间
  Future<void> doPostRoomJoin(roomID, password, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
              context,
              RoomPage(
                roomId: roomID,
                beforeId: '',
                roomToken: roomToken,
              ));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
