import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_homepage.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_notification.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_orderlist.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_menu.dart';

class AdminNavigationMenu extends StatelessWidget {
  const AdminNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminNavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          backgroundColor: Colors.pink, // Set the background color to pink
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.search_favorite), label: 'Search'),
            NavigationDestination(icon: Icon(Iconsax.clipboard), label: 'Order'),
            NavigationDestination(icon: Icon(Iconsax.notification), label: 'Notification'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class AdminNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  // Screens for each navigation destination
  final List<Widget> screens = [
    const AdminHomepage(), // Admin dashboard
    Container(color: Colors.blue), // Replace with actual Search screen
    const AdminOrderList(), // Admin order list
    const AdminCustomerFeedback(), // Notifications/feedback screen
    const AdminMenu(), // Admin profile menu
  ];
}
