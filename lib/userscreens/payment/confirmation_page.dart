import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mr_lowat_bakery/userscreens/home/homepage.dart';

class ConfirmationPage extends StatelessWidget {
  final String userId;
  final String cartItemId;

  const ConfirmationPage({
    super.key,
    required this.userId,
    required this.cartItemId,
  });

  Future<void> _updateIsPaid() async {
    try {
      // Update the `isPaid` field in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .update({'isPaid': true});
    } catch (e) {
      // Log the error or handle it as needed
      debugPrint('Error updating isPaid: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the Firestore update function when the page is built
    _updateIsPaid();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Thank you for your payment.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Homepage(),
                  ), // Navigate to the home page
                  (route) => false, // Remove all previous routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
