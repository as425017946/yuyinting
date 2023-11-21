import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';
/// 5万2特效
class QPPage extends StatefulWidget {
  const QPPage({super.key});

  @override
  State<QPPage> createState() => _QPPageState();
}

class _QPPageState extends State<QPPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SVGASimpleImage(assetsName: 'assets/svga/gp/gp_52.svga',),
    );
  }
}
