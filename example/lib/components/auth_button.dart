import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isAuthorized;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.isAuthorized,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: isAuthorized ? Colors.green : Colors.orange),
      ),
    );
  }
}
