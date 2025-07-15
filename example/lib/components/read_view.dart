import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/clinical_type.dart';
import 'package:health_kit_reporter/model/type/correlation_type.dart';
import 'package:health_kit_reporter/model/predicate.dart';

import 'reporter_mixin.dart';
import 'action_card.dart';
import 'result_display.dart';

class ReadView extends StatefulWidget {
  const ReadView({super.key});

  @override
  State<ReadView> createState() => _ReadViewState();
}

class _ReadViewState extends State<ReadView> with HealthKitReporterMixin {
  String _lastResult = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultDisplay(
          title: '查询结果',
          result: _lastResult,
          isLoading: _isLoading,
          placeholder: '点击下方按钮开始查询健康数据',
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              ActionCard(
                icon: Icons.favorite,
                title: '心率数据',
                subtitle: '查询用户心率相关数据',
                onTap: () => _queryHeartRate(),
              ),
              ActionCard(
                icon: Icons.directions_walk,
                title: '步数统计',
                subtitle: '查询用户步数和运动数据',
                onTap: () => _querySteps(),
              ),
              ActionCard(
                icon: Icons.bedtime,
                title: '睡眠分析',
                subtitle: '查询用户睡眠质量数据',
                onTap: () => _querySleep(),
              ),
              ActionCard(
                icon: Icons.fitness_center,
                title: '运动记录',
                subtitle: '查询用户运动锻炼数据',
                onTap: () => _queryWorkout(),
              ),
              ActionCard(
                icon: Icons.medical_services,
                title: '临床记录',
                subtitle: '查询用户临床医疗数据',
                onTap: () => _queryClinicalRecords(),
              ),
              ActionCard(
                icon: Icons.favorite,
                title: '心电图数据',
                subtitle: '查询用户心电图记录',
                onTap: () => _queryElectrocardiograms(),
              ),
              ActionCard(
                icon: Icons.bloodtype,
                title: '血压数据',
                subtitle: '查询用户血压相关数据',
                onTap: () => _queryBloodPressure(),
              ),
              ActionCard(
                icon: Icons.air,
                title: '血氧饱和度',
                subtitle: '查询用户血氧饱和度数据',
                onTap: () => _queryOxygenSaturation(),
              ),
              ActionCard(
                icon: Icons.analytics,
                title: '活动摘要',
                subtitle: '查询用户活动摘要数据',
                onTap: () => _queryActivitySummary(),
              ),
              ActionCard(
                icon: Icons.person,
                title: '个人特征',
                subtitle: '查询用户个人特征数据',
                onTap: () => _queryCharacteristics(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _updateResult(String result) {
    setState(() {
      _lastResult = result;
    });
  }

  DateTime _convertToDateTime(num timestamp) {
    return DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt());
  }

  Future<void> _queryHeartRate() async {
    _setLoading(true);
    try {
      final preferredUnits = await HealthKitReporter.preferredUnits([QuantityType.heartRate]);
      final hrUnits = preferredUnits.first.unit;
      final quantities = await HealthKitReporter.quantityQuery(QuantityType.heartRate, hrUnits, predicate);

      if (quantities.isNotEmpty) {
        final latest = quantities.first;
        _updateResult('最新心率: ${latest.harmonized.value} ${latest.harmonized.unit}\n'
            '时间: ${_convertToDateTime(latest.startTimestamp)}\n'
            '数据点数量: ${quantities.length}');
      } else {
        _updateResult('未找到心率数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _querySteps() async {
    _setLoading(true);
    try {
      final samples = await HealthKitReporter.sampleQuery(QuantityType.stepCount.identifier, predicate);
      if (samples.isNotEmpty) {
        final totalSteps = samples.fold<int>(0, (sum, sample) => sum + (sample.harmonized.value as int));
        _updateResult('总步数: $totalSteps\n'
            '数据点数量: ${samples.length}\n'
            '时间范围: ${_convertToDateTime(samples.last.startTimestamp)} - '
            '${_convertToDateTime(samples.first.endTimestamp)}');
      } else {
        _updateResult('未找到步数数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _querySleep() async {
    _setLoading(true);
    try {
      final categories = await HealthKitReporter.categoryQuery(CategoryType.sleepAnalysis, predicate);
      if (categories.isNotEmpty) {
        _updateResult('睡眠记录数量: ${categories.length}\n'
            '最新记录: ${_convertToDateTime(categories.first.startTimestamp)}\n'
            '睡眠类型: ${categories.first.harmonized.value}');
      } else {
        _updateResult('未找到睡眠数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _queryWorkout() async {
    _setLoading(true);
    try {
      final workouts = await HealthKitReporter.workoutQuery(predicate);
      if (workouts.isNotEmpty) {
        final totalCalories =
            workouts.fold<double>(0, (sum, workout) => sum + (workout.harmonized.totalEnergyBurned ?? 0));
        _updateResult('运动记录数量: ${workouts.length}\n'
            '总消耗卡路里: ${totalCalories.toStringAsFixed(1)} kcal\n'
            '最新运动: ${workouts.first.harmonized.type}');
      } else {
        _updateResult('未找到运动数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _queryClinicalRecords() async {
    _setLoading(true);
    try {
      final samples = await HealthKitReporter.sampleQuery(
        ClinicalType.allergyRecord.identifier,
        Predicate(
          DateTime.now().add(const Duration(days: -7000)),
          DateTime.now(),
        ),
      );
      if (samples.isNotEmpty) {
        _updateResult('临床记录数量: ${samples.length}\n'
            '记录类型: ${samples.first.identifier}');
      } else {
        _updateResult('未找到临床记录数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _queryElectrocardiograms() async {
    _setLoading(true);
    try {
      final electrocardiograms =
          await HealthKitReporter.electrocardiogramQuery(predicate, withVoltageMeasurements: true);
      if (electrocardiograms.isNotEmpty) {
        _updateResult('心电图记录数量: ${electrocardiograms.length}\n'
            '最新记录: ${_convertToDateTime(electrocardiograms.first.startTimestamp)}');
      } else {
        _updateResult('未找到心电图数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _queryBloodPressure() async {
    _setLoading(true);
    try {
      final correlations =
          await HealthKitReporter.correlationQuery(CorrelationType.bloodPressure.identifier, predicate);
      if (correlations.isNotEmpty) {
        _updateResult('血压记录数量: ${correlations.length}\n'
            '最新记录: ${_convertToDateTime(correlations.first.startTimestamp)}');
      } else {
        _updateResult('未找到血压数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _queryActivitySummary() async {
    _setLoading(true);
    try {
      final activitySummary = await HealthKitReporter.queryActivitySummary(predicate);
      if (activitySummary.isNotEmpty) {
        _updateResult('活动摘要数量: ${activitySummary.length}\n'
            '最新摘要: ${activitySummary.first.date}');
      } else {
        _updateResult('未找到活动摘要数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _queryCharacteristics() async {
    _setLoading(true);
    try {
      final characteristics = await HealthKitReporter.characteristicsQuery();
      _updateResult('个人特征数据:\n${characteristics.map}');
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _queryOxygenSaturation() async {
    _setLoading(true);
    try {
      final preferredUnits = await HealthKitReporter.preferredUnits([QuantityType.oxygenSaturation]);
      final o2Units = preferredUnits.first.unit;
      final quantities = await HealthKitReporter.quantityQuery(QuantityType.oxygenSaturation, o2Units, predicate);

      if (quantities.isNotEmpty) {
        final latest = quantities.first;
        final averageValue = quantities.fold<double>(0, (sum, q) => sum + q.harmonized.value) / quantities.length;
        _updateResult('最新血氧饱和度: ${latest.harmonized.value.toStringAsFixed(1)} ${latest.harmonized.unit}\n'
            '平均血氧饱和度: ${averageValue.toStringAsFixed(1)} ${latest.harmonized.unit}\n'
            '时间: ${_convertToDateTime(latest.startTimestamp)}\n'
            '数据点数量: ${quantities.length}');
      } else {
        _updateResult('未找到血氧饱和度数据');
      }
    } catch (e) {
      _updateResult('查询失败: $e');
    } finally {
      _setLoading(false);
    }
  }
}
