import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/cake_category_page.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, String>> bakeryItems = [
    {'title': 'Mini Cupcakes Cream Cheese', 'description': 'RM36-RM55', 'image': 'assets/mini_cupcakes_cream_cheese.png'},
    {'title': 'Mini Cupcakes Fresh Cream', 'description': 'RM30-RM40', 'image': 'assets/mini_cupcakes_fresh_cream.png'},
    {'title': 'Normal Size Cupcake Fresh Cream', 'description': 'RM2.30-RM3.00/pcs', 'image': 'assets/normal_cupcakes_fresh_cream.png'},
    {'title': 'Normal Size Cupcake Cream Cheese', 'description': 'RM3.50-RM3.80/pcs', 'image': 'assets/normal_cupcakes_cream_cheese.png'},
    {'title': 'Giant Cheese Tart 6 Inch', 'description': 'RM46-RM58', 'image': 'assets/giant_cheese_tart_6inch.png'},
    {'title': 'Giant Cheese Tart 7 Inch', 'description': 'RM56-RM68', 'image': 'assets/giant_cheese_tart_7inch.png'},
    {'title': 'Fruit Mini Tart', 'description': 'RM35-RM40', 'image': 'assets/tart.jpg'},
    {'title': 'Mini Cheese Tart 16 Pieces', 'description': 'RM34-RM38', 'image': 'assets/tart2.jpg'},
    {'title': 'Mini Cheese Tart 25 Pieces', 'description': 'RM55-RM58', 'image': 'assets/tart3.jpg'},
    {'title': 'Mini Cheese Tart 36 Pieces', 'description': 'RM43-RM58', 'image': 'assets/mini_cheese_tart_36.png'},
    {'title': 'Mini Cheese Tart 49 Pieces', 'description': 'RM59-RM78', 'image': 'assets/mini_cheese_tart_49.png'},
    {'title': 'Nutella Brownies', 'description': 'RM27-RM38', 'image': 'assets/nutella_brownies.png'},
    {'title': 'Cream Cheese and Nutella Brownies', 'description': 'RM30-RM45', 'image': 'assets/cream_cheese_nutella.png'},
    {'title': 'Peanuts Brownies', 'description': 'RM30-RM45', 'image': 'assets/peanuts_brownies.png'},
    {'title': 'Choux au Craquelin 25 Pieces', 'description': 'RM35-RM50', 'image': 'assets/choux_au_craquelin.png'},
    {'title': 'Cream Puff 25 Pieces', 'description': 'RM25-RM35', 'image': 'assets/cream_puff.png'},
    {'title': 'Fruit Choux 25 Pieces', 'description': 'RM35-RM40', 'image': 'assets/fruit_choux.png'},
    {'title': 'Kek Pisang', 'description': 'RM16-RM35', 'image': 'assets/kek_pisang.png'},
    {'title': 'Bun Sosej', 'description': 'RM20-RM30', 'image': 'assets/bun_sosej.png'},
    {'title': 'Party Set Sandwich', 'description': 'RM18-RM46', 'image': 'assets/sandwich.jpg'},
    {'title': 'Special Wedding Cake', 'description': 'RM150', 'image': 'assets/cake1.png'},
    {'title': 'Birthday Cake', 'description': 'RM80', 'image': 'assets/cake2.png'},
    {'title': 'Congratulations Cake', 'description': 'RM70', 'image': 'assets/cake3.png'},
    {'title': 'Dessert Cake', 'description': 'RM50', 'image': 'assets/cake4.png'},
    {'title': 'Apam@Moist 25 Pieces', 'description': 'RM30', 'image': 'assets/apam_moist.png'},
    {'title': 'Bite Size Cake 25 Pieces', 'description': 'RM35', 'image': 'assets/bite_size_cake.png'}
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
                hintText: 'Search...',
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
                        builder: (context) => const CakeCategoryPage(), 
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
