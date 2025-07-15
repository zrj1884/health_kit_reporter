import 'package:flutter/material.dart';

/// iOS风格的SnackBar组件
class IOSSnackBar {
  /// 显示iOS风格的SnackBar
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration? duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor ?? const Color(0xFF007AFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration ?? const Duration(seconds: 3),
        action: action,
      ),
    );
  }

  /// 显示成功消息
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF34C759), // iOS绿色
      duration: duration,
      action: action,
    );
  }

  /// 显示错误消息
  static void showError(
    BuildContext context, {
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFFFF3B30), // iOS红色
      duration: duration,
      action: action,
    );
  }

  /// 显示警告消息
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFFFF9500), // iOS橙色
      duration: duration,
      action: action,
    );
  }

  /// 显示信息消息
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context,
      message: message,
      backgroundColor: const Color(0xFF007AFF), // iOS蓝色
      duration: duration,
      action: action,
    );
  }

  /// 显示带操作按钮的消息
  static void showWithAction(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onActionPressed,
    Color? backgroundColor,
    Duration? duration,
  }) {
    show(
      context,
      message: message,
      backgroundColor: backgroundColor,
      duration: duration,
      action: SnackBarAction(
        label: actionLabel,
        textColor: Colors.white,
        onPressed: onActionPressed,
      ),
    );
  }
}
