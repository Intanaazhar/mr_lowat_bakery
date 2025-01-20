import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminUpdates extends StatefulWidget {
  const AdminUpdates({super.key});

  @override
  _AdminUpdatesState createState() => _AdminUpdatesState();
}

class _AdminUpdatesState extends State<AdminUpdates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No orders available."),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final cartId = orders[index].id;
              final userId = orders[index].reference.parent.parent?.id;

              if (userId == null) {
                return const SizedBox.shrink();
              }

              final isCancelled = order['isCancelled'] ?? false;
              final isAccepted = order['isAccepted'] ?? false;
              final productName = order['name'] ?? 'Unknown Product';
              final bookingDate = _parseDate(order['bookingDate']);
              final countdownText = _getCountdownText(bookingDate);

              // Automatically cancel overdue bookings only when isAccepted and isCancelled are false
              if (bookingDate != null &&
                  bookingDate.isBefore(DateTime.now()) &&
                  !isCancelled &&
                  !isAccepted) {
                _autoCancelOrder(userId: userId, cartId: cartId);
              }

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading user...");
                      }

                      final user = userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
                      final userName = user['firstName'] ?? 'Unknown User';

                      if (isCancelled) {
                        return Text(
                          'Automatically cancelled because booking day passed. We will notify the customer.\nOrder details: $productName',
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                        );
                      }

                      if (isAccepted) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order by $userName is accepted.',
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              countdownText,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$userName has ordered $productName',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            countdownText,
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      );
                    },
                  ),
                  subtitle: !isCancelled && !isAccepted
                      ? const Text(
                          'Action required.',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        )
                      : null,
                  trailing: !isCancelled && !isAccepted
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _updateOrderStatus(
                                userId: userId,
                                cartId: cartId,
                                isCancelled: false,
                                isAccepted: true,
                              ),
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                              tooltip: 'Accept',
                            ),
                            IconButton(
                              onPressed: () => _updateOrderStatus(
                                userId: userId,
                                cartId: cartId,
                                isCancelled: true,
                                isAccepted: false,
                              ),
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              tooltip: 'Cancel',
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> _fetchOrders() async {
    try {
      List<QueryDocumentSnapshot> allOrders = [];
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      for (var userDoc in usersSnapshot.docs) {
        final cartSnapshot = await userDoc.reference
            .collection('cart')
            .where('isPaid', isEqualTo: true)
            .get();
        allOrders.addAll(cartSnapshot.docs);
      }
      return allOrders;
    } catch (e) {
      debugPrint("Error fetching orders: $e");
      return [];
    }
  }

  void _updateOrderStatus({
    required String userId,
    required String cartId,
    required bool isCancelled,
    required bool isAccepted,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartId);

      if (isCancelled) {
        await docRef.update({'isCancelled': true, 'isAccepted': false});
      } else if (isAccepted) {
        await docRef.update({
          'isAccepted': true,
          'isCancelled': false,
        });
      }

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isAccepted ? 'Order accepted' : 'Order cancelled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating order: $e')),
      );
    }
  }

  void _autoCancelOrder({required String userId, required String cartId}) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartId);

      await docRef.update({'isCancelled': true, 'isAccepted': false});
      setState(() {});
    } catch (e) {
      debugPrint('Error auto-cancelling order: $e');
    }
  }

  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    try {
      return DateTime.parse(date.toString());
    } catch (_) {
      return null;
    }
  }

  String _getCountdownText(DateTime? bookingDate) {
    if (bookingDate == null) return 'Booking date: N/A';
    final today = DateTime.now();
    final difference = bookingDate.difference(today).inDays;

    if (difference > 0) {
      return 'Booking in $difference days';
    } else if (difference == 0) {
      return 'Happening today!';
    } else {
      return 'Overdue by ${-difference} days';
    }
  }
}
