import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/address_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/debit_card_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/feedback_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/support_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/user_profile.dart';
import 'package:mr_lowat_bakery/userscreens/welcome.dart';
//import 'user_profile.dart';
//import 'address_page.dart';
//import 'debit_card_page.dart';
//import 'feedback_page.dart';
//import 'support_page.dart';
//import 'welcome.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

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
            _buildSettingsOption('Profile', Icons.person, context, const UserProfile()),
            _buildSettingsOption('Address', Icons.location_on, context, const AddressPage()),
            _buildSettingsOption('Debit Card', Icons.credit_card, context, const DebitCardPage()),
            _buildSettingsOption('Feedback', Icons.feedback, context, const FeedbackPage()),
            _buildSettingsOption('Customer Support', Icons.support_agent, context, const SupportPage()),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
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