import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/cake_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/category_widgets.dart';
import 'package:mr_lowat_bakery/userscreens/home/menu_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  get cart => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 225, 225),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white), // Changed icon here
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(image: AssetImage('assets/homeAds.png')),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Discover by category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CakeCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/cake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          print('Cheesecake clicked!');
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/cheesecake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          print('Brownie clicked!');
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/brownie.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          print('Egg Tart clicked!');
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/egg-tart.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          print('Cupcake clicked!');
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/cupcake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          print('Puffs clicked!');
                        },
                        child: const CustomRoundedContainer(
                            imagePath: 'assets/puffs.png'),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Most Ordered',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        MenuWidgets(
                          imagePath: 'assets/tart.jpg',
                          name: 'Egg Tart',
                          price: 'RM 5.00',
                          onPressed: () {},
                        ),
                        const SizedBox(height: 14),
                        MenuWidgets(
                          imagePath: 'assets/brownies.jpg',
                          name: 'Brownies',
                          price: 'RM 8.00',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        MenuWidgets(
                          imagePath: 'assets/cupcake.jpg',
                          name: 'Cupcake',
                          price: 'RM 6.00',
                          onPressed: () {},
                        ),
                        const SizedBox(height: 14),
                        MenuWidgets(
                          imagePath: 'assets/puffs.jpg',
                          name: 'Cream Puffs',
                          price: 'RM 4.00',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}