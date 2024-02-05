import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/searchGonghuiBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/chat_page.dart';
/// 无工会的详情
class GonghuiMorePage extends StatefulWidget {
  searchGonghuiBean bean;
  GonghuiMorePage({Key? key, required this.bean}) : super(key: key);

  @override
  State<GonghuiMorePage> createState() => _GonghuiMorePageState();
}

class _GonghuiMorePageState extends State<GonghuiMorePage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会详情', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  WidgetUtils.showImagesFill('assets/images/gonghui_more_bg.jpg', ScreenUtil().setHeight(300), double.infinity),
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(20, 20),
                      WidgetUtils.CircleImageNet(ScreenUtil().setHeight(144), ScreenUtil().setHeight(144), 10, widget.bean.data!.logo!),
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                WidgetUtils.onlyText(widget.bean.data!.title!, StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.w600)),
                                // WidgetUtils.showImages(, height, width)
                              ],
                            ),
                            WidgetUtils.commonSizedBox(10, 20),
                            WidgetUtils.onlyText('ID: ${widget.bean.data!.number}', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25),)),
                            WidgetUtils.commonSizedBox(10, 20),
                            WidgetUtils.onlyText('创建时间: ${widget.bean.data!.addTime!}', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(25),)),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(20, 20),
                    ],
                  )
                ],
              ),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0,-15),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.white ,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        WidgetUtils.commonSizedBox(20, 20),
                        WidgetUtils.onlyText('公会公告', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                        WidgetUtils.commonSizedBox(10, 20),
                        WidgetUtils.onlyText(widget.bean.data!.notice!, StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(26),)),
                        WidgetUtils.commonSizedBox(20, 20),
                        WidgetUtils.onlyText('公会会长', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                        WidgetUtils.commonSizedBox(10, 20),
                        Row(
                          children: [
                            WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(120), ScreenUtil().setHeight(120), widget.bean.data!.leaderAvatar!),
                            WidgetUtils.commonSizedBox(10, 20),
                            Expanded(
                              child: Column(
                                children: [
                                  WidgetUtils.onlyText(widget.bean.data!.leaderNickname!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                                  WidgetUtils.commonSizedBox(10, 20),
                                  WidgetUtils.onlyText('ID: ${widget.bean.data!.leaderNumber}', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25),)),
                                ],
                              ),
                            )
                          ],
                        ),
                        WidgetUtils.commonSizedBox(30, 20),
                        WidgetUtils.onlyText('签约须知', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(29),)),
                        WidgetUtils.commonSizedBox(10, 20),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.bean.data!.signNotice!,
                              maxLines: 20,
                              style: StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          /// 应聘咨询按钮
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: ((){
                      if (MyUtils.checkClick()) {
                        MyUtils.goTransparentRFPage(
                            context,
                            ChatPage(
                              nickName: widget.bean.data!.leaderNickname!,
                              otherUid: widget.bean.data!.uid.toString(),
                              otherImg: widget.bean.data!.leaderAvatar!,
                            ));
                      }
                    }),
                    child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '应聘咨询', ScreenUtil().setSp(33), Colors.white) ,
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 20),
                Expanded(
                  child: GestureDetector(
                    onTap: ((){
                      if(MyUtils.checkClick()) {
                        if (widget.bean.data!.isApply != 1) {
                          doPostApplySign(widget.bean.data!.id.toString());
                        } else {
                          MyToastUtils.showToastBottom(
                              '您已经申请该公会，请耐心等待审核！');
                        }
                      }
                    }),
                    child: WidgetUtils.myContainer(ScreenUtil().setHeight(70), double.infinity, widget.bean.data!.isApply == 1 ? MyColors.mineGrey : MyColors.homeTopBG, widget.bean.data!.isApply == 1 ? MyColors.mineGrey : MyColors.homeTopBG, '申请签约', ScreenUtil().setSp(33), Colors.white) ,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  /// 申请签约
  Future<void> doPostApplySign(id) async {
    Map<String, dynamic> params = <String, dynamic>{
      'id': id,
    };
    try {
      CommonBean bean = await DataUtils.postApplySign(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("申请成功，请您耐心等待审核！");
          // ignore: use_build_context_synchronously
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
