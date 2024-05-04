import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/wealth_info_bean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/getx_tools.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../mine/xc_mine_model.dart';

class BigClientController extends GetxController with GetAntiCombo {
  late final WealthInfoBeanData data;
  var dayBean = 0.obs;
  // var dayExp = '996'.obs;
  // var weekBean = '96006'.obs;
  // var weekExp = '996'.obs;
  // var monthBean = '96006'.obs;
  // var monthExp = '996'.obs;
  // var ryz = '荣耀值:0'.obs;
  var select = 0.obs;
  var current = 0.obs;

  final XCMineController c = Get.find();
  String get avatarFrameGifImg {
    return c.avatarFrameGifImg.value;
  }
  String get avatarFrameImg {
    return c.avatarFrameImg.value;
  }
  int get grLevel {
    return data.gr_level;
  }
  // set grLevel(int grLevel){}
  final List<String> texts = ['曜星', '苍穹', '皓月', '辉耀', '星华', '天域', '银河', '至尊'];
  final List<String> exps = [
    '200',
    '200',
    '200',
    '200',
    '200',
    '200',
    '200',
    '200'
  ];
  var success =
      ['VIP1', 'VIP2', 'VIP3', 'VIP4', 'VIP5', 'VIP6', 'VIP7', 'VIP8'].obs;

  late PageController controller = PageController(initialPage: select.value);
  late SwiperController swiperController = SwiperController();

  void onPageChanged(int value) {
    select.value = value;
  }

  void onLeft() {
    controller.jumpToPage(0);
  }

  void onRight() {
    controller.jumpToPage(1);
  }

  void onIndexChanged(int value) {
    current.value = value;
    // swiperController.move(value);
  }

  @override
  void onInit() {
    data = Get.arguments;
    dayBean.value = data.day_return;
    super.onInit();
  }
  @override
  void onReady() {
    final num = data.title - 1;
    swiperController.move(num, animation: false);
    current.value = num;
    // doPostDayReturnList();
    super.onReady();
  }

  String getTag(int index) {
    final current = data.title - 1;
    if (index == current) {
      return 'dqdj';
    }
    if (index < current) {
      return 'ydc';
    }
    return 'wjs';
  }

  void onDay() {
    action(() async {
      if(dayBean.value == 0){
        MyToastUtils.showToastBottom('暂无可领取俸禄~');
        return;
      }
      Loading.show();
      try {
        CommonBean bean = await DataUtils.postGetDayReturn();
        switch (bean.code) {
          case MyHttpConfig.successCode:
            dayBean.value = 0;
            returnList(returnList.map((element) {
              element.is_receive = 1;
              return element;
            }).toList());
            MyToastUtils.showToastBottom('领取成功!');
            break;
          case MyHttpConfig.errorloginCode:
            final context = Get.context;
            if (context != null) {
              // ignore: use_build_context_synchronously
              MyUtils.jumpLogin(context);
            }
            break;
          default:
            final msg = bean.msg;
            if (msg != null && msg.isNotEmpty) {
              MyToastUtils.showToastBottom(msg);
            }
        }
      } catch (e) {
        Get.log(e.toString());
      } finally {
        Loading.dismiss();
      }
    });
  }

  final returnList = List<WealthDayReturnBeanData>.empty().obs;
  void doPostDayReturnList() async {
    try {
        WealthDayReturnBean bean = await DataUtils.postDayReturnList();
        switch (bean.code) {
          case MyHttpConfig.successCode:
            returnList.value = bean.data;
            break;
          case MyHttpConfig.errorloginCode:
            final context = Get.context;
            if (context != null) {
              // ignore: use_build_context_synchronously
              MyUtils.jumpLogin(context);
            }
            break;
          default:
            final msg = bean.msg;
            if (msg.isNotEmpty) {
              MyToastUtils.showToastBottom(msg);
            }
        }
      } catch (e) {
        Get.log(e.toString());
      }
  }
}
