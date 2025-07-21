# Anchor 缓存优化

## 概述

为 `AnchoredObjectQueryStreamHandler` 增加了本地缓存 anchor 的功能，通过控制开关变量来决定是否使用本地缓存的 anchor 作为查询的初始条件，并在回调中按照指标类型保存对应的 anchor。

## 功能特性

### 1. 本地缓存管理

#### Anchor 存储

- 使用 `UserDefaults` 进行本地存储
- 按指标类型分别缓存 anchor
- 键名格式：`anchor_cache_{identifier}`
- 使用 `NSKeyedArchiver` 将 `HKQueryAnchor` 序列化为 base64 字符串存储

#### 缓存操作

- **获取缓存**: `getCachedAnchor(for identifier: String) -> HKQueryAnchor?`
- **保存缓存**: `saveCachedAnchor(_ anchor: HKQueryAnchor, for identifier: String)`
- **清除缓存**: `clearCachedAnchor(for identifier: String)`

### 2. 控制开关

#### Dart 端

```dart
HealthKitReporter.anchoredObjectQuery(
  identifiers,
  predicate,
  useCachedAnchor: true, // 控制是否使用本地缓存的anchor
  onUpdate: (samples, deletedObjects) {
    // 处理更新
  },
);
```

#### Swift 端

```swift
let useCachedAnchor = arguments["useCachedAnchor"] as? Bool ?? false
```

### 3. 优化流程

1. **检查缓存开关**: 根据 `useCachedAnchor` 参数决定是否使用缓存
2. **获取缓存anchor**: 如果启用缓存，从本地获取对应指标类型的 anchor
3. **执行查询**: 使用 HealthKitReporter 的 anchoredObjectQuery 方法
4. **保存新anchor**: 在回调中保存新的 anchor 到本地缓存
5. **返回数据**: 将样本和删除对象数据返回给 Flutter

### 4. 同步流程优化

#### 首次同步流程

1. **初始同步**: 执行 `_performInitialSync()` 获取30天历史数据
2. **观察者查询**: 设置 `observerQuery` 监听数据变化
3. **锚点查询**: 设置 `anchoredObjectQuery` 使用 `useCachedAnchor = false`
4. **后台交付**: 启用后台通知

#### 后续同步流程

1. **跳过初始同步**: 不执行 `_performInitialSync()`
2. **观察者查询**: 设置 `observerQuery` 监听数据变化
3. **锚点查询**: 设置 `anchoredObjectQuery` 使用 `useCachedAnchor = true`
4. **后台交付**: 启用后台通知

### 4. 智能缓存策略

#### 首次查询策略

- **首次查询**: `useCachedAnchor = false`，获取完整的历史数据
- **后续查询**: `useCachedAnchor = true`，只获取增量数据
- **状态管理**: 使用 `_isFirstAnchoredQuery` 标记跟踪首次查询状态
- **持久化存储**: 状态保存在 `SharedPreferences` 中，应用重启后保持
- **重置机制**: 提供 `resetFirstQueryState()` 方法手动重置状态

#### 初始同步优化

- **首次同步**: 执行 `_performInitialSync()` 获取历史数据
- **后续同步**: 跳过初始同步，直接使用增量同步
- **性能提升**: 避免重复获取历史数据，提高同步效率

#### 持久化状态管理

- **状态存储**: 使用 `SharedPreferences` 持久化存储首次查询状态
- **应用重启**: 状态在应用重启后保持，不会重置
- **清空缓存**: 只有应用清空缓存或重装才会重置状态
- **手动重置**: 提供 `resetFirstQueryState()` 方法手动重置状态
- **清空记录**: 清空所有记录时自动重置状态，确保下次同步获取完整数据

## 实现细节

### 1. Swift 端实现

#### 序列化处理

由于 `HKQueryAnchor` 对象不能直接存储到 `UserDefaults` 中，我们使用以下步骤进行序列化：

1. **序列化**: 使用 `NSKeyedArchiver.archivedData(withRootObject:requiringSecureCoding:)` 将 `HKQueryAnchor` 对象序列化为 `Data`
2. **Base64编码**: 将序列化后的 `Data` 转换为 base64 字符串
3. **存储**: 将 base64 字符串保存到 `UserDefaults`
4. **反序列化**: 读取时先解码 base64 字符串，然后使用 `NSKeyedUnarchiver.unarchivedObject(ofClass:from:)` 反序列化为 `HKQueryAnchor` 对象

#### AnchoredObjectQueryStreamHandler.swift

```swift
// MARK: - Anchor Cache Management
private func getCachedAnchor(for identifier: String) -> HKQueryAnchor? {
    let key = "anchor_cache_\(identifier)"
    guard let base64String = UserDefaults.standard.string(forKey: key),
          let data = Data(base64Encoded: base64String) else {
        return nil
    }
    
    do {
        let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
        return anchor
    } catch {
        print("Failed to unarchive anchor for \(identifier): \(error)")
        return nil
    }
}

private func saveCachedAnchor(_ anchor: HKQueryAnchor, for identifier: String) {
    let key = "anchor_cache_\(identifier)"
    
    do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: false)
        let base64String = data.base64EncodedString()
        UserDefaults.standard.set(base64String, forKey: key)
    } catch {
        print("Failed to archive anchor for \(identifier): \(error)")
    }
}

private func clearCachedAnchor(for identifier: String) {
    let key = "anchor_cache_\(identifier)"
    UserDefaults.standard.removeObject(forKey: key)
}
```

#### 查询逻辑

```swift
// 获取缓存的anchor（如果启用缓存功能）
var cachedAnchor: HKQueryAnchor? = nil
if useCachedAnchor {
    cachedAnchor = getCachedAnchor(for: identifier)
}

let query = try reporter.reader.anchoredObjectQuery(
    type: type,
    predicate: predicate,
    anchor: cachedAnchor, // 使用缓存的anchor作为初始条件
    monitorUpdates: true
) { (query, samples, deletedObjects, anchor, error) in
    // 保存新的anchor到本地缓存
    if let anchor = anchor {
        self.saveCachedAnchor(anchor, for: identifier)
    }
    // ... 处理数据
}
```

### 2. Dart 端实现

#### 方法签名更新

```dart
static StreamSubscription<dynamic> anchoredObjectQuery(
    List<String> identifiers, 
    Predicate predicate,
    {required Function(List<Sample>, List<DeletedObject>) onUpdate,
    bool useCachedAnchor = false}) {
  final arguments = <String, dynamic>{
    'identifiers': identifiers,
    'useCachedAnchor': useCachedAnchor,
  };
  arguments.addAll(predicate.map);
  // ... 实现
}
```

## 使用示例

### 1. 基本使用

```dart
// 启用anchor缓存
HealthKitReporter.anchoredObjectQuery(
  ['HKQuantityTypeIdentifierStepCount', 'HKQuantityTypeIdentifierHeartRate'],
  predicate,
  useCachedAnchor: true,
  onUpdate: (samples, deletedObjects) {
    print('收到更新: ${samples.length} 个样本, ${deletedObjects.length} 个删除对象');
  },
);
```

### 2. 在同步服务中使用

```dart
// HealthSyncService 中的智能缓存策略
class HealthSyncService {
  bool _isFirstAnchoredQuery = true; // 标记是否是首次锚点查询

  Future<bool> startSync(List<String> identifiers) async {
    // 1. 首次同步时进行初始同步，否则跳过
    if (_isFirstAnchoredQuery) {
      debugPrint('首次同步，执行初始同步获取历史数据');
      result = await _performInitialSync();
    } else {
      debugPrint('非首次同步，跳过初始同步，直接使用增量同步');
      result = true; // 跳过初始同步，直接进行后续步骤
    }

    // 2. 设置观察者查询和锚点查询
    if (result) {
      result = await _setupObserverQuery();
    }
    if (result) {
      result = await _setupAnchoredObjectQuery();
    }
  }

  Future<bool> _setupAnchoredObjectQuery() async {
    // 首次查询不使用缓存anchor，后续查询使用缓存anchor
    final useCachedAnchor = !_isFirstAnchoredQuery;
    
    _anchoredSubscription = HealthKitReporter.anchoredObjectQuery(
      _syncingIdentifiers,
      predicate,
      useCachedAnchor: useCachedAnchor, // 根据是否首次查询决定是否使用缓存
      onUpdate: (samples, deletedObjects) async {
        await _handleAnchoredObjectUpdate(samples, deletedObjects);
      },
    );

    // 标记已完成首次查询
    _isFirstAnchoredQuery = false;
  }

  // 重置首次查询状态，下次同步时将重新获取完整数据
  Future<void> resetFirstQueryState() async {
    _isFirstAnchoredQuery = true;
    await _saveFirstAnchoredQueryState();
  }

  // 清空所有记录时自动重置状态
  Future<void> clearAllRecords() async {
    await _databaseService.clearAllRecords();
    // 清空记录后重置首次查询状态，确保下次同步获取完整数据
    await resetFirstQueryState();
  }

  // 加载首次锚点查询状态
  Future<void> _loadFirstAnchoredQueryState() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstAnchoredQuery = !(prefs.getBool(_firstAnchoredQueryKey) ?? false);
  }

  // 保存首次锚点查询状态
  Future<void> _saveFirstAnchoredQueryState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstAnchoredQueryKey, !_isFirstAnchoredQuery);
  }
}
```

### 3. 在监控界面中使用

```dart
// ObserveScreen 中的使用
_anchoredObjectQuery(List<String> identifiers) {
  final useCachedAnchor = true; // 可以通过UI控制
  
  _currentSubscription = HealthKitReporter.anchoredObjectQuery(
    identifiers, 
    predicate, 
    useCachedAnchor: useCachedAnchor,
    onUpdate: (samples, deletedObjects) {
      _addObservation('锚点查询更新: ${samples.length} 个样本, ${deletedObjects.length} 个删除对象');
    },
  );
}

// 在同步服务界面中使用智能缓存策略
class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final HealthSyncService _syncService = HealthSyncService();

  void _startSync() async {
    await _syncService.startSync([
      'HKQuantityTypeIdentifierStepCount',
      'HKQuantityTypeIdentifierHeartRate',
    ]);
  }

  void _resetSync() async {
    await _syncService.resetFirstQueryState();
    setState(() {
      // 更新UI状态
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('使用缓存Anchor: ${_syncService.isUsingCachedAnchor}'),
        ElevatedButton(
          onPressed: _startSync,
          child: Text('开始同步'),
        ),
        ElevatedButton(
          onPressed: _resetSync,
          child: Text('重置同步状态'),
        ),
      ],
    );
  }
}
```

## 优势

### 性能优化

- **减少重复数据**: 使用 anchor 避免重复获取相同的数据
- **提高查询效率**: 从上次查询的位置继续，减少数据传输
- **节省资源**: 减少网络和存储开销
- **跳过初始同步**: 后续同步跳过历史数据获取，只进行增量同步
- **智能流程**: 根据首次查询状态自动选择最优同步策略

### 数据一致性

- **增量同步**: 只获取新增或修改的数据
- **删除同步**: 正确处理删除的数据
- **状态跟踪**: 通过 anchor 跟踪数据变化状态
- **持久化状态**: 首次查询状态持久化存储，应用重启后保持
- **状态可靠性**: 避免因应用重启导致的重复历史数据获取

### 用户体验

- **快速响应**: 减少初始数据加载时间
- **实时更新**: 保持数据的最新状态
- **可控制性**: 通过开关控制是否使用缓存
- **智能策略**: 首次查询获取完整数据，后续查询只获取增量数据
- **状态管理**: 提供状态查询和重置功能
- **自动重置**: 清空记录时自动重置状态，确保数据完整性
- **调试友好**: 详细的日志输出，便于监控同步状态
- **性能透明**: 可以清楚看到当前使用的同步策略

## 注意事项

### 缓存管理

- **存储空间**: anchor 数据占用少量存储空间
- **清理策略**: 可以定期清理过期的 anchor 缓存
- **数据安全**: anchor 数据存储在本地，确保数据安全

### 兼容性

- **向后兼容**: 默认 `useCachedAnchor = false`，保持向后兼容
- **可选功能**: 用户可以选择是否启用此功能
- **渐进增强**: 不影响现有功能的使用
- **序列化兼容**: 使用 `requiringSecureCoding: false` 确保与旧版本 HealthKit 的兼容性

### 错误处理

- **缓存失败**: 如果缓存操作失败，不影响正常查询
- **数据恢复**: 如果 anchor 无效，会自动重新开始查询
- **异常处理**: 完善的错误处理机制
- **序列化错误**: 如果 `HKQueryAnchor` 序列化/反序列化失败，会记录错误并继续正常查询

## 未来改进

### 高级缓存策略

- **缓存过期**: 设置 anchor 缓存的有效期
- **缓存压缩**: 压缩 anchor 数据减少存储空间
- **缓存同步**: 在多设备间同步 anchor 数据

### 智能优化

- **自动清理**: 自动清理过期的 anchor 缓存
- **性能监控**: 监控缓存命中率和性能提升
- **自适应策略**: 根据使用情况自动调整缓存策略

### 用户体验2

- **UI 控制**: 在界面上提供缓存开关控制
- **状态显示**: 显示当前缓存状态和效果
- **手动清理**: 提供手动清理缓存的功能

## 总结

通过为 `AnchoredObjectQueryStreamHandler` 增加本地缓存 anchor 的功能，实现了：

1. **性能提升**: 减少重复数据传输，提高查询效率
2. **数据一致性**: 确保增量同步的准确性
3. **用户体验**: 提供可控制的缓存功能
4. **向后兼容**: 保持现有功能的正常使用

这个优化为健康数据同步提供了更高效、更可靠的解决方案。
