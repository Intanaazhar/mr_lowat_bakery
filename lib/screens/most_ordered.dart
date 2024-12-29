import 'package:flutter/material.dart';

class MostOrderedPage extends StatefulWidget {
  const MostOrderedPage({super.key});

  @override
  _MostOrderedPageState createState() => _MostOrderedPageState();
}

class _MostOrderedPageState extends State<MostOrderedPage> {
  final List<Map<String, String>> mostOrderedItems = [
    {
      'image': 'assets/cake1.png',
      'title': 'Special Wedding Cake',
      'price': 'RM150',
      'type': 'Cake',
    },
    {
      'image': 'assets/cake2.png',
      'title': 'Birthday Cake',
      'price': 'RM80',
      'type': 'Cake',
    },
    {
      'image': 'assets/nutella_brownies.png',
      'title': 'Nutella Brownies',
      'price': 'RM35',
      'type': 'Brownie',
    },
    {
      'image': 'assets/tart1.png',
      'title': 'Mini Fruit Tart',
      'price': 'RM35',
      'type': 'Tart',
    },
    {
      'image': 'assets/tart2.png',
      'title': 'Original Tart',
      'price': 'RM34',
      'type': 'Tart',
    },
    {
      'image': 'assets/cream_cheese_nutella.png',
      'title': 'Cream Cheese Brownies',
      'price': 'RM45',
      'type': 'Brownie',
    },
  ];

  final List<Map<String, String>> cart = []; // Cart list

  void addToCart(Map<String, String> item) {
    setState(() {
      cart.add(item); // Add item to cart
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
        title: const Text("Most Ordered"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
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
          itemCount: mostOrderedItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return buildCard(mostOrderedItems[index]);
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
              style: const TextStyle(backgroundColor: Colors.orange),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => addToCart(item),
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
