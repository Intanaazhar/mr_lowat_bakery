import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/confirmation_page.dart';
import 'package:mr_lowat_bakery/userscreens/cimb_clicks_page.dart';
import 'package:mr_lowat_bakery/userscreens/spay_page.dart';

class PaymentOptionsPage extends StatefulWidget {
  final String userId;
  final String cartItemId;
  final double price;
  final bool addOns;
  final bool isDelivery;

  const PaymentOptionsPage({
    super.key,
    required this.userId,
    required this.cartItemId,
    required this.price,
    required this.addOns,
    required this.isDelivery,
  });

  @override
  _PaymentOptionsPageState createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  String selectedPaymentMethod = '';
  String? selectedBank;
  bool cardSaved = false;
  double subtotal = 0.0;
  double addOn = 0.0;
  double shipping = 0.0;

  @override
  void initState() {
    super.initState();
    _initializePrices();
  }

  void _initializePrices() {
    subtotal = widget.price;
    addOn = widget.addOns ? 5.0 : 0.0;
    shipping = widget.isDelivery ? 10.0 : 0.0;
  }

  Future<void> _processPayment() async {
    try {
      final cartDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('cart')
          .doc(widget.cartItemId);

      await cartDoc.update({
        'isPaid': true,
        'isAccepted': false,
        'isCancelled': false,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ConfirmationPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: $e')),
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
            child: SingleChildScrollView(
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
                        _buildPaymentMethodIcon(Icons.phone_iphone, 'Spay', 'Spay'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (selectedPaymentMethod == 'Card') _buildCardDetailsSection(context),
                    if (selectedPaymentMethod == 'Banking') _buildBankingOptionsSection(),
                    if (selectedPaymentMethod == 'Spay') _buildSpaySection(),
                    const Divider(),
                    _buildSummarySection(
                      subtotal: subtotal,
                      addOn: addOn,
                      shipping: shipping,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Cancel button
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
                              if (selectedPaymentMethod == 'Banking') {
                                if (selectedBank == 'CIMB Clicks') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CIMBClicksPage(),
                                    ),
                                  );
                                } else if (selectedBank != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Redirecting to $selectedBank...')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please select a bank to proceed.')),
                                  );
                                }
                              } else if (selectedPaymentMethod == 'Card') {
                                _processPayment();
                              } else if (selectedPaymentMethod == 'Spay') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SPayPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please select a payment method.')),
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
                            child: const Text('Proceed to Payment'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
          selectedBank = null;
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
                  labelText: 'Expiry Date (MM/YY)',
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
              _processPayment();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all card details.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Submit Payment'),
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
              selectedBank = value; // Update the selected bank
            });
          },
        ),
      ],
    );
  }

  Widget _buildSpaySection() {
    return Column(
      children: const [
        Text(
          'Redirecting to Spay payment gateway...',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSummarySection({
    required double subtotal,
    required double addOn,
    required double shipping,
  }) {
    double total = subtotal + addOn + shipping;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('Subtotal: RM${subtotal.toStringAsFixed(2)}'),
        Text('Add-ons: RM${addOn.toStringAsFixed(2)}'),
        Text('Shipping: RM${shipping.toStringAsFixed(2)}'),
        const Divider(),
        Text('Total: RM${total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
