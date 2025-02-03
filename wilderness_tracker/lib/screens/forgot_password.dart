import 'package:flutter/material.dart';
import 'package:wilderness_tracker/theme.dart';
import 'package:wilderness_tracker/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Forgot Password Page
class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

  String errorMessage = '';

  void _resetPassword() async {
    // Call the resetPassword function from the AuthService
    String? result = await authService.resetPassword(emailController.text.trim());

    // Check if password reset was successful
    if(result != null) {
      setState(() {
      errorMessage = "Password Reset Email Sent to $result";
      });
    } else {
      setState(() {
        errorMessage = "Failed to send password reset email. Try again";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor,
      appBar: AppBar(
        title: Text("Forgot Password"), 
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), 
        backgroundColor: customColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            // Logo and Spacing
            SizedBox(height: 40),
            Image.asset(
              'lib/assets/images/logger.png',
              height: 90, // Adjust size
            ),
            SizedBox(height: 160),

            // Email TextField
            TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            // Error Message
            SizedBox(height: 10),
            if(errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: errorMessageColor)),

            // Reset Password Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Reset Password'),
            ),

            // Go back to login button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Go back to login
              },
              child: Text("Go back to login", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
