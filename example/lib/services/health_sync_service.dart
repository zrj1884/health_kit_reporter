import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/deleted_object.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

import '../models/health_record.dart';
import 'database_service.dart';
import 'health_icon_service.dart';

/// 健康数据同步服务
/// 结合observerQuery和anchoredObjectQuery实现数据同步
class HealthSyncService {
  static final HealthSyncService _instance = HealthSyncService._internal();
  factory HealthSyncService() => _instance;
  HealthSyncService._internal() {
    _loadFirstAnchoredQueryState();
  }

  // 数据库服务
  final DatabaseService _databaseService = DatabaseService();

  // 当前同步的标识符
  final List<String> _syncingIdentifiers = <String>[];

  // 订阅管理
  StreamSubscription<dynamic>? _observerSubscription;
  StreamSubscription<dynamic>? _anchoredSubscription;

  // 回调函数
  Function(String)? _onDataChanged;
  Function(List<HealthRecord>, List<String>)? _onSyncComplete;

  // 同步状态管理
  static const String _firstAnchoredQueryKey = 'first_anchored_query_completed';
  bool _isFirstAnchoredQuery = true; // 标记是否是首次锚点查询

  /// 开始同步指定类型的数据
  Future<bool> startSync(
    List<String> identifiers, {
    Function(String)? onDataChanged,
    Function(List<HealthRecord>, List<String>)? onSyncComplete,
  }) async {
    bool result = true;

    _onDataChanged = onDataChanged;
    _onSyncComplete = onSyncComplete;

    // 停止之前的同步
    await stopSync();

    // 添加新的标识符
    _syncingIdentifiers.addAll(identifiers);

    // 1. 首次同步时进行初始同步，否则跳过
    if (_isFirstAnchoredQuery) {
      debugPrint('首次同步，执行初始同步获取历史数据');
      result = await _performInitialSync();
    } else {
      debugPrint('非首次同步，跳过初始同步，直接使用增量同步');
      result = true; // 跳过初始同步，直接进行后续步骤
    }

    // 2. 设置观察者查询监听变化
    if (result) {
      result = await _setupObserverQuery();
    }

    // 3. 设置锚点对象查询进行增量同步
    if (result) {
      result = await _setupAnchoredObjectQuery();
    }

    // 4. 启用后台交付
    if (result) {
      result = await _enableBackgroundDelivery();
    }

    return result;
  }

  /// 停止同步
  Future<void> stopSync() async {
    _observerSubscription?.cancel();
    _anchoredSubscription?.cancel();
    _syncingIdentifiers.clear();
    // 不重置首次查询标记，保持持久化状态
  }

  /// 执行初始同步，先同步历史数据
  Future<bool> _performInitialSync() async {
    try {
      // 获取近30天所有数据
      final predicate = Predicate(
        DateTime.now().subtract(const Duration(days: 30)),
        DateTime.now(),
      );

      final records = <HealthRecord>[];

      for (final identifier in _syncingIdentifiers) {
        debugPrint(
            '初始同步: ${HealthIconService.getDisplayNameForIdentifier(identifier)}, predicate: ${predicate.startDate} - ${predicate.endDate}');
        final samples = await HealthKitReporter.sampleQuery(identifier, predicate);
        for (final sample in samples) {
          records.add(HealthRecord.fromSample(sample));
        }
      }

      // 保存到数据库
      await _databaseService.insertRecords(records);

      _onSyncComplete?.call(records, []);

      return true;
    } catch (e) {
      debugPrint('初始同步失败: $e');
      return false;
    }
  }

  /// 设置观察者查询
  Future<bool> _setupObserverQuery() async {
    try {
      _observerSubscription = HealthKitReporter.observerQuery(
        _syncingIdentifiers,
        null,
        onUpdate: (identifier) async {
          debugPrint('观察者查询更新: ${HealthIconService.getDisplayNameForIdentifier(identifier)}');

          _onDataChanged?.call(identifier);

          // 当收到变化通知时，触发增量同步
          await _performIncrementalSync([identifier]);
        },
      );

      return true;
    } catch (e) {
      debugPrint('设置观察者查询失败: $e');
      return false;
    }
  }

  /// 执行增量同步
  Future<void> _performIncrementalSync(List<String> identifiers) async {
    try {
      final predicate = Predicate(
        DateTime.now().subtract(const Duration(hours: 1)),
        DateTime.now(),
      );

      final records = <HealthRecord>[];

      for (final identifier in identifiers) {
        debugPrint(
            '初始同步: ${HealthIconService.getDisplayNameForIdentifier(identifier)}, predicate: ${predicate.startDate} - ${predicate.endDate}');
        final samples = await HealthKitReporter.sampleQuery(identifier, predicate);
        for (final sample in samples) {
          records.add(HealthRecord.fromSample(sample));
        }
      }

      // 更新数据库
      await _updateDatabase(records, []);

      _onSyncComplete?.call(records, []);
    } catch (e) {
      debugPrint('增量同步失败: $e');
    }
  }

  /// 设置锚点对象查询
  Future<bool> _setupAnchoredObjectQuery() async {
    try {
      final predicate = Predicate(
        DateTime.now().subtract(const Duration(days: 7)),
        DateTime.now(),
      );

      // 首次查询不使用缓存anchor，后续查询使用缓存anchor
      final useCachedAnchor = !_isFirstAnchoredQuery;

      debugPrint('设置锚点对象查询: useCachedAnchor = $useCachedAnchor (首次查询: $_isFirstAnchoredQuery)');

      _anchoredSubscription = HealthKitReporter.anchoredObjectQuery(
        _syncingIdentifiers,
        predicate,
        useCachedAnchor: useCachedAnchor, // 根据是否首次查询决定是否使用缓存
        onUpdate: (samples, deletedObjects, identifier) async {
          if (samples.isNotEmpty || deletedObjects.isNotEmpty) {
            debugPrint(
                '锚点对象查询更新: 新增${samples.length}, 删除${deletedObjects.length}, 标识符: ${HealthIconService.getDisplayNameForIdentifier(identifier)}');

            await _handleAnchoredObjectUpdate(samples, deletedObjects);
          }
        },
      );

      // 标记已完成首次查询并保存状态
      if (_isFirstAnchoredQuery) {
        _isFirstAnchoredQuery = false;
        await _saveFirstAnchoredQueryState();
      }

      return true;
    } catch (e) {
      debugPrint('设置锚点对象查询失败: $e');
      return false;
    }
  }

  /// 处理锚点对象查询更新
  Future<void> _handleAnchoredObjectUpdate(
    List<Sample> samples,
    List<DeletedObject> deletedObjects,
  ) async {
    try {
      // 处理新增/更新的记录
      final newRecords = <HealthRecord>[];
      for (final sample in samples) {
        newRecords.add(HealthRecord.fromSample(sample));
      }

      // 处理删除的记录
      final deletedIds = deletedObjects.map((obj) => obj.uuid).toList();

      // 更新数据库
      await _updateDatabase(newRecords, deletedIds);

      _onSyncComplete?.call(newRecords, deletedIds);
    } catch (e) {
      debugPrint('处理锚点对象更新失败: $e');
    }
  }

  /// 启用后台交付
  Future<bool> _enableBackgroundDelivery() async {
    bool result = true;
    for (final identifier in _syncingIdentifiers) {
      try {
        result = await HealthKitReporter.enableBackgroundDelivery(
          identifier,
          UpdateFrequency.immediate,
        );
      } catch (e) {
        debugPrint('启用后台交付失败 $identifier: $e');
        result = false;
      }

      if (!result) {
        break;
      }
    }

    return result;
  }

  /// 更新数据库
  Future<void> _updateDatabase(
    List<HealthRecord> newRecords,
    List<String> deletedIds,
  ) async {
    try {
      // 删除记录
      if (deletedIds.isNotEmpty) {
        await _databaseService.deleteRecords(deletedIds);
      }

      // 插入/更新记录
      if (newRecords.isNotEmpty) {
        await _databaseService.insertRecords(newRecords);
      }
    } catch (e) {
      debugPrint('更新数据库失败: $e');
    }
  }

  /// 获取所有本地记录
  Future<List<HealthRecord>> getAllRecords() async {
    return await _databaseService.getAllRecords();
  }

  /// 根据条件过滤记录
  Future<List<HealthRecord>> getFilteredRecords({
    String? identifier,
    DateTime? startDate,
    DateTime? endDate,
    bool? isValid,
    String? sourceName,
    int? limit,
    int? offset,
  }) async {
    return await _databaseService.getFilteredRecords(
      identifier: identifier,
      startDate: startDate,
      endDate: endDate,
      isValid: isValid,
      sourceName: sourceName,
      limit: limit,
      offset: offset,
    );
  }

  /// 获取记录数量
  Future<int> getRecordCount({
    String? identifier,
    DateTime? startDate,
    DateTime? endDate,
    bool? isValid,
    String? sourceName,
  }) async {
    return await _databaseService.getRecordCount(
      identifier: identifier,
      startDate: startDate,
      endDate: endDate,
      isValid: isValid,
      sourceName: sourceName,
    );
  }

  /// 获取统计信息
  Future<Map<String, dynamic>> getStatistics() async {
    return await _databaseService.getStatistics();
  }

  /// 删除记录
  Future<void> deleteRecord(String id) async {
    await _databaseService.deleteRecord(id);
  }

  /// 清空所有记录
  Future<void> clearAllRecords() async {
    await _databaseService.clearAllRecords();
  }

  /// 获取唯一的数据类型标识符
  Future<List<String>> getUniqueIdentifiers() async {
    return await _databaseService.getUniqueIdentifiers();
  }

  /// 获取唯一的数据来源名称
  Future<List<String>> getUniqueSourceNames() async {
    return await _databaseService.getUniqueSourceNames();
  }

  /// 获取指定时间范围内的记录
  Future<List<HealthRecord>> getRecordsInTimeRange(
    DateTime startTime,
    DateTime endTime, {
    String? identifier,
    bool? isValid,
    int? limit,
    int? offset,
  }) async {
    return await _databaseService.getRecordsInTimeRange(
      startTime,
      endTime,
      identifier: identifier,
      isValid: isValid,
      limit: limit,
      offset: offset,
    );
  }

  /// 获取今天的记录
  Future<List<HealthRecord>> getTodayRecords({
    String? identifier,
    bool? isValid,
  }) async {
    return await _databaseService.getTodayRecords(
      identifier: identifier,
      isValid: isValid,
    );
  }

  /// 获取本周的记录
  Future<List<HealthRecord>> getThisWeekRecords({
    String? identifier,
    bool? isValid,
  }) async {
    return await _databaseService.getThisWeekRecords(
      identifier: identifier,
      isValid: isValid,
    );
  }

  /// 获取本月的记录
  Future<List<HealthRecord>> getThisMonthRecords({
    String? identifier,
    bool? isValid,
  }) async {
    return await _databaseService.getThisMonthRecords(
      identifier: identifier,
      isValid: isValid,
    );
  }

  /// 获取最近N天的记录
  Future<List<HealthRecord>> getRecentDaysRecords(
    int days, {
    String? identifier,
    bool? isValid,
  }) async {
    return await _databaseService.getRecentDaysRecords(
      days,
      identifier: identifier,
      isValid: isValid,
    );
  }

  /// 获取时间范围内的记录数量
  Future<int> getRecordCountInTimeRange(
    DateTime startTime,
    DateTime endTime, {
    String? identifier,
    bool? isValid,
  }) async {
    return await _databaseService.getRecordCountInTimeRange(
      startTime,
      endTime,
      identifier: identifier,
      isValid: isValid,
    );
  }

  /// 获取最早和最晚的记录时间
  Future<Map<String, DateTime?>> getTimeRange() async {
    return await _databaseService.getTimeRange();
  }

  /// 获取同步状态
  bool get isSyncing => _syncingIdentifiers.isNotEmpty;

  /// 获取当前同步的标识符
  List<String> get syncingIdentifiers => _syncingIdentifiers;

  /// 重置首次查询状态，下次同步时将重新获取完整数据
  Future<void> resetFirstQueryState() async {
    _isFirstAnchoredQuery = true;
    await _saveFirstAnchoredQueryState();
    debugPrint('重置首次查询状态，下次同步将重新获取完整数据');
  }

  /// 获取当前是否使用缓存anchor的状态
  bool get isUsingCachedAnchor => !_isFirstAnchoredQuery;

  /// 加载首次锚点查询状态
  Future<void> _loadFirstAnchoredQueryState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstAnchoredQuery = !(prefs.getBool(_firstAnchoredQueryKey) ?? false);
      debugPrint('加载首次锚点查询状态: $_isFirstAnchoredQuery');
    } catch (e) {
      debugPrint('加载首次锚点查询状态失败: $e');
      _isFirstAnchoredQuery = true; // 默认值
    }
  }

  /// 保存首次锚点查询状态
  Future<void> _saveFirstAnchoredQueryState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstAnchoredQueryKey, !_isFirstAnchoredQuery);
      debugPrint('保存首次锚点查询状态: $_isFirstAnchoredQuery');
    } catch (e) {
      debugPrint('保存首次锚点查询状态失败: $e');
    }
  }
}
