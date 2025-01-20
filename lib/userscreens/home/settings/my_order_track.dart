import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//TAK PAKAI 
class OrderTracker extends StatelessWidget {
  final String userId;
  final String orderId;

  const OrderTracker({super.key, required this.userId, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracker'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Order not found or has been removed."),
            );
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final currentStatus = orderData['status'] ?? 'Accepted';

          // Define process stages with additional stages
          final processStages = ["Accepted", "Processing", "Ready", "Completed"];
          final steps = processStages.map((stage) {
            return OrderStepData(
              title: stage,
              isCompleted: processStages.indexOf(currentStatus) >= processStages.indexOf(stage),
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Track Your Order Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Column(
                  children: List.generate(steps.length, (index) {
                    return Column(
                      children: [
                        _buildOrderStep(steps[index]),
                        if (index < steps.length - 1)
                          _buildVerticalDivider(steps[index].isCompleted),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 20),
                _buildOrderDetails(orderData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderStep(OrderStepData step) {
    return Row(
      children: [
        Icon(
          step.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: step.isCompleted ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 10),
        Text(
          step.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: step.isCompleted ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isActive) {
    return Container(
      height: 30,
      width: 2,
      color: isActive ? Colors.green : Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
  }

  Widget _buildOrderDetails(Map<String, dynamic> orderData) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Item: ${orderData['name'] ?? 'N/A'}"),
            Text("Flavour: ${orderData['flavour'] ?? 'N/A'}"),
            Text("Pickup Option: ${orderData['pickupOption'] ?? 'N/A'}"),
            Text("Price: \$${orderData['price']?.toStringAsFixed(2) ?? 'N/A'}"),
            Text("Current Status: ${orderData['status'] ?? 'N/A'}"),
          ],
        ),
      ),
    );
  }
}

class OrderStepData {
  final String title;
  final bool isCompleted;

  OrderStepData({required this.title, required this.isCompleted});
}
