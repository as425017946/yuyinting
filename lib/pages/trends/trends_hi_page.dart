import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';
///打招呼弹窗
class TrendsHiPage extends StatefulWidget {
  String imgUrl;
  String uid;
  int index;
  TrendsHiPage({Key? key, required this.imgUrl, required this.uid, required this.index}) : super(key: key);

  @override
  State<TrendsHiPage> createState() => _TrendsHiPageState();
}

class _TrendsHiPageState extends State<TrendsHiPage> {
  var gz = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<SubmitButtonBack>().listen((event) {
        if(MyUtils.compare('发送', event.title) == 0){
          if(mounted) {
            doPostHi();
          }
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.black54,
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: ScreenUtil().setHeight(600),
                width: ScreenUtil().setHeight(520),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Expanded(child: Text('')),
                        GestureDetector(
                          onTap: ((){
                            ///关闭当前页面
                            Navigator.pop(context);
                          }),
                          child: WidgetUtils.showImages('assets/images/close.png', 15, 15),
                        ),
                        const SizedBox(width: 20,),
                      ],
                    ),
                    const SizedBox(height: 40,),
                    const Text('给TA别致打招呼',style: TextStyle(fontSize: 18,color: MyColors.black_3, fontWeight: FontWeight.w600),),
                    const SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      height: ScreenUtil().setHeight(150),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.f2,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: WidgetUtils.onlyText("遇见你真好，我们交个朋友吧！", StyleUtils.textStyleG3),
                    ),
                    WidgetUtils.commonSubmitButton('发送'),
                    WidgetUtils.commonSizedBox(10, 0),
                    GestureDetector(
                      onTap: ((){
                        setState(() {
                          gz = !gz;
                        });
                      }),
                      child: Row(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.showImages( gz == false ? 'assets/images/trends_r1.png' : 'assets/images/trends_r2.png', 15, 15),
                          WidgetUtils.commonSizedBox(0, 10),
                          const Text('关注TA，Ta的最新动态怎能错过~',style: TextStyle(fontSize: 13,color: MyColors.g9, ),),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              WidgetUtils.CircleHeadImage(80, 80, widget.imgUrl)
            ],
          ),
        ),
      ),
    );
  }

  /// 打招呼
  Future<void> doPostHi() async {
    if(gz){
      doPostFollow();
    }
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.uid,
    };
    try {
      CommonBean bean = await DataUtils.postHi(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          eventBus.fire(HiBack(isBack: true, index: widget.index));
          Navigator.pop(context);
          break;
        case MyHttpConfig.errorHiCode:
          eventBus.fire(HiBack(isBack: true, index: widget.index));
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
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 关注
  Future<void> doPostFollow() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status':'1',
      'follow_id': widget.uid,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:

          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

}
