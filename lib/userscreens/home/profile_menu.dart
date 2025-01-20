import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/edit_profile.dart';
import 'package:mr_lowat_bakery/userscreens/home/view_profile.dart';
import 'package:mr_lowat_bakery/userscreens/my_orders.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/settings_page.dart';
import 'package:mr_lowat_bakery/userscreens/welcome.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({super.key});

  @override
  _ProfileMenuState createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  String userName = "Loading..."; // Placeholder for user's name

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      // Get the current user
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // Replace with your Firestore collection name
            .doc(currentUser.uid) // Use the authenticated user's UID
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['firstName']; // Access the "firstName" field
          });
        } else {
          setState(() {
            userName = "User"; // Fallback if document doesn't exist
          });
        }
      }
    } catch (e) {
      print("Error fetching user name: $e");
      setState(() {
        userName = "Error"; // Fallback on error
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BakeryWelcomeScreen()),
      ); // Redirect to Welcome Page
    } catch (e) {
      print("Logout error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: () async {
              final shouldLogout = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Log Out"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Log Out"),
                    ),
                  ],
                ),
              );
              if (shouldLogout == true) {
                _logout();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Section with Alphabet
            Container(
              width: 180, // Size of the circular ring
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[200],
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U', // Display first letter of first name
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Display Fetched User Name
            Text(
              userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 68, 68, 68),
              ),
            ),
            const SizedBox(height: 20), // Spacing before buttons
            // View Profile Button
            ProfileButton(
              label: "View Profile",
              onTap: () {
                // Navigate to the User Profile Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // My Orders Button
            ProfileButton(
              label: "My Orders",
              onTap: () {
                // Navigate to the Order Tracker Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOrdersPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Settings Button
            ProfileButton(
              label: "Settings",
              onTap: () {
                // Show the Settings Dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const SettingsPopup(); // Call your SettingsPopup widget as a dialog
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
