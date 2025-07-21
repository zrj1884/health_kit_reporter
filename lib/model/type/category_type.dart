import '../../exceptions.dart';

/// Equivalent of [CategoryType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum CategoryType {
  abdominalCramps,
  acne,
  appetiteChanges,
  appleStandHour,
  appleWalkingSteadinessEvent,
  audioExposureEvent,
  bladderIncontinence,
  bleedingAfterPregnancy,
  bleedingDuringPregnancy,
  bloating,
  breastPain,
  cervicalMucusQuality,
  chestTightnessOrPain,
  chills,
  constipation,
  contraceptive,
  coughing,
  diarrhea,
  dizziness,
  drySkin,
  environmentalAudioExposureEvent,
  fainting,
  fatigue,
  fever,
  generalizedBodyAche,
  hairLoss,
  handwashingEvent,
  headache,
  headphoneAudioExposureEvent,
  heartburn,
  highHeartRateEvent,
  hotFlashes,
  infrequentMenstrualCycles,
  irregularHeartRhythmEvent,
  irregularMenstrualCycles,
  intermenstrualBleeding,
  lactation,
  lossOfSmell,
  lossOfTaste,
  lowCardioFitnessEvent,
  lowHeartRateEvent,
  lowerBackPain,
  memoryLapse,
  menstrualFlow,
  mindfulSession,
  moodChanges,
  nausea,
  nightSweats,
  ovulationTestResult,
  pelvicPain,
  persistentIntermenstrualBleeding,
  pregnancy,
  pregnancyTestResult,
  progesteroneTestResult,
  prolongedMenstrualPeriods,
  rapidPoundingOrFlutteringHeartbeat,
  runnyNose,
  sexualActivity,
  shortnessOfBreath,
  sinusCongestion,
  skippedHeartbeat,
  sleepAnalysis,
  sleepApneaEvent,
  sleepChanges,
  soreThroat,
  toothbrushingEvent,
  vaginalDryness,
  vomiting,
  wheezing,
}

extension CategoryTypeIdentifier on CategoryType {
  String get identifier {
    switch (this) {
      case CategoryType.abdominalCramps:
        return 'HKCategoryTypeIdentifierAbdominalCramps';
      case CategoryType.acne:
        return 'HKCategoryTypeIdentifierAcne';
      case CategoryType.appetiteChanges:
        return 'HKCategoryTypeIdentifierAppetiteChanges';
      case CategoryType.appleStandHour:
        return 'HKCategoryTypeIdentifierAppleStandHour';
      case CategoryType.appleWalkingSteadinessEvent:
        return 'HKCategoryTypeIdentifierAppleWalkingSteadinessEvent';
      case CategoryType.audioExposureEvent:
        return 'HKCategoryTypeIdentifierAudioExposureEvent';
      case CategoryType.bladderIncontinence:
        return 'HKCategoryTypeIdentifierBladderIncontinence';
      case CategoryType.bleedingAfterPregnancy:
        return 'HKCategoryTypeIdentifierBleedingAfterPregnancy';
      case CategoryType.bleedingDuringPregnancy:
        return 'HKCategoryTypeIdentifierBleedingDuringPregnancy';
      case CategoryType.bloating:
        return 'HKCategoryTypeIdentifierBloating';
      case CategoryType.breastPain:
        return 'HKCategoryTypeIdentifierBreastPain';
      case CategoryType.cervicalMucusQuality:
        return 'HKCategoryTypeIdentifierCervicalMucusQuality';
      case CategoryType.chestTightnessOrPain:
        return 'HKCategoryTypeIdentifierChestTightnessOrPain';
      case CategoryType.chills:
        return 'HKCategoryTypeIdentifierChills';
      case CategoryType.constipation:
        return 'HKCategoryTypeIdentifierConstipation';
      case CategoryType.contraceptive:
        return 'HKCategoryTypeIdentifierContraceptive';
      case CategoryType.coughing:
        return 'HKCategoryTypeIdentifierCoughing';
      case CategoryType.diarrhea:
        return 'HKCategoryTypeIdentifierDiarrhea';
      case CategoryType.dizziness:
        return 'HKCategoryTypeIdentifierDizziness';
      case CategoryType.drySkin:
        return 'HKCategoryTypeIdentifierDrySkin';
      case CategoryType.environmentalAudioExposureEvent:
        return 'HKCategoryTypeIdentifierEnvironmentalAudioExposureEvent';
      case CategoryType.fainting:
        return 'HKCategoryTypeIdentifierFainting';
      case CategoryType.fatigue:
        return 'HKCategoryTypeIdentifierFatigue';
      case CategoryType.fever:
        return 'HKCategoryTypeIdentifierFever';
      case CategoryType.generalizedBodyAche:
        return 'HKCategoryTypeIdentifierGeneralizedBodyAche';
      case CategoryType.hairLoss:
        return 'HKCategoryTypeIdentifierHairLoss';
      case CategoryType.handwashingEvent:
        return 'HKCategoryTypeIdentifierHandwashingEvent';
      case CategoryType.headache:
        return 'HKCategoryTypeIdentifierHeadache';
      case CategoryType.headphoneAudioExposureEvent:
        return 'HKCategoryTypeIdentifierHeadphoneAudioExposureEvent';
      case CategoryType.heartburn:
        return 'HKCategoryTypeIdentifierHeartburn';
      case CategoryType.highHeartRateEvent:
        return 'HKCategoryTypeIdentifierHighHeartRateEvent';
      case CategoryType.hotFlashes:
        return 'HKCategoryTypeIdentifierHotFlashes';
      case CategoryType.infrequentMenstrualCycles:
        return 'HKCategoryTypeIdentifierInfrequentMenstrualCycles';
      case CategoryType.irregularHeartRhythmEvent:
        return 'HKCategoryTypeIdentifierIrregularHeartRhythmEvent';
      case CategoryType.irregularMenstrualCycles:
        return 'HKCategoryTypeIdentifierIrregularMenstrualCycles';
      case CategoryType.intermenstrualBleeding:
        return 'HKCategoryTypeIdentifierIntermenstrualBleeding';
      case CategoryType.lactation:
        return 'HKCategoryTypeIdentifierLactation';
      case CategoryType.lossOfSmell:
        return 'HKCategoryTypeIdentifierLossOfSmell';
      case CategoryType.lossOfTaste:
        return 'HKCategoryTypeIdentifierLossOfTaste';
      case CategoryType.lowCardioFitnessEvent:
        return 'HKCategoryTypeIdentifierLowCardioFitnessEvent';
      case CategoryType.lowHeartRateEvent:
        return 'HKCategoryTypeIdentifierLowHeartRateEvent';
      case CategoryType.lowerBackPain:
        return 'HKCategoryTypeIdentifierLowerBackPain';
      case CategoryType.memoryLapse:
        return 'HKCategoryTypeIdentifierMemoryLapse';
      case CategoryType.menstrualFlow:
        return 'HKCategoryTypeIdentifierMenstrualFlow';
      case CategoryType.mindfulSession:
        return 'HKCategoryTypeIdentifierMindfulSession';
      case CategoryType.moodChanges:
        return 'HKCategoryTypeIdentifierMoodChanges';
      case CategoryType.nausea:
        return 'HKCategoryTypeIdentifierNausea';
      case CategoryType.nightSweats:
        return 'HKCategoryTypeIdentifierNightSweats';
      case CategoryType.ovulationTestResult:
        return 'HKCategoryTypeIdentifierOvulationTestResult';
      case CategoryType.pelvicPain:
        return 'HKCategoryTypeIdentifierPelvicPain';
      case CategoryType.persistentIntermenstrualBleeding:
        return 'HKCategoryTypeIdentifierPersistentIntermenstrualBleeding';
      case CategoryType.pregnancy:
        return 'HKCategoryTypeIdentifierPregnancy';
      case CategoryType.pregnancyTestResult:
        return 'HKCategoryTypeIdentifierPregnancyTestResult';
      case CategoryType.progesteroneTestResult:
        return 'HKCategoryTypeIdentifierProgesteroneTestResult';
      case CategoryType.prolongedMenstrualPeriods:
        return 'HKCategoryTypeIdentifierProlongedMenstrualPeriods';
      case CategoryType.rapidPoundingOrFlutteringHeartbeat:
        return 'HKCategoryTypeIdentifierRapidPoundingOrFlutteringHeartbeat';
      case CategoryType.runnyNose:
        return 'HKCategoryTypeIdentifierRunnyNose';
      case CategoryType.sexualActivity:
        return 'HKCategoryTypeIdentifierSexualActivity';
      case CategoryType.shortnessOfBreath:
        return 'HKCategoryTypeIdentifierShortnessOfBreath';
      case CategoryType.sinusCongestion:
        return 'HKCategoryTypeIdentifierSinusCongestion';
      case CategoryType.skippedHeartbeat:
        return 'HKCategoryTypeIdentifierSkippedHeartbeat';
      case CategoryType.sleepAnalysis:
        return 'HKCategoryTypeIdentifierSleepAnalysis';
      case CategoryType.sleepApneaEvent:
        return 'HKCategoryTypeIdentifierSleepApneaEvent';
      case CategoryType.sleepChanges:
        return 'HKCategoryTypeIdentifierSleepChanges';
      case CategoryType.soreThroat:
        return 'HKCategoryTypeIdentifierSoreThroat';
      case CategoryType.toothbrushingEvent:
        return 'HKCategoryTypeIdentifierToothbrushingEvent';
      case CategoryType.vaginalDryness:
        return 'HKCategoryTypeIdentifierVaginalDryness';
      case CategoryType.vomiting:
        return 'HKCategoryTypeIdentifierVomiting';
      case CategoryType.wheezing:
        return 'HKCategoryTypeIdentifierWheezing';
    }
  }
}

extension CategoryTypeFactory on CategoryType {
  static CategoryType from(String identifier) {
    for (final type in CategoryType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static CategoryType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
