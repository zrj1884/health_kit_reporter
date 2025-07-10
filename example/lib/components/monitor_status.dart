import 'package:flutter/material.dart';

class MonitorStatus extends StatelessWidget {
  final bool isObserving;
  final String? latestUpdate;

  const MonitorStatus({
    Key? key,
    required this.isObserving,
    this.latestUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isObserving ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isObserving ? Colors.green[300]! : Colors.orange[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isObserving ? Icons.visibility : Icons.visibility_off,
                color: isObserving ? Colors.green[600] : Colors.orange[600],
              ),
              const SizedBox(width: 8),
              Text(
                isObserving ? '正在监控健康数据' : '未开始监控',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isObserving ? Colors.green[600] : Colors.orange[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (latestUpdate != null && latestUpdate!.isNotEmpty)
            Text(
              '最新更新: $latestUpdate',
              style: const TextStyle(fontSize: 12),
            )
          else
            const Text(
              '点击下方按钮开始监控健康数据变化',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
