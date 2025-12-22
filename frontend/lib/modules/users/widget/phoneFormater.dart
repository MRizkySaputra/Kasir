import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9+]'), '');

    // kalau cuma input "0" → hapus
    if (text == '0') {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // 08xxxx → +628xxxx
    if (text.startsWith('08')) {
      text = '+628${text.substring(2)}';
    }
    // 8xxxx → +628xxxx
    else if (text.startsWith('8')) {
      text = '+62$text';
    }
    // +8xxxx → +628xxxx
    else if (text.startsWith('+8')) {
      text = '+62${text.substring(1)}';
    }

    // pastikan selalu diawali +62
    if (!text.startsWith('+62') && text.isNotEmpty) {
      text = '+62${text.replaceAll('+', '')}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
