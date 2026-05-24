
import 'dart:io';
import 'package:clincal/core/constants/api_constants.dart';
import 'package:clincal/features/profile/controllers/profile_controller.dart';
import 'package:clincal/features/profile/patient_data_model.dart';
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
              ValueListenableBuilder<PatientDataModel?>(
                valueListenable: ProfileController.instance.profileData,
                builder: (context, data, _) {
                  final imagePath = data?.data.imagePath;
                  
                  ImageProvider? imageProvider;
                  if (imagePath != null && imagePath.isNotEmpty) {
                    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
                      imageProvider = NetworkImage(imagePath);
                    } else if (File(imagePath).existsSync()) {
                      imageProvider = FileImage(File(imagePath));
                    } else {
                      imageProvider = NetworkImage('${ApiConstants.baseUrl}$imagePath');
                    }
                  }
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff1e293b),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: imageProvider != null
                          ? Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person_outline,
                                  color: Color(0xffcad5e0),
                                  size: 28,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person_outline,
                              color: Color(0xffcad5e0),
                              size: 28,
                            ),
                    ),
                  );
                },
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
                  ValueListenableBuilder<PatientDataModel?>(
                    valueListenable: ProfileController.instance.profileData,
                    builder: (context, data, _) {
                      String userName = "Loading...";
                      if (data != null && data.data.userName.isNotEmpty) {
                        userName = data.data.userName;
                      }
                      return CustomText(
                        text: "Welcome, $userName",
                        size: 15,
                        color: Colors.white,
                      );
                    },
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
