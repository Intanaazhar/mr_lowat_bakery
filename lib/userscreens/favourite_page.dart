import 'package:flutter/material.dart';

class favPage extends StatefulWidget {
  const favPage({super.key});

  @override
  _favPageState createState() => _favPageState();
}
class _favPageState extends State<favPage> {
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