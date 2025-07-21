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
import '../services/authorization_service.dart';
import 'delete_screen.dart';
import 'health_database_screen.dart';
import 'observe_screen.dart';
import 'read_screen.dart';
import 'write_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isAuthorized = false;
  bool _isClinicalAuthorized = false;
  late TabController _tabController;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // 初始化通知插件
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint(response.payload);
      return;
    });

    // 读取缓存的授权状态
    _loadCachedAuthorizationStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS系统背景色
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildAuthButton(
          icon: Icons.health_and_safety,
          tooltip: '授权健康数据访问',
          isAuthorized: _isAuthorized,
          onPressed: () => _authorize(),
        ),
        title: const Text(
          'HealthKit 数据管理器',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          _buildAuthButton(
            icon: Icons.medical_services,
            tooltip: '授权临床记录访问',
            isAuthorized: _isClinicalAuthorized,
            onPressed: () => _authorizeClinicalRecords(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 0),
              tabs: [
                _buildTab(Icons.storage, '数据同步'),
                _buildTab(Icons.visibility, '数据读取'),
                _buildTab(Icons.edit_note, '数据写入'),
                _buildTab(Icons.monitor_heart, '实时监控'),
                _buildTab(Icons.delete_forever, '数据删除'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LazyTabView(
            index: 0,
            child: HealthDatabaseScreen(
              flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
            ),
          ),
          _LazyTabView(
            index: 1,
            child: const ReadScreen(),
          ),
          _LazyTabView(
            index: 2,
            child: const WriteScreen(),
          ),
          _LazyTabView(
            index: 3,
            child: ObserveScreen(
              flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
            ),
          ),
          _LazyTabView(
            index: 4,
            child: const DeleteScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String text) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton({
    required IconData icon,
    required String tooltip,
    required bool isAuthorized,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAuthorized ? const Color(0xFF34C759) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isAuthorized ? const Color(0xFF34C759) : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isAuthorized ? Colors.white : Colors.grey.shade600,
            ),
          ),
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

        if (isRequested) {
          IOSSnackBar.showSuccess(context, message: '✅ 健康数据授权成功');
          // 缓存授权状态
          await AuthorizationService.cacheHealthDataAuthorization(isRequested);
        } else {
          IOSSnackBar.showError(context, message: '❌ 健康数据授权失败');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthorized = false;
        });
        IOSSnackBar.showError(context, message: '❌ 授权失败: $e');
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

        if (isRequested) {
          IOSSnackBar.showSuccess(context, message: '✅ 临床记录授权成功');
          // 缓存授权状态
          await AuthorizationService.cacheClinicalRecordsAuthorization(isRequested);
        } else {
          IOSSnackBar.showError(context, message: '❌ 临床记录授权失败');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isClinicalAuthorized = false;
        });

        IOSSnackBar.showError(context, message: '❌ 临床记录授权失败: $e');
      }
    }
  }

  /// 加载缓存的授权状态
  Future<void> _loadCachedAuthorizationStatus() async {
    try {
      final healthDataAuth = await AuthorizationService.getCachedHealthDataAuthorization();
      final clinicalRecordsAuth = await AuthorizationService.getCachedClinicalRecordsAuthorization();

      if (mounted) {
        setState(() {
          _isAuthorized = healthDataAuth;
          _isClinicalAuthorized = clinicalRecordsAuth;
        });
      }
    } catch (e) {
      debugPrint('加载缓存授权状态失败: $e');
    }
  }
}

/// 延迟加载的Tab视图组件
/// 实现AutomaticKeepAliveClientMixin来保持状态
class _LazyTabView extends StatefulWidget {
  final int index;
  final Widget child;

  const _LazyTabView({
    required this.index,
    required this.child,
  });

  @override
  State<_LazyTabView> createState() => _LazyTabViewState();
}

class _LazyTabViewState extends State<_LazyTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用super.build
    return widget.child;
  }
}
