import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomEditButton extends StatelessWidget {
   CustomEditButton({required this.text,super.key});
                String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
      // decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2),
      //     borderRadius: BorderRadius.circular(16)
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: text,color: Colors.white,size: 20,),
          Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,)
        ],
      ),
    );
  }
}
