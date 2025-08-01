
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _emailSent = false;
  bool _isEmailValid = true; // To track email validity
  final FocusNode _emailFocusNode = FocusNode();

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();

      setState(() {
        _emailSent = true;
        _isEmailValid = true;
      });

      _showSnackBar("Password reset link sent to $email", Colors.green);

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _emailSent = false;
        });
      });

      _emailController.clear();
      _emailFocusNode.unfocus();
    } else {
      setState(() {
        _isEmailValid = false;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get maxWidth of parent container
    return Scaffold(
      backgroundColor: const Color(0xFF2A4759),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A4759),
        title: const Text("Reset Password", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine maxWidth for form, larger for tablets
          double maxFormWidth = constraints.maxWidth < 600 ? constraints.maxWidth : 500;

          // Adjust padding based on screen width
          double horizontalPadding = constraints.maxWidth < 600 ? 24.0 : 48.0;

          // Optionally, scale text size for tablets
          double titleFontSize = constraints.maxWidth < 600 ? 24 : 28;
          double bodyFontSize = constraints.maxWidth < 600 ? 14 : 16;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxFormWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Forgot your password?",
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Enter your registered email address. We'll send you a link to reset your password.",
                        style: TextStyle(color: Colors.white70, fontSize: bodyFontSize),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.email, color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _isEmailValid ? Colors.white30 : Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _isEmailValid ? Colors.white : Colors.red),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!_isValidEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2A4759),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("SEND RESET LINK", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                      if (_emailSent)
                        const Center(
                          child: Text(
                            "Check your inbox for the reset link.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
