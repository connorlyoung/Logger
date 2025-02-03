import 'package:flutter/material.dart';
import 'package:wilderness_tracker/theme.dart';
import 'package:wilderness_tracker/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      // Implementation to grab firestore info and setup profile page
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
          );
        }
      )
    );
  }
}