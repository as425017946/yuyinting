import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 钱包明细支出
class WalletMoreZhichuPage extends StatefulWidget {
  const WalletMoreZhichuPage({Key? key}) : super(key: key);

  @override
  State<WalletMoreZhichuPage> createState() => _WalletMoreZhichuPageState();
}

class _WalletMoreZhichuPageState extends State<WalletMoreZhichuPage> {
  var length = 2;

  Widget _itemLiwu(BuildContext context, int i) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 20),
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            WidgetUtils.onlyText('送出礼物', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(31))),
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
              WidgetUtils.showImagesNet('https://img-blog.csdnimg.cn/3d809148c83f4720b5e2a6567f816d89.jpeg', ScreenUtil().setHeight(100), ScreenUtil().setHeight(100)),
              WidgetUtils.commonSizedBox(0, 20),
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    Row(
                      children: [
                        WidgetUtils.onlyText('礼物：魔法星球x10', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText('金币', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        WidgetUtils.onlyText('时间：2023-06-09 13:00:00', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(25))),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText('-1000', StyleUtils.getCommonTextStyle(color: MyColors.walletMingxi, fontSize: ScreenUtil().setSp(42), fontWeight: FontWeight.bold)),
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
      itemCount: length,
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
}
