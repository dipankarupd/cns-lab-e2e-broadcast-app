import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/config/constants/encryption_data.dart';
import 'package:hospital/config/routes/app_route.dart';
import 'user_card.dart';
import 'package:hospital/config/themes/theme_constants.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
      for (var user in users.docs) {
        final messages = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('messages')
            .get();
        print(messages);
        for (var message in messages.docs) {
          final encryptedMessage = message.data()['message'];
          final decryptedMessage = _decryptMessage(encryptedMessage);
          final createdAt =
              (message.data()['created_at'] as Timestamp).toDate();
          allMessages.add({
            'decryptedMessage': decryptedMessage,
            'createdAt': createdAt,
          });
        }
      }

      // Sort messages by createdAt in descending order (latest first)
      allMessages.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

      setState(() {
        _messages = allMessages;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _decryptMessage(String encryptedMessage) {
    try {
      return AESEncryption.decrypt(encryptedMessage);
    } catch (e) {
      print('Error decrypting message: $e');
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
              )
            );
  }
}
