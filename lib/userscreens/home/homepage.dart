import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/brownies_category.dart';
import 'package:mr_lowat_bakery/userscreens/click_button_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/burntcheesecake_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/cake_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/most_ordered.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/category_widgets.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/cheesetart_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/cupcake_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/menu_widgets.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/others_category.dart';




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
        /*actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cart: cart),
                ),
              );
            },
          ),
        ],*/
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
              // Discover by Category
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Discover by category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Horizontal Scrollable Categories
              SizedBox(
                height: 150, // Limit the height of the scrolling area
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Action for Cake
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CakeCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cake.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Action for Cheesecake
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BurntCheesecakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cheesecake.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Action for Brownie
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BrowniesCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/brownie.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Action for Egg Tart
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheeseTartCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/egg-tart.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Action for Cupcake
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CupcakeCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cupcake.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Action for Puffs
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OthersCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/puffs.png'),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Most Ordered',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the new page when "View All" is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MostOrderedPage()),
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.blue, // Customize the color
                          fontWeight: FontWeight.w500, // Optional for styling
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MenuWidgets(
                            imagePath: 'assets/tart.jpg',
                            name: 'Mini Cheese Tart',
                            price: 'RM34.00-RM38.00',
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DescriptionPage())),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MenuWidgets(
                            imagePath: 'assets/brownies.jpg',
                            name: 'Nutella Brownies',
                            price: 'RM27.00-RM38.00',
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DescriptionPage())),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MenuWidgets(
                            imagePath: 'assets/cupcake.jpg',
                            name: 'Cupcake Fresh Cream',
                            price: 'RM2.30-RM3.00/pcs',
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const DescriptionPage())),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MenuWidgets(
                            imagePath: 'assets/puffs.jpg',
                            name: 'Cream Puffs 25 Pieces',
                            price: 'RM25.00-RM35.00',
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DescriptionPage())),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MenuWidgets(
                            imagePath: 'assets/tart1.png',
                            name: 'Mini Fruit Tart',
                            price: 'RM35',
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>const DescriptionPage())),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MenuWidgets(
                            imagePath: 'assets/cream_cheese_nutella.png',
                            name: 'Cream Cheese Brownies',
                            price: 'RM45',
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DescriptionPage())),
                          ),
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
