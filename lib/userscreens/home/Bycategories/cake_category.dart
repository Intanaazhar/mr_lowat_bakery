import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/description_page.dart';

class CakeCategoryPage extends StatefulWidget {
  const CakeCategoryPage({super.key});

  @override
  _CakeCategoryPageState createState() => _CakeCategoryPageState();
}

class _CakeCategoryPageState extends State<CakeCategoryPage> {
  final List<Map<String, String>> items = [
    {'image': 'assets/cake1.png','title': 'Special Wedding Cake','price': 'RM150',},
    {'image': 'assets/cake2.png','title': 'Birthday Cake','price': 'RM80',},
    {'image': 'assets/cake3.png','title': 'Congratulations Cake','price': 'RM70',},
    {'image': 'assets/cake4.png','title': 'Dessert Cake','price': 'RM50',},
    {'image': 'assets/apam_moist.png', 'title': 'Apam@Moist 25 Pieces', 'price': 'RM30'},
    {'image': 'assets/bite_size_cake.png', 'title': 'Bite Size Cake 25 Pieces', 'price': 'RM35'},
  ];

  // Add the selected item to Firebase cart collection
  void addToCart(Map<String, String> item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart') // Firebase collection for cart items
            .add({
          'name': item['title'],
          'imageUrl': item['image'],
          'price': item['price'],
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show snack bar to confirm addition to cart
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${item['title']} added to cart!"),
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error adding to cart: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cake Menu"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(userId: user.uid),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8, // Adjust aspect ratio
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        items[index]['image']!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          items[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        items[index]['price']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionPage(
                              imagePath: items[index]['image']!,
                              name: items[index]['title']!,
                              price: items[index]['price']!,
                              onAddToCart: () {
                                addToCart(items[index]);
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24, // Bigger size
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
