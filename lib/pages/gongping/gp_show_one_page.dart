import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../widget/Marquee.dart';

/// 公屏展示系统推送的信息
class GPShowOnePage extends StatefulWidget {
  const GPShowOnePage({super.key});

  @override
  State<GPShowOnePage> createState() => _GPShowOnePageState();
}

class _GPShowOnePageState extends State<GPShowOnePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.transparent,
      body: Container(
        height: ScreenUtil().setHeight(400),
        width: double.infinity,
        child: Stack(
          children: [
            SVGASimpleImage(
              assetsName: 'assets/svga/gp/gp_1.svga',
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(230),
                  left: ScreenUtil().setHeight(50),
                  right: ScreenUtil().setHeight(50)
              ),
              child: Marquee(
                speed: 10,
                child: Text(
                  '恭喜某某用户单抽喜中价值500元的小柴一个',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(25),
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
