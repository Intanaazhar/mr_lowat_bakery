import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void openBookNowBottomSheet({
  required BuildContext context,
  required Function(Map<String, dynamic>) onAddToCart,
}) {
  String? selectedSize;
  String? selectedFlavour;
  String? selectedPickupOption;
  String? selectedPaymentOption;
  DateTime? bookingDate;
  bool addOns = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose your preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Size Selection
                _buildSelectionColumn(
                  title: 'Size:',
                  options: ['3 Inch', '5 Inch'],
                  selectedOption: selectedSize,
                  onOptionSelected: (String? newSize) {
                    setState(() {
                      selectedSize = newSize;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Booking Date
                _buildDatePickerColumn(
                  title: 'Booking Date:',
                  bookingDate: bookingDate,
                  onDateSelected: (DateTime? newDate) {
                    setState(() {
                      bookingDate = newDate;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Add to Cart Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Prepare data to save
                      final data = {
                        'size': selectedSize,
                        'flavour': selectedFlavour,
                        'pickupOption': selectedPickupOption,
                        'paymentOption': selectedPaymentOption,
                        'bookingDate': bookingDate?.toIso8601String(),
                        'addOns': addOns,
                        'timestamp': FieldValue.serverTimestamp(),
                      };

                      try {
                        // Get the current user ID
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final userId = user.uid;

                          // Save data under the user's order subcollection
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('order')
                              .add(data);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Booking saved successfully!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User not logged in!')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving booking: $e')),
                        );
                      }

                      // Pass data to callback for further use
                      onAddToCart(data);

                      // Close the bottom sheet
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildSelectionColumn({
  required String title,
  required List<String> options,
  String? selectedOption,
  required void Function(String? selectedOption) onOptionSelected,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((option) {
          return ChoiceChip(
            label: Text(option),
            selected: selectedOption == option,
            onSelected: (selected) {
              onOptionSelected(selected ? option : null);
            },
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildDatePickerColumn({
  required String title,
  DateTime? bookingDate,
  required void Function(DateTime? selectedDate) onDateSelected,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextButton.icon(
        icon: const Icon(Icons.calendar_today),
        label: Text(
          bookingDate != null
              ? '${bookingDate.day}-${bookingDate.month}-${bookingDate.year}'
              : 'Select Date',
        ),
        onPressed: () async {
          var context;
          final DateTime? pickedDate = await showDatePicker(
            context: onDateSelected.runtimeType == (BuildContext).runtimeType
                ? context
                : context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            onDateSelected(pickedDate);
          }
        },
      ),
    ],
  );
}

