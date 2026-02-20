import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  SearchField({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        cursorColor: Color(0xff004bac),
        cursorHeight: 20,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(fontSize: 13),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14,horizontal: 16),
        ),
      ),
    );
  }
}