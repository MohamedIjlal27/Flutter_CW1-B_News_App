import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const ProfileField({
    required this.icon,
    required this.value,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(value),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: onTap,
      ),
    );
  }
}
