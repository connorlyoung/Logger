import 'package:flutter/material.dart';
import 'package:wilderness_tracker/theme.dart';
import 'package:wilderness_tracker/services/auth.dart';

// Login Page
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  String errorMessage = '';
  bool isPasswordVisible = false; // for toggling password visibility

  void _login() async{
    //Navigator.pushReplacementNamed(context, '/home'); // Temporary Log in function ******************************************

    // Check if email and password are not empty
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Check if password is long enough
    if(passwordController.text.length < 6) {
      setState(() => errorMessage = "Input Valid Password, Password must be at least 6 characters");
      return;
    }

    // Aprove the login
    String? result = await authService.signInWithEmailPass(email, password);
    if (result != null) {
      print("Login successful! UID: $result");
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        errorMessage = "Failed to login. Try again";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor,
      appBar: AppBar(

        title: Text("Login"), 
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30), 
        backgroundColor: customColor
      
      ),
      body: SingleChildScrollView(
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
              SizedBox(height: 120),

              // Email TextField
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: "Username or Email",
                  hintStyle: TextStyle(color: const Color.fromARGB(255, 211, 211, 211)),
                ),
              ),

              // Password TextField
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

              // Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgotPassword');
                  },
                  child: Text("Forgot your password?", style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),

              // Errorr message
              SizedBox(height: 10),
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: TextStyle(color: errorMessageColor)),

              // Login Button
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 40),
                ),
                child: Text("Log In", style: TextStyle(color: customColor, fontSize: 18)),
              ),

              // Google Sign-In Button
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    errorMessage = "Under Construction";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.2), customColor),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.alphaBlend(Colors.white.withOpacity(0.2), customColor), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text("Sign in with Google", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),

              // Create Account Button
              SizedBox(height: 15),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/createAccount');
                  },
                  child: Text("Don't have an account? Sign up.", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

