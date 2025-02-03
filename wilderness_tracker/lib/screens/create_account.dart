import 'package:flutter/material.dart';
import 'package:wilderness_tracker/theme.dart';
import 'package:wilderness_tracker/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Create Account Page
class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordControllerRepeater = TextEditingController();
  final AuthService authService = AuthService();

  bool isPasswordVisible = false; // for toggling password visibility
  bool isConfirmPasswordVisible = false;

  String errorMessage = '';
  

  void _createAccount() async {

    // Check if passwords match
    if(passwordController.text != passwordControllerRepeater.text) {
      setState(() => errorMessage = "Passwords do not match");
      return;
    }

    try {
    // Register user in Firebase Auth
    UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    User? user = result.user;

    if (user != null) {
      // Save user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'displayName': "New User",
        'profilePic': "", // Add default image URL or let user upload
        'postCount': 0,
        'speciesCount': 0,
      });

      print("User registered: ${user.uid}");
      Navigator.pushReplacementNamed(context, '/home');
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message ?? "Registration failed.";
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor,
      appBar: AppBar(
        title: Text("Create Account"), 
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), 
        backgroundColor: customColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
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
              SizedBox(height: 100),

              // TextFields for email
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  ),
              ),

               // TextFields for username
              TextField(
                controller: usernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  ),
              ),

              // TextFields for password
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              TextField(
                controller: passwordControllerRepeater,
                obscureText: !isConfirmPasswordVisible,
                style: TextStyle(color: Colors.white), 
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              // Error Message
              SizedBox(height: 10),
              if(errorMessage.isNotEmpty)
                Text(errorMessage, style: TextStyle(color: errorMessageColor)),

              // Create Account Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAccount,
                child: Text('Create Account'),
              ),

              // Go back to login button
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to login
                },
                child: Text("Already have an account? Login", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
