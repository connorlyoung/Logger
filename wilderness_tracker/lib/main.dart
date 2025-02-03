import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const Color customColor = Color(0xFF7E9797);

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  runApp(MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: customColor),
        ),
        home: HomePage(),
      ),
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

// ...

// -- Home Page --
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // -- Drawer widget to display the sidebar -- 
      drawer: SideBar(),
      // -- Main content -- 
      body: Column(
        children: [
          // Upper Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                filled: true,
                fillColor: customColor.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Main page content, where the map will be displayed
          Expanded(
            child: Center(
              child: Text('Content Goes Here', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
      // buttons on the bottom of the screen
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // -- Drawer/Settings Button --
          SizedBox(width:0),
          SizedBox(height: 75),
          Builder(
            builder: (BuildContext context) {
              return FloatingActionButton(
                heroTag: 'openSideBar',
                onPressed: () { 
                  Scaffold.of(context).openDrawer(); // Open drawer when pressed
                },
                backgroundColor: customColor,
                shape: CircleBorder(side: BorderSide(color: customColor, width: 2)),
                elevation: 8.0,
                mini: true,
                child: Icon(Icons.menu, color: Colors.white),
              );
            }
          ),
          // Add post button
          SizedBox(width:290),
          FloatingActionButton(
            heroTag: 'addPost',
            onPressed: () { 
              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MakePostPage()),
                    );
            },
            backgroundColor: customColor,
            shape: CircleBorder(side: BorderSide(color: customColor, width: 2)),
            elevation: 8.0,
            mini: true,
            child:Icon(Icons.add, color: Colors.white),
          )
        ]
      ),
    );
  }
}

// -- Home Page Widgets --
class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: customColor,
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Profile Name & Settings button
            Row(
              children: [
                Icon(Icons.person, color: Colors.white),
                SizedBox(width: 10),
                Text('Profile Name', style: TextStyle(color: Colors.white, fontSize: 18)),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                ),
              ],
            ),
            Divider(color: Colors.white),
            
            // Menu options
            //Profile Search option
            ListTile(
              title: Text('Profile Search', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Add logic later to search for profiles
              },
            ),
            //Tracked Species option
            ListTile(
              title: Text('Tracked Species', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Add logic later to see lists of all and tracked species
              },
            ),
            // Hidden Posts option
            ListTile(
              title: Text('Hidden Posts', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Add logic later to view hidden posts
              },
            ),
            // Report a Bug option
            ListTile(
              title: Text('Report a Bug', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Add logic later to send reports
              },
            ),
            //settings option
            ListTile(
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// -- Profile Page --
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the Profile Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

// -- Settings Page --
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the Settings Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

// -- Make Post Page --
class MakePostPage extends StatelessWidget {
  const MakePostPage({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the Add Post Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}