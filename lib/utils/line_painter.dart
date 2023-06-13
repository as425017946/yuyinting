
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  Color colors ;
  LinePainter({required this.colors});
  //定义画笔
  late final Paint _paint = Paint()
    ..color = colors
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..style = PaintingStyle
        .fill; //画笔样式有填充PaintingStyle.fill 及没有填充PaintingStyle.stroke 两种

  void paint(Canvas canvas, Size size) {
    //绘制圆 参数为中心点 半径 画笔
    canvas.drawCircle(const Offset(2,2), 4, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}