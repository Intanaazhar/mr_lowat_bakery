import 'package:flutter/material.dart';
import 'confirmation_page.dart';

class SPayPage extends StatelessWidget {
  const SPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController pinController = TextEditingController();

    void _processSPayPayment() {
      if (nameController.text.isNotEmpty && pinController.text.length == 6) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ConfirmationPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid name and 6-digit PIN.')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sarawak Pay'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Sarawak Pay',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your Sarawak Pay details to proceed:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '6-digit PIN',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                maxLength: 6,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _processSPayPayment,
                  child: const Text('Proceed to Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
