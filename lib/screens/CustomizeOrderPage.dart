import 'package:flutter/material.dart';

class CustomizeOrderPage extends StatefulWidget {
  final Map<String, String> item;
  final Function(Map<String, dynamic>) addToCart;

  CustomizeOrderPage({required this.item, required this.addToCart});

  @override
  _CustomizeOrderPageState createState() => _CustomizeOrderPageState();
}

class _CustomizeOrderPageState extends State<CustomizeOrderPage> {
  String selectedSize = "3 Inch";
  String selectedFlavor = "Chocolate";
  String topperTheme = "";
  DateTime? bookingDate;
  String pickupOption = "Self Pickup";
  String paymentOption = "Deposit";
  bool addExtras = false;

  void addToCart() {
    Map<String, dynamic> customizedItem = {
      ...widget.item,
      'size': selectedSize,
      'flavor': selectedFlavor,
      'topperTheme': topperTheme,
      'bookingDate': bookingDate?.toIso8601String() ?? "No date selected",
      'pickupOption': pickupOption,
      'paymentOption': paymentOption,
      'addExtras': addExtras,
    };
    widget.addToCart(customizedItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customize ${widget.item['title']}"),
        backgroundColor: Colors.orange,
      ),
      body: Row(
        children: [
          // Categories on the left
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            color: Colors.grey[200],
            child: ListView(
              children: [
                ListTile(title: Text("Cakes", style: TextStyle(fontWeight: FontWeight.bold))),
                ListTile(title: Text("Brownies")),
                ListTile(title: Text("Cupcakes")),
                ListTile(title: Text("Pastries")),
              ],
            ),
          ),
          // Customization options on the right
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(widget.item['image']!, height: 200, fit: BoxFit.cover),
                  SizedBox(height: 10),
                  Text(
                    "Choose your preferences:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text("Size:"),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text("3 Inch"),
                        selected: selectedSize == "3 Inch",
                        onSelected: (_) => setState(() => selectedSize = "3 Inch"),
                      ),
                      SizedBox(width: 5),
                      ChoiceChip(
                        label: Text("5 Inch"),
                        selected: selectedSize == "5 Inch",
                        onSelected: (_) => setState(() => selectedSize = "5 Inch"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Flavor:"),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text("Chocolate"),
                        selected: selectedFlavor == "Chocolate",
                        onSelected: (_) => setState(() => selectedFlavor = "Chocolate"),
                      ),
                      SizedBox(width: 5),
                      ChoiceChip(
                        label: Text("Vanilla"),
                        selected: selectedFlavor == "Vanilla",
                        onSelected: (_) => setState(() => selectedFlavor = "Vanilla"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Topper Theme:"),
                  TextField(
                    onChanged: (value) => topperTheme = value,
                    decoration: InputDecoration(hintText: "Insert option"),
                  ),
                  SizedBox(height: 10),
                  Text("Booking Date:"),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      setState(() => bookingDate = date);
                    },
                    child: Text(bookingDate == null
                        ? "Select Date"
                        : bookingDate!.toLocal().toString().split(' ')[0]),
                  ),
                  SizedBox(height: 10),
                  Text("Pickup Options:"),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text("Self Pickup"),
                        selected: pickupOption == "Self Pickup",
                        onSelected: (_) => setState(() => pickupOption = "Self Pickup"),
                      ),
                      SizedBox(width: 5),
                      ChoiceChip(
                        label: Text("Delivery"),
                        selected: pickupOption == "Delivery",
                        onSelected: (_) => setState(() => pickupOption = "Delivery"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Payment Options:"),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text("Deposit"),
                        selected: paymentOption == "Deposit",
                        onSelected: (_) => setState(() => paymentOption = "Deposit"),
                      ),
                      SizedBox(width: 5),
                      ChoiceChip(
                        label: Text("Full Payment"),
                        selected: paymentOption == "Full Payment",
                        onSelected: (_) => setState(() => paymentOption = "Full Payment"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                    title: Text("Add on Knife, Candle, Box"),
                    value: addExtras,
                    onChanged: (value) => setState(() => addExtras = value ?? false),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: addToCart,
                    child: Text("Add to Cart"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}