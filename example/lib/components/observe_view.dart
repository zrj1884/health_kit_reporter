import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/date_components.dart';
import 'package:health_kit_reporter/model/payload/preferred_unit.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

import 'action_card.dart';
import 'monitor_status.dart';
import 'reporter_mixin.dart';

class ObserveView extends StatefulWidget {
  const ObserveView({
    Key? key,
    required this.flutterLocalNotificationsPlugin,
  }) : super(key: key);

  final dynamic flutterLocalNotificationsPlugin;

  @override
  State<ObserveView> createState() => _ObserveViewState();
}

class _ObserveViewState extends State<ObserveView> with HealthKitReporterMixin {
  bool _isObserving = false;
  final List<String> _observations = [];
  StreamSubscription<dynamic>? _currentSubscription;

  @override
  void dispose() {
    _currentSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonitorStatus(
          isObserving: _isObserving,
          latestUpdate: _observations.isNotEmpty ? _observations.first : null,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ActionCard(
                icon: Icons.monitor_heart,
                title: '监控步数和心率',
                subtitle: '实时监控步数和心率数据变化',
                backgroundColor: Colors.purple[100],
                iconColor: Colors.purple[600],
                onTap: () => _observerQuery([
                  QuantityType.stepCount.identifier,
                  QuantityType.heartRate.identifier,
                ]),
              ),
              ActionCard(
                icon: Icons.anchor,
                title: '锚点对象查询',
                subtitle: '使用锚点查询监控数据变化',
                backgroundColor: Colors.purple[100],
                iconColor: Colors.purple[600],
                onTap: () => _anchoredObjectQuery([
                  QuantityType.stepCount.identifier,
                  QuantityType.heartRate.identifier,
                ]),
              ),
              ActionCard(
                icon: Icons.analytics,
                title: '活动摘要更新',
                subtitle: '监控活动摘要数据更新',
                backgroundColor: Colors.purple[100],
                iconColor: Colors.purple[600],
                onTap: () => _queryActivitySummaryUpdates(),
              ),
              ActionCard(
                icon: Icons.timeline,
                title: '统计集合查询',
                subtitle: '监控统计数据集合变化',
                backgroundColor: Colors.purple[100],
                iconColor: Colors.purple[600],
                onTap: () => _statisticsCollectionQuery(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addObservation(String observation) {
    setState(() {
      _observations.insert(0, '${DateTime.now().toString().substring(11, 19)} - $observation');
      if (_observations.length > 10) {
        _observations.removeLast();
      }
    });
  }

  void _observerQuery(List<String> identifiers) async {
    try {
      setState(() {
        _isObserving = true;
      });

      // 取消之前的订阅
      _currentSubscription?.cancel();

      _currentSubscription = HealthKitReporter.observerQuery(identifiers, null, onUpdate: (identifier) async {
        _addObservation('观察到 $identifier 数据更新');
        // 暂时注释掉通知功能，因为导入有问题
        // const iOSDetails = DarwinNotificationDetails();
        // const details = NotificationDetails(iOS: iOSDetails);
        // await widget.flutterLocalNotificationsPlugin.show(0, '健康数据更新', identifier, details);
      });

      for (final identifier in identifiers) {
        final isSet = await HealthKitReporter.enableBackgroundDelivery(identifier, UpdateFrequency.immediate);
        _addObservation('$identifier 后台交付${isSet ? '启用' : '失败'}');
      }

      _addObservation('开始监控 ${identifiers.join(", ")}');
    } catch (e) {
      _addObservation('监控失败: $e');
    }
  }

  void _anchoredObjectQuery(List<String> identifiers) {
    try {
      setState(() {
        _isObserving = true;
      });

      // 取消之前的订阅
      _currentSubscription?.cancel();

      _currentSubscription =
          HealthKitReporter.anchoredObjectQuery(identifiers, predicate, onUpdate: (samples, deletedObjects) {
        _addObservation('锚点查询更新: ${samples.length} 个样本, ${deletedObjects.length} 个删除对象');
      });

      _addObservation('开始锚点查询监控 ${identifiers.join(", ")}');
    } catch (e) {
      _addObservation('锚点查询失败: $e');
    }
  }

  void _queryActivitySummaryUpdates() {
    try {
      setState(() {
        _isObserving = true;
      });

      // 取消之前的订阅
      _currentSubscription?.cancel();

      _currentSubscription = HealthKitReporter.queryActivitySummaryUpdates(predicate, onUpdate: (samples) {
        _addObservation('活动摘要更新: ${samples.length} 个摘要');
      });

      _addObservation('开始监控活动摘要更新');
    } catch (e) {
      _addObservation('活动摘要监控失败: $e');
    }
  }

  void _statisticsCollectionQuery() {
    try {
      setState(() {
        _isObserving = true;
      });

      // 取消之前的订阅
      _currentSubscription?.cancel();

      final anchorDate = DateTime.utc(2020, 2, 1, 12, 30, 30);
      final enumerateFrom = DateTime.utc(2020, 3, 1, 12, 30, 30);
      final enumerateTo = DateTime.utc(2020, 12, 31, 12, 30, 30);
      const intervalComponents = DateComponents(month: 1);

      _currentSubscription = HealthKitReporter.statisticsCollectionQuery(
        [
          PreferredUnit(
            QuantityType.stepCount.identifier,
            'count',
          ),
        ],
        predicate,
        anchorDate,
        enumerateFrom,
        enumerateTo,
        intervalComponents,
        onUpdate: (statistics) {
          _addObservation('统计集合更新: ${statistics.map}');
        },
      );

      _addObservation('开始统计集合查询监控');
    } catch (e) {
      _addObservation('统计集合监控失败: $e');
    }
  }
}
