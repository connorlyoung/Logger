import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/create_account.dart';
import 'screens/forgot_password.dart';
import 'screens/profile_page.dart';
import 'screens/add_post_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wilderness Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: customColor),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/createAccount': (context) => CreateAccount(),
        '/forgotPassword': (context) => ForgotPassword(),
        '/home': (context) => HomePage(),
        '/addPost': (context) => AddPostPage(),
        '/profilePage': (context) => ProfilePage(),
      },
    );
  }
}
