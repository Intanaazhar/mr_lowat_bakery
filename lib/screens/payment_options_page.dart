import 'package:flutter/material.dart';

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Cart Payment'),
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
              const Icon(Icons.radio_button_checked, color: Colors.orange),
              Container(width: 50, height: 2, color: Colors.orange),
              const Icon(Icons.radio_button_unchecked, color: Colors.orange),
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
                      _buildPaymentMethodIcon(Icons.credit_card, 'Credit/Debit Card'),
                      _buildPaymentMethodIcon(Icons.account_balance, 'Online Banking'),
                      _buildPaymentMethodIcon(Icons.phone_iphone, 'Spay'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildBankOption('Maybank2U'),
                        _buildBankOption('CIMB Clicks'),
                        _buildBankOption('Public Bank'),
                        _buildBankOption('RHB Now'),
                        _buildBankOption('Hong Leong Connect'),
                        _buildBankOption('Ambank'),
                        _buildBankOption('Bank Rakyat'),
                        _buildBankOption('Bank Islam'),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(fontSize: 16)),
                      Text('RM80', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add On', style: TextStyle(fontSize: 16)),
                      Text('RM10', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping', style: TextStyle(fontSize: 16)),
                      Text('RM0', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('RM90',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Proceed to payment'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.orange),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBankOption(String bankName) {
    return ListTile(
      title: Text(bankName, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}