# SQLite 数据库实现

## 概述

将本地数据存储从JSON文件迁移到SQLite数据库，提供更好的性能、数据完整性和查询能力。

## 核心组件

### 1. DatabaseService

- 单例模式管理数据库连接
- 提供完整的CRUD操作
- 支持复杂查询和过滤
- 自动创建索引提高性能

### 2. 数据库表结构

```sql
CREATE TABLE health_records (
  id TEXT PRIMARY KEY,
  identifier TEXT NOT NULL,
  value TEXT NOT NULL,
  unit TEXT NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  source_name TEXT NOT NULL,
  device_name TEXT NOT NULL,
  is_valid INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
```

### 3. 索引优化

```sql
CREATE INDEX idx_identifier ON health_records(identifier);
CREATE INDEX idx_start_date ON health_records(start_date);
CREATE INDEX idx_end_date ON health_records(end_date);
CREATE INDEX idx_is_valid ON health_records(is_valid);
```

## 功能特性

### 1. 数据操作

- **插入**: 支持单条和批量插入
- **更新**: 基于ID更新记录
- **删除**: 支持单条和批量删除
- **查询**: 支持复杂过滤条件

### 2. 查询功能

- **分页查询**: 支持limit和offset
- **条件过滤**: 数据类型、时间范围、有效性
- **统计查询**: 记录数量、类型统计
- **唯一值查询**: 获取所有数据类型

### 3. 性能优化

- **索引**: 关键字段建立索引
- **批量操作**: 使用事务提高性能
- **分页加载**: 避免一次性加载大量数据
- **连接池**: 复用数据库连接

## 实现细节

### 1. HealthRecord模型扩展

```dart
// 添加fromMap方法支持数据库映射
factory HealthRecord.fromMap(Map<String, dynamic> map) {
  return HealthRecord(
    id: map['id'],
    identifier: map['identifier'],
    value: map['value'],
    unit: map['unit'],
    startDate: DateTime.parse(map['start_date']),
    endDate: DateTime.parse(map['end_date']),
    sourceName: map['source_name'],
    deviceName: map['device_name'],
    isValid: map['is_valid'] == 1,
    createdAt: DateTime.parse(map['created_at']),
    updatedAt: DateTime.parse(map['updated_at']),
  );
}
```

### 2. HealthSyncService更新

- 移除JSON文件操作
- 集成DatabaseService
- 保持原有API接口不变
- 添加新的统计和查询功能

### 3. HealthDatabaseScreen增强

- **统计信息**: 显示数据统计
- **分页加载**: 支持无限滚动
- **批量操作**: 清空所有记录
- **实时更新**: 同步后自动刷新

## 优势对比

### JSON文件存储

- ❌ 性能差（全量读写）
- ❌ 不支持复杂查询
- ❌ 数据完整性差
- ❌ 不支持并发访问
- ❌ 文件大小限制

### SQLite数据库

- ✅ 高性能（索引查询）
- ✅ 支持复杂SQL查询
- ✅ 数据完整性保证
- ✅ 支持并发访问
- ✅ 无文件大小限制
- ✅ 事务支持
- ✅ 自动备份恢复

## 使用示例

### 1. 基本操作

```dart
final dbService = DatabaseService();

// 插入记录
await dbService.insertRecord(healthRecord);

// 批量插入
await dbService.insertRecords(records);

// 查询记录
final records = await dbService.getFilteredRecords(
  identifier: 'HKQuantityTypeIdentifierStepCount',
  startDate: DateTime.now().subtract(Duration(days: 7)),
  isValid: true,
  limit: 20,
  offset: 0,
);
```

### 2. 统计查询

```dart
// 获取统计信息
final statistics = await dbService.getStatistics();
print('总记录数: ${statistics['totalRecords']}');
print('有效记录: ${statistics['validRecords']}');

// 获取记录数量
final count = await dbService.getRecordCount(
  identifier: 'HKQuantityTypeIdentifierStepCount',
);
```

### 3. 高级查询

```dart
// 获取唯一的数据类型
final identifiers = await dbService.getUniqueIdentifiers();

// 分页查询
final page1 = await dbService.getFilteredRecords(limit: 20, offset: 0);
final page2 = await dbService.getFilteredRecords(limit: 20, offset: 20);
```

## 性能优化

### 1. 索引策略

- 为常用查询字段建立索引
- 复合索引优化多条件查询
- 定期分析查询性能

### 2. 批量操作

```dart
// 使用事务批量插入
final batch = db.batch();
for (final record in records) {
  batch.insert('health_records', record.toMap());
}
await batch.commit(noResult: true);
```

### 3. 分页加载

- 避免一次性加载大量数据
- 实现无限滚动
- 内存使用优化

## 数据迁移

### 1. 从JSON迁移到SQLite

```dart
// 读取JSON文件
final jsonFile = File('health_records.json');
final jsonString = await jsonFile.readAsString();
final jsonList = jsonDecode(jsonString) as List;

// 转换为HealthRecord对象
final records = jsonList
    .map((json) => HealthRecord.fromJson(json as Map<String, dynamic>))
    .toList();

// 批量插入到SQLite
await databaseService.insertRecords(records);
```

### 2. 数据验证

- 检查数据完整性
- 验证数据类型
- 确保时间格式正确

## 错误处理

### 1. 数据库错误

```dart
try {
  await databaseService.insertRecord(record);
} catch (e) {
  print('数据库操作失败: $e');
  // 实现错误恢复机制
}
```

### 2. 数据验证

```dart
// 验证记录完整性
if (record.id.isEmpty || record.identifier.isEmpty) {
  throw Exception('记录数据不完整');
}
```

## 未来改进

### 1. 数据库升级

- 版本管理
- 数据迁移脚本
- 向后兼容

### 2. 性能监控

- 查询性能分析
- 慢查询日志
- 数据库大小监控

### 3. 数据压缩

- 大文本字段压缩
- 历史数据归档
- 存储空间优化

### 4. 云端同步

- 数据备份
- 多设备同步
- 冲突解决

## 注意事项

1. **数据库路径**: 使用系统标准路径
2. **并发访问**: 正确处理多线程访问
3. **内存管理**: 及时关闭数据库连接
4. **数据备份**: 定期备份重要数据
5. **版本兼容**: 处理数据库版本升级
