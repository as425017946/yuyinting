import 'dart:math';

extension RoomPkImageName on String {
  String get pkSvga => 'assets/跨房PK/$this.svga';
  String get pkIcon => 'assets/跨房PK/icon/$this.png';
  String get pkGifSuccess => 'assets/跨房PK/胜利表情包/$this.gif';
  String get pkGifFailure => 'assets/跨房PK/失败者表情/$this.gif';
}

class RoomPkGif {
  static String get success => _success[Random().nextInt(_success.length)].pkGifSuccess;
  static final List<String> _success = [
    '01d2bf62284fc111013f01cd10ed5b',
    '01ed8162284fc211013f01cd728979',
    '014ebd62284fc211013e8cd0ede369',
    '01326862284fca11013f01cdb39cbc',
  ];
  
  static String get failure => _failure[Random().nextInt(_failure.length)].pkGifFailure;
  static final List<String> _failure = [
    '01b6365e0b5fc5a801216518e0d30d',
    '012e2c5e0b5fdca80120a8954e364e',
    '017de25e0b5fcfa801216518340e4c',
    '0191de5e0b5fa8a8012165183e1a93',
  ];
}

class RoomPkManager {
  
}