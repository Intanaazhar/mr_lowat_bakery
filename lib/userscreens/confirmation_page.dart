import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mr_lowat_bakery/userscreens/home/navigation_bar.dart';
//import 'package:mr_lowat_bakery/lib/userscreens/home/navigation_bar.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Confirmation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Payment Successful!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'You will receive the order confirmation email shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              minimumSize: const Size(200, 50),
            ),
           onPressed: () {
              // Use Get to navigate back to NavigationMenu and reset to Home
              final controller = Get.find<NavigationController>();
              controller.selectedIndex.value = 0; // Set Home as selected
              Get.offAll(() => const NavigationMenu());
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
