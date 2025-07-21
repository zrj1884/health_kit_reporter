import 'package:flutter/material.dart';

class HealthIconService {
  /// 根据健康数据标识符获取对应的图标
  static IconData getIconForIdentifier(String identifier) {
    switch (identifier) {
      // 活动相关
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
        return Icons.local_fire_department;
      case 'HKQuantityTypeIdentifierAppleExerciseTime':
        return Icons.fitness_center;
      case 'HKQuantityTypeIdentifierAppleMoveTime':
        return Icons.directions_walk;
      case 'HKQuantityTypeIdentifierAppleStandTime':
        return Icons.airline_seat_flat;
      case 'HKQuantityTypeIdentifierAppleWalkingSteadiness':
        return Icons.trending_up;
      case 'HKQuantityTypeIdentifierBasalEnergyBurned':
        return Icons.whatshot;
      case 'HKQuantityTypeIdentifierCrossCountrySkiingSpeed':
        return Icons.downhill_skiing;
      case 'HKQuantityTypeIdentifierCyclingCadence':
        return Icons.directions_bike;
      case 'HKQuantityTypeIdentifierCyclingFunctionalThresholdPower':
        return Icons.power;
      case 'HKQuantityTypeIdentifierCyclingPower':
        return Icons.power;
      case 'HKQuantityTypeIdentifierCyclingSpeed':
        return Icons.speed;
      case 'HKQuantityTypeIdentifierDistanceCrossCountrySkiing':
        return Icons.downhill_skiing;
      case 'HKQuantityTypeIdentifierDistanceCycling':
        return Icons.directions_bike;
      case 'HKQuantityTypeIdentifierDistanceDownhillSnowSports':
        return Icons.downhill_skiing;
      case 'HKQuantityTypeIdentifierDistancePaddleSports':
        return Icons.sports;
      case 'HKQuantityTypeIdentifierDistanceRowing':
        return Icons.sports;
      case 'HKQuantityTypeIdentifierDistanceSkatingSports':
        return Icons.sports;
      case 'HKQuantityTypeIdentifierDistanceSwimming':
        return Icons.pool;
      case 'HKQuantityTypeIdentifierDistanceWalkingRunning':
        return Icons.directions_run;
      case 'HKQuantityTypeIdentifierDistanceWheelchair':
        return Icons.accessible;
      case 'HKQuantityTypeIdentifierEstimatedWorkoutEffortScore':
        return Icons.fitness_center;
      case 'HKQuantityTypeIdentifierFlightsClimbed':
        return Icons.stairs;
      case 'HKQuantityTypeIdentifierNikeFuel':
        return Icons.local_fire_department;
      case 'HKQuantityTypeIdentifierPaddleSportsSpeed':
        return Icons.speed;
      case 'HKQuantityTypeIdentifierPhysicalEffort':
        return Icons.fitness_center;
      case 'HKQuantityTypeIdentifierPushCount':
        return Icons.fitness_center;
      case 'HKQuantityTypeIdentifierRowingSpeed':
        return Icons.speed;
      case 'HKQuantityTypeIdentifierRunningGroundContactTime':
        return Icons.timer;
      case 'HKQuantityTypeIdentifierRunningPower':
        return Icons.power;
      case 'HKQuantityTypeIdentifierRunningSpeed':
        return Icons.speed;
      case 'HKQuantityTypeIdentifierRunningStrideLength':
        return Icons.straighten;
      case 'HKQuantityTypeIdentifierRunningVerticalOscillation':
        return Icons.waves;
      case 'HKQuantityTypeIdentifierSixMinuteWalkTestDistance':
        return Icons.directions_walk;
      case 'HKQuantityTypeIdentifierStairAscentSpeed':
        return Icons.trending_up;
      case 'HKQuantityTypeIdentifierStairDescentSpeed':
        return Icons.trending_down;
      case 'HKQuantityTypeIdentifierStepCount':
        return Icons.directions_walk;
      case 'HKQuantityTypeIdentifierSwimmingStrokeCount':
        return Icons.pool;
      case 'HKQuantityTypeIdentifierTimeInDaylight':
        return Icons.wb_sunny;
      case 'HKQuantityTypeIdentifierUnderwaterDepth':
        return Icons.water;
      case 'HKQuantityTypeIdentifierUVExposure':
        return Icons.wb_sunny;
      case 'HKQuantityTypeIdentifierWaterTemperature':
        return Icons.thermostat;
      case 'HKQuantityTypeIdentifierWorkoutEffortScore':
        return Icons.fitness_center;

      // 心脏相关
      case 'HKQuantityTypeIdentifierAtrialFibrillationBurden':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierHeartRate':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute':
        return Icons.trending_down;
      case 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN':
        return Icons.timeline;
      case 'HKQuantityTypeIdentifierPeripheralPerfusionIndex':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierRestingHeartRate':
        return Icons.favorite_border;
      case 'HKQuantityTypeIdentifierVO2Max':
        return Icons.trending_up;
      case 'HKQuantityTypeIdentifierWalkingHeartRateAverage':
        return Icons.directions_walk;

      // 身体测量
      case 'HKQuantityTypeIdentifierAppleSleepingBreathingDisturbances':
        return Icons.bedtime;
      case 'HKQuantityTypeIdentifierAppleSleepingWristTemperature':
        return Icons.thermostat;
      case 'HKQuantityTypeIdentifierBasalBodyTemperature':
        return Icons.thermostat;
      case 'HKQuantityTypeIdentifierBodyFatPercentage':
        return Icons.pie_chart;
      case 'HKQuantityTypeIdentifierBodyMass':
        return Icons.monitor_weight;
      case 'HKQuantityTypeIdentifierBodyMassIndex':
        return Icons.analytics;
      case 'HKQuantityTypeIdentifierBodyTemperature':
        return Icons.thermostat;
      case 'HKQuantityTypeIdentifierHeight':
        return Icons.height;
      case 'HKQuantityTypeIdentifierLeanBodyMass':
        return Icons.fitness_center;
      case 'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages':
        return Icons.local_bar;
      case 'HKQuantityTypeIdentifierNumberOfTimesFallen':
        return Icons.warning;
      case 'HKQuantityTypeIdentifierWaistCircumference':
        return Icons.straighten;

      // 营养
      case 'HKQuantityTypeIdentifierDietaryBiotin':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryCaffeine':
        return Icons.coffee;
      case 'HKQuantityTypeIdentifierDietaryCalcium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
        return Icons.cake;
      case 'HKQuantityTypeIdentifierDietaryChloride':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryCholesterol':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryChromium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryCopper':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
        return Icons.restaurant;
      case 'HKQuantityTypeIdentifierDietaryFatMonounsaturated':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryFatPolyunsaturated':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryFatSaturated':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
        return Icons.oil_barrel;
      case 'HKQuantityTypeIdentifierDietaryFiber':
        return Icons.grain;
      case 'HKQuantityTypeIdentifierDietaryFolate':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryIodine':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryIron':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryMagnesium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryManganese':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryMolybdenum':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryNiacin':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryPantothenicAcid':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryPhosphorus':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryPotassium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryProtein':
        return Icons.set_meal;
      case 'HKQuantityTypeIdentifierDietaryRiboflavin':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietarySelenium':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietarySodium':
        return Icons.restaurant;
      case 'HKQuantityTypeIdentifierDietarySugar':
        return Icons.cake;
      case 'HKQuantityTypeIdentifierDietaryThiamin':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminA':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminB12':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminB6':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminC':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminD':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminE':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryVitaminK':
        return Icons.health_and_safety;
      case 'HKQuantityTypeIdentifierDietaryWater':
        return Icons.water_drop;
      case 'HKQuantityTypeIdentifierDietaryZinc':
        return Icons.health_and_safety;

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
      case 'HKQuantityTypeIdentifierBloodAlcoholContent':
        return Icons.local_bar;
      case 'HKQuantityTypeIdentifierBloodGlucose':
        return Icons.bloodtype;
      case 'HKQuantityTypeIdentifierBloodPressureDiastolic':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierBloodPressureSystolic':
        return Icons.favorite;
      case 'HKQuantityTypeIdentifierForcedExpiratoryVolume1':
        return Icons.air;
      case 'HKQuantityTypeIdentifierForcedVitalCapacity':
        return Icons.air;
      case 'HKQuantityTypeIdentifierOxygenSaturation':
        return Icons.air;
      case 'HKQuantityTypeIdentifierPeakExpiratoryFlowRate':
        return Icons.air;
      case 'HKQuantityTypeIdentifierRespiratoryRate':
        return Icons.air;

      // 听力
      case 'HKQuantityTypeIdentifierEnvironmentalAudioExposure':
        return Icons.hearing;
      case 'HKQuantityTypeIdentifierEnvironmentalSoundReduction':
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
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
      case 'HKQuantityTypeIdentifierAppleExerciseTime':
      case 'HKQuantityTypeIdentifierAppleMoveTime':
      case 'HKQuantityTypeIdentifierAppleStandTime':
      case 'HKQuantityTypeIdentifierAppleWalkingSteadiness':
      case 'HKQuantityTypeIdentifierBasalEnergyBurned':
      case 'HKQuantityTypeIdentifierCrossCountrySkiingSpeed':
      case 'HKQuantityTypeIdentifierCyclingCadence':
      case 'HKQuantityTypeIdentifierCyclingFunctionalThresholdPower':
      case 'HKQuantityTypeIdentifierCyclingPower':
      case 'HKQuantityTypeIdentifierCyclingSpeed':
      case 'HKQuantityTypeIdentifierDistanceCrossCountrySkiing':
      case 'HKQuantityTypeIdentifierDistanceCycling':
      case 'HKQuantityTypeIdentifierDistanceDownhillSnowSports':
      case 'HKQuantityTypeIdentifierDistancePaddleSports':
      case 'HKQuantityTypeIdentifierDistanceRowing':
      case 'HKQuantityTypeIdentifierDistanceSkatingSports':
      case 'HKQuantityTypeIdentifierDistanceSwimming':
      case 'HKQuantityTypeIdentifierDistanceWalkingRunning':
      case 'HKQuantityTypeIdentifierDistanceWheelchair':
      case 'HKQuantityTypeIdentifierEstimatedWorkoutEffortScore':
      case 'HKQuantityTypeIdentifierFlightsClimbed':
      case 'HKQuantityTypeIdentifierNikeFuel':
      case 'HKQuantityTypeIdentifierPaddleSportsSpeed':
      case 'HKQuantityTypeIdentifierPhysicalEffort':
      case 'HKQuantityTypeIdentifierPushCount':
      case 'HKQuantityTypeIdentifierRowingSpeed':
      case 'HKQuantityTypeIdentifierRunningGroundContactTime':
      case 'HKQuantityTypeIdentifierRunningPower':
      case 'HKQuantityTypeIdentifierRunningSpeed':
      case 'HKQuantityTypeIdentifierRunningStrideLength':
      case 'HKQuantityTypeIdentifierRunningVerticalOscillation':
      case 'HKQuantityTypeIdentifierSixMinuteWalkTestDistance':
      case 'HKQuantityTypeIdentifierStairAscentSpeed':
      case 'HKQuantityTypeIdentifierStairDescentSpeed':
      case 'HKQuantityTypeIdentifierStepCount':
      case 'HKQuantityTypeIdentifierSwimmingStrokeCount':
      case 'HKQuantityTypeIdentifierTimeInDaylight':
      case 'HKQuantityTypeIdentifierUnderwaterDepth':
      case 'HKQuantityTypeIdentifierUVExposure':
      case 'HKQuantityTypeIdentifierWaterTemperature':
      case 'HKQuantityTypeIdentifierWorkoutEffortScore':
        return Colors.orange;

      // 心脏相关 - 红色系
      case 'HKQuantityTypeIdentifierAtrialFibrillationBurden':
      case 'HKQuantityTypeIdentifierHeartRate':
      case 'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute':
      case 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN':
      case 'HKQuantityTypeIdentifierPeripheralPerfusionIndex':
      case 'HKQuantityTypeIdentifierRestingHeartRate':
      case 'HKQuantityTypeIdentifierVO2Max':
      case 'HKQuantityTypeIdentifierWalkingHeartRateAverage':
        return Colors.red;

      // 身体测量 - 蓝色系
      case 'HKQuantityTypeIdentifierAppleSleepingBreathingDisturbances':
      case 'HKQuantityTypeIdentifierAppleSleepingWristTemperature':
      case 'HKQuantityTypeIdentifierBasalBodyTemperature':
      case 'HKQuantityTypeIdentifierBodyFatPercentage':
      case 'HKQuantityTypeIdentifierBodyMass':
      case 'HKQuantityTypeIdentifierBodyMassIndex':
      case 'HKQuantityTypeIdentifierBodyTemperature':
      case 'HKQuantityTypeIdentifierHeight':
      case 'HKQuantityTypeIdentifierLeanBodyMass':
      case 'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages':
      case 'HKQuantityTypeIdentifierNumberOfTimesFallen':
      case 'HKQuantityTypeIdentifierWaistCircumference':
        return Colors.blue;

      // 营养 - 绿色系
      case 'HKQuantityTypeIdentifierDietaryBiotin':
      case 'HKQuantityTypeIdentifierDietaryCaffeine':
      case 'HKQuantityTypeIdentifierDietaryCalcium':
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
      case 'HKQuantityTypeIdentifierDietaryChloride':
      case 'HKQuantityTypeIdentifierDietaryCholesterol':
      case 'HKQuantityTypeIdentifierDietaryChromium':
      case 'HKQuantityTypeIdentifierDietaryCopper':
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
      case 'HKQuantityTypeIdentifierDietaryFatMonounsaturated':
      case 'HKQuantityTypeIdentifierDietaryFatPolyunsaturated':
      case 'HKQuantityTypeIdentifierDietaryFatSaturated':
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
      case 'HKQuantityTypeIdentifierDietaryFiber':
      case 'HKQuantityTypeIdentifierDietaryFolate':
      case 'HKQuantityTypeIdentifierDietaryIodine':
      case 'HKQuantityTypeIdentifierDietaryIron':
      case 'HKQuantityTypeIdentifierDietaryMagnesium':
      case 'HKQuantityTypeIdentifierDietaryManganese':
      case 'HKQuantityTypeIdentifierDietaryMolybdenum':
      case 'HKQuantityTypeIdentifierDietaryNiacin':
      case 'HKQuantityTypeIdentifierDietaryPantothenicAcid':
      case 'HKQuantityTypeIdentifierDietaryPhosphorus':
      case 'HKQuantityTypeIdentifierDietaryPotassium':
      case 'HKQuantityTypeIdentifierDietaryProtein':
      case 'HKQuantityTypeIdentifierDietaryRiboflavin':
      case 'HKQuantityTypeIdentifierDietarySelenium':
      case 'HKQuantityTypeIdentifierDietarySodium':
      case 'HKQuantityTypeIdentifierDietarySugar':
      case 'HKQuantityTypeIdentifierDietaryThiamin':
      case 'HKQuantityTypeIdentifierDietaryVitaminA':
      case 'HKQuantityTypeIdentifierDietaryVitaminB12':
      case 'HKQuantityTypeIdentifierDietaryVitaminB6':
      case 'HKQuantityTypeIdentifierDietaryVitaminC':
      case 'HKQuantityTypeIdentifierDietaryVitaminD':
      case 'HKQuantityTypeIdentifierDietaryVitaminE':
      case 'HKQuantityTypeIdentifierDietaryVitaminK':
      case 'HKQuantityTypeIdentifierDietaryWater':
      case 'HKQuantityTypeIdentifierDietaryZinc':
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
      case 'HKQuantityTypeIdentifierBloodAlcoholContent':
      case 'HKQuantityTypeIdentifierBloodGlucose':
      case 'HKQuantityTypeIdentifierBloodPressureDiastolic':
      case 'HKQuantityTypeIdentifierBloodPressureSystolic':
      case 'HKQuantityTypeIdentifierForcedExpiratoryVolume1':
      case 'HKQuantityTypeIdentifierForcedVitalCapacity':
      case 'HKQuantityTypeIdentifierOxygenSaturation':
      case 'HKQuantityTypeIdentifierPeakExpiratoryFlowRate':
      case 'HKQuantityTypeIdentifierRespiratoryRate':
        return Colors.red;

      // 听力 - 黄色系
      case 'HKQuantityTypeIdentifierEnvironmentalAudioExposure':
      case 'HKQuantityTypeIdentifierEnvironmentalSoundReduction':
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
        identifier.contains('FlightsClimbed') ||
        identifier.contains('UV') ||
        identifier.contains('Underwater') ||
        identifier.contains('Water') ||
        identifier.contains('NikeFuel') ||
        identifier.contains('PushCount') ||
        identifier.contains('Swimming') ||
        identifier.contains('Cycling') ||
        identifier.contains('Skiing') ||
        identifier.contains('Paddle') ||
        identifier.contains('Rowing') ||
        identifier.contains('Skating') ||
        identifier.contains('PhysicalEffort') ||
        identifier.contains('WorkoutEffort') ||
        identifier.contains('TimeInDaylight')) {
      return '活动';
    } else if ((identifier.contains('Heart') && !identifier.contains('BloodPressure')) ||
        identifier.contains('VO2Max') ||
        identifier.contains('AtrialFibrillation') ||
        identifier.contains('PeripheralPerfusion')) {
      return '心脏';
    } else if (identifier.contains('Body') ||
        identifier.contains('Height') ||
        identifier.contains('Mass') ||
        identifier.contains('Waist') ||
        identifier.contains('Temperature') ||
        identifier.contains('Fallen') ||
        (identifier.contains('Alcoholic') && !identifier.contains('BloodAlcohol')) ||
        identifier.contains('SleepingBreathing')) {
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
        identifier.contains('BloodGlucose') ||
        identifier.contains('BloodAlcohol') ||
        identifier.contains('Forced') ||
        identifier.contains('Peak')) {
      return '生命体征';
    } else if (identifier.contains('Audio') || identifier.contains('SoundReduction')) {
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
      case 'HKQuantityTypeIdentifierActiveEnergyBurned':
        return '活动消耗热量';
      case 'HKQuantityTypeIdentifierAppleExerciseTime':
        return 'Apple运动时间';
      case 'HKQuantityTypeIdentifierAppleMoveTime':
        return 'Apple活动时间';
      case 'HKQuantityTypeIdentifierAppleStandTime':
        return 'Apple站立时间';
      case 'HKQuantityTypeIdentifierAppleWalkingSteadiness':
        return 'Apple步行稳定性';
      case 'HKQuantityTypeIdentifierBasalEnergyBurned':
        return '基础代谢热量';
      case 'HKQuantityTypeIdentifierCrossCountrySkiingSpeed':
        return '越野滑雪速度';
      case 'HKQuantityTypeIdentifierCyclingCadence':
        return '骑行踏频';
      case 'HKQuantityTypeIdentifierCyclingFunctionalThresholdPower':
        return '骑行功能阈值功率';
      case 'HKQuantityTypeIdentifierCyclingPower':
        return '骑行功率';
      case 'HKQuantityTypeIdentifierCyclingSpeed':
        return '骑行速度';
      case 'HKQuantityTypeIdentifierDistanceCrossCountrySkiing':
        return '越野滑雪距离';
      case 'HKQuantityTypeIdentifierDistanceCycling':
        return '骑行距离';
      case 'HKQuantityTypeIdentifierDistanceDownhillSnowSports':
        return '下坡滑雪距离';
      case 'HKQuantityTypeIdentifierDistancePaddleSports':
        return '划艇运动距离';
      case 'HKQuantityTypeIdentifierDistanceRowing':
        return '划船距离';
      case 'HKQuantityTypeIdentifierDistanceSkatingSports':
        return '滑冰运动距离';
      case 'HKQuantityTypeIdentifierDistanceSwimming':
        return '游泳距离';
      case 'HKQuantityTypeIdentifierDistanceWalkingRunning':
        return '步行跑步距离';
      case 'HKQuantityTypeIdentifierDistanceWheelchair':
        return '轮椅距离';
      case 'HKQuantityTypeIdentifierEstimatedWorkoutEffortScore':
        return '预估运动强度评分';
      case 'HKQuantityTypeIdentifierFlightsClimbed':
        return '爬楼层数';
      case 'HKQuantityTypeIdentifierNikeFuel':
        return 'Nike燃料';
      case 'HKQuantityTypeIdentifierPaddleSportsSpeed':
        return '划艇运动速度';
      case 'HKQuantityTypeIdentifierPhysicalEffort':
        return '体力消耗';
      case 'HKQuantityTypeIdentifierPushCount':
        return '俯卧撑次数';
      case 'HKQuantityTypeIdentifierRowingSpeed':
        return '划船速度';
      case 'HKQuantityTypeIdentifierRunningGroundContactTime':
        return '跑步触地时间';
      case 'HKQuantityTypeIdentifierRunningPower':
        return '跑步功率';
      case 'HKQuantityTypeIdentifierRunningSpeed':
        return '跑步速度';
      case 'HKQuantityTypeIdentifierRunningStrideLength':
        return '跑步步长';
      case 'HKQuantityTypeIdentifierRunningVerticalOscillation':
        return '跑步垂直振荡';
      case 'HKQuantityTypeIdentifierSixMinuteWalkTestDistance':
        return '六分钟步行测试距离';
      case 'HKQuantityTypeIdentifierStairAscentSpeed':
        return '上楼速度';
      case 'HKQuantityTypeIdentifierStairDescentSpeed':
        return '下楼速度';
      case 'HKQuantityTypeIdentifierStepCount':
        return '步数';
      case 'HKQuantityTypeIdentifierSwimmingStrokeCount':
        return '游泳划水次数';
      case 'HKQuantityTypeIdentifierTimeInDaylight':
        return '日光暴露时间';
      case 'HKQuantityTypeIdentifierUnderwaterDepth':
        return '水下深度';
      case 'HKQuantityTypeIdentifierUVExposure':
        return '紫外线暴露';
      case 'HKQuantityTypeIdentifierWaterTemperature':
        return '水温';
      case 'HKQuantityTypeIdentifierWorkoutEffortScore':
        return '运动强度评分';

      // 心脏相关
      case 'HKQuantityTypeIdentifierAtrialFibrillationBurden':
        return '房颤负担';
      case 'HKQuantityTypeIdentifierHeartRate':
        return '心率';
      case 'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute':
        return '心率恢复（1分钟）';
      case 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN':
        return '心率变异性SDNN';
      case 'HKQuantityTypeIdentifierPeripheralPerfusionIndex':
        return '外周灌注指数';
      case 'HKQuantityTypeIdentifierRestingHeartRate':
        return '静息心率';
      case 'HKQuantityTypeIdentifierVO2Max':
        return '最大摄氧量';
      case 'HKQuantityTypeIdentifierWalkingHeartRateAverage':
        return '步行平均心率';

      // 身体测量
      case 'HKQuantityTypeIdentifierAppleSleepingBreathingDisturbances':
        return 'Apple睡眠呼吸障碍';
      case 'HKQuantityTypeIdentifierAppleSleepingWristTemperature':
        return 'Apple睡眠手腕温度';
      case 'HKQuantityTypeIdentifierBasalBodyTemperature':
        return '基础体温';
      case 'HKQuantityTypeIdentifierBodyFatPercentage':
        return '体脂百分比';
      case 'HKQuantityTypeIdentifierBodyMass':
        return '体重';
      case 'HKQuantityTypeIdentifierBodyMassIndex':
        return '体重指数(BMI)';
      case 'HKQuantityTypeIdentifierBodyTemperature':
        return '体温';
      case 'HKQuantityTypeIdentifierHeight':
        return '身高';
      case 'HKQuantityTypeIdentifierLeanBodyMass':
        return '去脂体重';
      case 'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages':
        return '酒精饮料数量';
      case 'HKQuantityTypeIdentifierNumberOfTimesFallen':
        return '跌倒次数';
      case 'HKQuantityTypeIdentifierWaistCircumference':
        return '腰围';

      // 营养
      case 'HKQuantityTypeIdentifierDietaryBiotin':
        return '膳食生物素';
      case 'HKQuantityTypeIdentifierDietaryCaffeine':
        return '膳食咖啡因';
      case 'HKQuantityTypeIdentifierDietaryCalcium':
        return '膳食钙';
      case 'HKQuantityTypeIdentifierDietaryCarbohydrates':
        return '膳食碳水化合物';
      case 'HKQuantityTypeIdentifierDietaryChloride':
        return '膳食氯';
      case 'HKQuantityTypeIdentifierDietaryCholesterol':
        return '膳食胆固醇';
      case 'HKQuantityTypeIdentifierDietaryChromium':
        return '膳食铬';
      case 'HKQuantityTypeIdentifierDietaryCopper':
        return '膳食铜';
      case 'HKQuantityTypeIdentifierDietaryEnergyConsumed':
        return '膳食能量摄入';
      case 'HKQuantityTypeIdentifierDietaryFatMonounsaturated':
        return '膳食单不饱和脂肪';
      case 'HKQuantityTypeIdentifierDietaryFatPolyunsaturated':
        return '膳食多不饱和脂肪';
      case 'HKQuantityTypeIdentifierDietaryFatSaturated':
        return '膳食饱和脂肪';
      case 'HKQuantityTypeIdentifierDietaryFatTotal':
        return '膳食总脂肪';
      case 'HKQuantityTypeIdentifierDietaryFiber':
        return '膳食纤维';
      case 'HKQuantityTypeIdentifierDietaryFolate':
        return '膳食叶酸';
      case 'HKQuantityTypeIdentifierDietaryIodine':
        return '膳食碘';
      case 'HKQuantityTypeIdentifierDietaryIron':
        return '膳食铁';
      case 'HKQuantityTypeIdentifierDietaryMagnesium':
        return '膳食镁';
      case 'HKQuantityTypeIdentifierDietaryManganese':
        return '膳食锰';
      case 'HKQuantityTypeIdentifierDietaryMolybdenum':
        return '膳食钼';
      case 'HKQuantityTypeIdentifierDietaryNiacin':
        return '膳食烟酸';
      case 'HKQuantityTypeIdentifierDietaryPantothenicAcid':
        return '膳食泛酸';
      case 'HKQuantityTypeIdentifierDietaryPhosphorus':
        return '膳食磷';
      case 'HKQuantityTypeIdentifierDietaryPotassium':
        return '膳食钾';
      case 'HKQuantityTypeIdentifierDietaryProtein':
        return '膳食蛋白质';
      case 'HKQuantityTypeIdentifierDietaryRiboflavin':
        return '膳食核黄素';
      case 'HKQuantityTypeIdentifierDietarySelenium':
        return '膳食硒';
      case 'HKQuantityTypeIdentifierDietarySodium':
        return '膳食钠';
      case 'HKQuantityTypeIdentifierDietarySugar':
        return '膳食糖';
      case 'HKQuantityTypeIdentifierDietaryThiamin':
        return '膳食硫胺素';
      case 'HKQuantityTypeIdentifierDietaryVitaminA':
        return '膳食维生素A';
      case 'HKQuantityTypeIdentifierDietaryVitaminB12':
        return '膳食维生素B12';
      case 'HKQuantityTypeIdentifierDietaryVitaminB6':
        return '膳食维生素B6';
      case 'HKQuantityTypeIdentifierDietaryVitaminC':
        return '膳食维生素C';
      case 'HKQuantityTypeIdentifierDietaryVitaminD':
        return '膳食维生素D';
      case 'HKQuantityTypeIdentifierDietaryVitaminE':
        return '膳食维生素E';
      case 'HKQuantityTypeIdentifierDietaryVitaminK':
        return '膳食维生素K';
      case 'HKQuantityTypeIdentifierDietaryWater':
        return '膳食水分';
      case 'HKQuantityTypeIdentifierDietaryZinc':
        return '膳食锌';

      // 睡眠
      case 'HKCategoryTypeIdentifierSleepAnalysis':
        return '睡眠分析';
      case 'HKCategoryTypeIdentifierSleepChanges':
        return '睡眠变化';

      // 运动
      case 'HKWorkoutTypeIdentifier':
        return '运动类型';
      case 'HKWorkoutTypeIdentifierWalking':
        return '步行运动';
      case 'HKWorkoutTypeIdentifierRunning':
        return '跑步运动';
      case 'HKWorkoutTypeIdentifierCycling':
        return '骑行运动';
      case 'HKWorkoutTypeIdentifierSwimming':
        return '游泳运动';
      case 'HKWorkoutTypeIdentifierYoga':
        return '瑜伽运动';
      case 'HKWorkoutTypeIdentifierStrengthTraining':
        return '力量训练';

      // 生命体征
      case 'HKQuantityTypeIdentifierBloodAlcoholContent':
        return '血液酒精浓度';
      case 'HKQuantityTypeIdentifierBloodGlucose':
        return '血糖';
      case 'HKQuantityTypeIdentifierBloodPressureDiastolic':
        return '舒张压';
      case 'HKQuantityTypeIdentifierBloodPressureSystolic':
        return '收缩压';
      case 'HKQuantityTypeIdentifierForcedExpiratoryVolume1':
        return '一秒用力呼气量';
      case 'HKQuantityTypeIdentifierForcedVitalCapacity':
        return '用力肺活量';
      case 'HKQuantityTypeIdentifierOxygenSaturation':
        return '血氧饱和度';
      case 'HKQuantityTypeIdentifierPeakExpiratoryFlowRate':
        return '峰值呼气流速';
      case 'HKQuantityTypeIdentifierRespiratoryRate':
        return '呼吸频率';

      // 听力
      case 'HKQuantityTypeIdentifierEnvironmentalAudioExposure':
        return '环境音频暴露';
      case 'HKQuantityTypeIdentifierEnvironmentalSoundReduction':
        return '环境声音减少';
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
