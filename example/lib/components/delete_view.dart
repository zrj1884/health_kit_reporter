import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/predicate.dart';

import 'action_card.dart';
import 'reporter_mixin.dart';
import 'result_display.dart';
import 'warning_display.dart';

class DeleteView extends StatefulWidget {
  const DeleteView({super.key});

  @override
  State<DeleteView> createState() => _DeleteViewState();
}

class _DeleteViewState extends State<DeleteView> with HealthKitReporterMixin {
  String _lastResult = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WarningDisplay(
          title: '⚠️ 数据删除警告',
          message: '删除操作将永久移除健康数据，请谨慎操作！',
        ),
        ResultDisplay(
          title: '删除结果',
          result: _lastResult,
          isLoading: _isLoading,
          placeholder: '点击下方按钮删除健康数据',
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
                icon: Icons.delete_forever,
                title: '删除步数数据',
                subtitle: '删除最近1天的步数记录',
                backgroundColor: Colors.red[100],
                iconColor: Colors.red[600],
                onTap: () => _deleteSteps(),
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

  Future<void> _deleteSteps() async {
    _setLoading(true);
    try {
      final map = await HealthKitReporter.deleteObjects(
          QuantityType.stepCount.identifier,
          Predicate(
            DateTime.now().add(const Duration(days: -1)),
            DateTime.now(),
          ));
      _updateResult('✅ 步数数据删除成功\n删除结果: $map');
    } catch (e) {
      _updateResult('❌ 删除失败: $e');
    } finally {
      _setLoading(false);
    }
  }
}
