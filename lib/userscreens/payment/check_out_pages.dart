import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mr_lowat_bakery/userscreens/payment/payment_options_page.dart';

class ProductInfo extends StatelessWidget {
  final String userId;
  final String cartItemId;
  final String imagePath;
  final String name;
  final String price;
  final String flavour;
  final String size;
  final bool addOns;
  final bool isDelivery;
  final DateTime bookingDate;
  final bool isFullPayment;
  final String pickupOption;

  const ProductInfo({
    super.key,
    required this.userId,
    required this.cartItemId,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.flavour,
    required this.size,
    required this.addOns,
    required this.isDelivery,
    required this.bookingDate,
    required this.isFullPayment,
    required this.pickupOption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: imagePath.startsWith("http") || imagePath.startsWith("https")
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/default_image.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(
                      imagePath.isNotEmpty ? imagePath : 'assets/images/default_image.png',
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(thickness: 1),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildDetailRow('Price', 'RM ${double.parse(price).toStringAsFixed(2)}'),
              _buildDetailRow('Flavour', flavour),
              _buildDetailRow('Size', size),
              _buildDetailRow(
                  'Booking Date', DateFormat('yyyy-MM-dd').format(bookingDate)),
              _buildDetailRow('Payment', isFullPayment ? 'Full Payment' : 'Deposit'),
              _buildDetailRow('Pickup', pickupOption),
              const Divider(thickness: 1),
              _buildDetailRow('Add-ons', addOns ? "RM 5.00" : "Not Included"),
              _buildDetailRow('Delivery', isDelivery ? "RM 10.00" : "Not Included"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final String userId;
  final String cartItemId;

  const CheckoutPage({super.key, required this.userId, required this.cartItemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(cartItemId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Cart item not found.'));
          }

          final cartItem = snapshot.data!.data() as Map<String, dynamic>;

          final bookingDate = _parseBookingDate(cartItem);
          final price = double.tryParse(
                  cartItem['price']?.toString().replaceAll(RegExp(r'[^\d.]'), '') ?? '0.00') ?? 0.00;
          final addOns = cartItem['addOns'] ?? false;
          final isDelivery = cartItem['pickupOption'] == 'Delivery';
          final isFullPayment = cartItem['isFullPayment'] == true ||
              cartItem['isFullPayment']?.toString().toLowerCase() == 'true';

          final addOnsPrice = addOns ? 5.00 : 0.00;
          final deliveryPrice = isDelivery ? 10.00 : 0.00;
          final totalPrice = price + addOnsPrice + deliveryPrice;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ProductInfo(
                        userId: userId,
                        cartItemId: cartItemId,
                        imagePath: cartItem['imagePath'] ?? '',
                        name: cartItem['name'] ?? '',
                        price: price.toStringAsFixed(2),
                        flavour: cartItem['flavour'] ?? '',
                        size: cartItem['size'] ?? '',
                        isFullPayment: cartItem['isFullPayment'] ?? '',
                        pickupOption: cartItem['pickupOption'] ?? '',
                        bookingDate: bookingDate,
                        addOns: addOns,
                        isDelivery: isDelivery,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'RM ${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentOptionsPage(
                            isDelivery: isDelivery,
                            addOns: addOns,
                            price: totalPrice,
                            cartItemId: cartItemId,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Center(child: Text('Proceed To Payment')),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DateTime _parseBookingDate(Map<String, dynamic> cartItem) {
    if (cartItem.containsKey('bookingDate')) {
      final bookingData = cartItem['bookingDate'];
      if (bookingData is Timestamp) return bookingData.toDate();
      if (bookingData is String) return DateTime.tryParse(bookingData) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
