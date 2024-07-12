import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital/config/encryption_data.dart';
import 'package:hospital/config/routes/app_route.dart';
import 'package:hospital/config/themes/theme_constants.dart';


class AdminDisplay extends StatefulWidget {
  const AdminDisplay({super.key});

  @override
  _AdminDisplayState createState() => _AdminDisplayState();
}

class _AdminDisplayState extends State<AdminDisplay> {
  final TextEditingController _controller = TextEditingController();

  void _broadcastMessage() async {
    // Get the text from the controller
    final String message = _controller.text;

    final encrypted = AESEncryption.encrypt(message);

    // Store the encrypted message in Firestore
    await FirebaseFirestore.instance.collection('messages').add({
      'message': encrypted,
      'created_at': FieldValue.serverTimestamp(),
    });

    // Broadcast the encrypted message to all users
    final users = await FirebaseFirestore.instance.collection('users').get();
    for (var user in users.docs) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('messages')
          .add({
        'message': encrypted,
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    print("Message broadcasted successfully");

    // show a snackbar text for success and reload this page

    // Show a Snackbar for success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message broadcasted successfully'),
      ),
    );

    // Clear the text field
    _controller.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 75, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Admin !!",
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "What do you want to broadcast?",
                style: TextStyle(
                  color: colorSecondary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the message to brodcast"),
              ),
              const SizedBox(height: 22),
              SizedBox(
                child: OutlinedButton(
                  onPressed: _broadcastMessage,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.all(14),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Broadcast",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.initial);
        },
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}
