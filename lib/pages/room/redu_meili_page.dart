import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../../bean/rankListBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../message/geren/people_info_page.dart';
import '../mine/my/my_info_page.dart';
/// 热度-魅力榜
class ReDuMeiLiPage extends StatefulWidget {
  String roomID;
  ReDuMeiLiPage({super.key, required this.roomID});

  @override
  State<ReDuMeiLiPage> createState() => _ReDuMeiLiPageState();
}

class _ReDuMeiLiPageState extends State<ReDuMeiLiPage>  with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  int page = 1;
  // 财富榜传wealth 魅力榜传charm : 日榜day 周榜week 月榜month
  String dateType = 'day', oldDateType = 'day';
  List<ListBD> _list = [];
  List<ListBD> _list2 = [];

  int showPage = 0;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  bool isUp = true; //是否允许上拉
  bool isDown = true; //是否允许下拉
  void _onRefresh() async {
    // 重新初始化
    _refreshController.resetNoData();
    setState(() {
      sp.setBool('joinRoom', false);
      isUp = false;
    });
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostRankList();
  }

  void _onLoading() async {
    setState(() {
      sp.setBool('joinRoom', false);
      isDown = false;
    });
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {
        page++;
      });
    }
    doPostRankList();
    _refreshController.loadComplete();
  }
  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            // MyToastUtils.showToastBottom('点击了');
            if (MyUtils.checkClick()) {
              // 如果点击的是自己，进入自己的主页
              if (sp.getString('user_id').toString() ==
                  _list[i].uid.toString()) {
                MyUtils.goTransparentRFPage(context, const MyInfoPage());
              } else {
                sp.setString('other_id', _list[i].uid.toString());
                MyUtils.goTransparentRFPage(
                    context,
                    PeopleInfoPage(
                      otherId: _list[i].uid.toString(),title: '其他',
                    ));
              }
            }
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(130),
            child: Row(
              children: [
                SizedBox(
                  width: 60.w,
                  child: WidgetUtils.onlyTextCenter(
                      (i + 1).toString(),
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(28))),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.CircleHeadImage(80.h, 80.h, _list[i].avatar!),
                    SizedBox(
                      height: 110.h,
                      width: 110.h,
                      child: i == 0
                          ? const SVGASimpleImage(
                        assetsName: 'assets/svga/ph_1.svga',
                      )
                          : i == 1
                          ? const SVGASimpleImage(
                        assetsName: 'assets/svga/ph_2.svga',
                      )
                          : i == 2
                          ? const SVGASimpleImage(
                        assetsName: 'assets/svga/ph_3.svga',
                      )
                          : const Text(''),
                    )
                  ],
                ),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                _list[i].nickname!.length > 10
                                    ? _list[i].nickname!.substring(0, 10)
                                    : _list[i].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(25))),
                            const Spacer(),
                            WidgetUtils.onlyText(
                                _list[i].score.toString(),
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(25))),
                            WidgetUtils.commonSizedBox(0, 20.h),
                          ],
                        ),
                      ),
                      const Expanded(child: Text(''))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 0.5.h,
          width: double.infinity,
          color: MyColors.home_hx,
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRankList();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: isUp, //是否允许上拉加载更多
      enablePullDown: isDown, // 是否允许下拉刷新
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            /// 日榜 周榜 月榜
            Row(
              children: [
                const Expanded(child: Text('')),
                Stack(
                  children: [
                    Opacity(
                      opacity: 0.2,
                      child: Row(
                        children: [
                          Container(
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: Colors.grey,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: WidgetUtils.commonSizedBox(ScreenUtil().setHeight(50), ScreenUtil().setHeight(270)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                      width: ScreenUtil().setHeight(270),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Opacity(
                                  opacity: showPage == 0 ? 0.2 : 0,
                                  child: Container(
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: ((){
                                    setState(() {
                                      showPage = 0;
                                      dateType = 'day';
                                      page = 1;
                                    });
                                    if (dateType != oldDateType) {
                                      setState(() {
                                        _list.clear();
                                        _list2.clear();
                                        oldDateType = 'day';
                                      });
                                      doPostRankList();
                                    }
                                  }),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.transparent,
                                    child: WidgetUtils.onlyTextCenter('日榜', StyleUtils.getCommonTextStyle(color: showPage == 0 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Opacity(
                                  opacity: showPage == 1 ? 0.2 : 0,
                                  child: Container(
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: ((){
                                    setState(() {
                                      showPage = 1;
                                      dateType = 'week';
                                      page = 1;
                                    });
                                    if (dateType != oldDateType) {
                                      setState(() {
                                        _list.clear();
                                        _list2.clear();
                                        oldDateType = 'week';
                                      });
                                      doPostRankList();
                                    }
                                  }),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.transparent,
                                    child: WidgetUtils.onlyTextCenter('周榜', StyleUtils.getCommonTextStyle(color: showPage == 1 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Opacity(
                                  opacity: showPage == 2 ? 0.2 : 0,
                                  child: Container(
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: ((){
                                    setState(() {
                                      showPage = 2;
                                      dateType = 'month';
                                      page = 1;
                                    });
                                    if (dateType != oldDateType) {
                                      setState(() {
                                        _list.clear();
                                        _list2.clear();
                                        oldDateType = 'month';
                                      });
                                      doPostRankList();
                                    }
                                  }),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.transparent,
                                    child: WidgetUtils.onlyTextCenter('月榜', StyleUtils.getCommonTextStyle(color: showPage == 2 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Expanded(child: Text('')),
              ],
            ),
            WidgetUtils.commonSizedBox(20.h, 20.h),
            Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20.h),
                WidgetUtils.onlyText(
                    '按本房间魅力值排序',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                WidgetUtils.onlyText(
                    '魅力值',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600)),
                WidgetUtils.commonSizedBox(0, 20.h),
              ],
            ),
            WidgetUtils.commonSizedBox(10.h, 20.h),
            /// 展示在线用户
            _list.isNotEmpty
                ? ListView.builder(
              padding: EdgeInsets.only(top: 0.h),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _itemTuiJian,
              itemCount: _list.length,
            )
                : const Text('')
          ],
        ),
      ),
    );
  }

  /// 榜单
  Future<void> doPostRankList() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'category': 'charm',
      'date_type': dateType,
      'room_id': widget.roomID,
      'page': page,
      'pageSize': MyConfig.pageSize,
    };
    try {
      rankListBean bean = await DataUtils.postRankList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
              _list2.clear();
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
            } else {
              if (page > 1) {
                if (bean.data!.list!.length < MyConfig.pageSize) {
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
