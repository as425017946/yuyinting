import 'package:flutter/services.dart';

class RegexFormatter extends TextInputFormatter {
  RegexFormatter({required this.regex});

  /// 需要匹配的正则表达
  final String regex;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return TextEditingValue.empty;
    }

    if (!RegExp(regex).hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}