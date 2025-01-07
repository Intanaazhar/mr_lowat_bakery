import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final String userId;

  const CheckoutPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('order')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          final orders = snapshot.data!.docs;
          double totalPrice = 0;

          // Calculate total price
          orders.forEach((order) {
            totalPrice += order['price'];
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Image.network(order['imageUrl']),
                      title: Text(order['name']),
                      subtitle: Text('\$${order['price']}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Proceed to order confirmation page
                },
                child: const Text('Confirm Order'),
              ),
            ],
          );
        },
      ),
    );
  }
}
