import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';

class SVGASimpleImage2 extends StatefulWidget {
  final String? resUrl;
  final String? assetsName;
  final String? isOk;
  final int? index;
  const SVGASimpleImage2({Key? key, this.resUrl, this.assetsName, this.isOk, this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SVGASimpleImageState();
  }
}

class _SVGASimpleImageState extends State<SVGASimpleImage2>
    with SingleTickerProviderStateMixin {
  SVGAAnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = SVGAAnimationController(vsync: this);
    _tryDecodeSvga();
  }

  @override
  void didUpdateWidget(covariant SVGASimpleImage2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resUrl != widget.resUrl ||
        oldWidget.assetsName != widget.assetsName) {
      _tryDecodeSvga();
    }
  }

  @override
  Widget build(BuildContext context) {
    LogE('============');
    if (animationController == null) {
      return Container();
    }
    return SVGAImage(
      animationController!,
      fit: BoxFit.fitWidth,
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
        if(widget.isOk!.toString() == 'true'){
          animationController!
            ..videoItem = videoItem
            ..reset();
        }else{
          animationController!
            ..videoItem = videoItem
            ..forward();
        }
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
