import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(
            Icons.shopping_cart,
            size: 50,
            color: Colors.black,
          ),
        ),
      ),
    
    );
  }
}
