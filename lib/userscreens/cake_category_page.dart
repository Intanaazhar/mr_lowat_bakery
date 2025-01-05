import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/brownies_category_page.dart';

class CakeCategoryPage extends StatefulWidget {
  const CakeCategoryPage({super.key});

  @override
  _CakeCategoryPageState createState() => _CakeCategoryPageState();
}

class _CakeCategoryPageState extends State<CakeCategoryPage> {
  final List<Map<String, String>> items = [
    {
      'image': 'assets/cake1.png',
      'title': 'Special Wedding Cake',
      'price': 'RM150',
    },
    {
      'image': 'assets/cake2.png',
      'title': 'Birthday Cake',
      'price': 'RM80',
    },
    {
      'image': 'assets/cake3.png',
      'title': 'Congratulations Cake',
      'price': 'RM70',
    },
    {
      'image': 'assets/cake4.png',
      'title': 'Dessert Cake',
      'price': 'RM50',
    },
  ];

  final List<Map<String, String>> cart = []; // Cart to store selected items

  void addToCart(Map<String, String> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['title']} added to cart!"),
        duration: const Duration(seconds: 1),
      ),
    );
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
              // Navigate to CartPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cart: cart),
                ),
              );
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
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return buildCard(items[index]);
          },
        ),
      ),
    );
  }

  Widget buildCard(Map<String, String> item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                item['image']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item['price']!,
              style: const TextStyle(color: Colors.orange),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                addToCart(item); // Add to cart when pressed
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
