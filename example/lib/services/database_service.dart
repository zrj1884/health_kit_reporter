import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/health_record.dart';

/// 数据库服务
/// 使用sqflite管理健康数据记录
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  /// 获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'health_records.db');

    return await openDatabase(
      path,
      version: 2, // 升级版本号
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 创建数据库表
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_records (
        id TEXT PRIMARY KEY,
        identifier TEXT NOT NULL,
        value TEXT NOT NULL,
        unit TEXT NOT NULL,
        start_timestamp INTEGER NOT NULL,
        end_timestamp INTEGER NOT NULL,
        source_name TEXT NOT NULL,
        device_name TEXT NOT NULL,
        is_valid INTEGER NOT NULL,
        created_timestamp INTEGER NOT NULL,
        updated_timestamp INTEGER NOT NULL
      )
    ''');

    // 创建索引以提高查询性能
    await db.execute('CREATE INDEX idx_identifier ON health_records(identifier)');
    await db.execute('CREATE INDEX idx_start_timestamp ON health_records(start_timestamp)');
    await db.execute('CREATE INDEX idx_end_timestamp ON health_records(end_timestamp)');
    await db.execute('CREATE INDEX idx_is_valid ON health_records(is_valid)');
  }

  /// 数据库升级
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 从版本1升级到版本2：将时间字段从TEXT改为INTEGER
      await _migrateToVersion2(db);
    }
  }

  /// 迁移到版本2：时间字段改为时间戳
  Future<void> _migrateToVersion2(Database db) async {
    // 创建临时表
    await db.execute('''
      CREATE TABLE health_records_temp (
        id TEXT PRIMARY KEY,
        identifier TEXT NOT NULL,
        value TEXT NOT NULL,
        unit TEXT NOT NULL,
        start_timestamp INTEGER NOT NULL,
        end_timestamp INTEGER NOT NULL,
        source_name TEXT NOT NULL,
        device_name TEXT NOT NULL,
        is_valid INTEGER NOT NULL,
        created_timestamp INTEGER NOT NULL,
        updated_timestamp INTEGER NOT NULL
      )
    ''');

    // 复制数据并转换时间格式
    await db.execute('''
      INSERT INTO health_records_temp 
      SELECT 
        id,
        identifier,
        value,
        unit,
        CASE 
          WHEN start_date IS NOT NULL AND start_date != '' 
          THEN CAST(start_date AS INTEGER) 
          ELSE 0 
        END as start_timestamp,
        CASE 
          WHEN end_date IS NOT NULL AND end_date != '' 
          THEN CAST(end_date AS INTEGER) 
          ELSE 0 
        END as end_timestamp,
        source_name,
        device_name,
        is_valid,
        CASE 
          WHEN created_at IS NOT NULL AND created_at != '' 
          THEN CAST(created_at AS INTEGER) 
          ELSE 0 
        END as created_timestamp,
        CASE 
          WHEN updated_at IS NOT NULL AND updated_at != '' 
          THEN CAST(updated_at AS INTEGER) 
          ELSE 0 
        END as updated_timestamp
      FROM health_records
    ''');

    // 删除旧表
    await db.execute('DROP TABLE health_records');

    // 重命名新表
    await db.execute('ALTER TABLE health_records_temp RENAME TO health_records');

    // 重新创建索引
    await db.execute('CREATE INDEX idx_identifier ON health_records(identifier)');
    await db.execute('CREATE INDEX idx_start_timestamp ON health_records(start_timestamp)');
    await db.execute('CREATE INDEX idx_end_timestamp ON health_records(end_timestamp)');
    await db.execute('CREATE INDEX idx_is_valid ON health_records(is_valid)');
  }

  /// 插入记录
  Future<void> insertRecord(HealthRecord record) async {
    final db = await database;
    await db.insert(
      'health_records',
      {
        'id': record.id,
        'identifier': record.identifier,
        'value': record.value,
        'unit': record.unit,
        'start_timestamp': record.startDate.millisecondsSinceEpoch,
        'end_timestamp': record.endDate.millisecondsSinceEpoch,
        'source_name': record.sourceName,
        'device_name': record.deviceName,
        'is_valid': record.isValid ? 1 : 0,
        'created_timestamp': record.createdAt.millisecondsSinceEpoch,
        'updated_timestamp': record.updatedAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 批量插入记录
  Future<void> insertRecords(List<HealthRecord> records) async {
    final db = await database;
    final batch = db.batch();

    for (final record in records) {
      batch.insert(
        'health_records',
        {
          'id': record.id,
          'identifier': record.identifier,
          'value': record.value,
          'unit': record.unit,
          'start_timestamp': record.startDate.millisecondsSinceEpoch,
          'end_timestamp': record.endDate.millisecondsSinceEpoch,
          'source_name': record.sourceName,
          'device_name': record.deviceName,
          'is_valid': record.isValid ? 1 : 0,
          'created_timestamp': record.createdAt.millisecondsSinceEpoch,
          'updated_timestamp': record.updatedAt.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// 更新记录
  Future<void> updateRecord(HealthRecord record) async {
    final db = await database;
    await db.update(
      'health_records',
      {
        'identifier': record.identifier,
        'value': record.value,
        'unit': record.unit,
        'start_timestamp': record.startDate.millisecondsSinceEpoch,
        'end_timestamp': record.endDate.millisecondsSinceEpoch,
        'source_name': record.sourceName,
        'device_name': record.deviceName,
        'is_valid': record.isValid ? 1 : 0,
        'updated_timestamp': record.updatedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  /// 删除记录
  Future<void> deleteRecord(String id) async {
    final db = await database;
    await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 批量软删除记录（标记为无效）
  Future<void> deleteRecords(List<String> ids) async {
    if (ids.isEmpty) return;

    final db = await database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.update(
      'health_records',
      {
        'is_valid': 0,
        'updated_timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  /// 获取所有记录
  Future<List<HealthRecord>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      orderBy: 'start_timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }

  /// 根据条件过滤记录
  Future<List<HealthRecord>> getFilteredRecords({
    String? identifier,
    DateTime? startDate,
    DateTime? endDate,
    bool? isValid,
    int? limit,
    int? offset,
  }) async {
    final db = await database;

    final List<String> whereConditions = [];
    final List<dynamic> whereArgs = [];

    if (identifier != null) {
      whereConditions.add('identifier = ?');
      whereArgs.add(identifier);
    }

    if (startDate != null) {
      whereConditions.add('start_timestamp >= ?');
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }

    if (endDate != null) {
      whereConditions.add('end_timestamp <= ?');
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    if (isValid != null) {
      whereConditions.add('is_valid = ?');
      whereArgs.add(isValid ? 1 : 0);
    }

    final whereClause = whereConditions.isNotEmpty ? whereConditions.join(' AND ') : null;

    final List<Map<String, dynamic>> maps = await db.query(
      'health_records',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'start_timestamp DESC',
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) {
      return HealthRecord.fromMap(maps[i]);
    });
  }

  /// 获取记录数量
  Future<int> getRecordCount({
    String? identifier,
    DateTime? startDate,
    DateTime? endDate,
    bool? isValid,
  }) async {
    final db = await database;

    final List<String> whereConditions = [];
    final List<dynamic> whereArgs = [];

    if (identifier != null) {
      whereConditions.add('identifier = ?');
      whereArgs.add(identifier);
    }

    if (startDate != null) {
      whereConditions.add('start_timestamp >= ?');
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }

    if (endDate != null) {
      whereConditions.add('end_timestamp <= ?');
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    if (isValid != null) {
      whereConditions.add('is_valid = ?');
      whereArgs.add(isValid ? 1 : 0);
    }

    final whereClause = whereConditions.isNotEmpty ? whereConditions.join(' AND ') : null;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM health_records${whereClause != null ? ' WHERE $whereClause' : ''}',
      whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// 获取唯一的数据类型标识符
  Future<List<String>> getUniqueIdentifiers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT identifier FROM health_records ORDER BY identifier',
    );

    return maps.map((map) => map['identifier'] as String).toList();
  }

  /// 获取统计信息
  Future<Map<String, dynamic>> getStatistics() async {
    final totalCount = await getRecordCount();
    final validCount = await getRecordCount(isValid: true);
    final invalidCount = await getRecordCount(isValid: false);

    final identifiers = await getUniqueIdentifiers();
    final identifierCounts = <String, int>{};

    for (final identifier in identifiers) {
      final count = await getRecordCount(identifier: identifier);
      identifierCounts[identifier] = count;
    }

    return {
      'totalRecords': totalCount,
      'validRecords': validCount,
      'invalidRecords': invalidCount,
      'identifierCounts': identifierCounts,
      'uniqueIdentifiers': identifiers.length,
    };
  }

  /// 清空所有记录
  Future<void> clearAllRecords() async {
    final db = await database;
    await db.delete('health_records');
  }

  /// 关闭数据库
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
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
    return await getFilteredRecords(
      identifier: identifier,
      startDate: startTime,
      endDate: endTime,
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
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));

    return await getRecordsInTimeRange(startOfDay, endOfDay, identifier: identifier, isValid: isValid);
  }

  /// 获取本周的记录
  Future<List<HealthRecord>> getThisWeekRecords({
    String? identifier,
    bool? isValid,
  }) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endOfWeek = startOfWeekDay.add(const Duration(days: 7)).subtract(const Duration(milliseconds: 1));

    return await getRecordsInTimeRange(startOfWeekDay, endOfWeek, identifier: identifier, isValid: isValid);
  }

  /// 获取本月的记录
  Future<List<HealthRecord>> getThisMonthRecords({
    String? identifier,
    bool? isValid,
  }) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(const Duration(milliseconds: 1));

    return await getRecordsInTimeRange(startOfMonth, endOfMonth, identifier: identifier, isValid: isValid);
  }

  /// 获取最近N天的记录
  Future<List<HealthRecord>> getRecentDaysRecords(
    int days, {
    String? identifier,
    bool? isValid,
  }) async {
    final now = DateTime.now();
    final startTime = now.subtract(Duration(days: days));

    return await getRecordsInTimeRange(startTime, now, identifier: identifier, isValid: isValid);
  }

  /// 获取时间范围内的记录数量
  Future<int> getRecordCountInTimeRange(
    DateTime startTime,
    DateTime endTime, {
    String? identifier,
    bool? isValid,
  }) async {
    return await getRecordCount(
      identifier: identifier,
      startDate: startTime,
      endDate: endTime,
      isValid: isValid,
    );
  }

  /// 获取最早和最晚的记录时间
  Future<Map<String, DateTime?>> getTimeRange() async {
    final db = await database;

    final minResult = await db.rawQuery('SELECT MIN(start_timestamp) as min_time FROM health_records');
    final maxResult = await db.rawQuery('SELECT MAX(end_timestamp) as max_time FROM health_records');

    final minTimestamp = Sqflite.firstIntValue(minResult);
    final maxTimestamp = Sqflite.firstIntValue(maxResult);

    return {
      'earliest': minTimestamp != null ? DateTime.fromMillisecondsSinceEpoch(minTimestamp) : null,
      'latest': maxTimestamp != null ? DateTime.fromMillisecondsSinceEpoch(maxTimestamp) : null,
    };
  }
}
