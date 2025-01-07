import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/check_out_pages.dart';

class CartPage extends StatelessWidget {
  final String userId;

  const CartPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
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
            return const Center(child: Text('Your cart is empty.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(order['imageUrl']),
                title: Text(order['name']),
                subtitle: Text('\$${order['price']}'),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // Navigate to Checkout page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(userId: userId),
            ),
          );
        },
        child: const Text('Proceed to Checkout'),
      ),
    );
  }
}
