import 'package:flutter/material.dart';

class StatusButton extends StatelessWidget {
  final String status;

  const StatusButton({Key? key, required this.status}) : super(key: key);

  Color _getBackgroundColor() {
    switch (status.toLowerCase()) {
      case 'habis':
        return Colors.red;
      case 'nonaktif':
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  String _getText() {
    switch (status.toLowerCase()) {
      case 'habis':
        return 'Habis';
      case 'nonaktif':
        return 'Nonaktif';
      default:
        return 'Tersedia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final text = _getText();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
