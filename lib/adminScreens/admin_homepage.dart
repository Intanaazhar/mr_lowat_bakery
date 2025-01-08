import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_menu.dart';
import 'package:mr_lowat_bakery/adminScreens/admincakes.dart';
import 'package:mr_lowat_bakery/adminScreens/admincheesecake.dart';
import 'package:mr_lowat_bakery/adminScreens/admintart.dart';
import 'package:mr_lowat_bakery/adminScreens/adminbrownies.dart';
import 'package:mr_lowat_bakery/adminScreens/admincupcake.dart';
import 'package:mr_lowat_bakery/adminScreens/adminothers.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/category_widgets.dart';

class AdminHomepage extends StatelessWidget {
  const AdminHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 225, 225),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 0,
        title: const Text(
          "Admin Home",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage('assets/homeAds.png'),
                fit: BoxFit.cover, // Ensures the image fits the width nicely
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Discover by category',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Slightly larger font size for emphasis
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminCakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminBurntCheesecakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cheesecake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminBrowniesPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/brownie.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminCheeseTartPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/egg-tart.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminCupcakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cupcake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminOthersPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/puffs.png'),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Most Ordered',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('items')
                    .where('isMostOrdered', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final mostOrderedItems = snapshot.data!.docs;

                if (mostOrderedItems.isEmpty) {
                  return const Center(child: Text("No most-ordered items available."));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: List.generate(mostOrderedItems.length, (index) {
                      final item = mostOrderedItems[index].data() as Map<String, dynamic>;
                      final docId = mostOrderedItems[index].id;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Column(
                          children: [
                            Container(
                              height: 150, // Fixed height to prevent overflow
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  item['image'] ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'RM ${item['price'] ?? ''}',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Update 'isMostOrdered' field to false
                                  FirebaseFirestore.instance
                                      .collection('cakes') // Adjust collection name dynamically if required
                                      .doc(docId)
                                      .update({'isMostOrdered': false});
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
