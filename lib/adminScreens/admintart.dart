import 'package:flutter/material.dart';

class TartCategoryPage extends StatefulWidget {
  const TartCategoryPage({super.key});

  @override
  _TartCategoryPageState createState() => _TartCategoryPageState();
}

class _TartCategoryPageState extends State<TartCategoryPage> {
  final List<Map<String, String>> tarts = [
    {
      'image': 'assets/fruit_tart.png',
      'title': 'Fruit Tart',
      'price': 'RM25-RM35',
    },
    {
      'image': 'assets/cheese_tart.png',
      'title': 'Cheese Tart',
      'price': 'RM28-RM40',
    },
    {
      'image': 'assets/chocolate_tart.png',
      'title': 'Chocolate Tart',
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
        title: const Text("Tart Menu"),
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
          itemCount: tarts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return buildCard(tarts[index]);
          },
        ),
      ),
    );
  }

  Widget buildCard(Map<String, String> tart) {
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
                tart['image']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tart['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              tart['price']!,
              style: const TextStyle(color: Colors.orange),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => addToCart(tart), // Add to cart on button press
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, String>> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(cart[index]['image']!),
            title: Text(cart[index]['title']!),
            subtitle: Text(cart[index]['price']!),
            trailing: const Icon(Icons.delete, color: Colors.red),
          );
        },
      ),
    );
  }
}
