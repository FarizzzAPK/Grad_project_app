import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/features/auth/views/login_view.dart';
import 'package:clincal/features/auth/data/models/user_model.dart';
import 'package:clincal/features/auth/widgets/custom_text_form_field.dart';
import 'package:clincal/features/auth/widgets/login_signup_button.dart';
import 'package:clincal/features/auth/widgets/login_with_google.dart';
import 'package:clincal/features/auth/widgets/or_row.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class RegisterContainer extends StatefulWidget {
  const RegisterContainer({super.key});

  @override
  State<RegisterContainer> createState() => _RegisterContainerState();
}

class _RegisterContainerState extends State<RegisterContainer> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // Multi-step: 0 = basic info, 1 = password
  int _currentStep = 0;

  int get _totalSteps => 2;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _validateBasicInfo();
      case 1:
        return _validatePasswords();
      default:
        return false;
    }
  }

  bool _validateBasicInfo() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your full name');
      return false;
    }
    if (name.length < 3) {
      _showError('Name must be at least 3 characters');
      return false;
    }
    if (email.isEmpty) {
      _showError('Please enter your email');
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return false;
    }
    if (phone.isNotEmpty && phone.length < 10) {
      _showError('Please enter a valid phone number');
      return false;
    }
    return true;
  }

  bool _validatePasswords() {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (password.isEmpty) {
      _showError('Please enter a password');
      return false;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return false;
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      _showError('Password must contain at least one uppercase letter');
      return false;
    }
    if (!RegExp(r'(?=.*[0-9])').hasMatch(password)) {
      _showError('Password must contain at least one number');
      return false;
    }
    if (!RegExp(r'(?=.*[!@#\$&*~])').hasMatch(password)) {
      _showError('Password must contain at least one special character (!@#\$&*~)');
      return false;
    }
    if (confirm.isEmpty) {
      _showError('Please confirm your password');
      return false;
    }
    if (password != confirm) {
      _showError('Passwords do not match');
      return false;
    }
    return true;
  }



  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      _submitRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitRegistration() async {
    setState(() => _isLoading = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Creating your account...'),
        backgroundColor: Colors.blue.shade700,
        duration: const Duration(seconds: 30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    try {
      final newUser = UserModel(
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        isDoctor: false,
      );

      await AuthService.instance.register(newUser.toJson());

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration Successful! Please Log in.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff304369)),
        color: const Color(0xff172133).withOpacity(0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator
          _buildStepIndicator(),
          const SizedBox(height: 24),

          // Animated step content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: _buildCurrentStep(),
          ),

          const SizedBox(height: 24),

          // Navigation buttons
          _buildNavigationButtons(),

          // Show Google login only on the first step
          if (_currentStep == 0) ...[
            const SizedBox(height: 16),
            const OrRow(),
            const SizedBox(height: 16),
            const LoginWithGoogle(),
          ],
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(_totalSteps, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < _totalSteps - 1 ? 8 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isCompleted
                    ? const Color(0xff256af4)
                    : isActive
                        ? const Color(0xff256af4).withOpacity(0.6)
                        : const Color(0xff304369),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildPasswordStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      key: const ValueKey('step_basic'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Create Account",
          color: Colors.white,
          size: 22,
          weight: FontWeight.bold,
        ),
        const SizedBox(height: 4),
        const CustomText(
          text: "Step 1: Your basic information",
          color: Colors.white54,
          size: 12,
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(bottom: 8, left: 8),
          child: CustomText(text: "Full Name", color: Colors.white, size: 12),
        ),
        CustomTextFormField(
          controller: _nameController,
          hintText: "John Doe",
          icon: const Icon(Icons.person),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(bottom: 8, left: 8),
          child: CustomText(text: "Email", color: Colors.white, size: 12),
        ),
        CustomTextFormField(
          controller: _emailController,
          hintText: "john@example.com",
          icon: const Icon(Icons.email),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(bottom: 8, left: 8),
          child: CustomText(
            text: "Phone Number (optional)",
            color: Colors.white,
            size: 12,
          ),
        ),
        CustomTextFormField(
          controller: _phoneController,
          hintText: "+1234567890",
          icon: const Icon(Icons.phone),
        ),
      ],
    );
  }


  Widget _buildPasswordStep() {
    return Column(
      key: const ValueKey('step_password'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Secure Your Account",
          color: Colors.white,
          size: 22,
          weight: FontWeight.bold,
        ),
        const SizedBox(height: 4),
        const CustomText(
          text: "Step 2: Create a strong password",
          color: Colors.white54,
          size: 12,
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(bottom: 8, left: 8),
          child: CustomText(text: "Password", color: Colors.white, size: 12),
        ),
        CustomTextFormField(
          controller: _passwordController,
          hintText: "********",
          icon: const Icon(Icons.lock),
          obscureText: true,
        ),
        const SizedBox(height: 8),
        _buildPasswordStrength(),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(bottom: 8, left: 8),
          child: CustomText(
            text: "Confirm Password",
            color: Colors.white,
            size: 12,
          ),
        ),
        CustomTextFormField(
          controller: _confirmPasswordController,
          hintText: "********",
          icon: const Icon(Icons.lock_outline),
          obscureText: true,
        ),
      ],
    );
  }

  Widget _buildPasswordStrength() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _passwordController,
      builder: (context, value, _) {
        final password = value.text;
        final checks = [
          _PasswordCheck('At least 6 characters', password.length >= 6),
          _PasswordCheck(
              'Uppercase letter', RegExp(r'[A-Z]').hasMatch(password)),
          _PasswordCheck('Number', RegExp(r'[0-9]').hasMatch(password)),
          _PasswordCheck('Special character (!@#\$&*~)',
              RegExp(r'[!@#\$&*~]').hasMatch(password)),
        ];

        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: checks
                .map((check) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            check.passed
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 14,
                            color: check.passed
                                ? Colors.green
                                : Colors.white24,
                          ),
                          const SizedBox(width: 6),
                          CustomText(
                            text: check.label,
                            color: check.passed
                                ? Colors.green
                                : Colors.white38,
                            size: 11,
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }


  Widget _buildNavigationButtons() {
    final isLastStep = _currentStep == _totalSteps - 1;

    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: GestureDetector(
              onTap: _isLoading ? null : _previousStep,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xff304369)),
                  color: const Color(0xff172133),
                ),
                child: const Center(
                  child: CustomText(
                    text: "Back",
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          flex: _currentStep > 0 ? 2 : 1,
          child: LoginSignupButton(
            text: _isLoading
                ? "Please wait..."
                : isLastStep
                    ? "Create Account"
                    : "Continue",
            onTap: _isLoading ? null : _nextStep,
          ),
        ),
      ],
    );
  }
}

class _PasswordCheck {
  final String label;
  final bool passed;

  _PasswordCheck(this.label, this.passed);
}
