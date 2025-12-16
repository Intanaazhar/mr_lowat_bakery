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
  double subtotal = 0.0;
  double addOn = 0.0;
  double shipping = 0.0;

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardholderNameController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSubtotal();
    _fetchDebitCardInfo();
  }

  Future<void> _fetchSubtotal() async {
    try {
      final cartDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('cart')
          .doc(widget.cartItemId)
          .get();

      if (cartDoc.exists) {
        final priceString = cartDoc.data()?['price'] ?? '0.00';
        final priceDouble = double.tryParse(
                priceString.toString().replaceAll(RegExp(r'[^\d.]'), '')) ??
            0.0;

        final bookingDetails = cartDoc.data()?['bookingDetails'] ?? {};
        final isDelivery = widget.isDelivery;
        final addOns = widget.addOns;

        setState(() {
          subtotal = priceDouble;
          addOn = addOns ? 5.0 : 0.0;
          shipping = isDelivery ? 10.0 : 0.0;
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

  Future<void> _fetchDebitCardInfo() async {
    try {
      final debitCardDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('category')
          .doc('debitCard')
          .get();

      if (debitCardDoc.exists) {
        setState(() {
          cardNumberController.text = debitCardDoc.data()?['cardNumber'] ?? '';
          cardholderNameController.text =
              debitCardDoc.data()?['cardholderName'] ?? '';
          cvvController.text = debitCardDoc.data()?['cvv'] ?? '';
          expiryDateController.text = debitCardDoc.data()?['expiryDate'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching debit card info: $e')),
      );
    }
  }

  Future<void> _saveDebitCardInfo() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('category')
          .doc('debitCard')
          .set({
        'cardNumber': cardNumberController.text,
        'cardholderName': cardholderNameController.text,
        'cvv': cvvController.text,
        'expiryDate': expiryDateController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debit card info saved successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving debit card info: $e')),
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
      body: SingleChildScrollView(
        child: Column(
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
            Container(
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
                  if (selectedPaymentMethod == 'Card') _buildDebitCardSection(),
                  if (selectedPaymentMethod == 'Banking') _buildBankingOptionsSection(),
                  const Divider(),
                  _buildSummarySection(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                            if (selectedPaymentMethod == 'Card') {
                              _saveDebitCardInfo();
                            } else if (selectedPaymentMethod == 'Banking' &&
                                selectedBank == 'CIMB Clicks') {
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
          ],
        ),
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

  Widget _buildDebitCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Debit Card Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: cardNumberController,
          decoration: const InputDecoration(labelText: 'Card Number'),
        ),
        TextField(
          controller: cardholderNameController,
          decoration: const InputDecoration(labelText: 'Cardholder Name'),
        ),
        TextField(
          controller: cvvController,
          decoration: const InputDecoration(labelText: 'CVV'),
          obscureText: true,
        ),
        TextField(
          controller: expiryDateController,
          decoration: const InputDecoration(labelText: 'Expiry Date'),
        ),
      ],
    );
  }

  Widget _buildBankingOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Bank',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: selectedBank,
          hint: const Text('Select Bank'),
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'CIMB Clicks', child: Text('CIMB Clicks')),
            DropdownMenuItem(value: 'Maybank2u', child: Text('Maybank2u')),
            DropdownMenuItem(value: 'RHB Now', child: Text('RHB Now')),
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
            const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('RM${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
