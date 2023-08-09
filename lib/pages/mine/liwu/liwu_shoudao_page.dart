import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/config/my_config.dart';

import '../../../bean/liwuMoreBean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
///收到的记录
class LiwuShoudaoPage extends StatefulWidget {
  const LiwuShoudaoPage({Key? key}) : super(key: key);

  @override
  State<LiwuShoudaoPage> createState() => _LiwuShoudaoPageState();
}

class _LiwuShoudaoPageState extends State<LiwuShoudaoPage> {
  var length = 1;
  List<Data> list = [];
  /// 当前页码
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
      doPostGiftDetail();
    }
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
    doPostGiftDetail();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGiftDetail();
  }

  Widget _itemLiwu(BuildContext context, int i) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(80),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,//宽度
                color: MyColors.f5, //边框颜色
              ),
            ),
          ),
          child: Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.CircleHeadImage(30, 30, list[i].avatar!),
              WidgetUtils.commonSizedBox(0, 10),
              WidgetUtils.onlyText(list[i].username!, StyleUtils.getCommonTextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(31))),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('送给您的礼物', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(31))),
              WidgetUtils.commonSizedBox(0, 20),
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(200),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 10,//宽度
                color: MyColors.f5, //边框颜色
              ),
            ),
          ),
          child: Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.showImagesNet(list[i].giftImg!, ScreenUtil().setHeight(125), ScreenUtil().setHeight(125)),
              WidgetUtils.commonSizedBox(0, 20),
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.onlyText('礼物：${list[i].giftName!}', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                    WidgetUtils.commonSizedBox(10, 0),
                    WidgetUtils.onlyText('价格：${list[i].amount!}', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                    WidgetUtils.commonSizedBox(10, 0),
                    WidgetUtils.onlyText('时间：${list[i].addTime!}', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  length > 0
        ? SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: true,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        itemBuilder: _itemLiwu,
        itemCount: list.length,
      ),
    )
        : Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          const Expanded(child: Text('')),
          WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.onlyTextCenter(
              '暂无收到礼物',
              StyleUtils.getCommonTextStyle(
                  color: MyColors.g6,
                  fontSize: ScreenUtil().setSp(26))),
          const Expanded(child: Text('')),
        ],
      ),
    );
  }


  /// 礼物记录
  Future<void> doPostGiftDetail() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      Loading.show("加载中...");
      liwuMoreBean bean = await DataUtils.postGiftDetail(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              list.clear();
            }
            if(bean.data!.isNotEmpty){
              for(int i =0; i < bean.data!.length; i++){
                list.add(bean.data![i]);
              }
              if(bean.data!.length < MyConfig.pageSize){
                _refreshController.loadNoData();
              }

              length = bean.data!.length;
            }else{
              if (page == 1) {
                length = 0;
              }else{
                _refreshController.loadNoData();
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
