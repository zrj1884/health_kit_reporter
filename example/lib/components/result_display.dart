import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  final String title;
  final String? result;
  final bool isLoading;
  final String placeholder;

  const ResultDisplay({
    super.key,
    required this.title,
    this.result,
    this.isLoading = false,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('正在处理...'),
              ],
            )
          else if (result != null && result!.isNotEmpty)
            Text(
              result!,
              style: const TextStyle(fontSize: 12),
            )
          else
            Text(
              placeholder,
              style: const TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
