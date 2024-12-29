import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/address_page.dart';
import 'package:mr_lowat_bakery/userscreens/debit_card_page.dart';
import 'package:mr_lowat_bakery/userscreens/feedback_page.dart';
import 'package:mr_lowat_bakery/userscreens/support_page.dart';
import 'package:mr_lowat_bakery/userscreens/edit_profile.dart';
import 'package:mr_lowat_bakery/userscreens/welcome.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            // Navigate to Edit Profile
            _buildSettingsOption('Edit Profile', Icons.person, context, const EditProfile()),

            // Navigate to Address Page
            _buildSettingsOption('Address', Icons.location_on, context, const AddressPage()),

            // Navigate to Debit Card Page
            _buildSettingsOption('Debit Card', Icons.credit_card, context, const DebitCardPage()),

            // Navigate to Feedback Page
            _buildSettingsOption('Feedback', Icons.feedback, context, const FeedbackPage()),

            // Navigate to Customer Support Page
            _buildSettingsOption('Customer Support', Icons.support_agent, context, const SupportPage()),

            const SizedBox(height: 30.0),
            // Log Out Button
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        // Cancel button
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        // Confirm Log Out
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const BakeryWelcomeScreen()),
                              (route) => false, // Remove all previous routes
                            );
                          },
                          child: const Text('Log Out'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 15.0,
                ),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each settings option
  Widget _buildSettingsOption(String title, IconData icon, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        // Navigate to the specific page when tapped
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
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
