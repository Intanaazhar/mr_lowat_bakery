import 'package:flutter/material.dart';

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

                // Flavour Selection
                _buildSelectionColumn(
                  title: 'Flavour:',
                  options: ['Chocolate', 'Pandan', 'Vanilla', 'Mocha'],
                  selectedOption: selectedFlavour,
                  onOptionSelected: (String? newFlavour) {
                    setState(() {
                      selectedFlavour = newFlavour;
                    });
                  },
                  isMultiSelect: true,
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

                // Pickup Options
                _buildSelectionColumn(
                  title: 'Pickup Options:',
                  options: ['Self Pickup', 'Delivery'],
                  selectedOption: selectedPickupOption,
                  onOptionSelected: (String? newOption) {
                    setState(() {
                      selectedPickupOption = newOption;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Payment Options
                _buildSelectionColumn(
                  title: 'Payment Options:',
                  options: ['Deposit', 'Full Payment'],
                  selectedOption: selectedPaymentOption,
                  onOptionSelected: (String? newOption) {
                    setState(() {
                      selectedPaymentOption = newOption;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Add-ons Checkbox
                _buildAddOnsColumn(
                  addOns: addOns,
                  onChanged: (bool? value) {
                    setState(() {
                      addOns = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Add to Cart Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Pass data to the callback
                      onAddToCart({
                        'size': selectedSize,
                        'flavour': selectedFlavour,
                        'pickupOption': selectedPickupOption,
                        'paymentOption': selectedPaymentOption,
                        'bookingDate': bookingDate,
                        'addOns': addOns,
                      });

                      Navigator.pop(context); // Close bottom sheet
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
  bool isMultiSelect = false,
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
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (picked != null && picked != bookingDate) {
            onDateSelected(picked);
          }
        },
      ),
    ],
  );
}

Widget _buildAddOnsColumn({
  required bool addOns,
  required ValueChanged<bool?> onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Add on Knife, Candle, Box:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      CheckboxListTile(
        title: const Text('Add-ons'),
        value: addOns,
        onChanged: onChanged,
      ),
    ],
  );
}
