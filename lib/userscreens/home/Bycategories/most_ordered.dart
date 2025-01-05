import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/description_page.dart';

class MostOrderedPage extends StatefulWidget {
  const MostOrderedPage({super.key});

  @override
  _MostOrderedPageState createState() => _MostOrderedPageState();
}

class _MostOrderedPageState extends State<MostOrderedPage> {
  final List<Map<String, String>> mostOrderedItems = [
    {'image': 'assets/tart.jpg', 'title': 'Mini Cheese Tart', 'price': 'RM34.00-RM38.00'},
    {'image': 'assets/brownies.jpg', 'title': 'Nutella Brownies', 'price': 'RM27.00-RM38.00'},
    {'image': 'assets/cupcake.jpg', 'title': 'Cupcake Fresh Cream', 'price': 'RM2.30-RM3.00/pcs'},
    {'image': 'assets/puffs.jpg', 'title': 'Cream Puffs', 'price': 'RM25.00-RM35'},
    {'image': 'assets/cake1.png', 'title': 'Special Wedding Cake', 'price': 'RM150'},
    {'image': 'assets/cake2.png', 'title': 'Birthday Cake', 'price': 'RM80'},
    {'image': 'assets/nutella_brownies.png', 'title': 'Nutella Brownies', 'price': 'RM35'},
    {'image': 'assets/tart1.png', 'title': 'Mini Fruit Tart', 'price': 'RM35'},
    {'image': 'assets/tart2.png', 'title': 'Original Tart', 'price': 'RM34'},
    {'image': 'assets/cream_cheese_nutella.png', 'title': 'Cream Cheese Brownies', 'price': 'RM45'},
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
            childAspectRatio: 0.8, // Adjust aspect ratio
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            Map<String, String> item = mostOrderedItems[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        item['image']!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item['price']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionPage(
                              imagePath: item['image']!,
                              name: item['title']!,
                              price: item['price']!,
                              onAddToCart: () {
                                addToCart(item);
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24, // Bigger size
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
