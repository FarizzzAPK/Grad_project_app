import 'package:flutter/material.dart';

class CustomTab extends StatefulWidget {
  @override
  State<CustomTab> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTab>{
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xff121a2e),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: buildTab("Active", 0)),
          Expanded(child: buildTab("Completed", 1)),
        ],
      ),
    );
  }

  Widget buildTab(String text, int index){
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffD0D7E6) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
