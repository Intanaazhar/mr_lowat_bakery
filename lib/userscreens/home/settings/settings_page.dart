import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/address_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/debit_card_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/feedback_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/support_page.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  Future<String?> _getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserId().then((userId) {
        if (userId != null) {
          showDialog(
            context: context,
            barrierDismissible: true, // Allow dismissing the dialog by tapping outside
            builder: (BuildContext context) {
              return Stack(
                children: [
                  // Blurred background
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.3), // Optional semi-transparent overlay
                    ),
                  ),
                  // Dialog in the center
                  Center(
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: 300, // Adjust the width as needed
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(thickness: 1),
                            _buildSettingsOption('Address', Icons.location_on, context, AddressPage(userId: userId)),
                            const Divider(thickness: 1),
                            _buildSettingsOption('Debit Card', Icons.credit_card, context, DebitCardPage(userId: userId)),
                            const Divider(thickness: 1),
                            _buildSettingsOption('Feedback', Icons.feedback, context, const FeedbackPage()),
                            const Divider(thickness: 1),
                            _buildSettingsOption('Customer Support', Icons.support_agent, context, const SupportPage()),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                              ),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to retrieve user ID. Please log in.')),
          );
        }
      });
    });

    // Empty Scaffold since the dialog will appear immediately
    return const Scaffold(
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSettingsOption(String title, IconData icon, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
