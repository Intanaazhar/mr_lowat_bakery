import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, String>> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(cart[index]['image']!),
            title: Text(cart[index]['title']!),
            subtitle: Text(cart[index]['price']!),
            trailing: const Icon(Icons.delete, color: Colors.red),
          );
        },
      ),
    );
  }
}