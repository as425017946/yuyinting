import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../colors/my_colors.dart';

mixin GetAntiCombo {
  // final Rx<int> _action = 0.obs;
  // Worker? _worker;

  // void action(void Function() a) {
  //   if (_worker == null) {
  //     done() {
  //       _worker?.dispose();
  //       _worker = null;
  //       _action.value = 0;
  //     }

  //     _worker = interval(_action, (_) => done(), onError: () => done());
  //     a();
  //   }
  //   _action.value++;
  // }

  bool _canTapAction = true;
  void action(void Function() a) {
    if (_canTapAction) {
      _canTapAction = false;
      Future.delayed(const Duration(seconds: 1), () => _canTapAction = true);
      a();
    }
  }
}

String charmLevelIcon(int level) {
  if (level <= 10) {
    return '1-10';
  } else if (level <= 15) {
    return '11-15';
  } else if (level <= 20) {
    return '16-20';
  } else if (level <= 25) {
    return '21-25';
  } else if (level <= 30) {
    return '26-30';
  } else if (level <= 35) {
    return '31-35';
  } else if (level <= 40) {
    return '36-40';
  } else if (level <= 45) {
    return '41-45';
  } else {
    return '46-50';
  }
}

int wealthLevelIcon(int level) {
  if (level <= 9) {
    return 1;
  } else if (level <= 15) {
    return 2;
  } else if (level <= 23) {
    return 3;
  } else if (level <= 31) {
    return 4;
  } else if (level <= 36) {
    return 5;
  } else if (level <= 40) {
    return 6;
  } else if (level <= 46) {
    return 7;
  } else {
    return 8;
  }
}

class CharmLevelFlag extends StatelessWidget {
  final int level;
  final double? width;
  final double? height;
  const CharmLevelFlag({super.key, required this.level, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    if (level == 0) {
      return SizedBox(
        width: width,
        height: height,
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 100,
          height: 40,
          child: Stack(
            children: [
              Image(
                image: AssetImage('assets/images/dj/dj_c_${charmLevelIcon(level)}.png'),
                fit: BoxFit.fill,
              ),
              Positioned(
                left: 55,
                child: Stack(
                  children: [
                    Text(
                      level.toString(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = MyColors.djTwoM,
                      ),
                    ),
                    Text(
                      level.toString(),
                      style: const TextStyle(
                        color: MyColors.djOne,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CharmLevelTag extends StatelessWidget with _Tag {
  final int level;
  final double? width;
  final double? height;
  final double scale;
  const CharmLevelTag({super.key, required this.level, this.width, this.height, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    final img = 'assets/images/dj/dj_${charmLevelIcon(level)}.png';
    return tag(img, level, width, height, scale);
  }
}

class WealthLevelTag extends StatelessWidget with _Tag {
  final int level;
  final double? width;
  final double? height;
  final double scale;
  const WealthLevelTag({super.key, required this.level, this.width, this.height, this.scale = 1.3});

  @override
  Widget build(BuildContext context) {
    final img = 'assets/images/bigclient_icon_${wealthLevelIcon(level)}.png';
    return tag(img, level, width, height, scale);
  }
}

mixin _Tag {
  Widget tag(String img, int level, double? width, double? height, double scale) {
    if (level == 0) {
      return SizedBox(
        width: width,
        height: height,
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 35,
          height: 35,
          child: Stack(
            children: [
              Transform.scale(
                scale: scale,
                child: Image(
                  image: AssetImage(img),
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Stack(
                  children: [
                    Text(
                      level.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = MyColors.djTwoM,
                      ),
                    ),
                    Text(
                      level.toString(),
                      style: const TextStyle(
                        color: MyColors.djOne,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'LR',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}