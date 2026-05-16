import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xff38DEBB), Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff38DEBB).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const CircleAvatar(
            backgroundColor: Color(0xff18223C),
            radius: 65,
            backgroundImage: AssetImage("assets/images/ma3soub.PNG"),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}