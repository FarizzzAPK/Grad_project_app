import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final AppColors appColors = AppColors();

  // Step 1: current password  →  Step 2: OTP + new password
  int _currentStep = 1;
  bool _isLoading = false;

  // Step 1 controllers
  final TextEditingController _currentPasswordController = TextEditingController();
  bool _obscureCurrent = true;

  // Step 2 controllers
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ───────────────────── Step 1: Send OTP ─────────────────────
  Future<void> _requestOtp() async {
    final currentPass = _currentPasswordController.text.trim();
    if (currentPass.isEmpty) {
      _showError("Please enter your current password.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.changePasswordRequest(currentPass);

      setState(() {
        _isLoading = false;
        _currentStep = 2;
      });

      _showSuccess("OTP sent to your email!");
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ───────────────────── Step 2: Confirm Change ────────────────
  Future<void> _confirmChange() async {
    final otp = _otpController.text.trim();
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (otp.isEmpty) {
      _showError("Please enter the OTP code.");
      return;
    }
    if (newPass.isEmpty) {
      _showError("Please enter your new password.");
      return;
    }
    if (newPass.length < 6) {
      _showError("Password must be at least 6 characters.");
      return;
    }
    if (newPass != confirmPass) {
      _showError("Passwords do not match.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.changePasswordConfirm(
        otpCode: otp,
        newPassword: newPass,
        confirmNewPassword: confirmPass,
      );

      setState(() => _isLoading = false);

      _showSuccess("Password changed successfully!");

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ───────────────────── Helpers ───────────────────────────────
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: Colors.blueAccent.withOpacity(0.8)),
          suffixIcon: onToggleVisibility != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                  ),
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

  // ───────────────────── Build ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const CustomText(text: "Change Password", color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
        ),
      ),
    );
  }

  // ───────────────── Step 1: Enter current password ───────────
  Widget _buildStep1() {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Icon(Icons.lock_outline_rounded, size: 80, color: Colors.blueAccent.withOpacity(0.8)),
        const SizedBox(height: 32),

        // Step indicator
        _buildStepIndicator(1),
        const SizedBox(height: 24),

        const Text(
          "Verify your identity",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          "Enter your current password to receive an OTP code on your registered email.",
          style: TextStyle(color: Colors.white54, fontSize: 15, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),

        _buildTextField(
          controller: _currentPasswordController,
          label: "Current Password",
          icon: Icons.lock_outline,
          obscureText: _obscureCurrent,
          onToggleVisibility: () => setState(() => _obscureCurrent = !_obscureCurrent),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _requestOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text(
                    "Send OTP",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }

  // ───────────────── Step 2: OTP + New Password ───────────────
  Widget _buildStep2() {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Icon(Icons.password_rounded, size: 80, color: Colors.blueAccent.withOpacity(0.8)),
        const SizedBox(height: 32),

        // Step indicator
        _buildStepIndicator(2),
        const SizedBox(height: 24),

        const Text(
          "Set your new password",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          "Enter the OTP code sent to your email and choose a new password.",
          style: TextStyle(color: Colors.white54, fontSize: 15, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),

        _buildTextField(
          controller: _otpController,
          label: "OTP Code",
          icon: Icons.pin_outlined,
          keyboardType: TextInputType.number,
        ),
        _buildTextField(
          controller: _newPasswordController,
          label: "New Password",
          icon: Icons.lock_reset_outlined,
          obscureText: _obscureNew,
          onToggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
        ),
        _buildTextField(
          controller: _confirmPasswordController,
          label: "Confirm New Password",
          icon: Icons.lock_outline,
          obscureText: _obscureConfirm,
          onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _confirmChange,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text(
                    "Change Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),

        const SizedBox(height: 16),

        // Resend link
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  setState(() => _currentStep = 1);
                },
          child: const Text(
            "← Back to re-enter password",
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      ],
    );
  }

  // ───────── Step indicator dots ──────────────────────────────
  Widget _buildStepIndicator(int activeStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(isActive: activeStep == 1, label: "1"),
        Container(
          width: 40,
          height: 2,
          color: activeStep >= 2 ? Colors.blueAccent : Colors.white.withOpacity(0.15),
        ),
        _buildDot(isActive: activeStep == 2, label: "2"),
      ],
    );
  }

  Widget _buildDot({required bool isActive, required String label}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blueAccent : Colors.white.withOpacity(0.1),
        border: Border.all(
          color: isActive ? Colors.blueAccent : Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
