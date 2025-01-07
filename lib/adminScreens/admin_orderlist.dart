import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminOrderList(),
    );
  }
}

class AdminOrderList extends StatefulWidget {
  const AdminOrderList({super.key});

  @override
  _AdminOrderListState createState() => _AdminOrderListState();
}

class _AdminOrderListState extends State<AdminOrderList> {
  final List<String> orderStatuses = ["Accepted", "Processing", "Ready"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          "Order List",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders') // Replace with your collection name
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final docId = orders[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.cake, color: Colors.white),
                  ),
                  title: Text("Order ID: ${order['orderId'] ?? 'N/A'}"),
                  subtitle: Text("Customer: ${order['customerName'] ?? 'Unknown'}"),
                  trailing: ElevatedButton(
                    onPressed: () => _showOrderDetails(context, order, docId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Details"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order, String docId) {
    String selectedStatus = order['status'] ?? "Accepted";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text("Order Details"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${order['customerName'] ?? 'Unknown'}"),
                    Text("Booking Date: ${order['bookingDate'] ?? 'N/A'}"),
                    Text("Products: ${order['products'] ?? 'N/A'}"),
                    Text("Description: ${order['description'] ?? 'N/A'}"),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "Order Status",
                      ),
                      items: orderStatuses.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (newStatus) {
                        setState(() {
                          selectedStatus = newStatus!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('orders') // Replace with your collection name
                        .doc(docId)
                        .update({'status': selectedStatus});
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order status updated")),
                    );
                  },
                  child: const Text("Save"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
