import 'package:flutter/material.dart';

class DescriptionPage extends StatefulWidget {
  final String imagePath;
  final String name;
  final String price;
  final VoidCallback onAddToCart;

  const DescriptionPage({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.onAddToCart,
  });

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final List<String> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text.trim());
        _commentController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment')),
      );
    }
  }

  // Bottom Sheet function to handle comment section
  void _openCommentBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Enter your comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addComment,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Add Comment'),
              ),
              const SizedBox(height: 16),
              const Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Display the list of comments
              ..._comments.map((comment) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(comment),
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade200, Colors.orange.shade100],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Image.asset(
                        widget.imagePath,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.price,
                        style: const TextStyle(fontSize: 20, color: Colors.orange),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: widget.onAddToCart,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: _openCommentBottomSheet, // Open bottom sheet for comments
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.comment, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text('Comments', style: TextStyle(color: Colors.white, fontSize: 18)),
                      const Spacer(),
                      Text('(${_comments.length})', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
