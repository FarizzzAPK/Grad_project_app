import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff1e293b),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 60,
                width: 60,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person_outline,
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
                    text: "Good Morning",
                    size: 12,
                    color: Color(0xff95a2b8),
                  ),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: AuthService.instance.getUserData(),
                    builder: (context, snapshot) {
                      String userName = "User";
                      if (snapshot.connectionState == ConnectionState.waiting) {
                         userName = "Loading...";
                      } else if (snapshot.hasData && snapshot.data!['name'] != null && snapshot.data!['name'].toString().isNotEmpty) {
                         userName = snapshot.data!['name'];
                      }
                      return CustomText(
                        text: "Welcome, $userName",
                        size: 15,
                        color: Colors.white,
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xff1e293b),
              borderRadius: BorderRadius.circular(16),
            ),
            height: 60,
            width: 60,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notification_add,
                color: Color(0xffcad5e0),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
