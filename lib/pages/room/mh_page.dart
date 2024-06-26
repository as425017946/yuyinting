import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

/// 盲盒介绍
class MHPage extends StatefulWidget {
  const MHPage({super.key});

  @override
  State<MHPage> createState() => _MHPageState();
}

class _MHPageState extends State<MHPage> {
  var appBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('惊喜礼盒玩法', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // WidgetUtils.commonSizedBox(100.h, 0),
            WidgetUtils.showImagesNetRoom(
                'http://oawawb.cn/image/202405/14/6642f5a14b609.jpg', 5200.w, double.infinity),
            // WidgetUtils.commonSizedBox(100.h, 0),
          ],
        ),
      ),
    );
  }
}
