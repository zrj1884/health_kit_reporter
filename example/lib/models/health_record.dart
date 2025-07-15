import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';

/// 健康数据记录模型
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

  HealthRecord({
    required this.id,
    required this.identifier,
    required this.value,
    required this.unit,
    required this.startDate,
    required this.endDate,
    required this.sourceName,
    required this.deviceName,
    required this.isValid,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从Sample创建HealthRecord
  factory HealthRecord.fromSample(Sample sample) {
    return HealthRecord(
      id: sample.uuid,
      identifier: sample.identifier,
      value: _extractValue(sample),
      unit: _extractUnit(sample),
      startDate: DateTime.fromMillisecondsSinceEpoch((sample.startTimestamp * 1000).toInt()),
      endDate: DateTime.fromMillisecondsSinceEpoch((sample.endTimestamp * 1000).toInt()),
      sourceName: sample.sourceRevision.source.name,
      deviceName: sample.device?.name ?? 'Unknown',
      isValid: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// 从JSON创建HealthRecord
  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id'],
      identifier: json['identifier'],
      value: json['value'],
      unit: json['unit'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      sourceName: json['sourceName'],
      deviceName: json['deviceName'],
      isValid: json['isValid'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// 从数据库Map创建HealthRecord
  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'],
      identifier: map['identifier'],
      value: map['value'],
      unit: map['unit'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_timestamp']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['end_timestamp']),
      sourceName: map['source_name'],
      deviceName: map['device_name'],
      isValid: map['is_valid'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_timestamp']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_timestamp']),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identifier': identifier,
      'value': value,
      'unit': unit,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'sourceName': sourceName,
      'deviceName': deviceName,
      'isValid': isValid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// 提取样本值
  static String _extractValue(Sample sample) {
    if (sample is Quantity) {
      return sample.harmonized.value.toString();
    } else if (sample is Category) {
      return sample.harmonized.value.toString();
    } else if (sample is Workout) {
      return sample.harmonized.type.description;
    }
    return 'Unknown';
  }

  /// 提取单位
  static String _extractUnit(Sample sample) {
    if (sample is Quantity) {
      return sample.harmonized.unit;
    } else if (sample is Category) {
      return 'category';
    } else if (sample is Workout) {
      return 'workout';
    }
    return 'unknown';
  }

  /// 复制并更新
  HealthRecord copyWith({
    String? id,
    String? identifier,
    String? value,
    String? unit,
    DateTime? startDate,
    DateTime? endDate,
    String? sourceName,
    String? deviceName,
    bool? isValid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sourceName: sourceName ?? this.sourceName,
      deviceName: deviceName ?? this.deviceName,
      isValid: isValid ?? this.isValid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '''HealthRecord(id: $id, identifier: $identifier, value: $value, unit: $unit,
 startDate: $startDate, endDate: $endDate, sourceName: $sourceName, deviceName: $deviceName,
 isValid: $isValid, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }
}
