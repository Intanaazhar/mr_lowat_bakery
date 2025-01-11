import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DebitCardPage extends StatefulWidget {
  final String userId;

  const DebitCardPage({super.key, required this.userId});

  @override
  _DebitCardPageState createState() => _DebitCardPageState();
}

class _DebitCardPageState extends State<DebitCardPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCardDetails();
  }

  Future<void> _fetchCardDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('category')
          .doc('debitCard')
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          _nameController.text = data['cardholderName'] ?? '';
          _cardNumberController.text = data['cardNumber'] ?? '';
          _expiryDateController.text = data['expiryDate'] ?? '';
          _cvvController.text = data['cvv'] ?? '';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching card details: $e')),
      );
    }
  }

  Future<void> _saveCardDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('category')
            .doc('debitCard')
            .set({
          'cardholderName': _nameController.text,
          'cardNumber': _cardNumberController.text,
          'expiryDate': _expiryDateController.text,
          'cvv': _cvvController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card details saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving card details: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debit Card'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add/Edit Debit Card',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField('Cardholder Name', 'Enter name on card', _nameController),
              _buildTextField('Card Number', 'Enter card number', _cardNumberController),
              _buildTextField('Expiry Date', 'MM/YY', _expiryDateController),
              _buildTextField('CVV', 'Enter CVV', _cvvController),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveCardDetails,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Save Card'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String placeholder, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}
