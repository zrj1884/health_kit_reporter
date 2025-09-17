import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/health_record.dart';
import '../services/health_sync_service.dart';
import '../services/health_icon_service.dart';
import '../components/ios_snackbar.dart';
import 'statistics_screen.dart';
import 'health_filter_screen.dart';

class HealthDatabaseScreen extends StatefulWidget {
  const HealthDatabaseScreen({super.key, required this.flutterLocalNotificationsPlugin});

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  State<HealthDatabaseScreen> createState() => _HealthDatabaseScreenState();
}

class _HealthDatabaseScreenState extends State<HealthDatabaseScreen> {
  final HealthSyncService _syncService = HealthSyncService();
  final ScrollController _scrollController = ScrollController();

  List<HealthRecord> _records = [];
  List<HealthRecord> _filteredRecords = [];
  bool _isLoading = false;
  bool _isSyncing = false;

  // 过滤条件
  String? _selectedIdentifier;
  DateTime? _startDate;
  DateTime? _endDate;
  bool? _isValidFilter;
  String? _selectedSourceName;
  int _totalFilteredRecords = 0;

  // 分页
  int _currentPage = 0;
  static const int _pageSize = 20;
  bool _hasMoreData = true;

  // 统计信息
  Map<String, dynamic>? _statistics;

  // 滚动到顶部按钮显示状态
  bool _showScrollToTopButton = false;

  // 可用的标识符
  final List<String> _availableIdentifiers = [
    // 活动相关
    'HKQuantityTypeIdentifierStepCount',
    'HKQuantityTypeIdentifierDistanceWalkingRunning',
    'HKQuantityTypeIdentifierDistanceCycling',
    'HKQuantityTypeIdentifierDistanceWheelchair',
    'HKQuantityTypeIdentifierDistanceSwimming',
    'HKQuantityTypeIdentifierDistanceDownhillSnowSports',
    'HKQuantityTypeIdentifierActiveEnergyBurned',
    'HKQuantityTypeIdentifierBasalEnergyBurned',
    'HKQuantityTypeIdentifierFlightsClimbed',
    'HKQuantityTypeIdentifierAppleExerciseTime',
    'HKQuantityTypeIdentifierAppleStandTime',
    'HKQuantityTypeIdentifierAppleMoveTime',
    'HKQuantityTypeIdentifierAppleWalkingSteadiness',
    'HKQuantityTypeIdentifierNikeFuel',
    'HKQuantityTypeIdentifierPushCount',
    'HKQuantityTypeIdentifierSwimmingStrokeCount',
    'HKQuantityTypeIdentifierWalkingSpeed',
    'HKQuantityTypeIdentifierWalkingDoubleSupportPercentage',
    'HKQuantityTypeIdentifierWalkingAsymmetryPercentage',
    'HKQuantityTypeIdentifierWalkingStepLength',
    'HKQuantityTypeIdentifierSixMinuteWalkTestDistance',
    'HKQuantityTypeIdentifierStairAscentSpeed',
    'HKQuantityTypeIdentifierStairDescentSpeed',
    'HKQuantityTypeIdentifierRunningStrideLength',
    'HKQuantityTypeIdentifierRunningVerticalOscillation',
    'HKQuantityTypeIdentifierRunningGroundContactTime',
    'HKQuantityTypeIdentifierRunningPower',
    'HKQuantityTypeIdentifierRunningSpeed',
    'HKQuantityTypeIdentifierUVExposure',
    'HKQuantityTypeIdentifierUnderwaterDepth',
    'HKQuantityTypeIdentifierWaterTemperature',

    // 心脏相关
    'HKQuantityTypeIdentifierHeartRate',
    'HKQuantityTypeIdentifierRestingHeartRate',
    'HKQuantityTypeIdentifierWalkingHeartRateAverage',
    'HKQuantityTypeIdentifierHeartRateVariabilitySDNN',
    'HKQuantityTypeIdentifierVO2Max',
    'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute',
    'HKQuantityTypeIdentifierAtrialFibrillationBurden',

    // 身体测量
    'HKQuantityTypeIdentifierBodyMass',
    'HKQuantityTypeIdentifierBodyFatPercentage',
    'HKQuantityTypeIdentifierHeight',
    'HKQuantityTypeIdentifierBodyMassIndex',
    'HKQuantityTypeIdentifierLeanBodyMass',
    'HKQuantityTypeIdentifierWaistCircumference',
    'HKQuantityTypeIdentifierBodyTemperature',
    'HKQuantityTypeIdentifierBasalBodyTemperature',
    'HKQuantityTypeIdentifierAppleSleepingWristTemperature',
    'HKQuantityTypeIdentifierNumberOfTimesFallen',
    'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages',

    // 营养
    'HKQuantityTypeIdentifierDietaryEnergyConsumed',
    'HKQuantityTypeIdentifierDietaryProtein',
    'HKQuantityTypeIdentifierDietaryCarbohydrates',
    'HKQuantityTypeIdentifierDietaryFiber',
    'HKQuantityTypeIdentifierDietarySugar',
    'HKQuantityTypeIdentifierDietaryFatTotal',
    'HKQuantityTypeIdentifierDietaryFatPolyunsaturated',
    'HKQuantityTypeIdentifierDietaryFatMonounsaturated',
    'HKQuantityTypeIdentifierDietaryFatSaturated',
    'HKQuantityTypeIdentifierDietaryCholesterol',
    'HKQuantityTypeIdentifierDietarySodium',
    'HKQuantityTypeIdentifierDietaryVitaminA',
    'HKQuantityTypeIdentifierDietaryVitaminB6',
    'HKQuantityTypeIdentifierDietaryVitaminB12',
    'HKQuantityTypeIdentifierDietaryVitaminC',
    'HKQuantityTypeIdentifierDietaryVitaminD',
    'HKQuantityTypeIdentifierDietaryVitaminE',
    'HKQuantityTypeIdentifierDietaryVitaminK',
    'HKQuantityTypeIdentifierDietaryCalcium',
    'HKQuantityTypeIdentifierDietaryIron',
    'HKQuantityTypeIdentifierDietaryThiamin',
    'HKQuantityTypeIdentifierDietaryRiboflavin',
    'HKQuantityTypeIdentifierDietaryNiacin',
    'HKQuantityTypeIdentifierDietaryFolate',
    'HKQuantityTypeIdentifierDietaryBiotin',
    'HKQuantityTypeIdentifierDietaryPantothenicAcid',
    'HKQuantityTypeIdentifierDietaryPhosphorus',
    'HKQuantityTypeIdentifierDietaryIodine',
    'HKQuantityTypeIdentifierDietaryMagnesium',
    'HKQuantityTypeIdentifierDietaryZinc',
    'HKQuantityTypeIdentifierDietarySelenium',
    'HKQuantityTypeIdentifierDietaryCopper',
    'HKQuantityTypeIdentifierDietaryManganese',
    'HKQuantityTypeIdentifierDietaryChromium',
    'HKQuantityTypeIdentifierDietaryMolybdenum',
    'HKQuantityTypeIdentifierDietaryChloride',
    'HKQuantityTypeIdentifierDietaryPotassium',
    'HKQuantityTypeIdentifierDietaryCaffeine',
    'HKQuantityTypeIdentifierDietaryWater',

    // 生命体征
    'HKQuantityTypeIdentifierBloodPressureSystolic',
    'HKQuantityTypeIdentifierBloodPressureDiastolic',
    'HKQuantityTypeIdentifierRespiratoryRate',
    'HKQuantityTypeIdentifierOxygenSaturation',
    'HKQuantityTypeIdentifierPeripheralPerfusionIndex',
    'HKQuantityTypeIdentifierBloodGlucose',
    'HKQuantityTypeIdentifierBloodAlcoholContent',
    'HKQuantityTypeIdentifierForcedVitalCapacity',
    'HKQuantityTypeIdentifierForcedExpiratoryVolume1',
    'HKQuantityTypeIdentifierPeakExpiratoryFlowRate',

    // 听力
    'HKQuantityTypeIdentifierEnvironmentalAudioExposure',
    'HKQuantityTypeIdentifierHeadphoneAudioExposure',

    // 其他健康指标
    'HKQuantityTypeIdentifierElectrodermalActivity',
    'HKQuantityTypeIdentifierInhalerUsage',
    'HKQuantityTypeIdentifierInsulinDelivery',

    // 睡眠
    'HKCategoryTypeIdentifierSleepAnalysis',
    'HKCategoryTypeIdentifierSleepChanges',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refreshList();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _syncService.stopSync();
    super.dispose();
  }

  /// 滚动监听器
  void _onScroll() {
    const double scrollThreshold = 200.0; // 滚动超过200像素时显示按钮
    final bool shouldShow = _scrollController.offset > scrollThreshold;

    if (shouldShow != _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = shouldShow;
      });
    }
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
        sourceName: _selectedSourceName,
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

      if (_selectedIdentifier != null ||
          _startDate != null ||
          _endDate != null ||
          _isValidFilter != null ||
          _selectedSourceName != null) {
        _totalFilteredRecords = await _syncService.getRecordCount(
          identifier: _selectedIdentifier,
          startDate: _startDate,
          endDate: _endDate,
          isValid: _isValidFilter,
          sourceName: _selectedSourceName,
        );
      }
      if (mounted) {
        setState(() {
          _statistics = statistics;
        });
      }
    } catch (e) {
      debugPrint('加载统计信息失败: $e');
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
          final displayName = HealthIconService.getDisplayNameForIdentifier(identifier);
          // if (mounted) {
          //   IOSSnackBar.showInfo(context, message: '检测到 $displayName 数据变化');
          // }

          const iOSDetails = DarwinNotificationDetails();
          const details = NotificationDetails(iOS: iOSDetails);
          widget.flutterLocalNotificationsPlugin.show(0, '健康数据更新', displayName, details);
        },
        onSyncComplete: (newRecords, deletedIds) async {
          _refreshList();

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

  Future<void> _showFilterDialog() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => HealthFilterScreen(
          initialIdentifier: _selectedIdentifier,
          initialStartDate: _startDate,
          initialEndDate: _endDate,
          initialIsValid: _isValidFilter,
          initialSourceName: _selectedSourceName,
        ),
      ),
    );

    if (result != null) {
      _selectedIdentifier = result['identifier'];
      _startDate = result['startDate'];
      _endDate = result['endDate'];
      _isValidFilter = result['isValid'];
      _selectedSourceName = result['sourceName'];

      _totalFilteredRecords = await _syncService.getRecordCount(
        identifier: _selectedIdentifier,
        startDate: _startDate,
        endDate: _endDate,
        isValid: _isValidFilter,
        sourceName: _selectedSourceName,
      );

      await _refreshList();
    }
  }

  Future<void> _refreshList() async {
    _currentPage = 0;
    await _loadRecords();
    await _loadStatistics();
    // 滚动到列表顶部
    _scrollToTop();
  }

  Future<void> _loadMoreData() async {
    if (_hasMoreData && !_isLoading) {
      _currentPage++;
      await _loadRecords();
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _showStatisticsDialog() {
    if (_statistics == null) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsScreen(statistics: _statistics!)));
  }

  Future<void> _clearAllRecords() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text('确定要清空所有记录吗？此操作不可撤销。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清空', style: TextStyle(color: Color(0xFFFF3B30))),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _syncService.clearAllRecords();
        // 重置首次查询状态，下次同步时将重新获取完整数据
        await _syncService.resetFirstQueryState();

        await _refreshList();
        if (mounted) {
          IOSSnackBar.showSuccess(context, message: '所有记录已清空，下次同步将重新获取完整数据');
        }
      } catch (e) {
        if (mounted) {
          IOSSnackBar.showError(context, message: '清空失败: $e');
        }
      }
    }
  }

  Future<void> _deleteRecord(HealthRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text(
          '确定要删除这条记录吗？\n${HealthIconService.getDisplayNameForIdentifier(record.identifier)}: ${_formatValue(record.value, record.unit)}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('删除')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _syncService.deleteRecord(record.id);
        await _refreshList();
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

  /// 检查当前是否有过滤条件
  bool get _hasActiveFilters {
    return _selectedIdentifier != null ||
        _startDate != null ||
        _endDate != null ||
        _isValidFilter != null ||
        _selectedSourceName != null;
  }

  /// 获取当前过滤条件下的总记录数
  int _getFilteredTotalCount() {
    // 如果有过滤条件，返回当前显示的记录数
    if (_hasActiveFilters) {
      return _totalFilteredRecords;
    }
    // 如果没有过滤条件，返回数据库总记录数
    return _statistics?['totalRecords'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: Column(
        children: [
          // 紧凑的顶部状态栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
            ),
            child: Row(
              children: [
                // 左侧：同步状态和记录数量
                Expanded(
                  child: Row(
                    children: [
                      // 同步状态
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: _isSyncing ? const Color(0xFF34C759).withValues(alpha: 0.1) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isSyncing ? const Color(0xFF34C759) : Colors.grey.shade300,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isSyncing ? Icons.sync : Icons.sync_disabled,
                              size: 12,
                              color: _isSyncing ? const Color(0xFF34C759) : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isSyncing ? '同步中' : '已停止',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: _isSyncing ? const Color(0xFF34C759) : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 记录数量（合并显示）
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF007AFF).withValues(alpha: 0.3), width: 0.5),
                        ),
                        child: Text(
                          '${_filteredRecords.length}/${_getFilteredTotalCount()}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF007AFF)),
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧：快捷按钮
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    _buildCompactIconButton(icon: Icons.analytics, onPressed: _showStatisticsDialog, tooltip: '统计信息'),
                    _buildCompactIconButton(
                      icon: _hasActiveFilters ? Icons.filter_list : Icons.filter_list_off,
                      onPressed: _showFilterDialog,
                      tooltip: '过滤',
                      iconColor: _hasActiveFilters ? const Color(0xFFFF9500) : null,
                    ),
                    _buildCompactIconButton(icon: Icons.refresh, onPressed: _refreshList, tooltip: '刷新'),
                    _buildCompactIconButton(
                      icon: Icons.delete_forever,
                      onPressed: _clearAllRecords,
                      tooltip: '清空所有记录',
                      iconColor: const Color(0xFFFF3B30),
                    ),
                  ],
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
                      controller: _scrollController,
                      itemCount: _filteredRecords.length + (_hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _filteredRecords.length) {
                          return const Center(
                            child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()),
                          );
                        }

                        final record = _filteredRecords[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200, width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: record.isValid
                                    ? HealthIconService.getBackgroundColorForIdentifier(record.identifier)
                                    : Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: record.isValid
                                      ? HealthIconService.getColorForIdentifier(
                                          record.identifier,
                                        ).withValues(alpha: 0.3)
                                      : Colors.grey.withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Icon(
                                HealthIconService.getIconForIdentifier(record.identifier),
                                color: record.isValid
                                    ? HealthIconService.getColorForIdentifier(record.identifier)
                                    : Colors.grey,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              HealthIconService.getDisplayNameForIdentifier(record.identifier),
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 12, color: Colors.grey.shade600),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        _formatValue(record.value, record.unit),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
                                    const SizedBox(width: 3),
                                    Text(
                                      record.startDate.toString().substring(0, 19),
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.source, size: 12, color: Colors.grey.shade600),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        record.sourceName,
                                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              margin: const EdgeInsets.only(left: 4),
                              child: PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                itemBuilder: (context) => [
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline, color: const Color(0xFFFF3B30), size: 18),
                                        const SizedBox(width: 10),
                                        const Text(
                                          '删除',
                                          style: TextStyle(
                                            color: Color(0xFFFF3B30),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
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
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              tooltip: '滚动到顶部',
              backgroundColor: const Color(0xFF007AFF),
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            )
          : FloatingActionButton(
              onPressed: _startSync,
              tooltip: '开始同步',
              backgroundColor: _isSyncing ? const Color(0xFF34C759) : const Color(0xFF007AFF),
              child: Icon(Icons.sync, color: Colors.white),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildCompactIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: iconColor ?? const Color(0xFF007AFF)),
        ),
      ),
    );
  }

  /// 格式化数值显示，控制浮点数精度
  String _formatValue(dynamic value, String unit) {
    if (value == null) return '0$unit';

    // 如果是字符串，尝试转换为数字
    if (value is String) {
      try {
        double? numValue = double.tryParse(value);
        if (numValue != null) {
          if (unit == '%') {
            numValue = numValue * 100;
          }
          return '${_formatNumber(numValue)}$unit';
        }
        return '$value$unit'; // 如果无法转换，直接返回原字符串
      } catch (e) {
        return '$value$unit';
      }
    }

    // 如果是数字类型
    if (value is num) {
      num numValue = value;
      if (unit == '%') {
        numValue = numValue * 100;
      }
      return '${_formatNumber(numValue.toDouble())}$unit';
    }

    // 其他类型直接转换为字符串
    return '$value$unit';
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
