
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

extension SvgaTools on MovieEntity {

  Future<void> hfItem(String img, String name) async {
    await dynamicItem.setImageWithUrl(img, '03');
    dynamicItem.setDynamicDrawer((canvas, frameIndex) {
      final textPainter = TextPainter(
        text: TextSpan(text: name, style: const TextStyle(fontSize: 30, color: Colors.yellow)),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: 192);
      textPainter.paint(canvas, const Offset(15, -2.5));
    }, '01');
    dynamicItem.setDynamicDrawer((canvas, frameIndex) {
      final textPainter = TextPainter(
        text: const TextSpan(text: '进来了', style: TextStyle(fontSize: 20, color: Colors.white)),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: 192);
      textPainter.paint(canvas, const Offset(15, 0));
    }, '02');
  }
}