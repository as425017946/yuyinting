import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 游戏规则说明
class CarGuiZeHPage extends StatefulWidget {
  const CarGuiZeHPage({super.key});

  @override
  State<CarGuiZeHPage> createState() => _CarGuiZeHPageState();
}

class _CarGuiZeHPageState extends State<CarGuiZeHPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Row(
        children: [
          const Spacer(),
          Opacity(
            opacity: 0,
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: WidgetUtils.showImages(
                  'assets/images/car/car_guanbi.png', 35, 35),
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: Container(
                    color: Colors.transparent,
                  )),
              Container(
                height: 310,
                width: 355,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage('assets/images/car_guize.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(15, 0),
                      Container(
                        alignment: Alignment.center,
                        child: WidgetUtils.showImages(
                            'assets/images/car_huodong.png', 20, 200),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      Padding(
                        padding: EdgeInsets.only(left:20.h, right: 20.h),
                        child: const Text(
                          '1.马里奥总动员为7条赛道的竞速游戏，每条赛道获胜概率均为(1/7)*100%，每轮比赛随机人物获胜。\n\n'
                              '2.本游戏可用金蘑菇/V豆/钻石参与，货币自动付款顺序为金蘑菇充足时先行消耗金蘑菇，不够时消耗V豆，最后消耗钻石。'
                              '比赛获胜后，获得相应数量的金蘑菇/钻石奖励。（价值：1金蘑菇=1 V豆=1钻石）。金蘑菇可在游戏页面的[商店]兑换背包礼物。\n\n'
                              '3.每次比赛，用户可选择任意单赛道或多赛道区竞猜，已选择的赛道区可通过多次点击增加参与数量。\n'
                              '1）单赛道区：选择1个人物的赛道竞猜，该赛道人物获胜后，用户获得参与数量6倍的金蘑菇/钻石奖励。\n'
                              '2）双赛道区：选择2个人物的赛道竞猜，其中任意赛道人物获胜后，用户获得参与数量3倍的金蘑菇/钻石奖励。\n'
                              '3）三赛道区：选择3个人物的赛道竞猜，其中任意赛道人物获胜后，用户获得竞猜数量2倍的金蘑菇/钻石奖励。\n'
                              '4）幸运七玩法：7号白灵所在的赛道为幸运赛道，当白灵赢得冠军时，猜中的用户将赢得16倍奖励，并且平台将返还本局竞猜失败用户的所有参与金额！\n\n'
                              '4.选择赛道竞猜后，将无法取消！\n'
                              '注意事项：\n'
                              '通过马里奥总动员获得的货币，不可兑换成现金，本平台严禁主播或用户私下交易，违规主播将按照平台规则严肃处理，请用户谨防上当受骗。',
                          maxLines: 50,
                          style: TextStyle(
                            fontSize: 10,
                            color: MyColors.g3,
                            height: 1.5,
                          ),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      Padding(
                        padding: EdgeInsets.only(left:20.h, right: 20.h),
                        child: const Text(
                          '一娱乐有风险，参与需谨慎一',
                          maxLines: 50,
                          style: TextStyle(
                            fontSize: 10,
                            color: MyColors.g3,
                            height: 1.5,
                          ),
                        ),
                      ),
                      WidgetUtils.commonSizedBox(20, 0),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                    color: Colors.transparent,
                  )),
            ],
          ),
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              height: double.infinity,
              width: 35,
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 20),
              child: WidgetUtils.showImages(
                  'assets/images/car/car_guanbi.png', 35, 35),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
