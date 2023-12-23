import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/searchGonghuiBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/widget_utils.dart';
import 'gonghui_more_page.dart';
/// 公会中心
class GonghuiHomePage extends StatefulWidget {
  const GonghuiHomePage({Key? key}) : super(key: key);

  @override
  State<GonghuiHomePage> createState() => _GonghuiHomePageState();
}

class _GonghuiHomePageState extends State<GonghuiHomePage> {
  var appBar;
  final TextEditingController _souSuoName = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会中心', true, context, true, 3);
    eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '创建公会'){
        Navigator.pushNamed(context, 'KefuPage');
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            WidgetUtils.showImages('assets/images/gonghui_jiaru.png', ScreenUtil().setHeight(250), double.infinity),
            WidgetUtils.commonSizedBox(30, 0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: ScreenUtil().setHeight(70),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: MyColors.f4,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                      //设置四周边框
                      border: Border.all(width: 1, color: MyColors.f4),
                    ),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 10),
                        WidgetUtils.showImages('assets/images/sousuo_hui.png',
                            ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                        WidgetUtils.commonSizedBox(0, 10),
                        Expanded(child: WidgetUtils.commonTextField(_souSuoName, '公会名称/公会ID')),
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: ((){
    if(MyUtils.checkClick()) {
      if (_souSuoName.text
          .trim()
          .isNotEmpty) {
        doPostSearchGuild(_souSuoName.text.trim());
        MyUtils.hideKeyboard(context);
      } else {
        MyToastUtils.showToastBottom('请输入公会名称/公会ID');
      }
    }
                  }),
                  child: WidgetUtils.onlyText('搜索', StyleUtils.getCommonTextStyle(color: MyColors.walletWZBlue, fontSize: ScreenUtil().setSp(32))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


  /// 搜索公会
  Future<void> doPostSearchGuild(keyword) async {
    Map<String, dynamic> params = <String, dynamic>{
      'keyword': keyword,
    };
    try {
      searchGonghuiBean bean = await DataUtils.postSearchGuild(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if(bean.data!.uid == null){
            MyToastUtils.showToastBottom("暂无搜索公会");
          }else{
            Future.delayed(const Duration(seconds: 0), () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return GonghuiMorePage(bean: bean,);
                  }));
            });
          }
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
