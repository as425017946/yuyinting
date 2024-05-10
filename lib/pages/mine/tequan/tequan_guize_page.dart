import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../utils/widget_utils.dart';

/// 贵族规则说明
class TeQuanGuiZePage extends StatefulWidget {
  const TeQuanGuiZePage({super.key});

  @override
  State<TeQuanGuiZePage> createState() => _TeQuanGuiZePageState();
}

class _TeQuanGuiZePageState extends State<TeQuanGuiZePage> {
  var appBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('规则说明', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            WidgetUtils.onlyTextGZ(
                '什么是贵族?',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '贵族是平台的特殊身份，身份类型包括:玄仙，上仙，金仙，仙帝，主神，天神，神王，神皇，天尊，传说。获得贵族身份后即可享用贵族专属特权。',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '如何成为贵族?',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '赠送经典、礼盒或贵族礼物(不包括背包礼物)可以获得贵族值，1 金豆 =1贵族值，贵族值在30天内累计，贵族值达到对应贵族等级要求即可成为玄仙，上仙，金仙，仙帝，主神，天神，神王。神皇，天尊，传说只能通过进阶活动获得。',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '贵族的升级/保级/降级',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '贵族有效期:自获得贵族等级起算30天有效期，有效期内可享用贵族特权，可升级贵族身份，有效期结束将不可使用特权，并自动进行保级或降级。保级值:赠送1经典、礼盒或贵族礼物(不包括背包礼物)可获得保级值,1金豆=1保级值，保级值用于贵族身份保级和降级的判断。',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '#升级:',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '30天内，玩家的贵族值达到其他等级的贵族值，则贵族等级升级，获得该等级对应的专属特权，30天周期重新计算;',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '#保级:',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '30 天后，玩家达到目前贵族等级的保级值，即可在接下来的30天周期内保持该等级，继续享用该等级的专属特权;',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '#降级:',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '30 天后，玩家的保级值低于目前等级的保级值，则根据玩家获得的保级值降级到贵族等级对应保级值要求的等级，获得降级后等级的专属特权，30天周期重新计算;',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.onlyTextGZ(
                '*保级值在升级/保级/降级后将置零。',
                StyleUtils.getCommonGZTextStyle(
                    color: MyColors.a5, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.onlyTextGZ(
                '*贵族值在保级/降级后将降至该贵族等级对应的初始贵族值',
                StyleUtils.getCommonGZTextStyle(
                    color: MyColors.a5, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((20 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_1.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '#举例:',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '1月1号玩家的贵族值达到22W，则获得神王身份和对应特权。①若玩家在1月31号前贵族值达到50W，则立即获得神皇身份和对应特权，此时保级值置零，30天有效期重置。②若玩家在1月31号前没有升级，但保级值达到神王的保级值6W，则在31号之后可继续保持神王身份和特权30天，此时保级值置零，贵族值降至20W。③若玩家在1月31号保级值为3000,则在31号后,身份降至玄仙，此时保级值置零，贵族值降至5000，30天有效期重置。',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_2.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '一.贵族勋章',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '专属贵族勋章，凸显尊贵身份，个人主页、个人名片页、房间公屏消息对应贵族专属勋章',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_3.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '二.特权礼物',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '贵族特权专属礼物，最豪华的礼物送给最心爱的TA',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_4.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '三.专属进场横幅',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '更高的贵族等级，更炫的进场横幅动画，展示您独一无二的尊享身份',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_5.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '四.限定表情包',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '解锁限定可爱表情，彰显您的无二个性',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_6.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '五.全服广播',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '当您达成高等级贵族，全服飘屏横幅让所有人瞩目您的荣耀时刻',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_7.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '六.特权公屏气泡',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '公屏发言将直接展示专属公聊皮肤',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_8.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '七.奢华名片栏',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '装饰您房间内的个人名片页，展现贵族的豪迈姿态',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_9.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '八.炫彩麦位昵称',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '昵称颜色将替换为独特的麦位昵称颜色，让您成为人群中的焦点',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_10.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '九.好友红名',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '您的名字在消息的各个列表突出展示，凸显您的与众不同',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_11.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '十.专属座驾',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '解锁平台限定专享座驾，光芒四射的进场特效',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_12.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '十一.专属客服',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '24H 专属一对一客服随时为您服务，让您拥有最贴心的私人助理',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_13.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '十二.隐身进房',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '获得后，在[我的]页面可开启/关闭进厅隐身。开启后，进所有房间时隐藏进房公屏信息、座驾、进厅横幅以及跟随进入信息',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_14.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '十三.房间防踢防禁言',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '获得特权后，房间内的会长、厅主及管理均无法将您踢出房间和无法禁言',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_15.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '十四.防开/关/上/下麦',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '获得特权后，房间内的会长、厅主及管理均无法将您上麦、下麦和开麦、闭麦',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_16.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '十五.至尊靓号ID',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            WidgetUtils.onlyTextGZ(
                '定制您的专属靓号ID，成为全服最闪耀的星，达成成就联系您的专属客服完成私人订制',
                StyleUtils.getCommonGZTextStyle(
                    color: Colors.black, fontSize: 26.sp, height: 1.5)),
            WidgetUtils.commonSizedBox((10 * 1.25).w, 0),
            const Image(image: AssetImage('assets/images/tequan_sm_17.png')),
            WidgetUtils.commonSizedBox((40 * 1.25).w, 0),
          ],
        ),
      ),
    );
  }
}
