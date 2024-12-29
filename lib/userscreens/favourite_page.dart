import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  _FavouritePageState createState() => _FavouritePageState();
}
class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
}
}
void main() {
  runApp(    
MaterialApp(
      home: Scaffold(
        //appBar: AppBar(),
       //title: Text(‘My First App’),
          //centerTitle: true,
//backgroundColor: Colors.green),
                  body: Container(
	color: Colors.grey,
	child: const Text('Favourites'),
)
),
)
);
}