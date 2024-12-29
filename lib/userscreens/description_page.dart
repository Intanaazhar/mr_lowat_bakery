import 'package:flutter/material.dart';

class DescriptionPage extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;
  final Function(Map<String, String>) onAddToCart;

  const DescriptionPage({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cake Preferences"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 16),
            Text(
              'Choose your preferences',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  _buildOptionRow('Size', ['3 inches', '5 inches']),
                  _buildOptionRow('Flavour', ['Chocolate', 'Vanilla', 'Pandan', 'Mocha']),
                  _buildOptionRow('Topper Theme', ['Roses', 'Stars', 'Custom']),
                  _buildDatePicker(context),
                  _buildToggleOption('Add on Knife, Candle, Box'),
                  _buildOptionRow('Payment Option', ['Deposit', 'Full payment']),
                  const SizedBox(height: 20),
                  _buildMoreToExplore(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onAddToCart({
                      'image': imagePath,
                      'title': name,
                      'price': price,
                    });
                    Navigator.pop(context); // Return to previous page
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text("Add to Cart"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showOverlay(context, 'Add a Comment');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Add a Comment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10.0,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: false, // Add selection logic here
              onSelected: (selected) {},
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Date',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                // Handle selected date
              },
              child: const Text('Select Date'),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildToggleOption(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Switch(
          value: false, // Add toggle logic here
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildMoreToExplore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'More to Explore',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildExploreCard('assets/explore1.png', 'Cake Design A'),
              _buildExploreCard('assets/explore2.png', 'Cake Design B'),
              _buildExploreCard('assets/explore3.png', 'Cake Design C'),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildExploreCard(String imagePath, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showOverlay(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (title == 'Add a Comment') ...[
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter your comment',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
              ] else if (title == 'Book Now') ...[
                const Text(
                  'Confirm your booking details.',
                  style: TextStyle(fontSize: 16),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Confirm booking logic
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Confirm'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
