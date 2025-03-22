import 'package:flutter/material.dart';
import 'package:stockorra/models/user_model.dart';

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;

  const UserTile({
    Key? key,
    required this.user,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(user.email),
          ),
          const Expanded(
            flex: 1,
            child: Text('xxxx'),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF4C6B37)),
            onPressed: onEdit,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}