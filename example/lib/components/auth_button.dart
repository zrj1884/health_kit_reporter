import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isAuthorized;
  final VoidCallback onPressed;

  const AuthButton({
    Key? key,
    required this.icon,
    required this.tooltip,
    required this.isAuthorized,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: isAuthorized ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isAuthorized ? Colors.green : Colors.orange,
          ),
        ),
      ),
    );
  }
}
