import 'package:flutter/material.dart';

class CupcakesCategoryPage extends StatefulWidget {
  const CupcakesCategoryPage({super.key});

  @override
  _CupcakesCategoryPageState createState() => _CupcakesCategoryPageState();
}

class _CupcakesCategoryPageState extends State<CupcakesCategoryPage> {
  final List<Map<String, String>> cupcakes = [
    {
      'image': 'assets/vanilla_cupcake.png',
      'title': 'Vanilla Cupcake',
      'price': 'RM15-RM25',
    },
    {
      'image': 'assets/chocolate_cupcake.png',
      'title': 'Chocolate Cupcake',
      'price': 'RM18-RM28',
    },
    {
      'image': 'assets/red_velvet_cupcake.png',
      'title': 'Red Velvet Cupcake',
      'price': 'RM20-RM30',
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
        title: const Text("Cupcakes Menu"),
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
          itemCount: cupcakes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return buildCard(cupcakes[index]);
          },
        ),
      ),
    );
  }

  Widget buildCard(Map<String, String> cupcake) {
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
                cupcake['image']!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cupcake['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              cupcake['price']!,
              style: const TextStyle(color: Colors.orange),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => addToCart(cupcake), // Add to cart on button press
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
