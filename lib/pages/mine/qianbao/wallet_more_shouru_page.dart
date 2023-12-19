import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/loading.dart';

import '../../../bean/walletListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 钱包明细收入
class WalletMoreShouruPage extends StatefulWidget {
  const WalletMoreShouruPage({Key? key}) : super(key: key);

  @override
  State<WalletMoreShouruPage> createState() => _WalletMoreShouruPageState();
}

class _WalletMoreShouruPageState extends State<WalletMoreShouruPage> {
  var length = 0;

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
        leixing = '提现';
        if(list[i].curType == 1){
          showImg = 'assets/images/wallet_d.png';
        }else{
          showImg = 'assets/images/wallet_z.png';
        }
        break;
      case 7:
        leixing = '兑换';
        if(list[i].curType == 1){
          showImg = 'assets/images/wallet_d.png';
        }else{
          showImg = 'assets/images/wallet_z.png';
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
        leixing = '刷礼物';
        showImg = list[i].img!;
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
              leixing == '刷礼物' ? WidgetUtils.showImagesNet(showImg, ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)) : WidgetUtils.showImages(showImg, ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
              WidgetUtils.commonSizedBox(0, 20),
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    Row(
                      children: [
                        leixing == '刷礼物' ? WidgetUtils.onlyText('礼物：${list[i].name}', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))) : const Text(''),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText(list[i].curType == 1 ? 'V豆' : '钻石', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        WidgetUtils.onlyText('时间：${list[i].addTime!.substring(5,16)}', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText('+${list[i].price!}', StyleUtils.getCommonTextStyle(color: MyColors.walletMingxi, fontSize: ScreenUtil().setSp(38), fontWeight: FontWeight.w600)),
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
    return length > 0 ? ListView.builder(
      itemBuilder: _itemLiwu,
      itemCount: list.length,
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

  List<Result> list = [];
  /// 钱包明细 - 收入
  Future<void> doPostBalance() async {
    Loading.show();
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'type': '1', //钱包类型 1收入 2支出
      };
      walletListBean bean = await DataUtils.postWalletList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list = bean.data!.result!;
            length = list.length;
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
