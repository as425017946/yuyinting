import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sqflite/sqflite.dart';
import '../../colors/my_colors.dart';
import '../../db/DatabaseHelper.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 全部礼物
class GiftAllPage extends StatefulWidget {
  String roomID;
  GiftAllPage({super.key, required this.roomID});

  @override
  State<GiftAllPage> createState() => _GiftAllPageState();
}

class _GiftAllPageState extends State<GiftAllPage> {

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
    // doPostMemberList();
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
    // doPostMemberList();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchChatInfo();
  }


  Widget allGift(BuildContext context, int i){
    return Container(
      height: 100.h,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      color: Colors.transparent,
      child: Row(
        children: [
          WidgetUtils.commonSizedBox(0, 10.w),
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(80),
              ScreenUtil().setHeight(80), result![i]['headImage']),
          WidgetUtils.commonSizedBox(0, 10),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(20.h, 0),
                  WidgetUtils.onlyText(
                      result![i]['nickeName'],
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.commonSizedBox(10.h, 0),
                  WidgetUtils.onlyText(
                      '赠送给${result![i]['otherNickName']}',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ1,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.commonSizedBox(10.h, 0),
                ],
              ),
            ),
          ),
          WidgetUtils.showImagesNet(result![i]['giftImage'], 80.h, 80.h),
          WidgetUtils.commonSizedBox(0, 20.w),
          Container(
            width: 130.w,
            color: Colors.transparent,
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20.h, 0),
                WidgetUtils.onlyText(
                    'X${result![i]['number']}',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.commonSizedBox(10.h, 0),
                WidgetUtils.onlyText(
                    result![i]['giftName'],
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ1,
                        fontSize: ScreenUtil().setSp(22))),
                WidgetUtils.commonSizedBox(10.h, 0),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(0, 10.w),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: false,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        itemBuilder: allGift,
        itemCount: length,
      ),
    );
  }

  int length = 0;
  List<Map<String, dynamic>>? result;
  /// 查询本房间消息
  Future<void> searchChatInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    // 获取所有数据
    // 执行查询操作
    String queryM =
        'select * from roomGiftTable order by id desc';
    result = await db.rawQuery(queryM);
    setState(() {
      length = result!.length;
    });
  }

}
