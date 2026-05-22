import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/features/auth/views/login_view.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatefulWidget {
  final String emailOrPhone;
  const ResetPasswordView({super.key, required this.emailOrPhone});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final AppColors appColors = AppColors();
  
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final otp = _otpController.text.trim();
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (otp.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showError("All fields are required.");
      return;
    }
    
    if (newPass != confirmPass) {
      _showError("Passwords do not match.");
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final response = await AuthService.instance.resetPassword(
        emailOrPhone: widget.emailOrPhone,
        otpCode: otp,
        newPassword: newPass,
        confirmNewPassword: confirmPass,
      );
      
      setState(() => _isLoading = false);

      if (response['success'] == true || response.containsKey('message')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully! Please login.'), backgroundColor: Colors.green),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: Colors.blueAccent.withOpacity(0.8)),
          suffixIcon: onToggleVisibility != null
              ? IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                  onPressed: onToggleVisibility,
                )
              : null,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const CustomText(text: "Verify & Reset", color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Icon(Icons.password_rounded, size: 80, color: Colors.blueAccent.withOpacity(0.8)),
            const SizedBox(height: 32),
            Text(
              "OTP sent to ${widget.emailOrPhone}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Enter the OTP code and your new password.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildTextField(
              controller: _otpController,
              label: "OTP Code",
              icon: Icons.pin_outlined,
            ),
            _buildTextField(
              controller: _newPasswordController,
              label: "New Password",
              icon: Icons.lock_outline,
              obscureText: _obscureNew,
              onToggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
            ),
            _buildTextField(
              controller: _confirmPasswordController,
              label: "Confirm New Password",
              icon: Icons.lock_reset_outlined,
              obscureText: _obscureConfirm,
              onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Text(
                        "Reset Password",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
