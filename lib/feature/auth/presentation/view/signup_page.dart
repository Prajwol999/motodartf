import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/egister_event.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAgreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    FocusScope.of(context).unfocus();
    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please agree to the terms and conditions."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_formKey.currentState!.validate()) {
      context.read<RegisterViewModel>().add(
            RegisterUserEvent(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              context: context,
            ),
          );
    }
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A4759),
          title: const Text('Terms and Conditions',
              style: TextStyle(color: Colors.white)),
          content: const SingleChildScrollView(
            child: Text(
              '1. Acceptance of Terms: By creating an account, you agree to these terms.\n\n'
              '2. Account Responsibilities: You are responsible for your account.\n\n'
              '3. Use of Service: For personal, non-commercial use only.\n\n'
              '4. Privacy Policy: Your use is governed by our Privacy Policy.\n\n'
              '5. Modifications: We can modify these terms at any time.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long.";
    }
    if (value.length > 12) {
      return "Password cannot be more than 12 characters long.";
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Must contain at least one uppercase letter.";
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return "Must contain at least one lowercase letter.";
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Must contain at least one number.";
    }
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      return "Must contain at least one special character.";
    }
    return null;
  }

  InputDecoration _inputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white38),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A4759),
      body: SafeArea(
        child: BlocConsumer<RegisterViewModel, RegisterState>(
          listener: (context, state) {},
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset('assets/images/motofix_logo.png',
                            height: 90),
                      ),
                      const SizedBox(height: 5),
                      const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 10),
                      const Text("Create your account",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 30),

                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                            label: "Full Name", icon: Icons.person),
                        validator: (value) => value!.trim().isEmpty
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            _inputDecoration(label: "Email", icon: Icons.email),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an email';
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                                label: "Password", icon: Icons.lock)
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: _obscureConfirmPassword,
                        decoration: _inputDecoration(
                                label: "Confirm Password",
                                icon: Icons.lock_outline)
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(() =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Terms and Conditions
                      Row(
                        children: [
                          Checkbox(
                            value: _termsAgreed,
                            onChanged: (bool? value) =>
                                setState(() => _termsAgreed = value!),
                            activeColor: Colors.white,
                            checkColor: const Color(0xFF2A4759),
                            side: const BorderSide(color: Colors.white70),
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'I agree to the ',
                                style: const TextStyle(color: Colors.white70),
                                children: [
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _showTermsAndConditions,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Button
                      ElevatedButton(
                        onPressed: state.isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2A4759),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Color(0xFF2A4759),
                                ),
                              )
                            : const Text("SIGN UP",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 30),

                      // Sign In Prompt
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(color: Colors.white60),
                            children: [
                              TextSpan(
                                text: 'Sign in Here',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
