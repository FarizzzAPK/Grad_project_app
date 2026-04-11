import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomRequestCard extends StatelessWidget {
  const CustomRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: 350,
      decoration: BoxDecoration(
        color: const Color(0xFF18223C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff222A3D),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 40,
                    width: 50,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.healing_sharp,
                        color: Color(0xffcad5e0),
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Dr. Sarah Jenkins",
                        size: 15,
                        color: Color(0xffDAE2FD),
                      ),
                      CustomText(
                        text: "Cardiology Specialist",
                        size: 12,
                        color: Color(0xffC5C6CD),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff93000A),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 35,
                width: 100,
                child: Center(
                  child: CustomText(text: "Urgent", color: Color(0xffFFDAD6)),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(text: "Surgery ", color: Color(0xffB9C7E4)),
              Container(color: Color(0xff44474D).withOpacity(0.2), height: 2),
            ],
          ),
          CustomText(
            overflow: TextOverflow.clip,
            text:
                "Pre-operative clearance required for scheduled valve replacement procedure next week.",
            color: Color(0xffC5C6CD),
            size: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              CustomText(
                text: "Today, 09:24 AM",
                color: Color(0xffC5C6CD),
                size: 12,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffB9C7E4),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 35,
                width: 150,
                child: Center(
                  child: CustomText(
                    weight: FontWeight.bold,
                    text: "Complete Now",
                    color: Color(0xff233148),
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}