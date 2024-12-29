import 'package:flutter/material.dart';
//import 'package:mr_lowat_bakery/screens/click_button_page.dart';
import 'package:mr_lowat_bakery/userscreens/description_page.dart';

class MenuWidgets extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;
  final VoidCallback onPressed; // Callback for the button press

  const MenuWidgets({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 246, 244), // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 6.0, // How much the shadow is blurred
            spreadRadius: 2.0, // How much the shadow spreads
            offset: const Offset(4.0, 4.0), // Position of the shadow (horizontal, vertical)
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ), // Round only top edges
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 50),
          // Name, Price, and Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name and Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                // Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                       builder: (context) => DescriptionPage(imagePath: '', name: '', price: '', onAddToCart: (item) {
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
