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
    // Get.lazyPut<BigClientController>(() => BigClientController());
    final c = Get.put(BigClientController());
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
          children: [
            _BigClientPage_Top(),
            _BigClientPage_Tab(),
            Expanded(
              child: PageView(
                controller: c.controller,
                onPageChanged: c.onPageChanged,
                children: [
                  _BigClientPage_List_0(),
                ],
              ),
            ),
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
  _BigClientPage_Tab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.w,
      child: Row(),
    );
  }
}

class _BigClientPage_List_0 extends StatelessWidget {
  const _BigClientPage_List_0({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BigClientController c = Get.find();
    return FittedBox(
      alignment: Alignment.topCenter,
      fit: BoxFit.fitWidth,
      child: SizedBox(
        width: 750,
        child: Column(
          children: [
            _item("日薪水", c.dayBean, c.dayExp),
            _item("周薪水", c.weekBean, c.weekExp),
            _item("月薪水", c.weekBean, c.weekExp),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, dynamic bean, dynamic exp) {
    const textColor = Color(0xFFF9E7C9);
    const detailColor = Color(0xFF91856F);
    textStyle(FontWeight fw) =>
        TextStyle(color: textColor, fontSize: 33, fontWeight: fw);
    const detailStyle = TextStyle(
        color: detailColor, fontSize: 21, fontWeight: FontWeight.normal);
    return SizedBox(
      width: 750,
      height: 167,
      child: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/bigclient_box.png'),
            fit: BoxFit.fill,
          ),
          Positioned(
            left: 90,
            bottom: 36.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: textStyle(FontWeight.w500),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 4),
                        child: SizedBox(
                          width: 137,
                          child: FittedBox(
                            child: Container(
                              alignment: Alignment.bottomRight,
                              constraints: const BoxConstraints(minWidth: 137),
                              child: Obx(() => Text(
                                    bean.value,
                                    style: textStyle(FontWeight.w900),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'V豆',
                        style: textStyle(FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                Obx(() =>
                    Text('还差 ${exp.value} 经验可领取当前等级$title', style: detailStyle))
              ],
            ),
          ),
          Positioned(
            right: 84,
            bottom: 56,
            width: 164,
            height: 55,
            child: GestureDetector(
              onTap: () {},
              child: const Image(
                image: AssetImage('assets/images/bigclient_btn.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
