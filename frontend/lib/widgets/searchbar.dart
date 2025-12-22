import 'package:kasir/themes/app_textstyle.dart';
import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry padding;

  const Searchbar({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = 'Cari...',
    this.suffixIcon,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyle.withColor(
          AppTextStyle.buttonMedium,
          Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyle.withColor(
            AppTextStyle.buttonMedium,
            isDark ? Colors.grey[400]! : Colors.grey[600]!,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.grey[400]! : Colors.grey[600]!,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
