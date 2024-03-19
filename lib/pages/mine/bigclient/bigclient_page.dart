import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yuyinting/utils/loading.dart';

import '../../../utils/my_utils.dart';
import '../bigclient/bigclient_model.dart';

class BigClientPage extends StatelessWidget {
  const BigClientPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<BigClientController>(() => BigClientController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "大客户体系",
            style: TextStyle(
                color: const Color(0xFFF9E7C9),
                fontSize: ScreenUtil().setSp(33)),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            color: Colors.black,
            onPressed: (() {
              //如果loading正在显示，让其消失
              Loading.dismiss();
              Get.back();
              MyUtils.hideKeyboard(context);
            }),
          )),
      body: Container(
        color: const Color(0xFF10101B),
        child: Column(
          children: const [
            _BigClientPage_Top(),
            _BigClientPage_Tab(),
          ],
        ),
      ),
    );
  }
}

class _BigClientPage_Top extends StatelessWidget {
  const _BigClientPage_Top({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Text("1");
  }
}

class _BigClientPage_Tab extends StatelessWidget {
  const _BigClientPage_Tab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const _BigClientPage_List_0();
  }
}
class _BigClientPage_List_0 extends StatelessWidget {
  const _BigClientPage_List_0({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BigClientController c = Get.find();
    return Container(
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Column(
          children: [
            Obx(() => _item("日薪水", c.dayBean, c.dayExp)),
            Obx(() => _item("周薪水", c.dayBean, c.dayExp)),
            Obx(() => _item("月薪水", c.dayBean, c.dayExp)),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, int bean, int exp) {
    return Stack(
      children: [
        Text(title),
      ],
    );
  }
}