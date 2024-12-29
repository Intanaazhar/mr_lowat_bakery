import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0;
  String? _selectedImprovement = '';
  final TextEditingController _improvementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView( // Make the whole body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 5 Star Rating
            const Text(
              'Rate your experience:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: const Color.fromARGB(255, 225, 183, 15),
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),

            // Multiple Choice Selection with border-styled buttons
            const Text(
              'What can we improve?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Column(
              children: [
                _buildImprovementOption('Overall Service'),
                _buildImprovementOption('Repair Quality'),
                _buildImprovementOption('Transparency'),
                _buildImprovementOption('Customer Support'),
                _buildImprovementOption('Pickup and Delivery Service'),
                _buildImprovementOption('Speed and Efficiency'),
              ],
            ),
            const SizedBox(height: 20),

            // Additional feedback
            const Text(
              'What else can we improve?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            TextField(
              controller: _improvementController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter your detailed feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feedback Submitted')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImprovementOption(String option) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedImprovement = option;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedImprovement == option
              ? Colors.orange
              : Colors.white,
          side: const BorderSide(color: Colors.orange),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        child: Text(
          option,
          style: TextStyle(
            color: _selectedImprovement == option
                ? Colors.white
                : Colors.orange,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
