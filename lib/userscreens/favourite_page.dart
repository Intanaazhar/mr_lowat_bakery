import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final Function onPressed;
  final bool isFavorite; // Track favorite state

  const FavoriteButton({
    super.key,
    required this.onPressed,
    this.isFavorite = false,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite; // Set initial favorite state
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite; // Toggle favorite state
          widget.onPressed(_isFavorite); // Call provided function with new state
        });
      },
    );
  }
}