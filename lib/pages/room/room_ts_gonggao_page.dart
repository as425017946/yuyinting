import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
/// 房间内弹窗公告
class RoomTSGongGaoPage extends StatefulWidget {
  const RoomTSGongGaoPage({super.key});

  @override
  State<RoomTSGongGaoPage> createState() => _RoomTSGongGaoPageState();
}

class _RoomTSGongGaoPageState extends State<RoomTSGongGaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.all(10),
            height: ScreenUtil().setHeight(300),
            width: double.infinity,
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: Colors.blue,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Column(
              children: [
                WidgetUtils.onlyTextCenter('房间公告', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.bold)),
                WidgetUtils.commonSizedBox(5, 0),
                const Expanded(child: SingleChildScrollView(
                  child: Text(
                      '先帝创业未半而中道崩殂，今天下三分，益州疲弊，此诚危急存亡之秋也。然侍卫之臣不懈于内，忠志之士忘身于外者，盖追先帝之殊遇，欲报之于陛下也。诚宜开张圣听，以光先帝遗德，恢弘志士之气，不宜妄自菲薄，引喻失义，以塞忠谏之路也。宫中府中，俱为一体，陟罚臧否，不宜异同。若有作奸犯科及为忠善者，宜付有司论其刑赏，以昭陛下平明之理，不宜偏私，使内外异法也。侍中、侍郎郭攸之、费祎、董允等，此皆良实，志虑忠纯，是以先帝简拔以遗陛下。愚以为宫中之事，事无大小，悉以咨之，然后施行，必能裨补阙漏，有所广益。将军向宠，性行淑均，晓畅军事，试用于昔日，先帝称之曰能，是以众议举宠为督。愚以为营中之事，悉以咨之，必能使行阵和睦，优劣得所。亲贤臣，远小人，此先汉所以兴隆也；亲小人，远贤臣，此后汉所以倾颓也。先帝在时，每与臣论此事，未尝不叹息痛恨于桓、灵也。侍中、尚书、长史、参军，此悉贞良死节之臣，愿陛下亲之信之，则汉室之隆，可计日而待也。'
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
