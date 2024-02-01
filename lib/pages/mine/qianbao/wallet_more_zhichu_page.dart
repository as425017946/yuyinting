import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../bean/walletListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 钱包明细支出
class WalletMoreZhichuPage extends StatefulWidget {
  const WalletMoreZhichuPage({Key? key}) : super(key: key);

  @override
  State<WalletMoreZhichuPage> createState() => _WalletMoreZhichuPageState();
}

class _WalletMoreZhichuPageState extends State<WalletMoreZhichuPage> {
  var length = 0;
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
    doPostBalance();
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
    doPostBalance();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostBalance();
  }

  Widget _itemLiwu(BuildContext context, int i) {
    //明细类型  1充值 2红包 3公会礼物即时分润 4公会礼物周返 5全民代理分润 6提现 7兑换 8 装扮 9个人礼物分润 10刷礼物
    String leixing = '', showImg = '';
    switch(list[i].type!){
      case 1:
        leixing = '充值';
        if(list[i].curType == 1){
          showImg = 'assets/images/wallet_d.png';
        }else{
          showImg = 'assets/images/wallet_z.png';
        }
        break;
      case 2:
        leixing = '红包';
        showImg = 'assets/images/wallet_jieshou.png';
        break;
      case 3:
        leixing = '公会礼物即时分润';
        showImg = 'assets/images/wallet_g.png';
        break;
      case 4:
        leixing = '公会礼物周返';
        showImg = 'assets/images/wallet_g.png';
        break;
      case 5:
        leixing = '全民代理分润';
        showImg = 'assets/images/wallet_q.png';
        break;
      case 6:
        if(list[i].curType == 1){
          showImg = 'assets/images/wallet_d.png';
        }else if(list[i].curType == 2){
          showImg = 'assets/images/wallet_z.png';
        }else{
          showImg = 'assets/images/mine_wallet_bb.png';
        }
        break;
      case 7:
        leixing = '兑换';
        if(list[i].curType == 1){
          showImg = 'assets/images/wallet_d.png';
        }else if(list[i].curType == 2){
          showImg = 'assets/images/wallet_z.png';
        }else{
          showImg = 'assets/images/mine_wallet_bb.png';
        }
        break;
      case 8:
        leixing = '装扮';
        if(list[i].curType == 1){
          showImg = 'assets/images/wallet_d.png';
        }else{
          showImg = 'assets/images/wallet_z.png';
        }
        break;
      case 9:
        leixing = '个人礼物分润';
        if(list[i].curType == 1){
          showImg = 'assets/images/wallet_d.png';
        }else{
          showImg = 'assets/images/wallet_z.png';
        }
        break;
      case 10:
        leixing = '打赏';
        showImg = list[i].img!;
        break;
      case 12:
        leixing = '提现申请冻结金';
        if(list[i].curType == 1){
          showImg = 'assets/images/wallet_d.png';
        }else if(list[i].curType == 2){
          showImg = 'assets/images/wallet_z.png';
        }else{
          showImg = 'assets/images/mine_wallet_bb.png';
        }
        break;
    }
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 20),
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            WidgetUtils.onlyText('类型:$leixing', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(31))),
          ],
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
              leixing == '打赏' ? WidgetUtils.showImagesNet(showImg, ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)) : WidgetUtils.showImages(showImg, ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
              WidgetUtils.commonSizedBox(0, 20),
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    Row(
                      children: [
                        leixing == '打赏' ? WidgetUtils.onlyText('礼物：${list[i].name}', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))) : const Text(''),
                        leixing == '打赏' ? WidgetUtils.onlyText('（x${list[i].number}）', StyleUtils.getCommonTextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(25))) : const Text(''),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText(list[i].curType == 1 ? 'V豆' : list[i].curType == 2 ? '钻石' : 'V币', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        WidgetUtils.onlyText('时间：${list[i].addTime!}', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText('-${list[i].price!}', StyleUtils.getCommonTextStyle(color: MyColors.walletMingxi, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return length > 0 ? SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: true,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemBuilder: _itemLiwu,
        itemCount: list.length,
      ),
    )
        :
    Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          const Expanded(child: Text('')),
          WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.onlyTextCenter('暂无收入', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
          const Expanded(child: Text('')),
        ],
      ),
    );
  }

  List<Data> list = [];
  /// 钱包明细 - 收入
  Future<void> doPostBalance() async {
    Loading.show();
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'type': '2', //钱包类型 1收入 2支出
        'page': page,
        'pageSize': MyConfig.pageSize
      };
      walletListBean bean = await DataUtils.postWalletList(params);
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
              length = bean.data!.length;
            } else {
              if (page == 1) {
                length = 0;
              } else {
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
