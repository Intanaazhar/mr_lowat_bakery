import 'package:flutter/material.dart';
import 'CustomizeOrderPage.dart';

class CakeCategoryPage extends StatefulWidget {
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
      'title': 'Congratulations Cake with Extra Details',
      'price': 'RM70',
    },
    {
      'image': 'assets/cake4.png',
      'title': 'Dessert Cake for Any Occasion',
      'price': 'RM50',
    },
  ];

  final List<Map<String, dynamic>> cart = []; // Cart to store selected items

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item['title']} successfully added to cart!"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cake Menu"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Show cart items in a simple dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Cart Items"),
                    content: cart.isEmpty
                        ? Text("Your cart is empty.")
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: cart
                                .map((item) => ListTile(
                                      title: Text(item['title']),
                                      subtitle: Text(item['price']),
                                    ))
                                .toList(),
                          ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75, // Adjust aspect ratio for better fit
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                item['image']!,
                fit: BoxFit.cover, // Ensure the image fits properly
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item['title']!,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 1, // Limit to 1 line
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item['price']!,
              style: TextStyle(color: Colors.orange),
              textAlign: TextAlign.center, // Center-align the price
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomizeOrderPage(
                      item: item,
                      addToCart: addToCart,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
