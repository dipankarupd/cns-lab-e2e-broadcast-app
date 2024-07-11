import 'package:flutter/material.dart';
import 'package:hospital/config/themes/theme_constants.dart';

class UserCard extends StatelessWidget {
  final String decryptedMessage;
  final DateTime createdAt;

  const UserCard({
    Key? key,
    required this.decryptedMessage,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            width: constraints.maxWidth,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  decryptedMessage,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Created at: ${createdAt.toLocal()}',
                  style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
