import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.orange,
      ),
      body: user == null
          ? const Center(
              child: Text('Please log in to view your notifications.'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('cart')
                  .where('isPaid', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No notifications available.'),
                  );
                }

                final items = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index].data() as Map<String, dynamic>;
                    final itemName = item['name'] ?? 'Unknown Item';
                    final isCancelled = item['isCancelled'] ?? false;
                    final isAccepted = item['isAccepted'] ?? false;
                    final requiredDate = item['requiredDate'] ?? 'Unknown Date';
                    final cartItemId = items[index].id;

                    List<Widget> notifications = [];

                    // Default notification for isPaid=true
                    notifications.add(
                      Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(itemName),
                          subtitle: const Text(
                              'Your order has been paid. The bakery has been notified.'),
                          trailing: IconButton(
                            icon: const Icon(Icons.info_outline, color: Colors.blue),
                            onPressed: () {
                              _showOrderDetails(context, item, cartItemId);
                            },
                          ),
                        ),
                      ),
                    );

                    // Notification for isAccepted=true
                    if (isAccepted) {
                      notifications.add(
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(itemName),
                            subtitle: const Text(
                                'Your order has been accepted by the bakery and is now in the kitchen.'),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline, color: Colors.blue),
                              onPressed: () {
                                _showOrderDetails(context, item, cartItemId);
                              },
                            ),
                          ),
                        ),
                      );
                    }

                    // Notification for isCancelled=true
                    if (isCancelled) {
                      notifications.add(
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(itemName),
                            subtitle: Text(
                              'Your order scheduled for delivery on $requiredDate was not accepted by the bakery. A refund is in progress. Please contact the bakery for further information.',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline, color: Colors.blue),
                              onPressed: () {
                                _showOrderDetails(context, item, cartItemId);
                              },
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: notifications,
                    );
                  },
                );
              },
            ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> orderData, String cartItemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(orderData['name'] ?? 'Order Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: RM${orderData['price'] ?? 'N/A'}'),
              Text('Pickup Option: ${orderData['pickupOption'] ?? 'Unknown'}'),
              Text('Booking Date: ${orderData['bookingDate'] ?? 'N/A'}'),
              const SizedBox(height: 10),
              Text(
                orderData['isCancelled'] == true
                    ? 'Status: Cancelled'
                    : (orderData['isAccepted'] == true
                        ? 'Status: Accepted'
                        : 'Status: Pending'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
