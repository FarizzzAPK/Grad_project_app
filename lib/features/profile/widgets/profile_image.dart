import 'dart:io';
import 'package:clincal/core/constants/api_constants.dart';
import 'package:clincal/features/profile/controllers/profile_controller.dart';
import 'package:clincal/features/profile/patient_data_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    
    // Show select source dialog (Camera or Gallery)
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xff18223C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blueAccent),
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.tealAccent),
                ),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // Show temporary loading indicator or snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 16),
                Text('Uploading profile image...', style: TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.blueAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }

      final success = await ProfileController.instance.uploadProfileImage(image.path);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile image updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update profile image.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickAndUploadImage(context),
      behavior: HitTestBehavior.opaque,
      child: Stack(
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
            child: ValueListenableBuilder<PatientDataModel?>(
              valueListenable: ProfileController.instance.profileData,
              builder: (context, data, _) {
                final imagePath = data?.data.imagePath;

                ImageProvider imageProvider;
                if (imagePath != null && imagePath.isNotEmpty) {
                  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
                    imageProvider = NetworkImage(imagePath);
                  } else if (File(imagePath).existsSync()) {
                    imageProvider = FileImage(File(imagePath));
                  } else {
                    imageProvider = NetworkImage('${ApiConstants.baseUrl}$imagePath');
                  }
                } else {
                  imageProvider = const AssetImage("assets/images/ma3soub.PNG");
                }

                return CircleAvatar(
                  backgroundColor: const Color(0xff18223C),
                  radius: 65,
                  backgroundImage: imageProvider,
                );
              },
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
      ),
    );
  }
}