import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'makefriends_model.dart';

class MakefriendsPage extends StatelessWidget {
  final MakefriendsController c = Get.put(MakefriendsController());
   MakefriendsPage( {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/all_bg.png"),
            fit: BoxFit.fill, 
          ),
        ),
    );
  }
}