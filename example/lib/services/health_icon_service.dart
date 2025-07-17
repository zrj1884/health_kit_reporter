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
      case 'HKQuantityTypeIdentifierDistanceCycling':
        return Icons.directions_bike;
      case 'HKQuantityTypeIdentifierDistanceWheelchair':
        return Icons.accessible;
      case 'HKQuantityTypeIdentifierDistanceSwimming':
        return Icons.pool;
      case 'HKQuantityTypeIdentifierDistanceDownhillSnowSports':
        return Icons.downhill_skiing;
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
      case 'HKQuantityTypeIdentifierAppleMoveTime':
        return Icons.directions_walk;
      case 'HKQuantityTypeIdentifierAppleWalkingSteadiness':
        return Icons.trending_up;
      case 'HKQuantityTypeIdentifierNikeFuel':
        return Icons.local_fire_department;
      case 'HKQuantityTypeIdentifierPushCount':
        return Icons.fitness_center;
      case 'HKQuantityTypeIdentifierSwimmingStrokeCount':
        return Icons.pool;
      case 'HKQuantityTypeIdentifierWalkingSpeed':
        return Icons.speed;
      case 'HKQuantityTypeIdentifierWalkingDoubleSupportPercentage':
        return Icons.accessibility;
      case 'HKQuantityTypeIdentifierWalkingAsymmetryPercentage':
        return Icons.compare_arrows;
      case 'HKQuantityTypeIdentifierWalkingStepLength':
        return Icons.straighten;
      case 'HKQuantityTypeIdentifierSixMinuteWalkTestDistance':
        return Icons.directions_walk;
      case 'HKQuantityTypeIdentifierStairAscentSpeed':
        return Icons.trending_up;
      case 'HKQuantityTypeIdentifierStairDescentSpeed':
        return Icons.trending_down;
      case 'HKQuantityTypeIdentifierRunningStrideLength':
        return Icons.straighten;
      case 'HKQuantityTypeIdentifierRunningVerticalOscillation':
        return Icons.waves;
      case 'HKQuantityTypeIdentifierRunningGroundContactTime':
        return Icons.timer;
      case 'HKQuantityTypeIdentifierRunningPower':
        return Icons.power;
      case 'HKQuantityTypeIdentifierRunningSpeed':
        return Icons.speed;
      case 'HKQuantityTypeIdentifierUVExposure':
        return Icons.wb_sunny;
      case 'HKQuantityTypeIdentifierUnderwaterDepth':
        return Icons.water;
      case 'HKQuantityTypeIdentifierWaterTemperature':
        return Icons.thermostat;

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
      case 'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute':
        return Icons.trending_down;
      case 'HKQuantityTypeIdentifierAtrialFibrillationBurden':
        return Icons.favorite;

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
      case 'HKQuantityTypeIdentifierWaistCircumference':
        return Icons.straighten;
      case 'HKQuantityTypeIdentifierBodyTemperature':
        return Icons.thermostat;
      case 'HKQuantityTypeIdentifierBasalBodyTemperature':
        return Icons.thermostat;
      case 'HKQuantityTypeIdentifierAppleSleepingWristTemperature':
        return Icons.thermostat;
      case 'HKQuantityTypeIdentifierNumberOfTimesFallen':
        return Icons.warning;
      case 'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages':
        return Icons.local_bar;

      // 营养
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
        return Icons.restaurant;
      case 'HKQuantityTypeIdentifierDietaryProtein':
        return Icons.set_meal;
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
        return Icons.cake;
      case 'HKQuantityTypeIdentifierDietaryFiber':
        return Icons.grain;
      case 'HKQuantityTypeIdentifierDietarySugar':
        return Icons.cake;
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryFatPolyunsaturated':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryFatMonounsaturated':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryFatSaturated':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryCholesterol':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietarySodium':
        return Icons.restaurant;
      case 'HKQuantityTypeIdentifierDietaryVitaminA':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminB6':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminB12':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminC':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminD':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminE':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminK':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryCalcium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryIron':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryThiamin':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryRiboflavin':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryNiacin':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryFolate':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryBiotin':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryPantothenicAcid':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryPhosphorus':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryIodine':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryMagnesium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryZinc':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietarySelenium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryCopper':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryManganese':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryChromium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryMolybdenum':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryChloride':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryPotassium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryCaffeine':
        return Icons.coffee;
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
      case 'HKQuantityTypeIdentifierOxygenSaturation':
        return Icons.air;
      case 'HKQuantityTypeIdentifierPeripheralPerfusionIndex':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierBloodGlucose':
        return Icons.bloodtype;
      case 'HKQuantityTypeIdentifierBloodAlcoholContent':
        return Icons.local_bar;
      case 'HKQuantityTypeIdentifierForcedVitalCapacity':
        return Icons.air;
      case 'HKQuantityTypeIdentifierForcedExpiratoryVolume1':
        return Icons.air;
      case 'HKQuantityTypeIdentifierPeakExpiratoryFlowRate':
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

      // 其他健康指标
      case 'HKQuantityTypeIdentifierElectrodermalActivity':
        return Icons.electric_bolt;
      case 'HKQuantityTypeIdentifierInhalerUsage':
        return Icons.medical_services;
      case 'HKQuantityTypeIdentifierInsulinDelivery':
        return Icons.medical_services;

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
      case 'HKQuantityTypeIdentifierDistanceCycling':
      case 'HKQuantityTypeIdentifierDistanceWheelchair':
      case 'HKQuantityTypeIdentifierDistanceSwimming':
      case 'HKQuantityTypeIdentifierDistanceDownhillSnowSports':
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
      case 'HKQuantityTypeIdentifierBasalEnergyBurned':
      case 'HKQuantityTypeIdentifierFlightsClimbed':
      case 'HKQuantityTypeIdentifierAppleExerciseTime':
      case 'HKQuantityTypeIdentifierAppleStandTime':
      case 'HKQuantityTypeIdentifierAppleMoveTime':
      case 'HKQuantityTypeIdentifierAppleWalkingSteadiness':
      case 'HKQuantityTypeIdentifierNikeFuel':
      case 'HKQuantityTypeIdentifierPushCount':
      case 'HKQuantityTypeIdentifierSwimmingStrokeCount':
      case 'HKQuantityTypeIdentifierWalkingSpeed':
      case 'HKQuantityTypeIdentifierWalkingDoubleSupportPercentage':
      case 'HKQuantityTypeIdentifierWalkingAsymmetryPercentage':
      case 'HKQuantityTypeIdentifierWalkingStepLength':
      case 'HKQuantityTypeIdentifierSixMinuteWalkTestDistance':
      case 'HKQuantityTypeIdentifierStairAscentSpeed':
      case 'HKQuantityTypeIdentifierStairDescentSpeed':
      case 'HKQuantityTypeIdentifierRunningStrideLength':
      case 'HKQuantityTypeIdentifierRunningVerticalOscillation':
      case 'HKQuantityTypeIdentifierRunningGroundContactTime':
      case 'HKQuantityTypeIdentifierRunningPower':
      case 'HKQuantityTypeIdentifierRunningSpeed':
      case 'HKQuantityTypeIdentifierUVExposure':
      case 'HKQuantityTypeIdentifierUnderwaterDepth':
      case 'HKQuantityTypeIdentifierWaterTemperature':
        return Colors.orange;

      // 心脏相关 - 红色系
      case 'HKQuantityTypeIdentifierHeartRate':
      case 'HKQuantityTypeIdentifierRestingHeartRate':
      case 'HKQuantityTypeIdentifierWalkingHeartRateAverage':
      case 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN':
      case 'HKQuantityTypeIdentifierVO2Max':
      case 'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute':
      case 'HKQuantityTypeIdentifierAtrialFibrillationBurden':
      case 'HKQuantityTypeIdentifierBloodPressureSystolic':
      case 'HKQuantityTypeIdentifierBloodPressureDiastolic':
      case 'HKQuantityTypeIdentifierPeripheralPerfusionIndex':
        return Colors.red;

      // 身体测量 - 蓝色系
      case 'HKQuantityTypeIdentifierBodyMass':
      case 'HKQuantityTypeIdentifierBodyFatPercentage':
      case 'HKQuantityTypeIdentifierHeight':
      case 'HKQuantityTypeIdentifierBodyMassIndex':
      case 'HKQuantityTypeIdentifierLeanBodyMass':
      case 'HKQuantityTypeIdentifierWaistCircumference':
      case 'HKQuantityTypeIdentifierBodyTemperature':
      case 'HKQuantityTypeIdentifierBasalBodyTemperature':
      case 'HKQuantityTypeIdentifierAppleSleepingWristTemperature':
      case 'HKQuantityTypeIdentifierNumberOfTimesFallen':
      case 'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages':
        return Colors.blue;

      // 营养 - 绿色系
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
      case 'HKQuantityTypeIdentifierDietaryProtein':
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
      case 'HKQuantityTypeIdentifierDietaryFiber':
      case 'HKQuantityTypeIdentifierDietarySugar':
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
      case 'HKQuantityTypeIdentifierDietaryFatPolyunsaturated':
      case 'HKQuantityTypeIdentifierDietaryFatMonounsaturated':
      case 'HKQuantityTypeIdentifierDietaryFatSaturated':
      case 'HKQuantityTypeIdentifierDietaryCholesterol':
      case 'HKQuantityTypeIdentifierDietarySodium':
      case 'HKQuantityTypeIdentifierDietaryVitaminA':
      case 'HKQuantityTypeIdentifierDietaryVitaminB6':
      case 'HKQuantityTypeIdentifierDietaryVitaminB12':
      case 'HKQuantityTypeIdentifierDietaryVitaminC':
      case 'HKQuantityTypeIdentifierDietaryVitaminD':
      case 'HKQuantityTypeIdentifierDietaryVitaminE':
      case 'HKQuantityTypeIdentifierDietaryVitaminK':
      case 'HKQuantityTypeIdentifierDietaryCalcium':
      case 'HKQuantityTypeIdentifierDietaryIron':
      case 'HKQuantityTypeIdentifierDietaryThiamin':
      case 'HKQuantityTypeIdentifierDietaryRiboflavin':
      case 'HKQuantityTypeIdentifierDietaryNiacin':
      case 'HKQuantityTypeIdentifierDietaryFolate':
      case 'HKQuantityTypeIdentifierDietaryBiotin':
      case 'HKQuantityTypeIdentifierDietaryPantothenicAcid':
      case 'HKQuantityTypeIdentifierDietaryPhosphorus':
      case 'HKQuantityTypeIdentifierDietaryIodine':
      case 'HKQuantityTypeIdentifierDietaryMagnesium':
      case 'HKQuantityTypeIdentifierDietaryZinc':
      case 'HKQuantityTypeIdentifierDietarySelenium':
      case 'HKQuantityTypeIdentifierDietaryCopper':
      case 'HKQuantityTypeIdentifierDietaryManganese':
      case 'HKQuantityTypeIdentifierDietaryChromium':
      case 'HKQuantityTypeIdentifierDietaryMolybdenum':
      case 'HKQuantityTypeIdentifierDietaryChloride':
      case 'HKQuantityTypeIdentifierDietaryPotassium':
      case 'HKQuantityTypeIdentifierDietaryCaffeine':
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
      case 'HKQuantityTypeIdentifierOxygenSaturation':
      case 'HKQuantityTypeIdentifierBloodGlucose':
      case 'HKQuantityTypeIdentifierBloodAlcoholContent':
      case 'HKQuantityTypeIdentifierForcedVitalCapacity':
      case 'HKQuantityTypeIdentifierForcedExpiratoryVolume1':
      case 'HKQuantityTypeIdentifierPeakExpiratoryFlowRate':
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

      // 其他健康指标 - 棕色系
      case 'HKQuantityTypeIdentifierElectrodermalActivity':
      case 'HKQuantityTypeIdentifierInhalerUsage':
      case 'HKQuantityTypeIdentifierInsulinDelivery':
        return Colors.brown;

      // 默认颜色
      default:
        return Colors.brown;
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
        identifier.contains('Stand') ||
        identifier.contains('Move') ||
        identifier.contains('Walking') ||
        identifier.contains('Running') ||
        identifier.contains('Stair') ||
        identifier.contains('UV') ||
        identifier.contains('Underwater') ||
        identifier.contains('Water') ||
        identifier.contains('NikeFuel') ||
        identifier.contains('PushCount') ||
        identifier.contains('Swimming')) {
      return '活动';
    } else if (identifier.contains('Heart') ||
        identifier.contains('VO2Max') ||
        identifier.contains('AtrialFibrillation')) {
      return '心脏';
    } else if (identifier.contains('Body') ||
        identifier.contains('Height') ||
        identifier.contains('Mass') ||
        identifier.contains('Waist') ||
        identifier.contains('Temperature') ||
        identifier.contains('Fallen') ||
        identifier.contains('Alcoholic')) {
      return '身体';
    } else if (identifier.contains('Dietary')) {
      return '营养';
    } else if (identifier.contains('Sleep')) {
      return '睡眠';
    } else if (identifier.contains('Workout')) {
      return '运动';
    } else if (identifier.contains('BloodPressure') ||
        identifier.contains('Respiratory') ||
        identifier.contains('Oxygen') ||
        identifier.contains('Peripheral') ||
        identifier.contains('BloodGlucose') ||
        identifier.contains('BloodAlcohol') ||
        identifier.contains('Forced') ||
        identifier.contains('Peak')) {
      return '生命体征';
    } else if (identifier.contains('Audio')) {
      return '听力';
    } else if (identifier.contains('Menstrual') || identifier.contains('Sexual')) {
      return '生殖健康';
    } else if (identifier.contains('Mindful')) {
      return '心理健康';
    } else if (identifier.contains('Electrodermal') ||
        identifier.contains('Inhaler') ||
        identifier.contains('Insulin')) {
      return '其他健康指标';
    } else {
      return '其他健康指标';
    }
  }

  /// 根据健康数据标识符获取显示名称
  static String getDisplayNameForIdentifier(String identifier) {
    switch (identifier) {
      // 活动相关
      case 'HKQuantityTypeIdentifierStepCount':
        return '步数';
      case 'HKQuantityTypeIdentifierDistanceWalkingRunning':
        return '步行跑步距离';
      case 'HKQuantityTypeIdentifierDistanceCycling':
        return '骑行距离';
      case 'HKQuantityTypeIdentifierDistanceWheelchair':
        return '轮椅距离';
      case 'HKQuantityTypeIdentifierDistanceSwimming':
        return '游泳距离';
      case 'HKQuantityTypeIdentifierDistanceDownhillSnowSports':
        return '滑雪距离';
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
        return '活动能量';
      case 'HKQuantityTypeIdentifierBasalEnergyBurned':
        return '基础能量';
      case 'HKQuantityTypeIdentifierFlightsClimbed':
        return '爬楼层数';
      case 'HKQuantityTypeIdentifierAppleExerciseTime':
        return '运动时间';
      case 'HKQuantityTypeIdentifierAppleStandTime':
        return '站立时间';
      case 'HKQuantityTypeIdentifierAppleMoveTime':
        return '活动时间';
      case 'HKQuantityTypeIdentifierAppleWalkingSteadiness':
        return '步行稳定性';
      case 'HKQuantityTypeIdentifierNikeFuel':
        return 'Nike燃料';
      case 'HKQuantityTypeIdentifierPushCount':
        return '俯卧撑次数';
      case 'HKQuantityTypeIdentifierSwimmingStrokeCount':
        return '游泳划水次数';
      case 'HKQuantityTypeIdentifierWalkingSpeed':
        return '步行速度';
      case 'HKQuantityTypeIdentifierWalkingDoubleSupportPercentage':
        return '步行双支撑百分比';
      case 'HKQuantityTypeIdentifierWalkingAsymmetryPercentage':
        return '步行不对称百分比';
      case 'HKQuantityTypeIdentifierWalkingStepLength':
        return '步行步长';
      case 'HKQuantityTypeIdentifierSixMinuteWalkTestDistance':
        return '六分钟步行测试距离';
      case 'HKQuantityTypeIdentifierStairAscentSpeed':
        return '上楼速度';
      case 'HKQuantityTypeIdentifierStairDescentSpeed':
        return '下楼速度';
      case 'HKQuantityTypeIdentifierRunningStrideLength':
        return '跑步步长';
      case 'HKQuantityTypeIdentifierRunningVerticalOscillation':
        return '跑步垂直振荡';
      case 'HKQuantityTypeIdentifierRunningGroundContactTime':
        return '跑步地面接触时间';
      case 'HKQuantityTypeIdentifierRunningPower':
        return '跑步功率';
      case 'HKQuantityTypeIdentifierRunningSpeed':
        return '跑步速度';
      case 'HKQuantityTypeIdentifierUVExposure':
        return '紫外线暴露';
      case 'HKQuantityTypeIdentifierUnderwaterDepth':
        return '水下深度';
      case 'HKQuantityTypeIdentifierWaterTemperature':
        return '水温';

      // 心脏相关
      case 'HKQuantityTypeIdentifierHeartRate':
        return '心率';
      case 'HKQuantityTypeIdentifierRestingHeartRate':
        return '静息心率';
      case 'HKQuantityTypeIdentifierWalkingHeartRateAverage':
        return '步行心率';
      case 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN':
        return '心率变异性';
      case 'HKQuantityTypeIdentifierVO2Max':
        return '有氧适能';
      case 'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute':
        return '心率恢复一分钟';
      case 'HKQuantityTypeIdentifierAtrialFibrillationBurden':
        return '房颤负担';

      // 身体测量
      case 'HKQuantityTypeIdentifierBodyMass':
        return '体重';
      case 'HKQuantityTypeIdentifierBodyFatPercentage':
        return '体脂率';
      case 'HKQuantityTypeIdentifierHeight':
        return '身高';
      case 'HKQuantityTypeIdentifierBodyMassIndex':
        return 'BMI';
      case 'HKQuantityTypeIdentifierLeanBodyMass':
        return '去脂体重';
      case 'HKQuantityTypeIdentifierWaistCircumference':
        return '腰围';
      case 'HKQuantityTypeIdentifierBodyTemperature':
        return '体温';
      case 'HKQuantityTypeIdentifierBasalBodyTemperature':
        return '基础体温';
      case 'HKQuantityTypeIdentifierAppleSleepingWristTemperature':
        return '睡眠手腕温度';
      case 'HKQuantityTypeIdentifierNumberOfTimesFallen':
        return '跌倒次数';
      case 'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages':
        return '酒精饮料数量';

      // 营养
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
        return '摄入能量';
      case 'HKQuantityTypeIdentifierDietaryProtein':
        return '蛋白质';
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
        return '碳水化合物';
      case 'HKQuantityTypeIdentifierDietaryFiber':
        return '膳食纤维';
      case 'HKQuantityTypeIdentifierDietarySugar':
        return '糖分';
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
        return '总脂肪';
      case 'HKQuantityTypeIdentifierDietaryFatPolyunsaturated':
        return '多不饱和脂肪';
      case 'HKQuantityTypeIdentifierDietaryFatMonounsaturated':
        return '单不饱和脂肪';
      case 'HKQuantityTypeIdentifierDietaryFatSaturated':
        return '饱和脂肪';
      case 'HKQuantityTypeIdentifierDietaryCholesterol':
        return '胆固醇';
      case 'HKQuantityTypeIdentifierDietarySodium':
        return '钠';
      case 'HKQuantityTypeIdentifierDietaryVitaminA':
        return '维生素A';
      case 'HKQuantityTypeIdentifierDietaryVitaminB6':
        return '维生素B6';
      case 'HKQuantityTypeIdentifierDietaryVitaminB12':
        return '维生素B12';
      case 'HKQuantityTypeIdentifierDietaryVitaminC':
        return '维生素C';
      case 'HKQuantityTypeIdentifierDietaryVitaminD':
        return '维生素D';
      case 'HKQuantityTypeIdentifierDietaryVitaminE':
        return '维生素E';
      case 'HKQuantityTypeIdentifierDietaryVitaminK':
        return '维生素K';
      case 'HKQuantityTypeIdentifierDietaryCalcium':
        return '钙';
      case 'HKQuantityTypeIdentifierDietaryIron':
        return '铁';
      case 'HKQuantityTypeIdentifierDietaryThiamin':
        return '硫胺素';
      case 'HKQuantityTypeIdentifierDietaryRiboflavin':
        return '核黄素';
      case 'HKQuantityTypeIdentifierDietaryNiacin':
        return '烟酸';
      case 'HKQuantityTypeIdentifierDietaryFolate':
        return '叶酸';
      case 'HKQuantityTypeIdentifierDietaryBiotin':
        return '生物素';
      case 'HKQuantityTypeIdentifierDietaryPantothenicAcid':
        return '泛酸';
      case 'HKQuantityTypeIdentifierDietaryPhosphorus':
        return '磷';
      case 'HKQuantityTypeIdentifierDietaryIodine':
        return '碘';
      case 'HKQuantityTypeIdentifierDietaryMagnesium':
        return '镁';
      case 'HKQuantityTypeIdentifierDietaryZinc':
        return '锌';
      case 'HKQuantityTypeIdentifierDietarySelenium':
        return '硒';
      case 'HKQuantityTypeIdentifierDietaryCopper':
        return '铜';
      case 'HKQuantityTypeIdentifierDietaryManganese':
        return '锰';
      case 'HKQuantityTypeIdentifierDietaryChromium':
        return '铬';
      case 'HKQuantityTypeIdentifierDietaryMolybdenum':
        return '钼';
      case 'HKQuantityTypeIdentifierDietaryChloride':
        return '氯';
      case 'HKQuantityTypeIdentifierDietaryPotassium':
        return '钾';
      case 'HKQuantityTypeIdentifierDietaryCaffeine':
        return '咖啡因';
      case 'HKQuantityTypeIdentifierDietaryWater':
        return '水分';

      // 睡眠
      case 'HKCategoryTypeIdentifierSleepAnalysis':
        return '睡眠分析';
      case 'HKCategoryTypeIdentifierSleepChanges':
        return '睡眠变化';

      // 运动
      case 'HKWorkoutTypeIdentifier':
        return '运动';
      case 'HKWorkoutTypeIdentifierWalking':
        return '步行';
      case 'HKWorkoutTypeIdentifierRunning':
        return '跑步';
      case 'HKWorkoutTypeIdentifierCycling':
        return '骑行';
      case 'HKWorkoutTypeIdentifierSwimming':
        return '游泳';
      case 'HKWorkoutTypeIdentifierYoga':
        return '瑜伽';
      case 'HKWorkoutTypeIdentifierStrengthTraining':
        return '力量训练';

      // 生命体征
      case 'HKQuantityTypeIdentifierBloodPressureSystolic':
        return '收缩压';
      case 'HKQuantityTypeIdentifierBloodPressureDiastolic':
        return '舒张压';
      case 'HKQuantityTypeIdentifierRespiratoryRate':
        return '呼吸率';
      case 'HKQuantityTypeIdentifierOxygenSaturation':
        return '血氧饱和度';
      case 'HKQuantityTypeIdentifierPeripheralPerfusionIndex':
        return '外周灌注指数';
      case 'HKQuantityTypeIdentifierBloodGlucose':
        return '血糖';
      case 'HKQuantityTypeIdentifierBloodAlcoholContent':
        return '血液酒精含量';
      case 'HKQuantityTypeIdentifierForcedVitalCapacity':
        return '用力肺活量';
      case 'HKQuantityTypeIdentifierForcedExpiratoryVolume1':
        return '一秒用力呼气量';
      case 'HKQuantityTypeIdentifierPeakExpiratoryFlowRate':
        return '峰值呼气流速';

      // 听力
      case 'HKQuantityTypeIdentifierEnvironmentalAudioExposure':
        return '环境音频暴露';
      case 'HKQuantityTypeIdentifierHeadphoneAudioExposure':
        return '耳机音频暴露';

      // 生殖健康
      case 'HKCategoryTypeIdentifierMenstrualFlow':
        return '月经流量';
      case 'HKCategoryTypeIdentifierIntermenstrualBleeding':
        return '经间期出血';
      case 'HKCategoryTypeIdentifierSexualActivity':
        return '性活动';

      // 心理健康
      case 'HKCategoryTypeIdentifierMindfulSession':
        return '正念会话';

      // 其他健康指标
      case 'HKQuantityTypeIdentifierElectrodermalActivity':
        return '皮肤电活动';
      case 'HKQuantityTypeIdentifierInhalerUsage':
        return '吸入器使用';
      case 'HKQuantityTypeIdentifierInsulinDelivery':
        return '胰岛素输送';

      default:
        return identifier;
    }
  }
}
