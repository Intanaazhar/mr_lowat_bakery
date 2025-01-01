import 'package:flutter/material.dart';

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

  void editBrownie(int index) {
    // Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Edit ${brownies[index]['title']}"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void deleteBrownie(int index) {
    setState(() {
      brownies.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Item deleted successfully!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brownies Menu - Admin"),
        backgroundColor: Colors.orange,
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
            return buildCard(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new brownie functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Add new brownie functionality not implemented."),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildCard(int index) {
    final brownie = brownies[index];
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => editBrownie(index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteBrownie(index),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
