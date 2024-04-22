import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

extension SvgaTools on MovieEntity {

  Future<void> hfItem(String img, String name) async {
    // await dynamicItem.setImageWithUrl(img, '03');
    final image = await _getNetImage(img);
    dynamicItem.setDynamicDrawer((canvas, frameIndex) {
      canvas.clipPath(Path()..addOval(Rect.fromCircle(center: const Offset(30, 30), radius: 30)));
      final size = min(image.width, image.height).toDouble();
      canvas.drawImageRect(image, Rect.fromLTWH((image.width - size)/2, (image.height - size)/2, size, size), const Rect.fromLTWH(0, 0, 60, 60), Paint());
    }, '03');
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

  Future<ui.Image> _getNetImage(String url, {width, height}) async {
    ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}