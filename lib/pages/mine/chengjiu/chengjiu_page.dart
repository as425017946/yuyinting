import 'package:flutter/material.dart';

import '../../../utils/widget_utils.dart';
/// 等级成就
class ChengJiuPage extends StatefulWidget {
  const ChengJiuPage({super.key});

  @override
  State<ChengJiuPage> createState() => _ChengJiuPageState();
}

class _ChengJiuPageState extends State<ChengJiuPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('魅力等级', true, context, false, 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Image(image: AssetImage('assets/images/cj/user_dj_1.jpg')),
            // Image(image: AssetImage('assets/images/cj/user_dj_2.jpg')),
            // Image(image: AssetImage('assets/images/cj/user_dj_3.jpg')),
            // Image(image: AssetImage('assets/images/cj/user_dj_4.jpg')),
            // Image(image: AssetImage('assets/images/cj/user_dj_5.jpg')),
            // Image(image: AssetImage('assets/images/cj/user_dj_6.jpg')),
          ],
        ),
      ),
    );
  }
}
