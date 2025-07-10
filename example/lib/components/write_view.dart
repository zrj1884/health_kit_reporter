import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/correlation.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';
import 'package:health_kit_reporter/model/payload/workout_event.dart';
import 'package:health_kit_reporter/model/payload/workout_event_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/correlation_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';

import 'reporter_mixin.dart';
import 'action_card.dart';
import 'result_display.dart';

class WriteView extends StatefulWidget {
  const WriteView({Key? key}) : super(key: key);

  @override
  State<WriteView> createState() => _WriteViewState();
}

class _WriteViewState extends State<WriteView> with HealthKitReporterMixin {
  String _lastResult = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultDisplay(
          title: '写入结果',
          result: _lastResult,
          isLoading: _isLoading,
          placeholder: '点击下方按钮开始写入健康数据',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ActionCard(
                icon: Icons.directions_walk,
                title: '记录步数',
                subtitle: '添加100步运动数据',
                backgroundColor: Colors.green[100],
                iconColor: Colors.green[600],
                onTap: () => _saveSteps(),
              ),
              ActionCard(
                icon: Icons.fitness_center,
                title: '记录运动',
                subtitle: '添加羽毛球运动记录',
                backgroundColor: Colors.green[100],
                iconColor: Colors.green[600],
                onTap: () => _saveWorkout(),
              ),
              ActionCard(
                icon: Icons.self_improvement,
                title: '记录冥想',
                subtitle: '添加1分钟冥想记录',
                backgroundColor: Colors.green[100],
                iconColor: Colors.green[600],
                onTap: () => _saveMindfulMinutes(),
              ),
              ActionCard(
                icon: Icons.bloodtype,
                title: '记录血压',
                subtitle: '添加血压测量数据',
                backgroundColor: Colors.green[100],
                iconColor: Colors.green[600],
                onTap: () => _saveBloodPressureCorrelation(),
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

  Future<void> _saveSteps() async {
    _setLoading(true);
    try {
      final canWrite = await HealthKitReporter.isAuthorizedToWrite(QuantityType.stepCount.identifier);
      if (canWrite) {
        final now = DateTime.now();
        final minuteAgo = now.add(const Duration(minutes: -1));
        const harmonized = QuantityHarmonized(100, 'count', null);
        final steps = Quantity('testStepsUUID', QuantityType.stepCount.identifier, minuteAgo.millisecondsSinceEpoch,
            now.millisecondsSinceEpoch, device, sourceRevision, harmonized);

        final saved = await HealthKitReporter.save(steps);
        _updateResult(saved ? '✅ 步数数据写入成功\n添加了100步运动数据' : '❌ 步数数据写入失败');
      } else {
        _updateResult('❌ 没有写入步数数据的权限');
      }
    } catch (e) {
      _updateResult('❌ 写入失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveWorkout() async {
    _setLoading(true);
    try {
      final canWrite = await HealthKitReporter.isAuthorizedToWrite(WorkoutType.workoutType.identifier);
      if (canWrite) {
        const harmonized = WorkoutHarmonized(
          WorkoutActivityType.badminton,
          1.2,
          'kcal',
          123,
          'm',
          0,
          'count',
          0,
          'count',
          null,
        );
        final now = DateTime.now();
        const duration = 60;
        const eventHarmonized = WorkoutEventHarmonized(WorkoutEventType.pause);
        final events = [
          WorkoutEvent(
            now.millisecondsSinceEpoch,
            now.millisecondsSinceEpoch,
            duration,
            eventHarmonized,
          )
        ];
        final minuteAgo = now.add(const Duration(seconds: -duration));
        final workout = Workout(
          'testWorkoutUUID',
          'basketball',
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          harmonized,
          duration,
          events,
        );

        final saved = await HealthKitReporter.save(workout);
        _updateResult(saved ? '✅ 运动记录写入成功\n添加了羽毛球运动数据' : '❌ 运动记录写入失败');
      } else {
        _updateResult('❌ 没有写入运动数据的权限');
      }
    } catch (e) {
      _updateResult('❌ 写入失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveMindfulMinutes() async {
    _setLoading(true);
    try {
      final canWrite = await HealthKitReporter.isAuthorizedToWrite(CategoryType.mindfulSession.identifier);
      if (canWrite) {
        final now = DateTime.now();
        final minuteAgo = now.add(const Duration(minutes: -1));
        const harmonized = CategoryHarmonized(
          0,
          'HKCategoryValue',
          'Not Aplicable',
          {},
        );
        final mindfulMinutes = Category(
          'testMindfulMinutesUUID',
          CategoryType.mindfulSession.identifier,
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          harmonized,
        );

        final saved = await HealthKitReporter.save(mindfulMinutes);
        _updateResult(saved ? '✅ 冥想记录写入成功\n添加了1分钟冥想数据' : '❌ 冥想记录写入失败');
      } else {
        _updateResult('❌ 没有写入冥想数据的权限');
      }
    } catch (e) {
      _updateResult('❌ 写入失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveBloodPressureCorrelation() async {
    _setLoading(true);
    try {
      final now = DateTime.now();
      final minuteAgo = now.add(const Duration(minutes: -1));
      final sys = Quantity(
          'testSysUUID234',
          QuantityType.bloodPressureSystolic.identifier,
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          const QuantityHarmonized(123, 'mmHg', null));
      final dia = Quantity(
          'testDiaUUID456',
          QuantityType.bloodPressureDiastolic.identifier,
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          const QuantityHarmonized(89, 'mmHg', null));
      final correlationJarmonized = CorrelationHarmonized([sys, dia], [], null);
      final correlation = Correlation('test', CorrelationType.bloodPressure.identifier,
          minuteAgo.millisecondsSinceEpoch, now.millisecondsSinceEpoch, device, sourceRevision, correlationJarmonized);

      final saved = await HealthKitReporter.save(correlation);
      _updateResult(saved ? '✅ 血压数据写入成功\n添加了血压测量数据' : '❌ 血压数据写入失败');
    } catch (e) {
      _updateResult('❌ 写入失败: $e');
    } finally {
      _setLoading(false);
    }
  }
}
