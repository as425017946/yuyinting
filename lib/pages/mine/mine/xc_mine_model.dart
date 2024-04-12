import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/myInfoBean.dart';
import '../../../bean/wealth_info_bean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/getx_tools.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';

class XCMineController extends GetxController with GetAntiCombo {
  final controller = RefreshController(initialRefresh: false, initialRefreshStatus: RefreshStatus.idle);
  /// 头像
  final userHeadImg = sp.getString('user_headimg').toString().obs;
  /// 昵称
  final nickname = sp.getString('nickname').toString().obs;
  /// ID
  final userNumber = ''.obs;
  /// 静态头像框
  final avatarFrameImg = ''.obs;
  /// 动态头像框
  final avatarFrameGifImg = ''.obs;
  /// 关注
  final care = ''.obs;
  /// 被关注
  final beCare = ''.obs;
  /// 看过我
  final lookMe = ''.obs;
  /// 是否开通贵族
  final isGuizu = false.obs;
  /// 身份
  final identity = ''.obs;
  /// 是否有代理权限 0无1有
  final isAgent = false.obs;
  /// 是否萌新
  final isNew = false.obs;
  /// 是否新贵
  final isNewNoble = false.obs;
  /// 是否靓号
  final isPretty = false.obs;
  ///用户等级
  final level = (sp.getInt("user_level") ?? 0).obs;
  final grLevel = (sp.getInt("user_grLevel") ?? 0).obs;
  /// 是否有入住审核信息
  final isShenHe = false.obs;
  /// 勿扰模式
  final switchValue = false.obs;
  // 客服
  String kefuUid = '';
  String kefuAvatar = '';

  Future<void> doPostMyIfon(BuildContext context) async {
    var isLoading = false;
    if (userNumber.value.isEmpty) {
      isLoading = true;
      Loading.show();
    }
    try {
      MyInfoBean bean = await DataUtils.postMyIfon();
      switch (bean.code) {
        case MyHttpConfig.successCode:
        final data = bean.data!;
            sp.setString('shimingzhi', data.auditStatus.toString());
            userHeadImg.value = data.avatar!;
            sp.setString("user_headimg", data.avatar!);
            sp.setInt("user_gender", data.gender!);
            nickname.value = data.nickname!;
            sp.setString("nickname", data.nickname!);
            sp.setString('user_id', data.uid.toString());
            sp.setString('user_phone', data.phone!);
            sp.setInt("user_level", bean.data!.level as int);
            sp.setInt("user_grLevel", bean.data!.grLevel as int);
            care.value = data.followNum.toString();
            beCare.value = data.isFollowNum.toString();
            lookMe.value = data.lookNum.toString();
            isGuizu.value = data.nobleId == 1;
            identity.value = data.identity!;
            isAgent.value = data.isAgent == 1;
            isNew.value = data.isNew == 1;
            isNewNoble.value = data.newNoble == 1;
            isPretty.value = data.isPretty == 1;
            // 如果身份变了
            if (sp.getString('user_identity').toString() != identity.value) {
              eventBus.fire(SubmitButtonBack(title: '更换了身份'));
              sp.setString('user_identity', identity.value);
            }
            // 等级变了
            if (bean.data!.level! >= 3) {
              eventBus.fire(SubmitButtonBack(title: '等级大于3级'));
            }
            // 等级变了
            if (bean.data!.grLevel! >= 3) {
              eventBus.fire(SubmitButtonBack(title: '财富等级大于3级'));
            }
            if (data.avatarFrameGifImg == null || data.avatarFrameGifImg!.isEmpty) {
              avatarFrameGifImg.value = '';
              avatarFrameImg.value = data.avatarFrameImg ?? '';
            } else {
              avatarFrameGifImg.value = data.avatarFrameGifImg ?? '';
              avatarFrameImg.value = '';
            }
            level.value = data.level as int;
            grLevel.value = data.grLevel as int;
            if (identity.value == 'leader' && data.unauditNum != 0) {
              isShenHe.value = true;
            } else {
              isShenHe.value = false;
            }
            kefuUid = data.kefuUid.toString();
            kefuAvatar = data.kefuAvatar!;
            switchValue.value = data.isDisturb != 0;
            userNumber.value = data.number.toString();
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      LogE(e.toString());
    } finally {
      if (isLoading) {
        Loading.dismiss();
      }
      controller.refreshCompleted();
    }
  }

  void onSwitch(BuildContext context) {
    switchValue.value = !switchValue.value;
    doPostSetDisturb(switchValue.value ? '1' : '0', context);
  }
  /// 勿扰模式
  Future<void> doPostSetDisturb(String isDisturb, BuildContext context) async {
    Map<String, dynamic> params = <String, dynamic>{
      'is_disturb': isDisturb,
    };
    try {
      CommonBean bean = await DataUtils.postSetDisturb(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (isDisturb == "0") {
            MyToastUtils.showToastBottom('勿扰模式已关闭');
          } else {
            MyToastUtils.showToastBottom('勿扰模式已开启，您现在只可收到互关用户消息');
          }
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      LogE(e.toString());
    }
  }

  void toBigclient() {
    action(() async {
      Loading.show();
      try {
        WealthInfoBean bean = await DataUtils.postWealthInfo();
        switch (bean.code) {
          case MyHttpConfig.successCode:
            final data = bean.data;
            if (data != null) {
              Get.toNamed('BigClientPage', arguments: data);
            }
            break;
          case MyHttpConfig.errorloginCode:
            final context = Get.context;
            if (context != null) {
              // ignore: use_build_context_synchronously
              MyUtils.jumpLogin(context);
            }
            break;
          default:
            MyToastUtils.showToastBottom(bean.msg);
        }
      } catch (e) {
        LogE(e.toString());
      } finally {
        Loading.dismiss();
      }
    });
  }
}