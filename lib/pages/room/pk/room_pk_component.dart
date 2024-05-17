import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'room_pk_manager.dart';

class RoomPkChaoFengPage extends StatelessWidget {
  const RoomPkChaoFengPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 646.w,
        height: 782.w,
        padding: EdgeInsets.all(58.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('pk_ridicule_bg'.pkIcon),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '消耗500钻可向对方房间发起嘲讽60秒并增加我方500PK值，且我方房间本场PK发起嘲讽达10次，可扣除对方本场100PK值',
              style: TextStyle(
                fontSize: 25.5.sp,
                color: Colors.white,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 58.w),
            _btn(),
          ],
        ),
      ),
    );
  }

  Widget _btn() {
    final RoomPKController c = Get.find();
    return GestureDetector(
      onTap: () => c.action(() {
        Get.back(result: true);
      }),
      child: Container(
        width: 303.w,
        height: 81.w,
        padding: EdgeInsets.only(top: 10.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('pk_bg_btn'.pkIcon),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '发起嘲讽',
              style: TextStyle(
                fontSize: 30.w,
                color: Colors.white,
                height: 1,
              ),
            ),
            Text(
              '500钻石',
              style: TextStyle(
                fontSize: 18.w,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomPkPiPeiPage extends StatelessWidget {
  const RoomPkPiPeiPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 856.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('pk_match_bg2'.pkIcon),
        ),
      ),
    );
  }
  
}