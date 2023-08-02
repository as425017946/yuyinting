import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/bean/BlackListBean.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 黑名单
class BlackPage extends StatefulWidget {
  const BlackPage({Key? key}) : super(key: key);

  @override
  State<BlackPage> createState() => _BlackPageState();
}

class _BlackPageState extends State<BlackPage> {
  var appBar;
  List<Data> _list = [];
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
    doBlackList();
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
    doBlackList();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('黑名单', true, context, false, 0);
    doBlackList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          GestureDetector(
            onTap: (() {
              doPostUpdateList(_list[i].blackUid!, i);
            }),
            child: WidgetUtils.myContainer(
                ScreenUtil().setHeight(45),
                ScreenUtil().setHeight(100),
                MyColors.homeTopBG,
                MyColors.homeTopBG,
                '解除',
                ScreenUtil().setSp(25),
                Colors.white),
          ),
          WidgetUtils.commonSizedBox(0, 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: length > 0
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
            ),
    );
  }

  /// 黑名单列表
  Future<void> doBlackList() async {
    try {
      Loading.show("加载中...");
      Map<String, dynamic> params = <String, dynamic>{
        'page': page,
        'pageSize': MyConfig.pageSize
      };
      BlackListBean bean = await DataUtils.postBlackList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.isNotEmpty) {
              for(int i =0; i < bean.data!.length; i++){
                _list.add(bean.data![i]);
              }

              length = bean.data!.length;
            }else{
              if (page == 1) {
                length = 0;
              }
            }
            if(bean.data!.length < MyConfig.pageSize){
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

  /// 解除黑名单
  Future<void> doPostUpdateList(blackUid, index) async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '0',
      'black_uid': blackUid,
    };
    try {
      Loading.show("提交中...");
      CommonBean bean = await DataUtils.postUpdateList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("解除成功！");
          setState(() {
            _list.removeAt(index);
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
