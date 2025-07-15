# HealthKit 数据同步解决方案

## 概述

本解决方案通过结合 `observerQuery` 和 `anchoredObjectQuery` 实现了健康数据的持续监听和同步，包括主动同步健康数据到本地数据库，监听健康数据变化，以及提供健康数据详情页面。

## 功能特性

### 1. 数据同步策略

#### ObserverQuery (观察者查询)

- 监听HealthKit中特定数据类型的变化通知
- 轻量级，资源消耗少
- 适合实时监控数据变化
- 需要配合enableBackgroundDelivery使用

#### AnchoredObjectQuery (锚点对象查询)

- 获取数据快照并监听后续变化
- 返回完整的样本数据和删除对象
- 使用锚点机制跟踪变化
- 适合数据同步场景

#### 组合使用策略

- ObserverQuery: 监听变化通知，触发同步
- AnchoredObjectQuery: 获取具体变化数据，同步到本地数据库

### 2. 核心组件

#### HealthRecord 模型

```dart
class HealthRecord {
  final String id;
  final String identifier;
  final String value;
  final String unit;
  final DateTime startDate;
  final DateTime endDate;
  final String sourceName;
  final String deviceName;
  final bool isValid;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

#### HealthSyncService 同步服务

- 单例模式，全局管理同步状态
- 结合observerQuery和anchoredObjectQuery
- 本地JSON文件存储
- 支持增量同步和删除同步

#### HealthDatabaseScreen 详情页面

- 查看本地健康数据记录
- 支持多条件过滤（数据类型、时间范围、有效性）
- 支持删除记录
- 实时同步状态显示

### 3. 同步流程

1. **初始同步**
   - 获取过去30天的历史数据
   - 保存到本地JSON文件

2. **变化监听**
   - ObserverQuery监听数据变化通知
   - 收到通知后触发增量同步

3. **增量同步**
   - AnchoredObjectQuery获取具体变化数据
   - 更新本地数据库（新增/更新/删除）

4. **后台交付**
   - 启用后台通知
   - 确保应用在后台时也能接收变化

### 4. 数据过滤功能

支持以下过滤条件：

- **数据类型**: 步数、心率、活动能量、距离、体重、睡眠、运动等
- **时间范围**: 自定义开始和结束日期
- **有效性**: 有效/无效/全部

### 5. 用户界面

#### 主屏幕更新

- 新增"本地数据库"标签页
- 保持延迟加载和keepalive功能

#### 详情页面功能

- 状态栏显示同步状态和记录数量
- 记录列表显示详细信息
- 过滤对话框支持多条件筛选
- 删除确认对话框

## 技术实现

### 文件结构

```text
example/lib/
├── models/
│   └── health_record.dart          # 健康数据记录模型
├── services/
│   └── health_sync_service.dart    # 同步服务
├── screens/
│   ├── home_screen.dart            # 主屏幕（已更新）
│   └── health_database_screen.dart # 详情页面
```

### 关键特性

1. **线程安全**
   - 修复了HealthKit回调的线程问题
   - 确保在主线程上发送消息到Flutter

2. **数据持久化**
   - 使用JSON文件存储本地数据
   - 支持增量和删除同步

3. **用户体验**
   - 实时状态反馈
   - 过滤和搜索功能
   - 删除确认机制

4. **性能优化**
   - 延迟加载Tab页面
   - 增量同步减少数据传输
   - 本地缓存提高响应速度

## 使用方法

### 1. 启动同步

```dart
final syncService = HealthSyncService();
await syncService.startSync(
  ['HKQuantityTypeIdentifierStepCount', 'HKQuantityTypeIdentifierHeartRate'],
  onDataChanged: (identifier) {
    print('检测到 $identifier 数据变化');
  },
  onSyncComplete: (newRecords, deletedIds) {
    print('同步完成: ${newRecords.length} 条新记录');
  },
);
```

### 2. 查看数据

```dart
// 获取所有记录
final records = await syncService.getAllRecords();

// 过滤记录
final filteredRecords = await syncService.getFilteredRecords(
  identifier: 'HKQuantityTypeIdentifierStepCount',
  startDate: DateTime.now().subtract(Duration(days: 7)),
  endDate: DateTime.now(),
  isValid: true,
);
```

### 3. 删除记录

```dart
await syncService.deleteRecord(recordId);
```

## 优势

1. **完整性**: 结合两种查询方式，确保数据同步的完整性
2. **实时性**: ObserverQuery提供实时变化通知
3. **可靠性**: AnchoredObjectQuery提供可靠的数据同步
4. **可扩展性**: 模块化设计，易于扩展新功能
5. **用户友好**: 直观的界面和丰富的过滤功能

## 注意事项

1. **权限要求**: 需要HealthKit读写权限
2. **存储空间**: 本地JSON文件会随着数据增长而增大
3. **后台限制**: iOS对后台应用有严格限制
4. **数据一致性**: 需要定期验证本地数据与HealthKit的一致性

## 未来改进

1. **数据库升级**: 从JSON文件迁移到SQLite或Hive
2. **数据压缩**: 实现数据压缩减少存储空间
3. **云端同步**: 添加云端备份和同步功能
4. **数据分析**: 集成数据分析和可视化功能
5. **离线支持**: 增强离线模式下的功能
