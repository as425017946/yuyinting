import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PagePreviewVideo extends StatefulWidget {
  final String url;
  const PagePreviewVideo({Key? key, required this.url}) : super(key: key);

  @override
  _PagePreviewVideoState createState() => _PagePreviewVideoState();
}

class _PagePreviewVideoState extends State<PagePreviewVideo> {
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _videoPlayerController!.play();
        setState(() {});
      });

    _videoPlayerController!.addListener(() {
      setState(() {
        _isPlaying = _videoPlayerController!.value.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _videoPlayerController!.value.isInitialized
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (_isPlaying) {
                    _videoPlayerController!.pause();
                  }
                },
                child: Container(
                  constraints:
                  const BoxConstraints(maxWidth: 0.85 * 1334),
                  child: AspectRatio(
                    aspectRatio:
                    _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor:
                  Colors.white.withOpacity(0.5), //进度条滑块左边颜色
                  inactiveTrackColor:
                  Colors.white.withOpacity(0.2), //进度条滑块右边颜色
                  thumbColor: Colors.transparent, //滑块颜色
                  overlayColor: Colors.transparent, //滑块拖拽时外圈的颜色
                  trackHeight: 4, //进度条宽度
                  // trackShape: RoundSliderTrackShape(
                  //     radius: 10), //进度条形状,这边自定义两头显示圆角
                ),
                child: Slider(
                  max: _videoPlayerController!
                      .value.duration.inMilliseconds
                      .truncateToDouble(),
                  value: _videoPlayerController!
                      .value.position.inMilliseconds
                      .truncateToDouble(),
                  // activeColor: Colors.white.withOpacity(0.5),
                  // inactiveColor: Colors.black.withOpacity(0.5),
                  onChanged: (double value) {
                    _videoPlayerController!.seekTo(
                      Duration(
                        milliseconds: value.truncate(),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
              : Center(
            child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation(Colors.white.withOpacity(0.7)),
              backgroundColor: Colors.white.withOpacity(0.4),
            ),
          ),
          Positioned(
            left: 30,
            top: 40,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.cancel,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          if (_videoPlayerController!.value.isInitialized && !_isPlaying)
            Center(
              child: GestureDetector(
                onTap: () {
                  _videoPlayerController!.play();
                },
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill_outlined,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}