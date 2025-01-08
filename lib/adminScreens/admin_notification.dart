import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_nav_bar.dart';

class AdminCustomerFeedback extends StatelessWidget {
  const AdminCustomerFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    // Example feedback data
    final List<Map<String, String>> feedbackData = [
      {
        "name": "Nur Qistina",
        "message": "This new app is very convenient and user friendly.",
      },
      {
        "name": "Jay",
        "message": "Surprisingly, I can track my order progress!!",
      },
      {
        "name": "Alex",
        "message": "Great app, easy to use and visually appealing.",
      },
      {
        "name": "Sophia",
        "message": "Really love the features, especially the tracking!",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Customer Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
        ),
      ),
      drawer: const AdminNavigationMenu(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: feedbackData.length,
        itemBuilder: (context, index) {
          final feedback = feedbackData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: const Color.fromARGB(255, 255, 91, 145),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedback["name"] ?? "Anonymous",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    feedback["message"] ?? "No feedback provided.",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}