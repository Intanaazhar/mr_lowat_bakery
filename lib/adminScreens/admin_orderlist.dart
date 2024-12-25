import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminOrderList(),
    );
  }
}

class AdminOrderList extends StatefulWidget {
  @override
  _AdminOrderListState createState() => _AdminOrderListState();
}

class _AdminOrderListState extends State<AdminOrderList> {
  final List<String> orderStatuses = ["Accepted", "Processing", "Ready"];
  List<String> currentStatuses = ["Accepted", "Processing"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          "Order List",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: currentStatuses.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.cake, color: Colors.white),
                      ),
                      title: Text("Order ID: 000${index + 1}"),
                      subtitle: Text(
                          "Customer: ${index == 0 ? 'Nur Qistina' : 'Ahmad'}"),
                      trailing: ElevatedButton(
                        onPressed: () => _showOrderDetails(context, index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Details"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedStatus = currentStatuses[index];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text("Order Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Name: ${index == 0 ? 'Nur Qistina' : 'Ahmad'}"),
                  Text("Booking Date: 10/12/2024"),
                  Text("Cake Size: 3 inches"),
                  Text("Flavor: Chocolate"),
                  Text("Topper: Roses"),
                  Text("Payment: Full payment"),
                  Text("Pickup: Self pickup"),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Order Status",
                    ),
                    items: orderStatuses.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      setState(() {
                        selectedStatus = newStatus!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentStatuses[index] = selectedStatus;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Save"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
