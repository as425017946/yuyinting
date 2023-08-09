import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bean/gameListBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
///游戏页面
class YouxiPage extends StatefulWidget {
  const YouxiPage({Key? key}) : super(key: key);

  @override
  State<YouxiPage> createState() => _YouxiPageState();
}

class _YouxiPageState extends State<YouxiPage> {

  List<Data> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGameList();
  }

  Widget gameItems(BuildContext context,int i){
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 0),
        Container(
          height: ScreenUtil().setHeight(300),
          width: double.infinity,
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(300), double.infinity, 10, list[i].couverImg!),
        ),
        WidgetUtils.commonSizedBox(10, 0),
        Container(
          height: ScreenUtil().setHeight(80),
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    WidgetUtils.onlyText(list[i].title!, StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(29),fontWeight: FontWeight.w600)),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Text(
                        list[i].content!,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: MyColors.g6,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              WidgetUtils.showImages('assets/images/quliaojie.png', 25, 65),
            ],
          ),
        ),
        WidgetUtils.myLine(color: MyColors.f6,thickness: 10),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20),
                  WidgetUtils.onlyText('热门游戏', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600))
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                itemBuilder: gameItems,
                itemCount: list.length,
              ),
            ],
          ),

        ),
      ),
    );
  }
  /// 游戏列表
  Future<void> doPostGameList() async {
    try {
      Loading.show();
      gameListBean bean = await DataUtils.postGameList();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(bean.data!.isNotEmpty){
              list = bean.data!;
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
