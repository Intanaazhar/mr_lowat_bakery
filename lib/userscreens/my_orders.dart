import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back to Profile
          },
        ),
        title: const Text('My Orders'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Horizontal Scroll Tabs
          Container(
            height: 50,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTabButton(context, 'To Pay', Colors.orange),
                _buildTabButton(context, 'To Deliver', Colors.green),
                _buildTabButton(context, 'To Receive', Colors.blue),
                _buildTabButton(context, 'Cancel/Refund', Colors.red),
                _buildTabButton(context, 'Completed', Colors.purple),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildOrderCard(
                  context,
                  imagePath: 'assets/brownies.jpg',
                  title: 'Nutella Brownies',
                  price: 'RM27.00',
                  status: 'To Pay',
                  statusColor: Colors.orange,
                ),
                _buildOrderCard(
                  context,
                  imagePath: 'assets/cake1.png',
                  title: 'Special Wedding Cake',
                  price: 'RM150.00',
                  status: 'Ready to Deliver',
                  statusColor: Colors.green,
                ),
                _buildOrderCard(
                  context,
                  imagePath: 'assets/tart.jpg',
                  title: 'Mini Cheese Tart',
                  price: 'RM35.00',
                  status: 'Arriving Soon',
                  statusColor: Colors.blue,
                ),
                _buildOrderCard(
                  context,
                  imagePath: 'assets/brownies.jpg',
                  title: 'Cream Cheese Brownies',
                  price: 'RM45.00',
                  status: 'Cancelled',
                  statusColor: Colors.red,
                ),
                _buildOrderCard(
                  context,
                  imagePath: 'assets/cupcake.jpg',
                  title: 'Cupcake Fresh Cream',
                  price: 'RM30.00',
                  status: 'Completed',
                  statusColor: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String title, Color color) {
    return GestureDetector(
      onTap: () {
        // Logic for handling tab changes goes here
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context,
      {required String imagePath,
      required String title,
      required String price,
      required String status,
      required Color statusColor}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 80),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price: $price',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  status,
                  style: TextStyle(fontSize: 14, color: statusColor),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                  ),
                  onPressed: () {
                    // Button logic goes here
                  },
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
