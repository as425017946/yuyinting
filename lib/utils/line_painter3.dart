
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinePainter3 extends CustomPainter {
  Color colors ;
  LinePainter3({required this.colors});
  //定义画笔
  late final Paint _paint = Paint()
    ..color = colors
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle
        .fill; //画笔样式有填充PaintingStyle.fill 及没有填充PaintingStyle.stroke 两种

  void paint(Canvas canvas, Size size) {
    //绘制圆 参数为中心点 半径 画笔
    canvas.drawCircle(const Offset(20,20), 10, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}