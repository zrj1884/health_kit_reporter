import 'package:flutter/material.dart';

import '../models/health_record.dart';
import '../services/health_sync_service.dart';

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

  // 分页
  int _currentPage = 0;
  static const int _pageSize = 20;
  bool _hasMoreData = true;

  // 统计信息
  Map<String, dynamic>? _statistics;

  // 可用的标识符
  final List<String> _availableIdentifiers = [
    'HKQuantityTypeIdentifierStepCount',
    'HKQuantityTypeIdentifierHeartRate',
    'HKQuantityTypeIdentifierActiveEnergyBurned',
    'HKQuantityTypeIdentifierDistanceWalkingRunning',
    'HKQuantityTypeIdentifierBodyMass',
    'HKCategoryTypeIdentifierSleepAnalysis',
    'HKWorkoutTypeIdentifier',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecords();
    _loadStatistics();
    _startSync();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载记录失败: $e')),
        );
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
      await _syncService.startSync(
        _availableIdentifiers,
        onDataChanged: (identifier) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('检测到 $identifier 数据变化')),
            );
          }
        },
        onSyncComplete: (newRecords, deletedIds) async {
          await _loadRecords();
          await _loadStatistics();
          if (newRecords.isNotEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('同步完成: ${newRecords.length} 条新记录')),
              );
            }
          }
          if (deletedIds.isNotEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('删除完成: ${deletedIds.length} 条记录')),
              );
            }
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('启动同步失败: $e')),
        );

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
    String? selectedIdentifier = _selectedIdentifier;
    DateTime? startDate = _startDate;
    DateTime? endDate = _endDate;
    bool? isValidFilter = _isValidFilter;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('过滤条件'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedIdentifier,
              decoration: const InputDecoration(labelText: '数据类型'),
              items: [
                const DropdownMenuItem(value: null, child: Text('全部')),
                ..._availableIdentifiers.map((id) => DropdownMenuItem(
                      value: id,
                      child: Text(_getIdentifierDisplayName(id)),
                    )),
              ],
              onChanged: (value) => selectedIdentifier = value,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        startDate = date;
                      }
                    },
                    child: Text(startDate?.toString().substring(0, 10) ?? '开始日期'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        endDate = date;
                      }
                    },
                    child: Text(endDate?.toString().substring(0, 10) ?? '结束日期'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<bool>(
              value: isValidFilter,
              decoration: const InputDecoration(labelText: '有效性'),
              items: const [
                DropdownMenuItem(value: null, child: Text('全部')),
                DropdownMenuItem(value: true, child: Text('有效')),
                DropdownMenuItem(value: false, child: Text('无效')),
              ],
              onChanged: (value) => isValidFilter = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedIdentifier = selectedIdentifier;
                _startDate = startDate;
                _endDate = endDate;
                _isValidFilter = isValidFilter;
                _applyFilters();
              });
              Navigator.pop(context);
            },
            child: const Text('应用'),
          ),
        ],
      ),
    );
  }

  Future<void> _showStatisticsDialog() async {
    if (_statistics == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('统计信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('总记录数: ${_statistics!['totalRecords']}'),
            Text('有效记录: ${_statistics!['validRecords']}'),
            Text('无效记录: ${_statistics!['invalidRecords']}'),
            Text('数据类型数: ${_statistics!['uniqueIdentifiers']}'),
            const SizedBox(height: 16),
            const Text('各类型记录数:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...(_statistics!['identifierCounts'] as Map<String, dynamic>).entries.map(
                  (entry) => Text('${_getIdentifierDisplayName(entry.key)}: ${entry.value}'),
                ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
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
            child: const Text('清空'),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('所有记录已清空')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('清空失败: $e')),
          );
        }
      }
    }
  }

  String _getIdentifierDisplayName(String identifier) {
    switch (identifier) {
      case 'HKQuantityTypeIdentifierStepCount':
        return '步数';
      case 'HKQuantityTypeIdentifierHeartRate':
        return '心率';
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
        return '活动能量';
      case 'HKQuantityTypeIdentifierDistanceWalkingRunning':
        return '步行跑步距离';
      case 'HKQuantityTypeIdentifierBodyMass':
        return '体重';
      case 'HKCategoryTypeIdentifierSleepAnalysis':
        return '睡眠分析';
      case 'HKWorkoutTypeIdentifier':
        return '运动';
      default:
        return identifier;
    }
  }

  Future<void> _deleteRecord(HealthRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除这条记录吗？\n${record.identifier}: ${record.value}'),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('记录已删除')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('删除失败: $e')),
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康数据详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showStatisticsDialog,
            tooltip: '统计信息',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: '过滤',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _currentPage = 0;
              _loadRecords();
              _loadStatistics();
            },
            tooltip: '刷新',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('清空所有记录'),
              ),
            ],
            onSelected: (value) {
              if (value == 'clear') {
                _clearAllRecords();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 状态栏
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(
                  _isSyncing ? Icons.sync : Icons.sync_disabled,
                  color: _isSyncing ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(_isSyncing ? '同步中...' : '同步已停止'),
                const Spacer(),
                Text('${_filteredRecords.length} 条记录'),
                if (_statistics != null) ...[
                  const SizedBox(width: 16),
                  Text('总: ${_statistics!['totalRecords']}'),
                ],
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
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: record.isValid ? Colors.green[100] : Colors.red[100],
                                  child: Icon(
                                    Icons.favorite,
                                    color: record.isValid ? Colors.green[600] : Colors.red[600],
                                  ),
                                ),
                                title: Text(
                                  _getIdentifierDisplayName(record.identifier),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('值: ${record.value} ${record.unit}'),
                                    Text('时间: ${record.startDate.toString().substring(0, 19)}'),
                                    Text('来源: ${record.sourceName}'),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('删除'),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _deleteRecord(record);
                                    }
                                  },
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
}
