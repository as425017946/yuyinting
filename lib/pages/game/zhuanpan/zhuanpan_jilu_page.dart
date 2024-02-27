import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/winListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';

/// 转盘记录
class ZhuanPanJiLuPage extends StatefulWidget {
  int type;
  ZhuanPanJiLuPage({super.key, required this.type});

  @override
  State<ZhuanPanJiLuPage> createState() => _ZhuanPanJiLuPageState();
}

class _ZhuanPanJiLuPageState extends State<ZhuanPanJiLuPage> {
  int page = 1;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGetMineRouletteWinList();
  }

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
    doPostGetMineRouletteWinList();
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
    doPostGetMineRouletteWinList();
    _refreshController.loadComplete();
  }

  Widget Jilu(BuildContext context, int i) {
    return Column(
      children: [
        SizedBox(
          height: 100.h,
          child: Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20.h),
              WidgetUtils.showImagesNet(
                  list[i].giftImg!, 60.h, 60.h),
              WidgetUtils.commonSizedBox(0, 10.h),
              Expanded(
                  child: Column(
                children: [
                  const Spacer(),
                  WidgetUtils.onlyText(
                      list[i].giftName!,
                      StyleUtils.getCommonTextStyle(
                          color: Colors.white, fontSize: 28.sp)),
                  WidgetUtils.commonSizedBox(5.h, 0),
                  WidgetUtils.onlyText(
                      list[i].addTime!,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.zpJLYellow, fontSize: 24.sp)),
                  const Spacer(),
                ],
              )),
              WidgetUtils.onlyText(
                  'x${list[i].number}',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomTCYellow, fontSize: 48.sp)),
              WidgetUtils.commonSizedBox(0, 20.h),
            ],
          ),
        ),
        Container(
          height: 3.h,
          margin: EdgeInsets.only(left: 20.h, right: 20.h),
          color: MyColors.zpJLHX,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              height: 380.h,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/zhuanpan_jl_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(50.h, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetUtils.commonSizedBox(0, 20.h),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/back_white.png', 30.h, 20.h),
                    ),
                    const Spacer(),
                    WidgetUtils.showImages(
                        'assets/images/zhuanpan_jl_title.png', 30.h, 230.h),
                    const Spacer(),
                    WidgetUtils.commonSizedBox(0, 40.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(20.h, 0),
                Expanded(
                    child: SmartRefresher(
                      header: MyUtils.myHeader(),
                      footer: MyUtils.myFotter(),
                      controller: _refreshController,
                      enablePullUp: true,
                      onLoading: _onLoading,
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                        itemBuilder: Jilu,
                        itemCount: list.length,
                      ),
                    )
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  List<Data> list = [];
  /// 魔方转盘我的中奖记录
  Future<void> doPostGetMineRouletteWinList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'game_id': '2', // 1魔方2转盘
      'price': widget.type == 0 ? '100' : '1000',
      'page': page,
      'pageSize': MyConfig.pageSize,
    };
    Loading.show(MyConfig.successTitle);
    try {
      winListBean bean = await DataUtils.postGetMineRouletteWinList(params);
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
