import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/date_picker.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

///房间流水 - 新增
class RoomLiuShuiPage extends StatefulWidget {
  const RoomLiuShuiPage({super.key});

  @override
  State<RoomLiuShuiPage> createState() => _RoomLiuShuiPageState();
}

class _RoomLiuShuiPageState extends State<RoomLiuShuiPage> {
  var appBar;
  int page = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String starTime = '', endTime = '', keyword = '';

  void _onRefresh() async {
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
    // doPostSettleList();
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
    // doPostSettleList();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('房间流水', true, context, false, 0);
    DateTime now = DateTime.now();
    setState(() {
      starTime = now.toString().substring(0, 10);
      endTime = now.toString().substring(0, 10);
      // doPostTeamReport();
    });
    // listen = eventBus.on<InfoBack>().listen((event) {
    //   setState(() {
    //     keyword = event.info;
    //   });
    // });
  }

  /// 账单
  Widget _itemZhangdan(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {}),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 260.h),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        margin: const EdgeInsets.only(bottom: 10),
        color: MyColors.dailiBaobiao,
        child: Column(
          children: [
            Row(
              children: [
                WidgetUtils.onlyText(
                    "list[i].beginTime!",
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.commonSizedBox(0, 5),
                WidgetUtils.onlyText(
                    '至',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2, fontSize: ScreenUtil().setSp(28))),
                WidgetUtils.commonSizedBox(0, 5),
                WidgetUtils.onlyText(
                    "list[i].endTime!",
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                const Expanded(child: Text('')),
                // WidgetUtils.onlyText('已结算', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
              ],
            ),
            WidgetUtils.commonSizedBox(15, 10),
            Row(
              children: [
                WidgetUtils.onlyText(
                    '当周总流水：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    "list[i].weekSp!",
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2,
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                // WidgetUtils.onlyText('无效流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                // WidgetUtils.onlyText(list[i].unvalidSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            Row(
              children: [
                WidgetUtils.onlyText(
                    'V币直刷流水：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    "list[i].gbDirectSp!",
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2,
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(
                    '背包流水：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    "list[i].packSp!",
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2,
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            // WidgetUtils.onlyTextCenter('查明细>', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
            // WidgetUtils.commonSizedBox(10, 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(20.h, 20.h),
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20.h),
              WidgetUtils.onlyText(
                  '时间：',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
              GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    DateTime now = DateTime.now();
                    int year = now.year;
                    int month = now.month;
                    int day = now.day;

                    DatePicker.show(
                      context,
                      startDate: DateTime(1970, 1, 1),
                      selectedDate: DateTime(year, month, day),
                      endDate: DateTime(2024, 12, 31),
                      onSelected: (date) {
                        setState(() {
                          starTime = date.toString().substring(0, 10);
                        });
                      },
                    );
                  }
                }),
                child: Container(
                  color: MyColors.dailiTime,
                  padding: const EdgeInsets.all(2),
                  child: WidgetUtils.onlyText(
                      starTime,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g6,
                          fontSize: ScreenUtil().setSp(28))),
                ),
              ),
              Opacity(opacity: 1, child: WidgetUtils.commonSizedBox(0, 10)),
              Opacity(
                  opacity: 1,
                  child: WidgetUtils.onlyText(
                      '至',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g6,
                          fontSize: ScreenUtil().setSp(28)))),
              Opacity(opacity: 1, child: WidgetUtils.commonSizedBox(0, 10)),
              GestureDetector(
                onTap: (() {
                  DateTime now = DateTime.now();
                  int year = now.year;
                  int month = now.month;
                  int day = now.day;

                  DatePicker.show(
                    context,
                    startDate: DateTime(1970, 1, 1),
                    selectedDate: DateTime(year, month, day),
                    endDate: DateTime(2024, 12, 31),
                    onSelected: (date) {
                      setState(() {
                        endTime = date.toString().substring(0, 10);
                      });
                    },
                  );
                }),
                child: Container(
                  color: MyColors.dailiTime,
                  padding: const EdgeInsets.all(2),
                  child: WidgetUtils.onlyText(
                      endTime,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g6,
                          fontSize: ScreenUtil().setSp(28))),
                ),
              ),
              WidgetUtils.commonSizedBox(0, 10),
              GestureDetector(
                onTap: (() {
                  MyUtils.hideKeyboard(context);
                  // doPostTeamReport();
                }),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(50),
                    ScreenUtil().setHeight(120),
                    MyColors.homeTopBG,
                    MyColors.homeTopBG,
                    '查询',
                    ScreenUtil().setSp(25),
                    Colors.white),
              ),
              WidgetUtils.commonSizedBox(0, 20.h),
            ],
          ),
          Expanded(
            child: SmartRefresher(
              header: MyUtils.myHeader(),
              footer: MyUtils.myFotter(),
              controller: _refreshController,
              enablePullUp: true,
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                itemBuilder: _itemZhangdan,
                itemCount: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
