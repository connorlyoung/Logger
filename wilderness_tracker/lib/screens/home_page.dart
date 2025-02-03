import 'package:flutter/material.dart';
import 'package:wilderness_tracker/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

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