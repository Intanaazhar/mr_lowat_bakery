import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfile(),
    );
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(  // Wrap the entire body in a Center widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center everything vertically
          crossAxisAlignment: CrossAxisAlignment.center,  // Center everything horizontally
          children: [
            // Adjusting the height of the profile picture
            SizedBox(height: 40),
            Container(
              width: 180, // Size of the circular ring
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(5), // Space between ring and profile picture
                child: CircleAvatar(
                  radius: 150,
                  backgroundImage: AssetImage('assets/userProfilePic.jpg'), // Replace with your avatar image asset
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(height: 10), // Spacing between the profile picture and the text
            Text(
              "Nur Qistina", // Replace with dynamic name if needed
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Qistina03@gmail.com", // Replace with dynamic email if needed
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20), // Spacing before the buttons
            // Buttons
            ProfileButton(label: "My Orders", onTap: () {}),
            SizedBox(height: 20),
            ProfileButton(label: "My Carts", onTap: () {}),
            SizedBox(height: 20),
            ProfileButton(label: "Settings", onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  ProfileButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350,
        padding: EdgeInsets.symmetric(vertical: 30),  // Adjusted padding
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
