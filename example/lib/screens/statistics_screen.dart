import 'package:flutter/material.dart';

import '../services/health_icon_service.dart';

/// 统计信息页面
class StatisticsScreen extends StatefulWidget {
  final Map<String, dynamic> statistics;

  const StatisticsScreen({
    super.key,
    required this.statistics,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计信息'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.share),
        //     onPressed: _shareStatistics,
        //     tooltip: '分享统计信息',
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 总体统计卡片
            _buildOverallStatisticsCard(),
            const SizedBox(height: 24),

            // 按分类统计
            const Text(
              '按分类统计',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._buildCategoryStatistics(),
          ],
        ),
      ),
    );
  }

  /// 构建总体统计卡片
  Widget _buildOverallStatisticsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  '总体统计',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '总记录数',
                    '${widget.statistics['totalRecords']}',
                    Icons.list_alt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    '有效记录',
                    '${widget.statistics['validRecords']}',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    '无效记录',
                    '${widget.statistics['invalidRecords']}',
                    Icons.error,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    '数据类型数',
                    '${widget.statistics['uniqueIdentifiers']}',
                    Icons.category,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分类统计
  List<Widget> _buildCategoryStatistics() {
    final Map<String, dynamic> identifierCounts = widget.statistics['identifierCounts'] as Map<String, dynamic>;
    final Map<String, List<MapEntry<String, dynamic>>> categoryGroups = {};

    // 按分类组织数据
    for (final entry in identifierCounts.entries) {
      final category = HealthIconService.getCategoryForIdentifier(entry.key);
      if (!categoryGroups.containsKey(category)) {
        categoryGroups[category] = [];
      }
      categoryGroups[category]!.add(entry);
    }

    final List<Widget> widgets = [];

    categoryGroups.forEach((category, entries) {
      final totalCount = entries.fold<int>(0, (sum, entry) => sum + (entry.value as int));

      widgets.add(
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(category).withValues(alpha: 0.1),
              child: Icon(
                _getCategoryIcon(category),
                color: _getCategoryColor(category),
                size: 20,
              ),
            ),
            title: Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '$totalCount 条记录',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            children: [
              ...entries.map((entry) => _buildTypeItem(entry)),
            ],
          ),
        ),
      );
    });

    return widgets;
  }

  /// 构建类型项
  Widget _buildTypeItem(MapEntry<String, dynamic> entry) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: HealthIconService.getColorForIdentifier(entry.key).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              HealthIconService.getIconForIdentifier(entry.key),
              size: 16,
              color: HealthIconService.getColorForIdentifier(entry.key),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HealthIconService.getDisplayNameForIdentifier(entry.key),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${entry.value} 条记录',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: HealthIconService.getColorForIdentifier(entry.key).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${entry.value}',
              style: TextStyle(
                color: HealthIconService.getColorForIdentifier(entry.key),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取分类图标
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '活动':
        return Icons.directions_walk;
      case '心脏':
        return Icons.favorite;
      case '身体':
        return Icons.monitor_weight;
      case '营养':
        return Icons.restaurant;
      case '睡眠':
        return Icons.bedtime;
      case '运动':
        return Icons.sports_soccer;
      case '生命体征':
        return Icons.favorite;
      case '听力':
        return Icons.hearing;
      case '生殖健康':
        return Icons.calendar_today;
      case '心理健康':
        return Icons.self_improvement;
      case '其他健康指标':
        return Icons.health_and_safety;
      default:
        return Icons.health_and_safety;
    }
  }

  /// 获取分类颜色
  Color _getCategoryColor(String category) {
    switch (category) {
      case '活动':
        return Colors.orange;
      case '心脏':
        return Colors.red;
      case '身体':
        return Colors.blue;
      case '营养':
        return Colors.green;
      case '睡眠':
        return Colors.purple;
      case '运动':
        return Colors.indigo;
      case '生命体征':
        return Colors.red;
      case '听力':
        return Colors.amber;
      case '生殖健康':
        return Colors.pink;
      case '心理健康':
        return Colors.teal;
      case '其他健康指标':
        return Colors.brown;
      default:
        return Colors.brown;
    }
  }

  /// 分享统计信息
  // void _shareStatistics() {
  //   // 实现分享功能
  //   IOSSnackBar.showInfo(context, message: '分享功能开发中...');
  // }
}
