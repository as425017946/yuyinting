import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

extension SvgaTools on MovieEntity {

  Future<void> hfItem(String img, String name, String svgaName) async {
    // await dynamicItem.setImageWithUrl(img, '03');
    dynamicItem.setHidden(true, '04');
    // const AssetImage('assets/images/empty.png')
    final image = await _drawNetCircleImage(img);
    dynamicItem.setImage(image, '03');
    // dynamicItem.setDynamicDrawer((canvas, frameIndex) {
    //   canvas.clipPath(Path()..addOval(Rect.fromCircle(center: const Offset(30, 30), radius: 30)));
    //   final size = min(image.width, image.height).toDouble();
    //   canvas.drawImageRect(image, Rect.fromLTWH((image.width - size)/2, (image.height - size)/2, size, size), const Rect.fromLTWH(0, 0, 60, 60), Paint());
    // }, '03');
    switch (svgaName) {
      case '龙年':
        dynamicItem.setDynamicDrawer((canvas, frameIndex) {
          const size = 25.0;
          const height = 37.0/size;
          final textPainter = TextPainter(
            text: TextSpan(
              text: name, 
              style: const TextStyle(fontSize: size, color: Colors.yellow, height: height),
              children: const [
                 TextSpan(text: ' 进入聊天室', style: TextStyle(fontSize: size, color: Colors.white, height: height)),
              ]
            ),
            textDirection: TextDirection.ltr,
            maxLines: 1,
          )..layout(maxWidth: 192);
          textPainter.paint(canvas, const Offset(15, 0));
        }, '02');
        break;
      default:
        dynamicItem.setDynamicDrawer((canvas, frameIndex) {
          const size = 25.0;
          const height = 30.0/size;
          final textPainter = TextPainter(
            text: TextSpan(text: name, style: const TextStyle(fontSize: size, color: Colors.yellow, height: height)),
            textDirection: TextDirection.ltr,
            maxLines: 1,
          )..layout(maxWidth: 192);
          textPainter.paint(canvas, const Offset(15, 0));
        }, '01');
        dynamicItem.setDynamicDrawer((canvas, frameIndex) {
          const size = 20.0;
          const height = 30.0/size;
          final textPainter = TextPainter(
            text: const TextSpan(text: '进入聊天室', style: TextStyle(fontSize: size, color: Colors.white, height: height)),
            textDirection: TextDirection.ltr,
            maxLines: 1,
          )..layout(maxWidth: 192);
          textPainter.paint(canvas, const Offset(15, 0));
        }, '02');
    }
  }

  Future<ui.Image> _getNetImage(String url, {width, height}) async {
    ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<ui.Image> _drawNetCircleImage(String url) async {
    ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();

    final image = fi.image;
    final size = min(image.width, image.height).toDouble();

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final radius = size/2.0;
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset(radius, radius), radius: radius)));
    canvas.drawImageRect(image, Rect.fromLTWH((image.width - size)/2, (image.height - size)/2, size, size), Rect.fromLTWH(0, 0, size, size), Paint());

    final ui.Picture picture = recorder.endRecording();
    final int imgSize = size.toInt();
    return await picture.toImage(imgSize, imgSize);
  }
}