import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/utils/loading.dart';

import '../../bean/memberListBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../message/geren/people_info_page.dart';
import '../mine/my/my_info_page.dart';
/// 热度-在线列表
class ReDuZaiXianPage extends StatefulWidget {
  String roomID;
  ReDuZaiXianPage({super.key, required this.roomID});

  @override
  State<ReDuZaiXianPage> createState() => _ReDuZaiXianPageState();
}

class _ReDuZaiXianPageState extends State<ReDuZaiXianPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List<ListOn> list = [];
  int page = 1;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostMemberList();
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
    doPostMemberList();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostMemberList();
  }

  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            if(MyUtils.checkClick()){
              // 如果点击的是自己，进入自己的主页
              if(sp.getString('user_id').toString() == list[i].uid.toString()){
                MyUtils.goTransparentRFPage(context, const MyInfoPage());
              }else{
                sp.setString('other_id', list[i].uid.toString());
                MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: list[i].uid.toString(),));
              }
            }
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(130),
            child: Row(
              children: [
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(80),
                    ScreenUtil().setHeight(80),
                    list[i].avatar!),
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
                                list[i].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(25))),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages(
                                list[i].gender == 1 ? 'assets/images/room_nan.png' : 'assets/images/room_nv.png' ,
                                ScreenUtil().setHeight(31),
                                ScreenUtil().setHeight(29)),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(2, 0),
                      // Row(
                      //   children: [
                      //     WidgetUtils.showImages(
                      //         'assets/images/room_fangguan.png',
                      //         ScreenUtil().setHeight(25),
                      //         ScreenUtil().setHeight(25)),
                      //     const Expanded(child: Text(''))
                      //   ],
                      // ),
                      const Expanded(child: Text(''))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 在线用户文字提示
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            WidgetUtils.onlyText(
                '在线用户（${list.length}人）',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.roomTCWZ3,
                    fontSize: ScreenUtil().setSp(21))),
          ],
        ),

        /// 展示在线用户
        Expanded(
          child: SmartRefresher(
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
          ),
        )
      ],
    );
  }



  /// 关注用户或房间
  Future<void> doPostMemberList() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'page': page,
      'pageSize': MyConfig.pageSize,
    };
    try {
      memberListBean bean = await DataUtils.postMemberList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              list.clear();
            }
            if (bean.data!.list!.isNotEmpty) {
              list = bean.data!.list!;
            }else{
              if(page > 1){
                if(bean.data!.list!.length < MyConfig.pageSize){
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
