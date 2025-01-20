import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mr_lowat_bakery/userscreens/payment/cimb_clicks_page.dart';

class PaymentOptionsPage extends StatefulWidget {
  const PaymentOptionsPage({
    super.key,
    required this.isDelivery,
    required this.addOns,
    required this.price,
    required this.cartItemId,
    required this.userId,
  });

  final bool isDelivery;
  final bool addOns;
  final double price;
  final String cartItemId;
  final String userId;

  @override
  _PaymentOptionsPageState createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  String selectedPaymentMethod = '';
  String? selectedBank;
  bool cardSaved = false;
  double subtotal = 0.0; // To be fetched
  double addOn = 0.0; // Dynamic based on widget.addOns
  double shipping = 0.0; // Dynamic based on widget.isDelivery

  @override
  void initState() {
    super.initState();
    _fetchSubtotal();
  }

  Future<void> _fetchSubtotal() async {
  try {
    // Fetch the cart document from Firestore
    final cartDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('cart')
        .doc(widget.cartItemId)
        .get();

    if (cartDoc.exists) {
      final priceString = cartDoc.data()?['price'] ?? '0.00';

      final priceDouble = double.tryParse(priceString.toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;

      setState(() {
        subtotal = priceDouble;
        addOn = widget.addOns ? 5.0 : 0.0;
        shipping = widget.isDelivery ? 10.0 : 0.0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart item not found.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching subtotal: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Payment',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.radio_button_checked,
                color: selectedPaymentMethod.isNotEmpty ? Colors.orange : Colors.grey,
              ),
              Container(width: 50, height: 2, color: Colors.orange),
              Icon(
                Icons.radio_button_unchecked,
                color: selectedPaymentMethod == 'Confirmation' ? Colors.orange : Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select payment method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPaymentMethodIcon(Icons.credit_card, 'Credit/Debit Card', 'Card'),
                      _buildPaymentMethodIcon(Icons.account_balance, 'Online Banking', 'Banking'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (selectedPaymentMethod == 'Card') _buildCardDetailsSection(context),
                  if (selectedPaymentMethod == 'Banking') _buildBankingOptionsSection(),
                  const Divider(),
                  _buildSummarySection(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Cancel button functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedPaymentMethod == 'Banking' && selectedBank == 'CIMB Clicks') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CIMBClicksPage(
                                    userId: widget.userId,
                                    cartItemId: widget.cartItemId,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Proceed to payment'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodIcon(IconData icon, String label, String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
          selectedBank = null; // Reset the bank selection
        });
      },
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.orange),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailsSection(BuildContext context) {
    TextEditingController cardHolderNameController = TextEditingController();
    TextEditingController cardNumberController = TextEditingController();
    TextEditingController expiryDateController = TextEditingController();
    TextEditingController cvvController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: cardHolderNameController,
          decoration: const InputDecoration(
            labelText: 'Card Holder Name',
          ),
        ),
        TextField(
          controller: cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (cardHolderNameController.text.isNotEmpty &&
                cardNumberController.text.isNotEmpty &&
                expiryDateController.text.isNotEmpty &&
                cvvController.text.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CIMBClicksPage(
                    userId: widget.userId,
                    cartItemId: widget.cartItemId,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all card details.'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget _buildBankingOptionsSection() {
    return Column(
      children: [
        const Text(
          'Select a bank:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: selectedBank,
          hint: const Text('Choose your bank'),
          items: const [
            DropdownMenuItem(value: 'Maybank2U', child: Text('Maybank2U')),
            DropdownMenuItem(value: 'CIMB Clicks', child: Text('CIMB Clicks')),
            DropdownMenuItem(value: 'Public Bank', child: Text('Public Bank')),
          ],
          onChanged: (value) {
            setState(() {
              selectedBank = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    double total = subtotal + addOn + shipping;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal', style: TextStyle(fontSize: 16)),
            Text('RM${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add On', style: TextStyle(fontSize: 16)),
            Text('RM${addOn.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shipping', style: TextStyle(fontSize: 16)),
            Text('RM${shipping.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('RM${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
