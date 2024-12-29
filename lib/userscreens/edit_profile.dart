import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/screens/settings_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Editable fields
  final TextEditingController _nameController = TextEditingController(text: "Nur Qistina");
  final TextEditingController _emailController = TextEditingController(text: "Qistina03@gmail.com");
  
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Handle logout logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Profile Picture
            Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 150,
                  backgroundImage: const AssetImage('assets/userProfilePic.jpg'), // Replace with your avatar
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Editable Name
            _isEditing
                ? _buildEditableField("Name", _nameController)
                : Text(
                    _nameController.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

            // Editable Email
            const SizedBox(height: 10),
            _isEditing
                ? _buildEditableField("Email", _emailController)
                : Text(
                    _emailController.text,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),

            const SizedBox(height: 20),

            // Edit/Save Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
                if (!_isEditing) {
                  // Save changes logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile Updated')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(_isEditing ? "Save Changes" : "Edit Profile"),
            ),

            const SizedBox(height: 20),

            // Buttons for other actions
            ProfileButton(label: "My Orders", onTap: () {}),
            const SizedBox(height: 20),
            ProfileButton(label: "My Carts", onTap: () {}),
            const SizedBox(height: 20),
            ProfileButton(
              label: "Settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPopup()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class ProfileButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ProfileButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
