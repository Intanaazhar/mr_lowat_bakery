import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/description_page.dart';

class BrowniesCategoryPage extends StatefulWidget {
  const BrowniesCategoryPage({super.key});

  @override
  _BrowniesCategoryPageState createState() => _BrowniesCategoryPageState();
}

class _BrowniesCategoryPageState extends State<BrowniesCategoryPage> {
  final List<Map<String, String>> brownies = [
    {
      'image': 'assets/nutella_brownies.png',
      'title': 'Nutella Brownies',
      'price': 'RM27-RM38',
    },
    {
      'image': 'assets/cream_cheese_nutella.png',
      'title': 'Cream Cheese and Nutella Brownies',
      'price': 'RM30-RM45',
    },
    {
      'image': 'assets/peanuts_brownies.png',
      'title': 'Peanuts Brownies',
      'price': 'RM30-RM45',
    },
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
        title: const Text("Brownies Menu"),
        backgroundColor: Colors.orange,
        actions: [
          // Shopping Cart Icon
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
          itemCount: brownies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
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
                        brownies[index]['image']!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          brownies[index]['title']!,
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
                        brownies[index]['price']!,
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
                              imagePath: brownies[index]['image']!,
                              name: brownies[index]['title']!,
                              price: brownies[index]['price']!,
                              onAddToCart: () {
                                addToCart(brownies[index]);
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
