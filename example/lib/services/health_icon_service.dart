import 'package:flutter/material.dart';

class HealthIconService {
  /// 根据健康数据标识符获取对应的图标
  static IconData getIconForIdentifier(String identifier) {
    switch (identifier) {
      // 活动相关
      case 'HKQuantityTypeIdentifierStepCount':
        return Icons.directions_walk;
      case 'HKQuantityTypeIdentifierDistanceWalkingRunning':
        return Icons.directions_run;
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
        return Icons.local_fire_department;
      case 'HKQuantityTypeIdentifierBasalEnergyBurned':
        return Icons.whatshot;
      case 'HKQuantityTypeIdentifierFlightsClimbed':
        return Icons.stairs;
      case 'HKQuantityTypeIdentifierAppleExerciseTime':
        return Icons.fitness_center;
      case 'HKQuantityTypeIdentifierAppleStandTime':
        return Icons.airline_seat_flat;

      // 心脏相关
      case 'HKQuantityTypeIdentifierHeartRate':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierRestingHeartRate':
        return Icons.favorite_border;
      case 'HKQuantityTypeIdentifierWalkingHeartRateAverage':
        return Icons.directions_walk;
      case 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN':
        return Icons.timeline;
      case 'HKQuantityTypeIdentifierVO2Max':
        return Icons.trending_up;

      // 身体测量
      case 'HKQuantityTypeIdentifierBodyMass':
        return Icons.monitor_weight;
      case 'HKQuantityTypeIdentifierBodyFatPercentage':
        return Icons.pie_chart;
      case 'HKQuantityTypeIdentifierHeight':
        return Icons.height;
      case 'HKQuantityTypeIdentifierBodyMassIndex':
        return Icons.analytics;
      case 'HKQuantityTypeIdentifierLeanBodyMass':
        return Icons.fitness_center;

      // 营养
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
        return Icons.restaurant;
      case 'HKQuantityTypeIdentifierDietaryProtein':
        return Icons.set_meal;
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
        return Icons.cake;
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryWater':
        return Icons.water_drop;

      // 睡眠
      case 'HKCategoryTypeIdentifierSleepAnalysis':
        return Icons.bedtime;
      case 'HKCategoryTypeIdentifierSleepChanges':
        return Icons.bed;

      // 运动
      case 'HKWorkoutTypeIdentifier':
        return Icons.sports_soccer;
      case 'HKWorkoutTypeIdentifierWalking':
        return Icons.directions_walk;
      case 'HKWorkoutTypeIdentifierRunning':
        return Icons.directions_run;
      case 'HKWorkoutTypeIdentifierCycling':
        return Icons.directions_bike;
      case 'HKWorkoutTypeIdentifierSwimming':
        return Icons.pool;
      case 'HKWorkoutTypeIdentifierYoga':
        return Icons.self_improvement;
      case 'HKWorkoutTypeIdentifierStrengthTraining':
        return Icons.fitness_center;

      // 生命体征
      case 'HKQuantityTypeIdentifierBloodPressureSystolic':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierBloodPressureDiastolic':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierRespiratoryRate':
        return Icons.air;
      case 'HKQuantityTypeIdentifierBodyTemperature':
        return Icons.thermostat;
      case 'HKQuantityTypeIdentifierOxygenSaturation':
        return Icons.air;

      // 听力
      case 'HKQuantityTypeIdentifierEnvironmentalAudioExposure':
        return Icons.hearing;
      case 'HKQuantityTypeIdentifierHeadphoneAudioExposure':
        return Icons.headphones;

      // 生殖健康
      case 'HKCategoryTypeIdentifierMenstrualFlow':
        return Icons.calendar_today;
      case 'HKCategoryTypeIdentifierIntermenstrualBleeding':
        return Icons.calendar_month;
      case 'HKCategoryTypeIdentifierSexualActivity':
        return Icons.favorite;

      // 心理健康
      case 'HKCategoryTypeIdentifierMindfulSession':
        return Icons.self_improvement;

      // 默认图标
      default:
        return Icons.health_and_safety;
    }
  }

  /// 根据健康数据标识符获取对应的颜色
  static Color getColorForIdentifier(String identifier) {
    switch (identifier) {
      // 活动相关 - 橙色系
      case 'HKQuantityTypeIdentifierStepCount':
      case 'HKQuantityTypeIdentifierDistanceWalkingRunning':
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
      case 'HKQuantityTypeIdentifierBasalEnergyBurned':
      case 'HKQuantityTypeIdentifierFlightsClimbed':
      case 'HKQuantityTypeIdentifierAppleExerciseTime':
      case 'HKQuantityTypeIdentifierAppleStandTime':
        return Colors.orange;

      // 心脏相关 - 红色系
      case 'HKQuantityTypeIdentifierHeartRate':
      case 'HKQuantityTypeIdentifierRestingHeartRate':
      case 'HKQuantityTypeIdentifierWalkingHeartRateAverage':
      case 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN':
      case 'HKQuantityTypeIdentifierVO2Max':
      case 'HKQuantityTypeIdentifierBloodPressureSystolic':
      case 'HKQuantityTypeIdentifierBloodPressureDiastolic':
        return Colors.red;

      // 身体测量 - 蓝色系
      case 'HKQuantityTypeIdentifierBodyMass':
      case 'HKQuantityTypeIdentifierBodyFatPercentage':
      case 'HKQuantityTypeIdentifierHeight':
      case 'HKQuantityTypeIdentifierBodyMassIndex':
      case 'HKQuantityTypeIdentifierLeanBodyMass':
        return Colors.blue;

      // 营养 - 绿色系
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
      case 'HKQuantityTypeIdentifierDietaryProtein':
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
      case 'HKQuantityTypeIdentifierDietaryWater':
        return Colors.green;

      // 睡眠 - 紫色系
      case 'HKCategoryTypeIdentifierSleepAnalysis':
      case 'HKCategoryTypeIdentifierSleepChanges':
        return Colors.purple;

      // 运动 - 深蓝色系
      case 'HKWorkoutTypeIdentifier':
      case 'HKWorkoutTypeIdentifierWalking':
      case 'HKWorkoutTypeIdentifierRunning':
      case 'HKWorkoutTypeIdentifierCycling':
      case 'HKWorkoutTypeIdentifierSwimming':
      case 'HKWorkoutTypeIdentifierYoga':
      case 'HKWorkoutTypeIdentifierStrengthTraining':
        return Colors.indigo;

      // 生命体征 - 红色系
      case 'HKQuantityTypeIdentifierRespiratoryRate':
      case 'HKQuantityTypeIdentifierBodyTemperature':
      case 'HKQuantityTypeIdentifierOxygenSaturation':
        return Colors.red;

      // 听力 - 黄色系
      case 'HKQuantityTypeIdentifierEnvironmentalAudioExposure':
      case 'HKQuantityTypeIdentifierHeadphoneAudioExposure':
        return Colors.amber;

      // 生殖健康 - 粉色系
      case 'HKCategoryTypeIdentifierMenstrualFlow':
      case 'HKCategoryTypeIdentifierIntermenstrualBleeding':
      case 'HKCategoryTypeIdentifierSexualActivity':
        return Colors.pink;

      // 心理健康 - 青色系
      case 'HKCategoryTypeIdentifierMindfulSession':
        return Colors.teal;

      // 默认颜色
      default:
        return Colors.grey;
    }
  }

  /// 获取图标背景色（浅色版本）
  static Color getBackgroundColorForIdentifier(String identifier) {
    final color = getColorForIdentifier(identifier);
    return color.withValues(alpha: 0.1);
  }

  /// 获取图标前景色（深色版本）
  static Color getForegroundColorForIdentifier(String identifier) {
    final color = getColorForIdentifier(identifier);
    return color.withValues(alpha: 0.8);
  }

  /// 根据健康数据标识符获取分类名称
  static String getCategoryForIdentifier(String identifier) {
    if (identifier.contains('StepCount') ||
        identifier.contains('Distance') ||
        identifier.contains('Energy') ||
        identifier.contains('Exercise') ||
        identifier.contains('Stand')) {
      return '活动';
    } else if (identifier.contains('Heart') || identifier.contains('BloodPressure') || identifier.contains('VO2Max')) {
      return '心脏';
    } else if (identifier.contains('Body') || identifier.contains('Height') || identifier.contains('Mass')) {
      return '身体';
    } else if (identifier.contains('Dietary')) {
      return '营养';
    } else if (identifier.contains('Sleep')) {
      return '睡眠';
    } else if (identifier.contains('Workout')) {
      return '运动';
    } else if (identifier.contains('Audio')) {
      return '听力';
    } else if (identifier.contains('Menstrual') || identifier.contains('Sexual')) {
      return '生殖健康';
    } else if (identifier.contains('Mindful')) {
      return '心理健康';
    } else {
      return '其他';
    }
  }
}
