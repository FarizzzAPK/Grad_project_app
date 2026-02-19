import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  final String hintText;
  final Widget icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 18,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 12),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        prefixIcon: icon,
        prefixIconColor: Colors.white30,
        hint: CustomText(text: hintText, color: Colors.white30),
        fillColor: const Color(0xff172133),
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xff304369)),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xff304369)),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xff304369)),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
