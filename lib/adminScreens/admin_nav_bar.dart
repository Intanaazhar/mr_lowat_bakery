import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_menu.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_orderlist.dart';
//import 'package:mr_lowat_bakery/adminScreens/adminHomepage.dart';


class AdminNavigationMenu extends StatelessWidget {
  const AdminNavigationMenu({super.key});

@override
Widget build(BuildContext context) {
  final controller =Get.put(AdminNavigationController());

  return Scaffold(
    bottomNavigationBar: Obx(
      ()=> NavigationBar(
        height: 80,
        elevation:0,
        backgroundColor: Colors.orange, // Set the background color to orange
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
    body: Obx(()=> controller.screens[controller.selectedIndex.value]),
   );
  }
}

class AdminNavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;
  //to edit more
  final screens = [Container(color: Colors.pink),Container(color: Colors.blue),const AdminOrderList(),Container(color: Colors.grey), const AdminMenu()];
}