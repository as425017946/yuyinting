import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import 'edit_gh_head_page.dart';
/// 公会设置
class SettingGonghuiPage extends StatefulWidget {
  const SettingGonghuiPage({Key? key}) : super(key: key);

  @override
  State<SettingGonghuiPage> createState() => _SettingGonghuiPageState();
}

class _SettingGonghuiPageState extends State<SettingGonghuiPage> {
  var appBar;
  TextEditingController controllerGG = TextEditingController();
  var listen;
  String logoid = '',imgPath = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会设置', true, context, false, 0);
    imgPath = sp.getString('guild_logo').toString();
    controllerGG.text = sp.getString('guild_notice').toString();
    listen = eventBus.on<FileBack>().listen((event) {
      if(event.type == 0){
        setState(() {
          logoid = event.id;
          imgPath = event.info;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              WidgetUtils.commonSizedBox(20, 20),
              Expanded(child: WidgetUtils.onlyText('公会头像', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.w600))),
              GestureDetector(
                onTap: ((){
                  MyUtils.goTransparentPage(context, const EditGHHeadPage());
                }),
                child:  WidgetUtils.CircleImageNet(ScreenUtil().setHeight(100),
                    ScreenUtil().setHeight(100), 10, imgPath),
              ),
              WidgetUtils.commonSizedBox(10, 10),
              Image(
                image: const AssetImage('assets/images/mine_more.png'),
                width: ScreenUtil().setHeight(16),
                height: ScreenUtil().setHeight(27),
              ),
              WidgetUtils.commonSizedBox(20, 20),
            ],
          ),
          WidgetUtils.myLine(color: MyColors.f4),
          Column(
            children: [
               Row(
                 children: [
                   WidgetUtils.commonSizedBox(20, 20),
                   Expanded(child: WidgetUtils.onlyText('公会公告', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.w600))),
                 ],
               ),
              Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20),
                  Expanded(child: WidgetUtils.commonTextField(controllerGG, '输入公告')),
                ],
              ),
              WidgetUtils.myLine(color: MyColors.f4),
              WidgetUtils.commonSizedBox(50, 20),
              GestureDetector(
                onTap: (() {
                  doPostSignExamine();
                }),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(70),
                    ScreenUtil().setHeight(300),
                    MyColors.homeTopBG,
                    MyColors.homeTopBG,
                    '完成',
                    ScreenUtil().setSp(31),
                    Colors.white),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// 设置公会
  Future<void> doPostSignExamine() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'guild_id': sp.getString('guild_id'),
      'logo': logoid,
      'notice': controllerGG.text.trim().toString()
    };
    try {
      CommonBean bean = await DataUtils.postGhSave(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('操作成功！');
          Navigator.pop(context);
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
