import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wilderness_tracker/services/auth.dart';
import 'firebase_options.dart';

const Color customColor = Color(0xFF7E9797);
const Color errorMessageColor = Color.fromARGB(255, 255, 0, 0);

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listens for auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator
        }

        // If user is signed in, go to Home, else go to Login
        return MaterialApp(
          title: 'Namer App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: customColor),
          ),
          initialRoute: snapshot.hasData ? '/home' : '/login', 
          routes: {
            '/login': (context) => LoginPage(),
            '/createAccount': (context) => CreateAccount(),
            '/forgotPassword': (context) => ForgotPassword(),
            '/home': (context) => HomePage(),
            '/addPost': (context) => AddPostPage(),
            '/profilePage': (context) => ProfilePage(),
          },
        );
      },
    );
  }
}

// ...

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

////////////////////////////////////////////////////////////////////////////////////////////
///LOGIN PAGE STUFF
////////////////////////////////////////////////////////////////////////////////////////////

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
    Navigator.pushReplacementNamed(context, '/home'); // Temporary Log in function ******************************************

    // Check if email and password are not empty
    /*String email = emailController.text.trim();
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
      Navigator.pushReplacementNamed(context, '/home')
    } else {
      setState(() {
        errorMessage = "Failed to login. Try again";
      });
    }*/

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor,
      appBar: AppBar(
        /*backgroundColor: customColor,
        elevation: 0,
        title: Row(
          children: [
            Flexible(
              child: Image.asset(
                'lib/assets/images/logger.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),*/

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
      /* Uncomment later when firestore is setup ***************************************************************************************
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'displayName': "New User",
        'profilePic': "", // Add default image URL or let user upload
        'postCount': 0,
        'speciesCount': 0,
      });*/

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
    //setState(() {
    //    errorMessage = "Under Construction";
    //});
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

////////////////////////////////////////////////////////////////////////////////////////////
///HOME PAGE STUFF
////////////////////////////////////////////////////////////////////////////////////////////

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildTopBar(context),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              // Edit later to include map api ******************************************************************
              child: Text('Content Goes Here', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
      
      // Add Post Functionality
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addPost');
        },
        backgroundColor: customColor,
        shape: CircleBorder(side: BorderSide(color: customColor, width: 2)),
        elevation: 8.0,
        child: Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }

  // Function to build the Drawer
  Widget _buildDrawer(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Container(
        color: customColor,
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context),
            Divider(color: Colors.white),
            _buildDrawerMenuItem("Profile Search", Icons.search, () {}),
            _buildDrawerMenuItem("Tracked Species", Icons.pets, () {}),
            _buildDrawerMenuItem("Hidden Posts", Icons.visibility_off, () {}),
            _buildDrawerMenuItem("Report a Bug", Icons.bug_report, () {}),
            _buildDrawerMenuItem("Settings", Icons.settings, () {}),
            _buildDrawerMenuItem("Log Out", Icons.logout, () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              } catch (e) {
                print("Logout Failed: $e");
              }
            }),

            // Bottom Left Logo
            Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                'lib/assets/images/logger.png',
                height: 40,
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Function to build Profile Section
  Widget _buildProfileSection(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Row(
      children: [
        // Profile Image fetcher
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null, // Set to null if no profile picture
          child: user?.photoURL == null
              ? Icon(Icons.person, color: Colors.grey, size: 24) // Default icon
              : null, // Hide the icon if there's a profile picture
        ),
        SizedBox(width: 10),
        
        /// Grab User name 
       Text(
          user?.displayName ?? "Guest User", // Use displayName if available
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),

        Spacer(),

        // gOES TO profile Page
        IconButton(
          icon: Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/profilePage');
          },
        ),
      ],
    );
  }

  // Function to build a Drawer Menu Item
  Widget _buildDrawerMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  // Top Bar Function
  Widget _buildTopBar(BuildContext context) {
     final User? user = FirebaseAuth.instance.currentUser;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: customColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Drawer Opening tab top left
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          
          // Topright Profile Icon
          IconButton(
            icon: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null, // Set to null if no profile picture
                    child: user?.photoURL == null
                        ? Icon(Icons.person, color: Colors.grey, size: 24) // Default icon
                        : null, // Hide the icon if there's a profile picture
                  ),
            onPressed: () {
              Navigator.pushNamed(context, '/profilePage');
            },
          ),
        ],
      ),
    );
  }
}

// Add Post Page
class AddPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Posts")),
      body: Padding (
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: customColor,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "New Post",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 16),

                  Container(
                    width: 150,
                    height: 150,
                    color: Colors.white,
                    child: Icon(Icons.image, size:50, color: Colors.grey),
                  ),

                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 5),
                      Expanded(

                        // Location TextField
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Santa Cruz, CA",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            )
                          )
                        )
                      )
                    ],
                  ),

                  // Title TextField
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Title",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )
                    )
                  ),

                  // Description TextField
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Description",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: customColor,
      appBar: AppBar(
        backgroundColor: customColor, 
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Edit Profile **********************************************
              },

              // Edit style later for better look
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.2), customColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  
                ),
              ),
              child: Text("Edit Profile", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      /* // Implementation to grab firestore info and setup profile page
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;

          return Column(
            children: [
              // Profile Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: userData?['profilePic'] != "" 
                        ? NetworkImage(userData!['profilePic'])
                        : null,
                      child: userData?['profilePic'] == "" 
                        ? Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                    ),
                    SizedBox(height: 10),

                    Text(
                      userData?['displayName'] ?? "Guest User",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${userData?['postCount'] ?? 0} Posts", style: TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(width: 40),
                        Text("${userData?['speciesCount'] ?? 0} Species", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.white, thickness: 1, indent: 20, endIndent: 20),
                  ],
                ),
              ),

              // Grid of Posts
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    itemCount: userData?['postCount'] ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Color(0xFF7E9797), width: 2),
                        ),
                        child: Center(
                          child: Text("Post $index", style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );*/
        // Temporary profile page delete later ******************************************************
      body: Column(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 10),

                // Profile Name
                Text(user?.displayName ?? "Guest User", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),

                SizedBox(height: 10),

                // Posts & Species Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("21 Posts", style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(width: 40),
                    Text("# Species", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: Colors.white, thickness: 1, indent: 20, endIndent: 20),
              ],
            ),
          ),

          // Grid of Posts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                itemCount: 21,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Color(0xFF7E9797), width: 2),
                    ),
                    child: Center(
                      child: Text("Jan. 17th", style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
  
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asPascalCase, 
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}
