import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart';
import 'package:mr_lowat_bakery/userscreens/description_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/menu_widgets.dart';

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
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return MenuWidgets(
              imagePath: items[index]['image']!,
              name: items[index]['title']!,
              price: items[index]['price']!,
              onPressed: () {
                // Navigate to DescriptionPage with item details
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
            );
          },
        ),
      ),
    );
  }
}
