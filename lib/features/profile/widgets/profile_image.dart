import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xff38DEBB), Color(0xffB9C7E4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 70,
            backgroundImage: AssetImage("assets/images/ma3soub.PNG"),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
              style: ButtonStyle(
                iconSize: WidgetStatePropertyAll(28),
                iconColor: WidgetStatePropertyAll(Color(0xff233148)),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xffB9C7E4),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
