import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../colors/my_colors.dart';
///打招呼弹窗
class TrendsHiPage extends StatefulWidget {
  const TrendsHiPage({Key? key}) : super(key: key);

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
          Navigator.pop(context);
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
              WidgetUtils.CircleHeadImage(80, 80, 'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342')
            ],
          ),
        ),
      ),
    );
  }
}
