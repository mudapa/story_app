import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/helper.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final TextStyle? style;
  final Color color;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    required this.color,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 8.h,
        ),
        width: width ?? 1.sw,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: style,
          ),
        ),
      ),
    );
  }
}
