import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOthersPage extends StatefulWidget {
  const AdminOthersPage({super.key});

  @override
  _AdminOthersPageState createState() => _AdminOthersPageState();
}

class _AdminOthersPageState extends State<AdminOthersPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  void _addItem() async {
    try {
      await FirebaseFirestore.instance.collection('others').add({
        'name': _nameController.text,
        'price': _priceController.text,
        'image': _imageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding item: $e")),
      );
    }
  }

  void _updateItem(String id) async {
    try {
      await FirebaseFirestore.instance.collection('others').doc(id).update({
        'name': _nameController.text,
        'price': _priceController.text,
        'image': _imageController.text,
      });
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating item: $e")),
      );
    }
  }

  void _deleteItem(String id) async {
    try {
      await FirebaseFirestore.instance.collection('others').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting item: $e")),
      );
    }
  }

  void _showDialog({String? id, Map<String, dynamic>? data}) {
    if (data != null) {
      _nameController.text = data['name'];
      _priceController.text = data['price'];
      _imageController.text = data['image'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? "Add Item" : "Edit Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (id == null) {
                  _addItem();
                } else {
                  _updateItem(id);
                }
              },
              child: Text(id == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Others Menu"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('others')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          return GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              final id = items[index].id;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                          item['image'],
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          item['name'],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item['price'],
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showDialog(id: id, data: item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(id),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
