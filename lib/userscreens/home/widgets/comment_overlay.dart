import 'package:flutter/material.dart';

class CommentOverlayWidget extends StatelessWidget {
  final TextEditingController commentController;
  final VoidCallback onAddComment;
  final VoidCallback onClose;
  final List<String> comments;

  const CommentOverlayWidget({
    super.key,
    required this.commentController,
    required this.onAddComment,
    required this.onClose,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: comments.isEmpty
                  ? const Center(child: Text('No comments yet.', style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Text(comments[index], style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      },
                    ),
            ),
            TextField(
              controller: commentController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onClose,
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: onAddComment,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
