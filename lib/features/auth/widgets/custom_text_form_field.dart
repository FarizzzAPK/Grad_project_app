import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({super.key, required this.hintText, required this.icon});
  final String hintText;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: Colors.white
      ),
      decoration: InputDecoration(
        prefixIcon: icon,
        hint: Text(hintText, style: TextStyle(color: Colors.white30)),
        fillColor: Color(0xff172133),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xff304369)),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xff304369)),

          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xff304369)),

          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
