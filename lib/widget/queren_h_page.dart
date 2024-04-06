import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../colors/my_colors.dart';
import '../main.dart';
import '../utils/style_utils.dart';
/// 二次确认弹窗
class QueRenHPage extends StatefulWidget {
  String title;
  int jine;
  bool isDuiHuan;
  String index;
  QueRenHPage({super.key, required this.title, required this.jine, required this.isDuiHuan, required this.index});

  @override
  State<QueRenHPage> createState() => _QueRenPageState();
}

class _QueRenPageState extends State<QueRenHPage> {
  // 默认选中今日不在弹出
  bool  isCheck = true;
  @override
  void initState() {
    super.initState();
    AutoOrientation.landscapeAutoMode();
    ///关闭状态栏，与底部虚拟操作按钮
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: []); //隐藏状态栏，底部按钮栏
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 300,
          height: 150,
          decoration: const BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(
                Radius.circular(10)),
          ),
          child: Column(
            children: [
              const Spacer(),
              RichText(
                text: TextSpan(
                    text: '本次参与将消耗',
                    style: StyleUtils.getCommonTextStyle(
                        color: MyColors.g2, fontSize: 16, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                          text: '${widget.jine}',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.origin, fontSize: 16, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: widget.title == '赛车商店' && widget.isDuiHuan ? '蘑菇币，请确认' : '金豆/钻石，请确认',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g2, fontSize: 16, fontWeight: FontWeight.w600)),
                    ]),
              ),
              WidgetUtils.commonSizedBox(10, 10),
              widget.isDuiHuan == false ? Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: ((){
                      setState(() {
                        isCheck = !isCheck;
                      });
                    }),
                    child: WidgetUtils.showImages(isCheck ? 'assets/images/mofang_check_yes.png' : 'assets/images/mofang_check_no.png', 15, 15),
                  ),
                  WidgetUtils.commonSizedBox(0, 5),
                  WidgetUtils.onlyText('今日不在弹出', StyleUtils.getCommonTextStyle(
                      color: MyColors.g2, fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                ],
              ) : const Text(''),
              WidgetUtils.commonSizedBox(20, 10),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: ((){
                      Navigator.pop(context);
                    }),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.d8,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: WidgetUtils.onlyTextCenter('取消', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: 16)),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                  GestureDetector(
                    onTap: ((){
                      ///确认后请求接口
                      if(isCheck){
                        DateTime now = DateTime.now();
                        int year = now.year;
                        int month = now.month;
                        int day = now.day;
                        sp.setBool('car_queren_h', true);
                        sp.setString('car_queren_time_h', '$year-$month-$day');
                      }else{
                        sp.setBool('car_queren_h', false);
                      }
                      ///确认后请求接口
                      Navigator.pop(context);
                      eventBus.fire(QuerenBack(title: '横屏赛车', jine: widget.jine, index: widget.index));
                    }),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.blue,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: WidgetUtils.onlyTextCenter('确认', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              WidgetUtils.commonSizedBox(10, 10),
            ],
          ),
        ),
      ),
    );
  }
}
