import 'package:flutter/material.dart';
import 'package:wilderness_tracker/theme.dart';
import 'package:wilderness_tracker/services/auth.dart';

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

