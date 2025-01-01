import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/cake_category.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, String>> bakeryItems = [
    {
      'title': 'Burnt Cheese Cake',
      'description': '6-inch RM40 | 8-inch RM60',
      'image': 'assets/burnt_cheese_cake.png',
    },
    {
      'title': 'Giant Cheese Tart',
      'description': '6-inch RM46-58 | 7-inch RM56-68',
      'image': 'assets/giant_cheese_tart.png',
    },
    {
      'title': 'Mini Cheese Tart',
      'description': 'Original RM20 | Fruity Filling RM22 | Nutella Toppings RM26',
      'image': 'assets/mini_cheese_tart.png',
    },
    {
      'title': 'Mini Cupcakes Fresh Cream',
      'description': 'RM30-40',
      'image': 'assets/mini_cupcakes_fresh_cream.png',
    },
    {
      'title': 'Mini Cupcakes Cream Cheese',
      'description': 'RM36-55',
      'image': 'assets/mini_cupcakes_cream_cheese.png',
    },
    {
      'title': 'Normal Cupcakes Fresh Cream',
      'description': 'RM2.80/pcs',
      'image': 'assets/normal_cupcakes_fresh_cream.png',
    },
    {
      'title': 'Normal Cupcakes Cream Cheese',
      'description': 'RM3.50/pcs',
      'image': 'assets/normal_cupcakes_cream_cheese.png',
    },
    {
      'title': 'Cream Puff',
      'description': 'Fresh Cream RM25 | Cream Custard RM35 | Chocolate RM35 | Tiramisu RM35',
      'image': 'assets/cream_puff.png',
    },
    {
      'title': 'Choux au Craquelin',
      'description': 'Fresh Cream RM35 | Cream Custard RM45 | Chocolate RM50 | Tiramisu RM50',
      'image': 'assets/choux_au_craquelin.png',
    },
    {
      'title': 'Fruit Choux',
      'description': 'Fresh Cream RM35 | Cream Custard RM40 | Chocolate RM40 | Tiramisu RM40',
      'image': 'assets/fruit_choux.png',
    },
    {
      'title': 'Brownies',
      'description': '6-inch RM25-32 | 8-inch RM35-48',
      'image': 'assets/brownies.png',
    },
    {
      'title': 'Sponge Cake Simple Decoration',
      'description': 'RM35-90',
      'image': 'assets/sponge_cake.png',
    },
  ];

  List<Map<String, String>> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = bakeryItems;
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = bakeryItems
          .where((item) =>
              item['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => filterCategories(query),
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CakeCategoryPage(), // Navigate to CakeCategoryPage
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(category['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category['description']!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
