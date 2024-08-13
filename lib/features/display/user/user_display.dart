import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/config/encryption_data.dart';
import 'package:hospital/config/routes/app_route.dart';
import 'user_card.dart';
import 'package:hospital/config/themes/theme_constants.dart';

class UserDisplay extends StatefulWidget {
  const UserDisplay({Key? key}) : super(key: key);

  @override
  _UserDisplayState createState() => _UserDisplayState();
}

class _UserDisplayState extends State<UserDisplay> {
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, dynamic>> allMessages = [];
      Set<String> uniqueMessages = Set<String>(); // Track unique decrypted messages

      for (var user in users.docs) {
        final messages = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('messages')
            .get();

        for (var message in messages.docs) {
          final encryptedMessage = message.data()['message'];
          final decryptedMessage = _decryptMessage(encryptedMessage);
          final createdAt =
              (message.data()['created_at'] as Timestamp).toDate();

          // Only add message if it's unique or more recent
          if (uniqueMessages.add(decryptedMessage)) {
            allMessages.add({
              'decryptedMessage': decryptedMessage,
              'createdAt': createdAt,
            });
          } else {
            // Replace the existing message if the current one is more recent
            for (var i = 0; i < allMessages.length; i++) {
              if (allMessages[i]['decryptedMessage'] == decryptedMessage &&
                  allMessages[i]['createdAt'].isBefore(createdAt)) {
                allMessages[i]['createdAt'] = createdAt;
                break;
              }
            }
          }
        }
      }

      // Sort messages by createdAt in descending order (latest first)
      allMessages.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

      setState(() {
        _messages = allMessages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error fetching messages: $e');
    }
  }

  String _decryptMessage(String encryptedMessage) {
    try {
      return AESEncryption.decrypt(encryptedMessage);
    } catch (e) {
      _showSnackBar('Error decrypting message: $e');
      return 'Error: Failed to decrypt message';
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchMessages();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, AppRoute.initial); // Redirect to login screen after logout
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView(
                padding: EdgeInsets.fromLTRB(24, 75, 24, 0),
                children: [
                  const Text(
                    "Hello User ",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: colorSecondary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      "Community posts...",
                      style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: _messages.map((msg) {
                      return UserCard(
                        decryptedMessage: msg['decryptedMessage'],
                        createdAt: msg['createdAt'],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}
