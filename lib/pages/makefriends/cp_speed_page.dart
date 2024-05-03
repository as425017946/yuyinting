import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'makefriends_model.dart';

class CPSpeedPage extends StatelessWidget {
  final MakefriendsController c = Get.find();
  CPSpeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 35),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/cp_bj.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          _nav(),
        ],
      ),
    );
  }

  Widget _nav() {
    return Container(
      height: 60.w,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 44.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => c.select = 0,
            child: Text(
              'CP速配',
              style: TextStyle(
                color: const Color(0xFFCFD9FF),
                fontSize: 33.sp,
                fontFamily: 'LR',
              ),
            ),
          ),
          SizedBox(width: 44.w),
          Text(
            '告白纸条',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.sp,
              fontFamily: 'LR',
            ),
          ),
        ],
      ),
    );
  }
}