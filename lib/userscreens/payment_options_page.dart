import 'package:flutter/material.dart';

class PaymentOptionsPage extends StatefulWidget {
  const PaymentOptionsPage({super.key});

  @override
  _PaymentOptionsPageState createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  String selectedPaymentMethod = '';
  bool cardSaved = false;
  double subtotal = 80.0;
  double addOn = 10.0;
  double shipping = 0.0;

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
                      _buildPaymentMethodIcon(Icons.phone_iphone, 'Spay', 'Spay'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (selectedPaymentMethod == 'Card') _buildCardDetailsSection(),
                  if (selectedPaymentMethod == 'Banking') _buildBankingOptionsSection(),
                  if (selectedPaymentMethod == 'Spay') _buildSpaySection(),
                  const Divider(),
                  _buildSummarySection(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
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
                            if (selectedPaymentMethod == 'Spay') {
                              _showSpayConfirmationDialog();
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

  Widget _buildCardDetailsSection() {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Card Holder Name',
          ),
        ),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Card Number',
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
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
            setState(() {
              cardSaved = true;
              selectedPaymentMethod = 'Confirmation';
            });
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
          items: const [
            DropdownMenuItem(value: 'Maybank2U', child: Text('Maybank2U')),
            DropdownMenuItem(value: 'CIMB Clicks', child: Text('CIMB Clicks')),
            DropdownMenuItem(value: 'Public Bank', child: Text('Public Bank')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildSpaySection() {
    return Center(
      child: Column(
        children: const [
          Text('Spay Payment Page Placeholder'),
        ],
      ),
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

  void _showSpayConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Proceed to Sarawak Pay?'),
          content: const Text('Do you want to proceed to the Sarawak Pay app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }
}
