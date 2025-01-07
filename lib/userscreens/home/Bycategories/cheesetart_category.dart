import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/description_page.dart';

class CheeseTartCategoryPage extends StatefulWidget {
  const CheeseTartCategoryPage({super.key});

  @override
  _CheeseTartCategoryPageState createState() => _CheeseTartCategoryPageState();
}

class _CheeseTartCategoryPageState extends State<CheeseTartCategoryPage> {
  final List<Map<String, String>> cheeseTarts = [
    {'image': 'assets/giant_cheese_tart_6inch.png', 'title': 'Giant Cheese Tart 6 Inch', 'price': 'RM46-RM58'},
    {'image': 'assets/giant_cheese_tart_7inch.png', 'title': 'Giant Cheese Tart 7 Inch', 'price': 'RM56-RM68'},
    {'image': 'assets/tart.jpg', 'title': 'Fruit Mini Tart', 'price': 'RM35-RM40'},
    {'image': 'assets/tart2.jpg', 'title': 'Mini Cheese Tart 16 Pieces', 'price': 'RM34-RM38'},
    {'image': 'assets/tart3.jpg', 'title': 'Mini Cheese Tart 25 Pieces', 'price': 'RM55-RM58'},
    {'image': 'assets/mini_cheese_tart_36.png', 'title': 'Mini Cheese Tart 36 Pieces', 'price': 'RM43-RM58'},
    {'image': 'assets/mini_cheese_tart_49.png', 'title': 'Mini Cheese Tart 49 Pieces', 'price': 'RM59-RM78'},
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
        title: const Text("Cheese Tart Menu"),
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
          itemCount: cheeseTarts.length,
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
                        cheeseTarts[index]['image']!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          cheeseTarts[index]['title']!,
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
                        cheeseTarts[index]['price']!,
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
                              imagePath: cheeseTarts[index]['image']!,
                              name: cheeseTarts[index]['title']!,
                              price: cheeseTarts[index]['price']!,
                              onAddToCart: () {
                                addToCart(cheeseTarts[index]);
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
