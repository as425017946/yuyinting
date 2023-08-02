import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/userDTListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
///动态

class MyDongtaiPage extends StatefulWidget {
  const MyDongtaiPage({Key? key}) : super(key: key);

  @override
  State<MyDongtaiPage> createState() => _MyDongtaiPageState();
}

class _MyDongtaiPageState extends State<MyDongtaiPage> {
  List<ListDT> _list = [];
  var length = 1;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  int page = 1;


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
    doPostUserList();
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
    doPostUserList();
    _refreshController.loadComplete();
  }


  Widget _itemPeople(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
      width: double.infinity,
      height: ScreenUtil().setHeight(120),
      child: Row(
        children: [
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100),
              ScreenUtil().setWidth(100), _list[i].avatar!),
          WidgetUtils.commonSizedBox(0, 10),
          Expanded(
            child: Column(
              children: [
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(
                    _list[i].nickname!,
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: 14)),
                WidgetUtils.commonSizedBox(5, 10),
                WidgetUtils.onlyText(
                    'ID: ${_list[i].number!}',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g9, fontSize: 12)),
                const Expanded(child: Text('')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostUserList();
  }

  @override
  Widget build(BuildContext context) {
    return length > 0
        ? SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: true,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        itemBuilder: _itemPeople,
        itemCount: _list.length,
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
              '暂无黑名单人员',
              StyleUtils.getCommonTextStyle(
                  color: MyColors.g6,
                  fontSize: ScreenUtil().setSp(26))),
          const Expanded(child: Text('')),
        ],
      ),
    );
  }


  /// 用户动态
  Future<void> doPostUserList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id'),
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      Loading.show("加载中...");
      userDTListBean bean = await DataUtils.postUserList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.list!.isNotEmpty) {
              for(int i =0; i < bean.data!.list!.length; i++){
                _list.add(bean.data!.list![i]);
              }

              length = bean.data!.list!.length;
            }else{
              if (page == 1) {
                length = 0;
              }
            }
            if(bean.data!.list!.length < MyConfig.pageSize){
              _refreshController.loadNoData();
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
