import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final String userId;

  const CartPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.orange, // Set app bar color to orange
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final orders = snapshot.data!.docs;

          final cartItems = orders.map((order) {
            var orderData = order.data() as Map<String, dynamic>;
            return {
              'imagePath': orderData['imagePath'],
              'name': orderData['name'],
              'price': orderData['price'],
            };
          }).toList();

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              var cartItem = cartItems[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Image.asset(
                          cartItem['imagePath'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem['name'],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                cartItem['price'],
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Add edit functionality here
                              },
                              child: const Text('Edit'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Add individual item checkout functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange, // Set background color to orange
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: const Text('Checkout'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
