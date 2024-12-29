import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart';

class BrowniesCategoryPage extends StatefulWidget {
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

  final List<Map<String, String>> cart = []; // List to store cart items

  void addToCart(Map<String, String> item) {
    setState(() {
      cart.add(item); // Add the item to the cart
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['title']} added to cart!"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brownies Menu"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Show cart or navigate to a cart page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
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
            return buildCard(brownies[index]);
          },
        ),
      ),
    );
  }

  Widget buildCard(Map<String, String> brownie) {
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
                brownie['image']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              brownie['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              brownie['price']!,
              style: const TextStyle(color: Colors.orange),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => addToCart(brownie), // Add to cart on button press
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
