import 'package:flutter/material.dart';

import '../models/health_record.dart';
import '../services/health_sync_service.dart';
import '../services/health_icon_service.dart';
import '../components/ios_snackbar.dart';
import 'statistics_screen.dart';
import 'health_filter_screen.dart';

class HealthDatabaseScreen extends StatefulWidget {
  const HealthDatabaseScreen({super.key});

  @override
  State<HealthDatabaseScreen> createState() => _HealthDatabaseScreenState();
}

class _HealthDatabaseScreenState extends State<HealthDatabaseScreen> {
  final HealthSyncService _syncService = HealthSyncService();

  List<HealthRecord> _records = [];
  List<HealthRecord> _filteredRecords = [];
  bool _isLoading = false;
  bool _isSyncing = false;

  // 过滤条件
  String? _selectedIdentifier;
  DateTime? _startDate;
  DateTime? _endDate;
  bool? _isValidFilter;
  int _totalFilteredRecords = 0;

  // 分页
  int _currentPage = 0;
  static const int _pageSize = 20;
  bool _hasMoreData = true;

  // 统计信息
  Map<String, dynamic>? _statistics;

  // 可用的标识符
  final List<String> _availableIdentifiers = [
    // 活动相关
    'HKQuantityTypeIdentifierStepCount',
    'HKQuantityTypeIdentifierDistanceWalkingRunning',
    'HKQuantityTypeIdentifierActiveEnergyBurned',
    'HKQuantityTypeIdentifierBasalEnergyBurned',
    'HKQuantityTypeIdentifierFlightsClimbed',
    'HKQuantityTypeIdentifierAppleExerciseTime',
    'HKQuantityTypeIdentifierAppleStandTime',

    // 心脏相关
    'HKQuantityTypeIdentifierHeartRate',
    'HKQuantityTypeIdentifierRestingHeartRate',
    'HKQuantityTypeIdentifierWalkingHeartRateAverage',
    'HKQuantityTypeIdentifierHeartRateVariabilitySDNN',
    'HKQuantityTypeIdentifierVO2Max',

    // 身体测量
    'HKQuantityTypeIdentifierBodyMass',
    'HKQuantityTypeIdentifierBodyFatPercentage',
    'HKQuantityTypeIdentifierHeight',
    'HKQuantityTypeIdentifierBodyMassIndex',
    'HKQuantityTypeIdentifierLeanBodyMass',

    // 营养
    'HKQuantityTypeIdentifierDietaryEnergyConsumed',
    'HKQuantityTypeIdentifierDietaryProtein',
    'HKQuantityTypeIdentifierDietaryCarbohydrates',
    'HKQuantityTypeIdentifierDietaryFatTotal',
    'HKQuantityTypeIdentifierDietaryWater',

    // 睡眠
    // 'HKCategoryTypeIdentifierSleepAnalysis',
    // 'HKCategoryTypeIdentifierSleepChanges',

    // 运动
    // 'HKWorkoutTypeIdentifier',
    // 'HKWorkoutTypeIdentifierWalking',
    // 'HKWorkoutTypeIdentifierRunning',
    // 'HKWorkoutTypeIdentifierCycling',
    // 'HKWorkoutTypeIdentifierSwimming',
    // 'HKWorkoutTypeIdentifierYoga',
    // 'HKWorkoutTypeIdentifierStrengthTraining',

    // 生命体征
    'HKQuantityTypeIdentifierBloodPressureSystolic',
    'HKQuantityTypeIdentifierBloodPressureDiastolic',
    'HKQuantityTypeIdentifierRespiratoryRate',
    'HKQuantityTypeIdentifierBodyTemperature',
    'HKQuantityTypeIdentifierOxygenSaturation',

    // 听力
    // 'HKQuantityTypeIdentifierEnvironmentalAudioExposure',
    // 'HKQuantityTypeIdentifierHeadphoneAudioExposure',

    // 生殖健康
    // 'HKCategoryTypeIdentifierMenstrualFlow',
    // 'HKCategoryTypeIdentifierIntermenstrualBleeding',
    // 'HKCategoryTypeIdentifierSexualActivity',

    // 心理健康
    // 'HKCategoryTypeIdentifierMindfulSession',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecords();
    _loadStatistics();
    // _startSync();
  }

  @override
  void dispose() {
    _syncService.stopSync();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final records = await _syncService.getFilteredRecords(
        identifier: _selectedIdentifier,
        startDate: _startDate,
        endDate: _endDate,
        isValid: _isValidFilter,
        limit: _pageSize,
        offset: _currentPage * _pageSize,
      );

      if (mounted) {
        setState(() {
          if (_currentPage == 0) {
            _records = records;
          } else {
            _records.addAll(records);
          }
          _filteredRecords = _records;
          _hasMoreData = records.length == _pageSize;
        });
      }
    } catch (e) {
      if (mounted) {
        IOSSnackBar.showError(context, message: '加载记录失败: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadStatistics() async {
    try {
      final statistics = await _syncService.getStatistics();

      if (_selectedIdentifier != null || _startDate != null || _endDate != null || _isValidFilter != null) {
        _totalFilteredRecords = await _syncService.getRecordCount(
          identifier: _selectedIdentifier,
          startDate: _startDate,
          endDate: _endDate,
          isValid: _isValidFilter,
        );
      }
      if (mounted) {
        setState(() {
          _statistics = statistics;
        });
      }
    } catch (e) {
      print('加载统计信息失败: $e');
    }
  }

  Future<void> _startSync() async {
    if (mounted) {
      setState(() {
        _isSyncing = true;
      });
    }

    try {
      final result = await _syncService.startSync(
        _availableIdentifiers,
        onDataChanged: (identifier) {
          if (mounted) {
            IOSSnackBar.showInfo(context, message: '检测到 ${_getIdentifierDisplayName(identifier)} 数据变化');
          }
        },
        onSyncComplete: (newRecords, deletedIds) async {
          await _loadRecords();
          await _loadStatistics();
          if (newRecords.isNotEmpty) {
            if (mounted) {
              IOSSnackBar.showSuccess(context, message: '同步完成: ${newRecords.length} 条新记录');
            }
          }
          if (deletedIds.isNotEmpty) {
            if (mounted) {
              IOSSnackBar.showInfo(context, message: '删除完成: ${deletedIds.length} 条记录');
            }
          }
        },
      );

      if (mounted) {
        setState(() {
          _isSyncing = result;
        });
      }
    } catch (e) {
      if (mounted) {
        IOSSnackBar.showError(context, message: '启动同步失败: $e');

        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  void _applyFilters() {
    _currentPage = 0;
    _loadRecords();
  }

  Future<void> _showFilterDialog() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => HealthFilterScreen(
          initialIdentifier: _selectedIdentifier,
          initialStartDate: _startDate,
          initialEndDate: _endDate,
          initialIsValid: _isValidFilter,
        ),
      ),
    );

    if (result != null) {
      _selectedIdentifier = result['identifier'];
      _startDate = result['startDate'];
      _endDate = result['endDate'];
      _isValidFilter = result['isValid'];

      _totalFilteredRecords = await _syncService.getRecordCount(
        identifier: _selectedIdentifier,
        startDate: _startDate,
        endDate: _endDate,
        isValid: _isValidFilter,
      );

      setState(() {
        _applyFilters();
      });
    }
  }

  void _showStatisticsDialog() {
    if (_statistics == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(statistics: _statistics!),
      ),
    );
  }

  Future<void> _clearAllRecords() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text('确定要清空所有记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              '清空',
              style: TextStyle(color: Color(0xFFFF3B30)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _syncService.clearAllRecords();
        await _loadRecords();
        await _loadStatistics();
        if (mounted) {
          IOSSnackBar.showSuccess(context, message: '所有记录已清空');
        }
      } catch (e) {
        if (mounted) {
          IOSSnackBar.showError(context, message: '清空失败: $e');
        }
      }
    }
  }

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

  Future<void> _deleteRecord(HealthRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除这条记录吗？\n${_getIdentifierDisplayName(record.identifier)}: ${_formatValue(record.value)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _syncService.deleteRecord(record.id);
        await _loadRecords();
        await _loadStatistics();
        if (mounted) {
          IOSSnackBar.showSuccess(context, message: '记录已删除');
        }
      } catch (e) {
        if (mounted) {
          IOSSnackBar.showError(context, message: '删除失败: $e');
        }
      }
    }
  }

  void _loadMoreData() {
    if (_hasMoreData && !_isLoading) {
      _currentPage++;
      _loadRecords();
    }
  }

  /// 获取当前过滤条件下的总记录数
  int _getFilteredTotalCount() {
    // 如果有过滤条件，返回当前显示的记录数
    if (_selectedIdentifier != null || _startDate != null || _endDate != null || _isValidFilter != null) {
      return _totalFilteredRecords;
    }
    // 如果没有过滤条件，返回数据库总记录数
    return _statistics?['totalRecords'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '健康数据详情',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          _buildIOSStyleIconButton(
            icon: Icons.analytics,
            onPressed: _showStatisticsDialog,
            tooltip: '统计信息',
          ),
          _buildIOSStyleIconButton(
            icon: Icons.filter_list,
            onPressed: _showFilterDialog,
            tooltip: '过滤',
          ),
          _buildIOSStyleIconButton(
            icon: Icons.refresh,
            onPressed: () {
              _currentPage = 0;
              _loadRecords();
              _loadStatistics();
            },
            tooltip: '刷新',
          ),
          _buildIOSStylePopupMenu(),
        ],
      ),
      body: Column(
        children: [
          // 状态栏
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isSyncing ? const Color(0xFF34C759).withValues(alpha: 0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isSyncing ? const Color(0xFF34C759) : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSyncing ? Icons.sync : Icons.sync_disabled,
                        size: 16,
                        color: _isSyncing ? const Color(0xFF34C759) : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isSyncing ? '同步中...' : '同步已停止',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _isSyncing ? const Color(0xFF34C759) : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${_filteredRecords.length} 条记录',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 显示当前过滤条件下的总记录数
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '总: ${_getFilteredTotalCount()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 记录列表
          Expanded(
            child: _isLoading && _currentPage == 0
                ? const Center(child: CircularProgressIndicator())
                : _filteredRecords.isEmpty
                    ? const Center(child: Text('暂无数据'))
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                            _loadMoreData();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: _filteredRecords.length + (_hasMoreData ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredRecords.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final record = _filteredRecords[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: record.isValid
                                        ? HealthIconService.getBackgroundColorForIdentifier(record.identifier)
                                        : const Color(0xFFFF3B30).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: record.isValid
                                          ? HealthIconService.getColorForIdentifier(record.identifier)
                                              .withValues(alpha: 0.3)
                                          : const Color(0xFFFF3B30).withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    HealthIconService.getIconForIdentifier(record.identifier),
                                    color: record.isValid
                                        ? HealthIconService.getColorForIdentifier(record.identifier)
                                        : const Color(0xFFFF3B30),
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  _getIdentifierDisplayName(record.identifier),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${_formatValue(record.value)} ${record.unit}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          record.startDate.toString().substring(0, 19),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.source,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          record.sourceName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.grey.shade600,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    itemBuilder: (context) => [
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              color: const Color(0xFFFF3B30),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              '删除',
                                              style: TextStyle(
                                                color: Color(0xFFFF3B30),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        _deleteRecord(record);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startSync,
        tooltip: '开始同步',
        child: const Icon(Icons.sync),
      ),
    );
  }

  Widget _buildIOSStyleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 22,
              color: const Color(0xFF007AFF),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIOSStylePopupMenu() {
    return Container(
      margin: const EdgeInsets.all(4),
      child: PopupMenuButton<String>(
        icon: const Icon(
          Icons.more_vert,
          color: Color(0xFF007AFF),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'clear',
            child: Row(
              children: [
                Icon(
                  Icons.delete_forever,
                  color: const Color(0xFFFF3B30),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  '清空所有记录',
                  style: TextStyle(
                    color: Color(0xFFFF3B30),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'clear') {
            _clearAllRecords();
          }
        },
      ),
    );
  }

  /// 格式化数值显示，控制浮点数精度
  String _formatValue(dynamic value) {
    if (value == null) return '0';

    // 如果是字符串，尝试转换为数字
    if (value is String) {
      try {
        final numValue = double.tryParse(value);
        if (numValue != null) {
          return _formatNumber(numValue);
        }
        return value; // 如果无法转换，直接返回原字符串
      } catch (e) {
        return value;
      }
    }

    // 如果是数字类型
    if (value is num) {
      return _formatNumber(value.toDouble());
    }

    // 其他类型直接转换为字符串
    return value.toString();
  }

  /// 格式化数字，限制小数点后3位
  String _formatNumber(double number) {
    // 如果是整数，直接返回整数形式
    if (number == number.toInt()) {
      return number.toInt().toString();
    }

    // 如果是小数，限制为3位小数
    return number.toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}
