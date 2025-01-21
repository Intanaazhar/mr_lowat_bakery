import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // Define process stages as a static constant list
  static const List<String> processStages = ["Accepted", "Processing", "Ready", "Completed"];

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
                    final currentStatus = item['status'] ?? 'Pending';
                    final bookingDate = item['bookingDate'] ?? 'Unknown Date';
                    final isCancelled = item['isCancelled'] ?? false;
                    final isIgnored = item['isIgnored'] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          itemName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          isCancelled
                              ? 'This order has been cancelled. Please contact support for further assistance.'
                              : isIgnored
                                  ? 'Your order was cancelled due to no action taken by the admin. We apologize for the inconvenience.'
                                  : _getNotificationMessage(currentStatus, bookingDate),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            _showOrderDetails(context, item, currentStatus, isCancelled, isIgnored);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String _getNotificationMessage(String status, String bookingDate) {
    switch (status) {
      case "Accepted":
        return 'Your order has been accepted and is being prepared.';
      case "Processing":
        return 'Your order is currently being processed in the kitchen.';
      case "Ready":
        return 'Your order is ready for pickup or delivery on $bookingDate.';
      case "Completed":
        return 'Your order has been successfully completed. Thank you for your purchase!';
      default:
        return 'Your order is awaiting confirmation.';
    }
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> orderData, String status, bool isCancelled, bool isIgnored) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(orderData['name'] ?? 'Order Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking Date: ${orderData['bookingDate'] ?? 'N/A'}'),
              Text('Pickup Option: ${orderData['pickupOption'] ?? 'Unknown'}'),
              const SizedBox(height: 10),
              if (isCancelled)
                const Text(
                  'This order was cancelled and refunded. Please contact support if you have any questions.',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
              if (isIgnored)
                const Text(
                  'This order was automatically cancelled due to no action taken by the admin. We apologize for the inconvenience. Refund is made.',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
              if (!isCancelled && !isIgnored)
                Text(
                  'Current Status: $status',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              if (status == "Completed")
                const Text(
                  'Your order is completed. Thank you!',
                  style: TextStyle(fontSize: 14),
                ),
              if (status == "Ready")
                const Text(
                  'Your order is ready for pickup or delivery.',
                  style: TextStyle(fontSize: 14),
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
