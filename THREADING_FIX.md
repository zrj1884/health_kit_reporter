# HealthKit Reporter 线程问题修复

## 问题描述

在HealthKit Reporter插件中，当使用observer query、anchored object query、activity summary query和statistics collection query时，会出现以下错误：

```text
[ERROR:flutter/shell/common/shell.cc(1064)] The 'health_kit_reporter_event_channel_observer_query' channel sent a message from native to Flutter on a non-platform thread. Platform channel messages must be sent on the platform thread. Failure to do so may result in data loss or crashes, and must be fixed in the plugin or application code creating that channel.
```

## 问题原因

HealthKit的回调函数在后台线程执行，但Flutter平台通道要求所有消息必须在主线程（平台线程）上发送。当HealthKit检测到数据变化时，回调在后台线程执行，直接调用`events()`函数发送消息到Flutter，这违反了Flutter的线程安全规则。

## 修复方案

在所有StreamHandler的回调函数中，使用`DispatchQueue.main.async`确保在主线程上发送消息到Flutter。

### 修复的文件

1. **ObserverQueryStreamHandler.swift**
   - 在observer query回调中添加主线程调度

2. **AnchoredObjectQueryStreamHandler.swift**
   - 在anchored object query回调中添加主线程调度

3. **QueryActivitySummaryStreamHandler.swift**
   - 在activity summary query回调中添加主线程调度

4. **StatisticsCollectionQueryStreamHandler.swift**
   - 在statistics collection query回调中添加主线程调度

### 修复代码示例

```swift
// 修复前
events(["identifier": identifier])

// 修复后
DispatchQueue.main.async {
    events(["identifier": identifier])
}
```

## 修复效果

1. **消除线程错误**: 不再出现"non-platform thread"错误
2. **提高稳定性**: 避免数据丢失和崩溃
3. **符合Flutter规范**: 遵循Flutter平台通道的线程安全要求
4. **保持功能完整**: 所有HealthKit监控功能正常工作

## 测试验证

修复后，以下功能应该正常工作且不再出现线程错误：

- Observer Query (观察者查询)
- Anchored Object Query (锚点对象查询)
- Activity Summary Updates (活动摘要更新)
- Statistics Collection Query (统计集合查询)

## 注意事项

1. 所有HealthKit回调现在都会在主线程上执行，这可能会稍微影响性能，但这是Flutter平台通道的要求
2. 修复不会影响HealthKit的数据监控功能，只是确保线程安全
3. 这个修复是向后兼容的，不会破坏现有的API
