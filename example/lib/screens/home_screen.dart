import 'package:flutter/material.dart';

import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/type/activity_summary_type.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/characteristic_type.dart';
import 'package:health_kit_reporter/model/type/clinical_type.dart';
import 'package:health_kit_reporter/model/type/document_type.dart';
import 'package:health_kit_reporter/model/type/electrocardiogram_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 导入组件
import '../components/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAuthorized = false;
  bool _isClinicalAuthorized = false;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // 初始化通知插件
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      print(response.payload);
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: AuthButton(
            icon: Icons.health_and_safety,
            tooltip: '授权健康数据访问',
            isAuthorized: _isAuthorized,
            onPressed: () => _authorize(),
          ),
          title: const Text(
            'HealthKit 数据管理器',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            AuthButton(
              icon: Icons.medical_services,
              tooltip: '授权临床记录访问',
              isAuthorized: _isClinicalAuthorized,
              onPressed: () => _authorizeClinicalRecords(),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.visibility),
                text: '数据读取',
              ),
              Tab(
                icon: Icon(Icons.edit_note),
                text: '数据写入',
              ),
              Tab(
                icon: Icon(Icons.monitor_heart),
                text: '实时监控',
              ),
              Tab(
                icon: Icon(Icons.delete_forever),
                text: '数据删除',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const ReadView(),
            const WriteView(),
            ObserveView(
              flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
            ),
            const DeleteView(),
          ],
        ),
      ),
    );
  }

  Future<void> _authorize() async {
    try {
      final readTypes = <String>[];
      readTypes.addAll(ActivitySummaryType.values.map((e) => e.identifier));
      readTypes.addAll(CategoryType.values.map((e) => e.identifier));
      readTypes.addAll(CharacteristicType.values.map((e) => e.identifier));
      readTypes.addAll(QuantityType.values.map((e) => e.identifier));
      readTypes.addAll(WorkoutType.values.map((e) => e.identifier));
      readTypes.addAll(SeriesType.values.map((e) => e.identifier));
      readTypes.addAll(ElectrocardiogramType.values.map((e) => e.identifier));
      readTypes.addAll(DocumentType.values.map((e) => e.identifier));

      final writeTypes = <String>[
        QuantityType.stepCount.identifier,
        WorkoutType.workoutType.identifier,
        CategoryType.sleepAnalysis.identifier,
        CategoryType.mindfulSession.identifier,
        QuantityType.bloodPressureDiastolic.identifier,
        QuantityType.bloodPressureSystolic.identifier,
      ];

      final isRequested = await HealthKitReporter.requestAuthorization(readTypes, writeTypes);

      if (mounted) {
        setState(() {
          _isAuthorized = isRequested;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isRequested ? '✅ 健康数据授权成功' : '❌ 健康数据授权失败'),
            backgroundColor: isRequested ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthorized = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 授权失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _authorizeClinicalRecords() async {
    try {
      final readTypes = ClinicalType.values.map((type) => type.identifier).toList();
      final isRequested = await HealthKitReporter.requestAuthorization(readTypes, []);

      if (mounted) {
        setState(() {
          _isClinicalAuthorized = isRequested;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isRequested ? '✅ 临床记录授权成功' : '❌ 临床记录授权失败'),
            backgroundColor: isRequested ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isClinicalAuthorized = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 临床记录授权失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
