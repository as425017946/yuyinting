import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../colors/my_colors.dart';
import '../main.dart';
import '../utils/style_utils.dart';
/// 商品二次确认弹窗 横屏使用
class DuiHuanQueRenHPage extends StatefulWidget {
  String goodsId;
  String goodsType;
  int exchangeCost;
  String title;
  DuiHuanQueRenHPage({super.key, required this.goodsId, required this.goodsType, required this.exchangeCost, required this.title});

  @override
  State<DuiHuanQueRenHPage> createState() => _QueRenPageState();
}

class _QueRenPageState extends State<DuiHuanQueRenHPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // 默认选中今日不在弹出
  bool  isCheck = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 300,
          height: 180,
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
                    text: '本次兑换将消耗',
                    style: StyleUtils.getCommonTextStyle(
                        color: MyColors.g2, fontSize: 16, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                          text: '${widget.exchangeCost}',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.origin, fontSize: 16, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: widget.title == '心动转盘' ? '个心之钥' : widget.title == '超级转盘' ? '个星之钥' : '个蘑菇币',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g2, fontSize: 16, fontWeight: FontWeight.w600)),
                    ]),
              ),
              const Spacer(),
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
                  WidgetUtils.commonSizedBox(0, 20),
                  GestureDetector(
                    onTap: ((){
                      Navigator.pop(context);
                      eventBus.fire(DHQuerenBack(goodsId: widget.goodsId, goodsType: widget.goodsType, exchangeCost: widget.exchangeCost));
                    }),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        //背景
                        color:  widget.title == '心动转盘' ? MyColors.zp1 : widget.title == '超级转盘' ? MyColors.CarBG : MyColors.roomBlue,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: WidgetUtils.onlyTextCenter('确认', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 10),
            ],
          ),
        ),
      ),
    );
  }
}
