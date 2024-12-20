import 'package:flutter/material.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
 _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
        backgroundColor: Colors.pink,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/CustomerLogin.jpg', // Ensure the image path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Form Content
          Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // First Name Field
                  buildTextField("First Name"),
                  const SizedBox(height: 20),
                  // Last Name Field
                  buildTextField("Last Name"),
                  const SizedBox(height: 20),
                  // Username Field
                  buildTextField("Username"),
                  const SizedBox(height: 20),
                  // Email Field
                  buildTextField("Email"),
                  const SizedBox(height: 20),
                  // Phone Number Field
                  buildTextField("Phone Number"),
                  const SizedBox(height: 20),
                  // Password Field
                  buildTextField("Password", obscureText: true),
                  const SizedBox(height: 30),
                  // Sign-Up Button
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                        ),
                        onPressed: () {
                          // Add your sign-up logic here
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build a text field
  Widget buildTextField(String hintText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }
}
