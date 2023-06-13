import 'dart:async';

import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  // final List<String> images;
  // final double height;
  const ImageCarousel({Key? key}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel>  with SingleTickerProviderStateMixin{

  //动画控制器
  late AnimationController controller;
  late Animation<Offset> animation ;


  late PageController _controller;
  int _currentPage = 0;
  late Timer _timer;
  List<String> imagesa = [
    "assets/images/saiche/road.jpg",
    "assets/images/saiche/road.jpg"
  ];



  @override
  void initState() {
    super.initState();
    //duration 动画的时长，这里设置的 seconds: 2 为2秒，当然也可以设置毫秒 milliseconds：2000.
    controller =
        AnimationController(duration: const Duration(seconds: 10), vsync: this);
    animation =
        Tween(begin: Offset.zero, end: Offset(5, 0)).animate(controller);

    controller.forward();


    _controller = PageController(
      initialPage: imagesa.length * 100,
    )..addListener(_onPageChanged);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_controller.page!.round() >= 2) {
        _controller.jumpToPage(0);
      }
      _controller.nextPage(
          duration: Duration(seconds: 1), curve: Curves.linear);
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    int newIndex = _controller.page!.round() % imagesa.length;
    if (newIndex != _currentPage) {
      setState(() {
        _currentPage = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      final imageIndex = index % imagesa.length;
                      return Image.asset(
                        imagesa[imageIndex],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.fitHeight,
                      );
                    },
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                        width: 50,
                      ),
                      SlideTransition(
                        position: animation,
                        child: Image.asset(
                          'assets/images/saiche/car1.png',
                          width: 50,
                          height: 25,
                        ),
                      ),
                      Image.asset(
                        'assets/images/saiche/car2.png',
                        width: 50,
                        height: 25,
                      ),
                      Image.asset(
                        'assets/images/saiche/car3.png',
                        width: 50,
                        height: 25,
                      ),
                      Image.asset(
                        'assets/images/saiche/car4.png',
                        width: 50,
                        height: 25,
                      ),
                      Image.asset(
                        'assets/images/saiche/car5.png',
                        width: 50,
                        height: 25,
                      ),
                      Image.asset(
                        'assets/images/saiche/car6.png',
                        width: 50,
                        height: 25,
                      ),
                      Image.asset(
                        'assets/images/saiche/car7.png',
                        width: 50,
                        height: 25,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
