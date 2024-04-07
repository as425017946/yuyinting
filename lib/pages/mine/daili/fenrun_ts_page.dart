import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 今日实际分润说明
class FenRunTSPage extends StatefulWidget {
  const FenRunTSPage({super.key});

  @override
  State<FenRunTSPage> createState() => _FenRunTSPageState();
}

class _FenRunTSPageState extends State<FenRunTSPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Center(
            child: Container(
              // height: 240.w,//270*1.25.w,
              width: 380.w,//350*1.25.w,
              padding: EdgeInsets.all(25.w),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.black54,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Text(
                  // '今日实时分润=（游戏参与额-中奖礼物额）*游戏股份比例 + 直刷礼物额*直刷股份比例\n今日分润金将在明日转存到您的“可领取分润',
                  '今日实时分润 = 打赏礼物额 x 分成比例\n今日分润金将在明日转存到您的“可领取金币”',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp
                  ),
              ),
            ),
          ),
          // Expanded(
          //     child: GestureDetector(
          //       onTap: (() {
          //         Navigator.pop(context);
          //       }),
          //       child: Container(
          //         color: Colors.transparent,
          //       ),
          //     )),
        ],
      ),
    );
  }
}
