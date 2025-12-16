import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/payment/check_out_pages.dart';

class CartPage extends StatefulWidget {
  final String userId;

  const CartPage({super.key, required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<QueryDocumentSnapshot>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _fetchCartItems();
  }

  Future<List<QueryDocumentSnapshot>> _fetchCartItems() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('cart')
          .where('status.isPaid', isEqualTo: false) // Updated field reference
          .get();
      return snapshot.docs;
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    }
  }

  double _parsePrice(String? priceString) {
    if (priceString == null || priceString.isEmpty) return 0.0;
    final numericString = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(numericString) ?? 0.0;
  }

  Future<void> _deleteCartItem(String cartItemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
      setState(() {
        _cartItemsFuture = _fetchCartItems(); // Refresh the cart list
      });
    } catch (e) {
      print('Error deleting cart item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove item')),
      );
    }
  }

  // Show details of the cart item
  void _showItemDetails(Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(orderData['name'] ?? 'Unknown Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                orderData['imagePath'] ?? 'assets/default_image.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text('Price: RM ${_parsePrice(orderData['price'].toString()).toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              Text('Pickup Option: ${orderData['bookingDetails']['pickupOption'] ?? 'Unknown'}'),
              const SizedBox(height: 10),
              Text('Add-Ons: ${orderData['bookingDetails']['addOns'] ?? false ? 'Yes' : 'No'}'),
              const SizedBox(height: 10),
              Text('Booking Date: ${orderData['bookingDetails']['bookingDate'] ?? 'N/A'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              var documentId = orders[index].id;

              // Handle null values with defaults
              var name = orderData['name'] ?? 'Unknown Item';
              var priceString = orderData['price']?.toString() ?? '0.0';
              final price = _parsePrice(priceString);
              var imagePath = orderData['imagePath'] ?? 'assets/default_image.png';
              var addOns = orderData['bookingDetails']['addOns'] ?? false;
              var isDelivery = orderData['bookingDetails']['pickupOption'] == 'Delivery';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Image.asset(
                          imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 60),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'RM ${price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _deleteCartItem(documentId);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                            IconButton(
                              onPressed: () {
                                _showItemDetails(orderData); // Show details popup
                              },
                              icon: const Icon(Icons.info_outline, color: Colors.blue),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(
                                      userId: widget.userId,
                                      cartItemId: documentId,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: const Text('Checkout'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
