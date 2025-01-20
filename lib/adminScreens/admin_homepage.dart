import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_menu.dart';
import 'package:mr_lowat_bakery/adminScreens/edit_products/admineditmenu.dart';
import 'package:mr_lowat_bakery/adminScreens/edit_products/admincakes.dart';
import 'package:mr_lowat_bakery/adminScreens/edit_products/admincheesecake.dart';
import 'package:mr_lowat_bakery/adminScreens/edit_products/admintart.dart';
import 'package:mr_lowat_bakery/adminScreens/edit_products/adminbrownies.dart';
import 'package:mr_lowat_bakery/adminScreens/edit_products/admincupcake.dart';
import 'package:mr_lowat_bakery/adminScreens/edit_products/adminothers.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/category_widgets.dart';

class AdminHomepage extends StatelessWidget {
  const AdminHomepage({super.key});

Future<void> toggleMostOrdered(
    String docId, String category, bool currentValue) async {
  try {
    await FirebaseFirestore.instance
        .collection(category)
        .doc(docId)
        .update({'isMostOrdered': !currentValue});
  } catch (e) {
    print("Error updating 'isMostOrdered': $e");
  }
}

Widget buildCategoryGridWithToggle(String category) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection(category).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final items = snapshot.data!.docs;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              category.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              final docId = items[index].id;

              return buildCardWithToggle(docId, item, category);
            },
          ),
        ],
      );
    },
  );
}

Widget buildCardWithToggle(String docId, Map<String, dynamic> item, String category) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 4,
    child: Column(
      children: [
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: item['image'].toString().startsWith('http')
                ? Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                    },
                  )
                : Image.asset(
                    item['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                    },
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'RM ${item['price']}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Switch(
              value: item['isMostOrdered'] ?? false,
              onChanged: (value) {
                toggleMostOrdered(
                  docId,
                  category,
                  item['isMostOrdered'] ?? false,
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}

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
              MaterialPageRoute(
                builder: (context) => const AdminMenu(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminEditMenu(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(image: AssetImage('assets/homeAds.png')),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Discover by category',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                            MaterialPageRoute(
                                builder: (context) => const AdminCakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/cake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminBurntCheesecakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/cheesecake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminBrowniesPage()),
                          );
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/brownie.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminCheeseTartPage()),
                          );
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/egg-tart.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminCupcakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/cupcake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminOthersPage()),
                          );
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/puffs.png'),
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
                  'Manage Most Ordered Items',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    buildCategoryGridWithToggle('cakes'),
                    const SizedBox(height: 20),
                    buildCategoryGridWithToggle('burntCheesecakes'),
                    const SizedBox(height: 20),
                    buildCategoryGridWithToggle('brownies'),
                    const SizedBox(height: 20),
                    buildCategoryGridWithToggle('cheeseTarts'),
                    const SizedBox(height: 20),
                    buildCategoryGridWithToggle('cupcakes'),
                    const SizedBox(height: 20),
                    buildCategoryGridWithToggle('others'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
