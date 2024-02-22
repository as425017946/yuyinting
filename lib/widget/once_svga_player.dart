import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:svgaplayer_flutter/proto/svga.pb.dart';

class OnceSvgAPlayer extends StatefulWidget {
  const OnceSvgAPlayer(
      {
        super.key,
        this.resUrl,
        this.assetsName,
        this.repeatAgain = false,
        this.backgroundUrl,
        this.callback,
      });
  final String? resUrl;
  final String? assetsName;
  final bool repeatAgain;
  final String? backgroundUrl;
  final Function? callback;

  @override
  State<StatefulWidget> createState() => OnceSvgAPlayerState();
}

class OnceSvgAPlayerState extends State<OnceSvgAPlayer>
    with TickerProviderStateMixin {
  SVGAAnimationController? animationController;
  Future<MovieEntity>? decode;

  @override
  void initState() {
    super.initState();
    animationController = SVGAAnimationController(vsync: this);
    animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.callback != null) {
          widget.callback!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.resUrl != null) {
      decode = SVGAParser.shared.decodeFromURL(widget.resUrl!);
    } else if (widget.assetsName != null) {
      decode = SVGAParser.shared.decodeFromAssets(widget.assetsName!);
    }
    decode?.then((value) {
      if (mounted && animationController != null) {
        animationController!
          ..videoItem = value
          ..reset()
          ..forward();
      }
    });
    if (animationController == null) {
      return Container();
    }
    return SVGAImage(
      animationController!,
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}
