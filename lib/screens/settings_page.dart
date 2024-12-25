// settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildSettingsOption('Profile', Icons.person, context),
          _buildSettingsOption('Address', Icons.location_on, context),
          _buildSettingsOption('Debit Card', Icons.credit_card, context),
          _buildSettingsOption('Feedback', Icons.feedback, context),
          _buildSettingsOption('Customer Support', Icons.support_agent, context),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(String title, IconData icon, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(fontSize: 18.0)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        // Add navigation logic for each option
      },
    );
  }
}
