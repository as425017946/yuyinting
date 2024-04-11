import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CeShiPage extends StatefulWidget {
  const CeShiPage({super.key});

  @override
  State<CeShiPage> createState() => _CeShiPageState();
}

class _CeShiPageState extends State<CeShiPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              constraints: BoxConstraints(maxWidth: double.infinity - 130.w),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    centerSlice: Rect.fromLTWH(13, 20, 1, 1),
                    image: AssetImage('assets/images/cj/chat_text.png'),
                    scale: 2,
                  )
              ),
              child: const Text('测试一下测试测试'),
            )
          ],
        ),
      );
  }
}
