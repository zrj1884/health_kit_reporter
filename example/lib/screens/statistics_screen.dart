import 'package:flutter/material.dart';

import '../components/ios_snackbar.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareStatistics,
            tooltip: '分享统计信息',
          ),
        ],
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
                  _getIdentifierDisplayName(entry.key),
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

  /// 获取标识符显示名称
  String _getIdentifierDisplayName(String identifier) {
    switch (identifier) {
      // 活动相关
      case 'HKQuantityTypeIdentifierStepCount':
        return '步数';
      case 'HKQuantityTypeIdentifierDistanceWalkingRunning':
        return '步行跑步距离';
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
        return '活动能量';
      case 'HKQuantityTypeIdentifierBasalEnergyBurned':
        return '基础能量';
      case 'HKQuantityTypeIdentifierFlightsClimbed':
        return '爬楼层数';
      case 'HKQuantityTypeIdentifierAppleExerciseTime':
        return '运动时间';
      case 'HKQuantityTypeIdentifierAppleStandTime':
        return '站立时间';

      // 心脏相关
      case 'HKQuantityTypeIdentifierHeartRate':
        return '心率';
      case 'HKQuantityTypeIdentifierRestingHeartRate':
        return '静息心率';
      case 'HKQuantityTypeIdentifierWalkingHeartRateAverage':
        return '步行心率';
      case 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN':
        return '心率变异性';
      case 'HKQuantityTypeIdentifierVO2Max':
        return '最大摄氧量';

      // 身体测量
      case 'HKQuantityTypeIdentifierBodyMass':
        return '体重';
      case 'HKQuantityTypeIdentifierBodyFatPercentage':
        return '体脂率';
      case 'HKQuantityTypeIdentifierHeight':
        return '身高';
      case 'HKQuantityTypeIdentifierBodyMassIndex':
        return 'BMI';
      case 'HKQuantityTypeIdentifierLeanBodyMass':
        return '瘦体重';

      // 营养
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
        return '摄入能量';
      case 'HKQuantityTypeIdentifierDietaryProtein':
        return '蛋白质';
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
        return '碳水化合物';
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
        return '总脂肪';
      case 'HKQuantityTypeIdentifierDietaryWater':
        return '水分';

      // 睡眠
      case 'HKCategoryTypeIdentifierSleepAnalysis':
        return '睡眠分析';
      case 'HKCategoryTypeIdentifierSleepChanges':
        return '睡眠变化';

      // 运动
      case 'HKWorkoutTypeIdentifier':
        return '运动';
      case 'HKWorkoutTypeIdentifierWalking':
        return '步行';
      case 'HKWorkoutTypeIdentifierRunning':
        return '跑步';
      case 'HKWorkoutTypeIdentifierCycling':
        return '骑行';
      case 'HKWorkoutTypeIdentifierSwimming':
        return '游泳';
      case 'HKWorkoutTypeIdentifierYoga':
        return '瑜伽';
      case 'HKWorkoutTypeIdentifierStrengthTraining':
        return '力量训练';

      // 生命体征
      case 'HKQuantityTypeIdentifierBloodPressureSystolic':
        return '收缩压';
      case 'HKQuantityTypeIdentifierBloodPressureDiastolic':
        return '舒张压';
      case 'HKQuantityTypeIdentifierRespiratoryRate':
        return '呼吸率';
      case 'HKQuantityTypeIdentifierBodyTemperature':
        return '体温';
      case 'HKQuantityTypeIdentifierOxygenSaturation':
        return '血氧饱和度';

      // 听力
      case 'HKQuantityTypeIdentifierEnvironmentalAudioExposure':
        return '环境音频暴露';
      case 'HKQuantityTypeIdentifierHeadphoneAudioExposure':
        return '耳机音频暴露';

      // 生殖健康
      case 'HKCategoryTypeIdentifierMenstrualFlow':
        return '月经流量';
      case 'HKCategoryTypeIdentifierIntermenstrualBleeding':
        return '经间期出血';
      case 'HKCategoryTypeIdentifierSexualActivity':
        return '性活动';

      // 心理健康
      case 'HKCategoryTypeIdentifierMindfulSession':
        return '正念会话';

      default:
        return identifier;
    }
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
      case '听力':
        return Icons.hearing;
      case '生殖健康':
        return Icons.calendar_today;
      case '心理健康':
        return Icons.self_improvement;
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
      case '听力':
        return Colors.amber;
      case '生殖健康':
        return Colors.pink;
      case '心理健康':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  /// 分享统计信息
  void _shareStatistics() {
    // TODO: 实现分享功能
    IOSSnackBar.showInfo(context, message: '分享功能开发中...');
  }
}
