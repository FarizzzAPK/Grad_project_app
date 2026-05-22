import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/features/auth/views/login_view.dart';
import 'package:clincal/features/profile/controllers/profile_controller.dart';
import 'package:clincal/features/profile/views/change_password_view.dart';
import 'package:clincal/features/profile/widgets/custom_container.dart';
import 'package:clincal/features/profile/widgets/profile_image.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class EditUserData extends StatefulWidget {
  const EditUserData({super.key});

  @override
  State<EditUserData> createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  final AppColors appColors = AppColors();

  // ───────────────────────── Helper: Styled Input Field ─────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.blueAccent.withOpacity(0.8)),
        filled: true,
        fillColor: const Color(0xff131B2E),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }

  // ───────────────── Helper: Show a bottom sheet form ──────────────────────
  Future<void> _showEditSheet({
    required String title,
    required String fieldLabel,
    required IconData fieldIcon,
    required String buttonText,
    required Color buttonColor,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required Future<void> Function(String value) onSubmit,
  }) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool sheetLoading = false;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                decoration: const BoxDecoration(
                  color: Color(0xff18223C),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Title
                      CustomText(
                        text: title,
                        color: const Color(0xffDAE2FD),
                        size: 20,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 24),
                      // Input
                      _buildTextField(
                        controller: controller,
                        label: fieldLabel,
                        icon: fieldIcon,
                        obscure: isPassword,
                        keyboardType: keyboardType,
                      ),
                      const SizedBox(height: 24),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: sheetLoading
                              ? null
                              : () async {
                                  final value = controller.text.trim();
                                  if (value.isEmpty) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please enter $fieldLabel',
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }
                                  setSheetState(() => sheetLoading = true);
                                  try {
                                    await onSubmit(value);
                                    if (ctx.mounted) Navigator.pop(ctx);
                                  } catch (e) {
                                    if (ctx.mounted) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.toString().replaceAll(
                                              'Exception: ',
                                              '',
                                            ),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (ctx.mounted) {
                                      setSheetState(() => sheetLoading = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: sheetLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  buttonText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ───────────────────────── Change Name ────────────────────────────────────
  Future<void> _handleChangeName() async {
    await _showEditSheet(
      title: 'Update Username',
      fieldLabel: 'New Username',
      fieldIcon: Icons.person_outline,
      buttonText: 'Update Username',
      buttonColor: Colors.blueAccent,
      onSubmit: (value) async {
        await AuthService.instance.updateUsername(value);
        ProfileController.instance.loadProfile(); // Reload
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Username updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );
  }

  // ───────────────────────── Change Email ───────────────────────────────────
  Future<void> _handleChangeEmail() async {
    await _showEditSheet(
      title: 'Update Email',
      fieldLabel: 'New Email',
      fieldIcon: Icons.email_outlined,
      buttonText: 'Update Email',
      buttonColor: Colors.blueAccent,
      keyboardType: TextInputType.emailAddress,
      onSubmit: (value) async {
        await AuthService.instance.updateEmail(value);
        ProfileController.instance.loadProfile(); // Reload
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );
  }

  // ───────────────────────── Delete Account ─────────────────────────────────
  Future<void> _handleDeleteAccount() async {
    // First show a confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff18223C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Delete Account',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'This action is permanent and cannot be undone. '
          'All your data will be lost.\n\n'
          'Are you sure you want to proceed?',
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show password prompt
    if (!mounted) return;
    await _showEditSheet(
      title: 'Confirm Deletion',
      fieldLabel: 'Enter your password',
      fieldIcon: Icons.lock_outline,
      buttonText: 'Delete My Account',
      buttonColor: Colors.redAccent,
      isPassword: true,
      onSubmit: (password) async {
        await AuthService.instance.deleteAccount(password);
        // Clear local auth data
        await AuthService.instance.clearAuth();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to login and clear stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        }
      },
    );
  }

  // ───────────────────────── Build ──────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const CustomText(text: "Edit Your Info", color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff101a31),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              // Profile image header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: const Color(0xff131B2E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 1.5,
                  ),
                ),
                child: const Column(
                  children: [
                    ProfileImage(),
                    SizedBox(height: 12),
                    CustomText(
                      text: "Tap an option below to edit",
                      color: Colors.white38,
                      size: 14,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ──── Section: Account Settings ────
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 14),
                  child: CustomText(
                    text: "Account Settings",
                    color: Color(0xffDAE2FD),
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
              ),

              // Change Username
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: "Change Username",
                subtitle: "Update your display name",
                iconBgColor: Colors.blueAccent,
                onTap: _handleChangeName,
              ),
              const SizedBox(height: 12),

              // Change Email
              _buildSettingsTile(
                icon: Icons.email_outlined,
                title: "Change Email",
                subtitle: "Update your email address",
                iconBgColor: Colors.tealAccent.shade700,
                onTap: _handleChangeEmail,
              ),
              const SizedBox(height: 12),

              // Change Password
              _buildSettingsTile(
                icon: Icons.lock_reset_rounded,
                title: "Change Password",
                subtitle: "Update your account password",
                iconBgColor: Colors.deepPurpleAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // ──── Danger Zone ────
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 14),
                  child: CustomText(
                    text: "Danger Zone",
                    color: Colors.redAccent,
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
              ),

              // Delete Account
              GestureDetector(
                onTap: _handleDeleteAccount,
                child: CustomContainer(
                  text: "Delete My Account",
                  icon: Icons.delete_forever_outlined,
                  bgColor: Colors.red,
                  iconColor: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── Reusable settings tile widget ──────────────────────────────────
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff18223C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconBgColor, size: 24),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
