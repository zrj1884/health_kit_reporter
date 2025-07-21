import 'package:health_kit_reporter/exceptions.dart';

/// Equivalent of [QuantityType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum QuantityType {
  activeEnergyBurned,
  appleExerciseTime,
  appleMoveTime,
  appleSleepingBreathingDisturbances,
  appleSleepingWristTemperature,
  appleStandTime,
  appleWalkingSteadiness,
  atrialFibrillationBurden,
  basalBodyTemperature,
  basalEnergyBurned,
  bloodAlcoholContent,
  bloodGlucose,
  bloodPressureDiastolic,
  bloodPressureSystolic,
  bodyFatPercentage,
  bodyMass,
  bodyMassIndex,
  bodyTemperature,
  crossCountrySkiingSpeed,
  cyclingCadence,
  cyclingFunctionalThresholdPower,
  cyclingPower,
  cyclingSpeed,
  dietaryBiotin,
  dietaryCaffeine,
  dietaryCalcium,
  dietaryCarbohydrates,
  dietaryChloride,
  dietaryCholesterol,
  dietaryChromium,
  dietaryCopper,
  dietaryEnergyConsumed,
  dietaryFatMonounsaturated,
  dietaryFatPolyunsaturated,
  dietaryFatSaturated,
  dietaryFatTotal,
  dietaryFiber,
  dietaryFolate,
  dietaryIodine,
  dietaryIron,
  dietaryMagnesium,
  dietaryManganese,
  dietaryMolybdenum,
  dietaryNiacin,
  dietaryPantothenicAcid,
  dietaryPhosphorus,
  dietaryPotassium,
  dietaryProtein,
  dietaryRiboflavin,
  dietarySelenium,
  dietarySodium,
  dietarySugar,
  dietaryThiamin,
  dietaryVitaminA,
  dietaryVitaminB12,
  dietaryVitaminB6,
  dietaryVitaminC,
  dietaryVitaminD,
  dietaryVitaminE,
  dietaryVitaminK,
  dietaryWater,
  dietaryZinc,
  distanceCrossCountrySkiing,
  distanceCycling,
  distanceDownhillSnowSports,
  distancePaddleSports,
  distanceRowing,
  distanceSkatingSports,
  distanceSwimming,
  distanceWalkingRunning,
  distanceWheelchair,
  electrodermalActivity,
  environmentalAudioExposure,
  environmentalSoundReduction,
  estimatedWorkoutEffortScore,
  flightsClimbed,
  forcedExpiratoryVolume1,
  forcedVitalCapacity,
  headphoneAudioExposure,
  heartRate,
  heartRateRecoveryOneMinute,
  heartRateVariabilitySDNN,
  height,
  inhalerUsage,
  insulinDelivery,
  leanBodyMass,
  nikeFuel,
  numberOfAlcoholicBeverages,
  numberOfTimesFallen,
  oxygenSaturation,
  paddleSportsSpeed,
  peakExpiratoryFlowRate,
  peripheralPerfusionIndex,
  physicalEffort,
  pushCount,
  respiratoryRate,
  restingHeartRate,
  rowingSpeed,
  runningGroundContactTime,
  runningPower,
  runningSpeed,
  runningStrideLength,
  runningVerticalOscillation,
  sixMinuteWalkTestDistance,
  stairAscentSpeed,
  stairDescentSpeed,
  stepCount,
  swimmingStrokeCount,
  timeInDaylight,
  underwaterDepth,
  uvExposure,
  vo2Max,
  walkingAsymmetryPercentage,
  walkingDoubleSupportPercentage,
  walkingHeartRateAverage,
  walkingSpeed,
  walkingStepLength,
  waistCircumference,
  waterTemperature,
  workoutEffortScore,
}

extension QuantityTypeIdentifier on QuantityType {
  String get identifier {
    switch (this) {
      case QuantityType.activeEnergyBurned:
        return 'HKQuantityTypeIdentifierActiveEnergyBurned';
      case QuantityType.appleExerciseTime:
        return 'HKQuantityTypeIdentifierAppleExerciseTime';
      case QuantityType.appleMoveTime:
        return 'HKQuantityTypeIdentifierAppleMoveTime';
      case QuantityType.appleSleepingBreathingDisturbances:
        return 'HKQuantityTypeIdentifierAppleSleepingBreathingDisturbances';
      case QuantityType.appleSleepingWristTemperature:
        return 'HKQuantityTypeIdentifierAppleSleepingWristTemperature';
      case QuantityType.appleStandTime:
        return 'HKQuantityTypeIdentifierAppleStandTime';
      case QuantityType.appleWalkingSteadiness:
        return 'HKQuantityTypeIdentifierAppleWalkingSteadiness';
      case QuantityType.atrialFibrillationBurden:
        return 'HKQuantityTypeIdentifierAtrialFibrillationBurden';
      case QuantityType.basalBodyTemperature:
        return 'HKQuantityTypeIdentifierBasalBodyTemperature';
      case QuantityType.basalEnergyBurned:
        return 'HKQuantityTypeIdentifierBasalEnergyBurned';
      case QuantityType.bloodAlcoholContent:
        return 'HKQuantityTypeIdentifierBloodAlcoholContent';
      case QuantityType.bloodGlucose:
        return 'HKQuantityTypeIdentifierBloodGlucose';
      case QuantityType.bloodPressureDiastolic:
        return 'HKQuantityTypeIdentifierBloodPressureDiastolic';
      case QuantityType.bloodPressureSystolic:
        return 'HKQuantityTypeIdentifierBloodPressureSystolic';
      case QuantityType.bodyFatPercentage:
        return 'HKQuantityTypeIdentifierBodyFatPercentage';
      case QuantityType.bodyMass:
        return 'HKQuantityTypeIdentifierBodyMass';
      case QuantityType.bodyMassIndex:
        return 'HKQuantityTypeIdentifierBodyMassIndex';
      case QuantityType.bodyTemperature:
        return 'HKQuantityTypeIdentifierBodyTemperature';
      case QuantityType.crossCountrySkiingSpeed:
        return 'HKQuantityTypeIdentifierCrossCountrySkiingSpeed';
      case QuantityType.cyclingCadence:
        return 'HKQuantityTypeIdentifierCyclingCadence';
      case QuantityType.cyclingFunctionalThresholdPower:
        return 'HKQuantityTypeIdentifierCyclingFunctionalThresholdPower';
      case QuantityType.cyclingPower:
        return 'HKQuantityTypeIdentifierCyclingPower';
      case QuantityType.cyclingSpeed:
        return 'HKQuantityTypeIdentifierCyclingSpeed';
      case QuantityType.dietaryBiotin:
        return 'HKQuantityTypeIdentifierDietaryBiotin';
      case QuantityType.dietaryCaffeine:
        return 'HKQuantityTypeIdentifierDietaryCaffeine';
      case QuantityType.dietaryCalcium:
        return 'HKQuantityTypeIdentifierDietaryCalcium';
      case QuantityType.dietaryCarbohydrates:
        return 'HKQuantityTypeIdentifierDietaryCarbohydrates';
      case QuantityType.dietaryChloride:
        return 'HKQuantityTypeIdentifierDietaryChloride';
      case QuantityType.dietaryCholesterol:
        return 'HKQuantityTypeIdentifierDietaryCholesterol';
      case QuantityType.dietaryChromium:
        return 'HKQuantityTypeIdentifierDietaryChromium';
      case QuantityType.dietaryCopper:
        return 'HKQuantityTypeIdentifierDietaryCopper';
      case QuantityType.dietaryEnergyConsumed:
        return 'HKQuantityTypeIdentifierDietaryEnergyConsumed';
      case QuantityType.dietaryFatMonounsaturated:
        return 'HKQuantityTypeIdentifierDietaryFatMonounsaturated';
      case QuantityType.dietaryFatPolyunsaturated:
        return 'HKQuantityTypeIdentifierDietaryFatPolyunsaturated';
      case QuantityType.dietaryFatSaturated:
        return 'HKQuantityTypeIdentifierDietaryFatSaturated';
      case QuantityType.dietaryFatTotal:
        return 'HKQuantityTypeIdentifierDietaryFatTotal';
      case QuantityType.dietaryFiber:
        return 'HKQuantityTypeIdentifierDietaryFiber';
      case QuantityType.dietaryFolate:
        return 'HKQuantityTypeIdentifierDietaryFolate';
      case QuantityType.dietaryIodine:
        return 'HKQuantityTypeIdentifierDietaryIodine';
      case QuantityType.dietaryIron:
        return 'HKQuantityTypeIdentifierDietaryIron';
      case QuantityType.dietaryMagnesium:
        return 'HKQuantityTypeIdentifierDietaryMagnesium';
      case QuantityType.dietaryManganese:
        return 'HKQuantityTypeIdentifierDietaryManganese';
      case QuantityType.dietaryMolybdenum:
        return 'HKQuantityTypeIdentifierDietaryMolybdenum';
      case QuantityType.dietaryNiacin:
        return 'HKQuantityTypeIdentifierDietaryNiacin';
      case QuantityType.dietaryPantothenicAcid:
        return 'HKQuantityTypeIdentifierDietaryPantothenicAcid';
      case QuantityType.dietaryPhosphorus:
        return 'HKQuantityTypeIdentifierDietaryPhosphorus';
      case QuantityType.dietaryPotassium:
        return 'HKQuantityTypeIdentifierDietaryPotassium';
      case QuantityType.dietaryProtein:
        return 'HKQuantityTypeIdentifierDietaryProtein';
      case QuantityType.dietaryRiboflavin:
        return 'HKQuantityTypeIdentifierDietaryRiboflavin';
      case QuantityType.dietarySelenium:
        return 'HKQuantityTypeIdentifierDietarySelenium';
      case QuantityType.dietarySodium:
        return 'HKQuantityTypeIdentifierDietarySodium';
      case QuantityType.dietarySugar:
        return 'HKQuantityTypeIdentifierDietarySugar';
      case QuantityType.dietaryThiamin:
        return 'HKQuantityTypeIdentifierDietaryThiamin';
      case QuantityType.dietaryVitaminA:
        return 'HKQuantityTypeIdentifierDietaryVitaminA';
      case QuantityType.dietaryVitaminB12:
        return 'HKQuantityTypeIdentifierDietaryVitaminB12';
      case QuantityType.dietaryVitaminB6:
        return 'HKQuantityTypeIdentifierDietaryVitaminB6';
      case QuantityType.dietaryVitaminC:
        return 'HKQuantityTypeIdentifierDietaryVitaminC';
      case QuantityType.dietaryVitaminD:
        return 'HKQuantityTypeIdentifierDietaryVitaminD';
      case QuantityType.dietaryVitaminE:
        return 'HKQuantityTypeIdentifierDietaryVitaminE';
      case QuantityType.dietaryVitaminK:
        return 'HKQuantityTypeIdentifierDietaryVitaminK';
      case QuantityType.dietaryWater:
        return 'HKQuantityTypeIdentifierDietaryWater';
      case QuantityType.dietaryZinc:
        return 'HKQuantityTypeIdentifierDietaryZinc';
      case QuantityType.distanceCrossCountrySkiing:
        return 'HKQuantityTypeIdentifierDistanceCrossCountrySkiing';
      case QuantityType.distanceCycling:
        return 'HKQuantityTypeIdentifierDistanceCycling';
      case QuantityType.distanceDownhillSnowSports:
        return 'HKQuantityTypeIdentifierDistanceDownhillSnowSports';
      case QuantityType.distancePaddleSports:
        return 'HKQuantityTypeIdentifierDistancePaddleSports';
      case QuantityType.distanceRowing:
        return 'HKQuantityTypeIdentifierDistanceRowing';
      case QuantityType.distanceSkatingSports:
        return 'HKQuantityTypeIdentifierDistanceSkatingSports';
      case QuantityType.distanceSwimming:
        return 'HKQuantityTypeIdentifierDistanceSwimming';
      case QuantityType.distanceWalkingRunning:
        return 'HKQuantityTypeIdentifierDistanceWalkingRunning';
      case QuantityType.distanceWheelchair:
        return 'HKQuantityTypeIdentifierDistanceWheelchair';
      case QuantityType.electrodermalActivity:
        return 'HKQuantityTypeIdentifierElectrodermalActivity';
      case QuantityType.environmentalAudioExposure:
        return 'HKQuantityTypeIdentifierEnvironmentalAudioExposure';
      case QuantityType.environmentalSoundReduction:
        return 'HKQuantityTypeIdentifierEnvironmentalSoundReduction';
      case QuantityType.estimatedWorkoutEffortScore:
        return 'HKQuantityTypeIdentifierEstimatedWorkoutEffortScore';
      case QuantityType.flightsClimbed:
        return 'HKQuantityTypeIdentifierFlightsClimbed';
      case QuantityType.forcedExpiratoryVolume1:
        return 'HKQuantityTypeIdentifierForcedExpiratoryVolume1';
      case QuantityType.forcedVitalCapacity:
        return 'HKQuantityTypeIdentifierForcedVitalCapacity';
      case QuantityType.headphoneAudioExposure:
        return 'HKQuantityTypeIdentifierHeadphoneAudioExposure';
      case QuantityType.heartRate:
        return 'HKQuantityTypeIdentifierHeartRate';
      case QuantityType.heartRateRecoveryOneMinute:
        return 'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute';
      case QuantityType.heartRateVariabilitySDNN:
        return 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN';
      case QuantityType.height:
        return 'HKQuantityTypeIdentifierHeight';
      case QuantityType.inhalerUsage:
        return 'HKQuantityTypeIdentifierInhalerUsage';
      case QuantityType.insulinDelivery:
        return 'HKQuantityTypeIdentifierInsulinDelivery';
      case QuantityType.leanBodyMass:
        return 'HKQuantityTypeIdentifierLeanBodyMass';
      case QuantityType.nikeFuel:
        return 'HKQuantityTypeIdentifierNikeFuel';
      case QuantityType.numberOfAlcoholicBeverages:
        return 'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages';
      case QuantityType.numberOfTimesFallen:
        return 'HKQuantityTypeIdentifierNumberOfTimesFallen';
      case QuantityType.oxygenSaturation:
        return 'HKQuantityTypeIdentifierOxygenSaturation';
      case QuantityType.paddleSportsSpeed:
        return 'HKQuantityTypeIdentifierPaddleSportsSpeed';
      case QuantityType.peakExpiratoryFlowRate:
        return 'HKQuantityTypeIdentifierPeakExpiratoryFlowRate';
      case QuantityType.peripheralPerfusionIndex:
        return 'HKQuantityTypeIdentifierPeripheralPerfusionIndex';
      case QuantityType.physicalEffort:
        return 'HKQuantityTypeIdentifierPhysicalEffort';
      case QuantityType.pushCount:
        return 'HKQuantityTypeIdentifierPushCount';
      case QuantityType.respiratoryRate:
        return 'HKQuantityTypeIdentifierRespiratoryRate';
      case QuantityType.restingHeartRate:
        return 'HKQuantityTypeIdentifierRestingHeartRate';
      case QuantityType.rowingSpeed:
        return 'HKQuantityTypeIdentifierRowingSpeed';
      case QuantityType.runningGroundContactTime:
        return 'HKQuantityTypeIdentifierRunningGroundContactTime';
      case QuantityType.runningPower:
        return 'HKQuantityTypeIdentifierRunningPower';
      case QuantityType.runningSpeed:
        return 'HKQuantityTypeIdentifierRunningSpeed';
      case QuantityType.runningStrideLength:
        return 'HKQuantityTypeIdentifierRunningStrideLength';
      case QuantityType.runningVerticalOscillation:
        return 'HKQuantityTypeIdentifierRunningVerticalOscillation';
      case QuantityType.sixMinuteWalkTestDistance:
        return 'HKQuantityTypeIdentifierSixMinuteWalkTestDistance';
      case QuantityType.stairAscentSpeed:
        return 'HKQuantityTypeIdentifierStairAscentSpeed';
      case QuantityType.stairDescentSpeed:
        return 'HKQuantityTypeIdentifierStairDescentSpeed';
      case QuantityType.stepCount:
        return 'HKQuantityTypeIdentifierStepCount';
      case QuantityType.swimmingStrokeCount:
        return 'HKQuantityTypeIdentifierSwimmingStrokeCount';
      case QuantityType.timeInDaylight:
        return 'HKQuantityTypeIdentifierTimeInDaylight';
      case QuantityType.underwaterDepth:
        return 'HKQuantityTypeIdentifierUnderwaterDepth';
      case QuantityType.uvExposure:
        return 'HKQuantityTypeIdentifierUVExposure';
      case QuantityType.vo2Max:
        return 'HKQuantityTypeIdentifierVO2Max';
      case QuantityType.walkingAsymmetryPercentage:
        return 'HKQuantityTypeIdentifierWalkingAsymmetryPercentage';
      case QuantityType.walkingDoubleSupportPercentage:
        return 'HKQuantityTypeIdentifierWalkingDoubleSupportPercentage';
      case QuantityType.walkingHeartRateAverage:
        return 'HKQuantityTypeIdentifierWalkingHeartRateAverage';
      case QuantityType.walkingSpeed:
        return 'HKQuantityTypeIdentifierWalkingSpeed';
      case QuantityType.walkingStepLength:
        return 'HKQuantityTypeIdentifierWalkingStepLength';
      case QuantityType.waistCircumference:
        return 'HKQuantityTypeIdentifierWaistCircumference';
      case QuantityType.waterTemperature:
        return 'HKQuantityTypeIdentifierWaterTemperature';
      case QuantityType.workoutEffortScore:
        return 'HKQuantityTypeIdentifierWorkoutEffortScore';
    }
  }
}

extension QuantityTypeFactory on QuantityType {
  static QuantityType from(String identifier) {
    for (final type in QuantityType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static QuantityType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
