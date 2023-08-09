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
import '../message/geren/people_info_page.dart';
import '../trends/trends_hi_page.dart';

///在线
class ZaixianPage extends StatefulWidget {
  const ZaixianPage({Key? key}) : super(key: key);

  @override
  State<ZaixianPage> createState() => _ZaixianPageState();
}

class _ZaixianPageState extends State<ZaixianPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List<Data> list = [];
  var listen;
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
          list[event.index].isHi = 1;
        });
      }
    });
  }

  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {

          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: list[i].uid.toString(),));
                  }),
                  child: Container(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setHeight(80),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CircleHeadImage(40, 40, list[i].avatar!),
                        list[i].live == 1 ? WidgetUtils.showImages( 'assets/images/zhibozhong.webp', 80, 80) : const Text(''),
                      ],
                    ),
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
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            WidgetUtils.commonSizedBox(0, 5),
                            Stack(
                              children: [
                                WidgetUtils.showImages(
                                    list[i].gender == 1
                                        ? 'assets/images/avj.png'
                                        : 'assets/images/avk.png',
                                    15,
                                    45),
                                Container(
                                  padding: const EdgeInsets.only(right: 8),
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
                list[i].isHi == 0
                    ? GestureDetector(
                        onTap: (() {
                          MyUtils.goTransparentPageCom(
                              context,
                              TrendsHiPage(
                                  imgUrl: list[i].avatar!,
                                  uid: list[i].uid.toString(),
                                  index: i));
                        }),
                        child: WidgetUtils.showImages(
                            'assets/images/trends_hi.png',
                            ScreenUtil().setHeight(40),
                            ScreenUtil().setHeight(90)),
                      )
                    : GestureDetector(
                        onTap: (() {}),
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
        WidgetUtils.myLine(indent: 20, endIndent: 20)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return list.isNotEmpty ? SmartRefresher(
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
    ) : const Text('');
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
              list = bean.data!;
            }else{
              if(page > 1){
                if(bean.data!.length < MyConfig.pageSize){
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
