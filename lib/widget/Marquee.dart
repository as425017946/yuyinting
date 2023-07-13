import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {
  const Marquee({required this.child, this.speed = 10, Key? key})
      : super(key: key);
  final Widget child;
  final int speed;

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late ScrollController _scrctrl;
  SingleChildScrollView? _scrollView;

  double _space = 0;

  @override
  void initState() {
    super.initState();

    _scrctrl = ScrollController();

    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.speed));
    _animation = Tween(
      begin: 0.1,
      end: 100.0,
    ).animate(_controller);
    _animation.addListener(() {
      if (_scrctrl.hasClients) {
        if (_scrollView != null && _scrctrl.position.hasContentDimensions) {
          var index = _animation.value / 100;
          _scrctrl.jumpTo(index * _scrctrl.position.maxScrollExtent);
        }
        if (_scrctrl.position.hasViewportDimension && _space == 0) {
          setState(() {
            _space = _scrctrl.position.viewportDimension;
          });
        }
      }
    });
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    _scrollView = SingleChildScrollView(
      controller: _scrctrl,
      scrollDirection: Axis.horizontal,
      child: _scrctrl.hasClients
          ? Row(
        children: [
          SizedBox(
            width: _space,
          ),
          widget.child,
          SizedBox(
            width: _space,
          ),
        ],
      )
          : const SizedBox(),
    );
    return _scrollView ?? Column();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

