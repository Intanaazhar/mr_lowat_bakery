import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/open_comment_bottom_sheet.dart'; // Import "Comment" Bottom Sheet
import 'book_now_bottom_sheet.dart';  // Import "Book Now" Bottom Sheet


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
  final List<Map<String, String>> _comments = [];
  
  void _addComment(String comment) {
    setState(() {
      _comments.add({'author': 'User', 'message': comment});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added successfully!')),
    );
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
                    onPressed: () {
                      openBookNowBottomSheet(
                        context: context,
                        onAddToCart: (preferences) {
                          // Handle the preferences (e.g., add to cart)
                          print(preferences);
                        },
                      );
                    },
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
                onTap: () {
                  openCommentsBottomSheet(
                    context: context,
                    comments: _comments,
                    onAddComment: _addComment,
                  );
                },
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
