import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/helper.dart';
import '../../shared/style.dart';

class CustomForm extends StatelessWidget {
  final String text;
  final String? hint;
  final bool? obscureText;
  final TextEditingController controller;
  const CustomForm({
    super.key,
    required this.text,
    this.hint,
    this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
