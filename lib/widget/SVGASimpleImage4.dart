import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../utils/event_utils.dart';

class SVGASimpleImage4 extends StatefulWidget {
  final String? resUrl;
  final String? assetsName;

  const SVGASimpleImage4({Key? key, this.resUrl, this.assetsName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SVGASimpleImage4State();
  }
}

class _SVGASimpleImage4State extends State<SVGASimpleImage4>
    with SingleTickerProviderStateMixin {
  SVGAAnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = SVGAAnimationController(vsync: this);
    animationController!.addListener(() {
      if(animationController!.isCompleted){
        eventBus.fire(ResidentBack(isBack: true));
      }
    });
    _tryDecodeSvga();
  }

  @override
  void didUpdateWidget(covariant SVGASimpleImage4 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resUrl != widget.resUrl ||
        oldWidget.assetsName != widget.assetsName) {
      _tryDecodeSvga();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (animationController == null) {
      return Container();
    }
    return SVGAImage(
      animationController!,
      fit: BoxFit.fill,
      preferredSize: const Size(double.infinity, double.infinity),
      allowDrawingOverflow: false,
      clearsAfterStop: false,
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    animationController = null;
    super.dispose();
  }

  void _tryDecodeSvga() {
    Future<MovieEntity> decode;
    if (widget.resUrl != null) {
      decode = SVGAParser.shared.decodeFromURL(widget.resUrl!);
    } else if (widget.assetsName != null) {
      decode = SVGAParser.shared.decodeFromAssets(widget.assetsName!);
    } else {
      return;
    }
    decode.then((videoItem) {
      if (mounted && animationController != null) {
        animationController!
          ..videoItem = videoItem
          ..repeat();
      } else {
        videoItem.dispose();
      }
    }).catchError((e, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stack,
        library: 'svga library',
        informationCollector: () => [
          if (widget.resUrl != null) StringProperty('resUrl', widget.resUrl),
          if (widget.assetsName != null)
            StringProperty('assetsName', widget.assetsName),
        ],
      ));
    });
  }
}
