import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_nav_bar.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.orange.shade300,
      ),
      drawer: const AdminNavigationMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildDashboardCard(
              context,
              title: "Orders",
              icon: Icons.shopping_cart,
              onTap: () {
                // Navigate to Orders Page
              },
            ),
            _buildDashboardCard(
              context,
              title: "Products",
              icon: Icons.cake,
              onTap: () {
                // Navigate to Products Page
              },
            ),
            _buildDashboardCard(
              context,
              title: "Customers",
              icon: Icons.people,
              onTap: () {
                // Navigate to Customers Page
              },
            ),
            _buildDashboardCard(
              context,
              title: "Feedback",
              icon: Icons.feedback,
              onTap: () {
                // Navigate to Feedback Page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.orange.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48.0, color: Colors.white),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}